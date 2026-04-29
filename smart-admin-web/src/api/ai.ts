import { http } from '@/utils/request'

export interface ChatMessage {
  sessionKey: string
  content: string
  role: 'user' | 'assistant'
  model?: string
  createTime?: string
}

export interface ChatSession {
  sessionKey: string
  title: string
  model?: string
  createTime?: string
}

/**
 * 发送消息
 */
export function chatApi(data: { sessionKey?: string; content: string }) {
  return http.post<ChatMessage>('/ai/chat', data)
}

/**
 * 获取历史消息
 */
export function getHistoryApi(sessionKey: string) {
  return http.get<ChatMessage[]>('/ai/history/' + sessionKey)
}

/**
 * 获取会话列表
 */
export function getSessionsApi() {
  return http.get<ChatSession[]>('/ai/sessions')
}

/**
 * 删除会话
 */
export function deleteSessionApi(sessionKey: string) {
  return http.delete('/ai/sessions/' + sessionKey)
}
