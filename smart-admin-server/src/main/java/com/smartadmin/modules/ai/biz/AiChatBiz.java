package com.smartadmin.modules.ai.biz;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smartadmin.modules.ai.config.AiProperties;
import com.smartadmin.modules.ai.dto.request.ChatReq;
import com.smartadmin.modules.ai.dto.response.ChatResp;
import com.smartadmin.modules.ai.dto.response.ChatSessionResp;
import com.smartadmin.modules.ai.entity.AiChatMessage;
import com.smartadmin.modules.ai.entity.AiChatSession;
import com.smartadmin.modules.ai.service.AiMessageService;
import com.smartadmin.modules.ai.service.AiSessionService;
import com.smartadmin.utils.UserContext;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class AiChatBiz {

    private final AiSessionService sessionService;
    private final AiMessageService messageService;
    private final AiProperties aiProperties;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    private static final String DEFAULT_SESSION_TITLE = "新对话";

    public ChatResp chat(ChatReq req) {
        Long userId = UserContext.getUserId();
        AiChatSession session = getOrCreateSession(req.getSessionKey(), userId);
        saveMessage(session, req.getContent(), "user");

        String aiResponse = callAiService(session.getSessionKey(), req.getContent());
        saveMessage(session, aiResponse, "assistant");

        if (DEFAULT_SESSION_TITLE.equals(session.getTitle())) {
            updateSessionTitle(session, req.getContent());
        }

        ChatResp resp = new ChatResp();
        resp.setSessionKey(session.getSessionKey());
        resp.setContent(aiResponse);
        resp.setRole("assistant");
        resp.setModel(session.getModel());
        return resp;
    }

    public void chatStream(ChatReq req, HttpServletResponse response) {
        Long userId = UserContext.getUserId();
        AiChatSession session = getOrCreateSession(req.getSessionKey(), userId);
        saveMessage(session, req.getContent(), "user");

        final String sessionKey = session.getSessionKey();

        // 设置 SSE 响应头
        response.setContentType("text/event-stream;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setHeader("X-Accel-Buffering", "no");

        try {
            PrintWriter writer = response.getWriter();

            // 调用 Python 流式接口
            String pythonUrl = aiProperties.getBaseUrl() + "/chat/stream";

            java.net.HttpURLConnection conn = (java.net.HttpURLConnection)
                new java.net.URL(pythonUrl).openConnection();

            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Accept", "text/event-stream");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(30000);

            // 发送请求
            String jsonBody = objectMapper.writeValueAsString(Map.of(
                "session_id", sessionKey,
                "message", req.getContent()
            ));
            conn.getOutputStream().write(jsonBody.getBytes(StandardCharsets.UTF_8));
            conn.getOutputStream().flush();

            // 读取并转发响应
            StringBuilder fullContent = new StringBuilder();
            byte[] buffer = new byte[1024];
            int len;

            while ((len = conn.getInputStream().read(buffer)) != -1) {
                String chunk = new String(buffer, 0, len, StandardCharsets.UTF_8);

                // 解析 SSE：找出所有 data: 开头的行
                StringBuilder lineBuf = new StringBuilder();
                for (int i = 0; i < chunk.length(); i++) {
                    char c = chunk.charAt(i);
                    if (c == '\n') {
                        String line = lineBuf.toString().trim();
                        lineBuf = new StringBuilder();

                        if (line.startsWith("data: ")) {
                            String data = line.substring(6);

                            if (data.equals("[DONE]")) {
                                break;
                            } else if (data.startsWith("[TOOL_RESULT]")) {
                                // 跳过 tool 结果
                            } else if (data.startsWith("[ERROR]")) {
                                writer.write("data: " + data + "\n\n");
                                writer.flush();
                            } else {
                                fullContent.append(data);
                                writer.write("data: " + data + "\n\n");
                                writer.flush();
                            }
                        }
                    } else {
                        lineBuf.append(c);
                    }
                }
            }

            conn.disconnect();

            // 保存 AI 消息
            if (!fullContent.isEmpty()) {
                saveMessage(session, fullContent.toString(), "assistant");
                if (DEFAULT_SESSION_TITLE.equals(session.getTitle())) {
                    updateSessionTitle(session, req.getContent());
                }
            }

            writer.flush();

        } catch (Exception e) {
            log.error("流式调用失败", e);
            try {
                response.getWriter().write("data: [ERROR]" + e.getMessage() + "\n\n");
                response.getWriter().flush();
            } catch (Exception ex) {
                log.error("发送错误失败", ex);
            }
        }
    }

    public List<ChatResp> getHistory(String sessionKey) {
        AiChatSession session = sessionService.getBySessionKey(sessionKey);
        if (session == null) {
            return new ArrayList<>();
        }

        List<AiChatMessage> messages = messageService.getBySessionId(session.getId());
        List<ChatResp> result = new ArrayList<>();
        for (AiChatMessage msg : messages) {
            ChatResp resp = new ChatResp();
            resp.setSessionKey(sessionKey);
            resp.setContent(msg.getContent());
            resp.setRole(msg.getRole());
            resp.setModel(msg.getModel());
            resp.setCreateTime(msg.getCreateTime());
            result.add(resp);
        }
        return result;
    }

    public List<ChatSessionResp> getSessions() {
        Long userId = UserContext.getUserId();
        List<AiChatSession> sessions = sessionService.lambdaQuery()
                .eq(AiChatSession::getUserId, userId)
                .orderByDesc(AiChatSession::getCreateTime)
                .list();

        List<ChatSessionResp> result = new ArrayList<>();
        for (AiChatSession session : sessions) {
            ChatSessionResp resp = new ChatSessionResp();
            resp.setSessionKey(session.getSessionKey());
            resp.setTitle(session.getTitle());
            resp.setModel(session.getModel());
            resp.setCreateTime(session.getCreateTime());
            result.add(resp);
        }
        return result;
    }

    public void deleteSession(String sessionKey) {
        sessionService.deleteBySessionKey(sessionKey);
    }

    private AiChatSession getOrCreateSession(String sessionKey, Long userId) {
        if (sessionKey != null && !sessionKey.isEmpty()) {
            AiChatSession session = sessionService.getBySessionKey(sessionKey);
            if (session != null) {
                return session;
            }
        }
        return sessionService.createSession(userId);
    }

    private void saveMessage(AiChatSession session, String content, String role) {
        AiChatMessage message = new AiChatMessage();
        message.setSessionId(session.getId());
        message.setUserId(session.getUserId());
        message.setRole(role);
        message.setContent(content);
        message.setModel(session.getModel());
        messageService.save(message);
    }

    private void updateSessionTitle(AiChatSession session, String content) {
        String title = content.length() > 30 ? content.substring(0, 30) + "..." : content;
        session.setTitle(title);
        sessionService.updateById(session);
    }

    private String callAiService(String sessionKey, String message) {
        try {
            String url = aiProperties.getBaseUrl() + "/chat";
            Map<String, Object> requestBody = Map.of(
                    "session_id", sessionKey,
                    "message", message
            );

            JsonNode responseNode = restTemplate.postForObject(url, requestBody, JsonNode.class);

            if (responseNode != null && responseNode.has("answer")) {
                return responseNode.get("answer").asText();
            }
            return "抱歉，AI 服务暂时无法回复";

        } catch (Exception e) {
            log.error("调用 AI 服务失败", e);
            return "抱歉，AI 服务暂时无法回复：" + e.getMessage();
        }
    }
}