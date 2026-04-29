package com.smartadmin.modules.ai.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.modules.ai.biz.AiChatBiz;
import com.smartadmin.modules.ai.dto.request.ChatReq;
import com.smartadmin.modules.ai.dto.response.ChatResp;
import com.smartadmin.modules.ai.dto.response.ChatSessionResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "AI 聊天")
@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
@Slf4j
public class AiChatController {

    private final AiChatBiz aiChatBiz;

    @Operation(summary = "发送消息")
    @PostMapping("/chat")
    public Result<ChatResp> chat(@Valid @RequestBody ChatReq req) {
        return Result.success(aiChatBiz.chat(req));
    }

    @Operation(summary = "发送消息（流式）")
    @PostMapping(value = "/chat/stream", produces = "text/event-stream;charset=UTF-8")
    public void chatStream(@Valid @RequestBody ChatReq req, HttpServletResponse response) {
        aiChatBiz.chatStream(req, response);
    }

    @Operation(summary = "获取历史消息")
    @GetMapping("/history/{sessionKey}")
    public Result<List<ChatResp>> getHistory(@PathVariable String sessionKey) {
        return Result.success(aiChatBiz.getHistory(sessionKey));
    }

    @Operation(summary = "获取会话列表")
    @GetMapping("/sessions")
    public Result<List<ChatSessionResp>> getSessions() {
        return Result.success(aiChatBiz.getSessions());
    }

    @OperLog(title = "AI 聊天", businessType = BusinessType.DELETE)
    @Operation(summary = "删除会话")
    @DeleteMapping("/sessions/{sessionKey}")
    public Result<Void> deleteSession(@PathVariable String sessionKey) {
        aiChatBiz.deleteSession(sessionKey);
        return Result.success();
    }
}