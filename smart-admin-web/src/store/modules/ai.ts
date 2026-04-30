import { defineStore } from 'pinia'
import { chatApi, getHistoryApi, getSessionsApi, deleteSessionApi, ChatMessage, ChatSession } from '@/api/ai'
import { useUserStore } from '@/store/modules/user'

interface AiState {
  isDrawerOpen: boolean
  isLoading: boolean
  isGenerating: boolean
  currentSessionKey: string | null
  messages: ChatMessage[]
  sessions: ChatSession[]
  streamingContent: string
  abortController: AbortController | null
}

export const useAiStore = defineStore('ai', {
  state: (): AiState => ({
    isDrawerOpen: false,
    isLoading: false,
    isGenerating: false,
    currentSessionKey: null,
    messages: [],
    sessions: [],
    streamingContent: '',
    abortController: null,
  }),

  getters: {
    hasMessages: (state) => state.messages.length > 0,
  },

  actions: {
    toggleDrawer() {
      this.isDrawerOpen = !this.isDrawerOpen
    },

    openDrawer() {
      this.isDrawerOpen = true
      this.loadSessions()
    },

    closeDrawer() {
      this.isDrawerOpen = false
    },

    stopGeneration() {
      if (this.abortController) {
        this.abortController.abort()
        this.abortController = null
      }
      this.isGenerating = false
      this.isLoading = false
    },

    async sendMessage(content: string) {
      if (!content.trim() || this.isLoading) return

      this.isLoading = true
      this.isGenerating = true

      this.messages.push({
        sessionKey: this.currentSessionKey || '',
        content,
        role: 'user',
      })

      const aiMessageIndex = this.messages.length
      this.messages.push({
        sessionKey: this.currentSessionKey || '',
        content: '',
        role: 'assistant',
      })

      this.streamingContent = ''
      this.abortController = new AbortController()

      try {
        const userStore = useUserStore()

        // 调用流式接口
        const response = await fetch('/api/ai/chat/stream', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': userStore.token ? `Bearer ${userStore.token}` : '',
          },
          body: JSON.stringify({
            sessionKey: this.currentSessionKey || undefined,
            content,
          }),
          signal: this.abortController.signal,
        })

        if (!response.body) {
          throw new Error('无法读取响应流')
        }

        const reader = response.body.getReader()
        const decoder = new TextDecoder()
        let buffer = ''

        while (true) {
          const { done, value } = await reader.read()
          if (done) break

          buffer += decoder.decode(value, { stream: true })

          const lines = buffer.split('\n')
          buffer = lines.pop() || ''

          for (const line of lines) {
            if (line.startsWith('data:')) {
              const data = line.slice(5).trim()

              if (data === '[DONE]') {
                break
              } else if (data.startsWith('[SESSION_KEY]')) {
                const key = data.slice(13)
                this.currentSessionKey = key
              } else if (data.startsWith('[ERROR]')) {
                this.messages[aiMessageIndex].content = data.slice(7)
                break
              } else if (!data.startsWith('[TOOL_RESULT]')) {
                this.streamingContent += data + '\n'
                this.messages[aiMessageIndex].content = this.streamingContent
              }
            }
          }
        }

        this.loadSessions()

      } catch (error: any) {
        if (error.name === 'AbortError') {
          // 用户中止请求
          this.messages[aiMessageIndex].content = (this.streamingContent || '') + '（已中止）'
        } else {
          console.error('发送消息失败', error)
          this.messages[aiMessageIndex].content = '抱歉，发送消息失败，请稍后重试'
        }
      } finally {
        this.isGenerating = false
        this.isLoading = false
        this.abortController = null
        this.streamingContent = ''
      }
    },

    async loadHistory(sessionKey: string) {
      try {
        const response = await getHistoryApi(sessionKey)
        this.messages = response.data || []
        this.currentSessionKey = sessionKey
      } catch (error) {
        console.error('加载历史消息失败', error)
      }
    },

    async loadSessions() {
      try {
        const response = await getSessionsApi()
        this.sessions = response.data || []
      } catch (error) {
        console.error('加载会话列表失败', error)
      }
    },

    async deleteSession(sessionKey: string) {
      try {
        await deleteSessionApi(sessionKey)
        this.sessions = this.sessions.filter((s) => s.sessionKey !== sessionKey)
        if (this.currentSessionKey === sessionKey) {
          this.currentSessionKey = null
          this.messages = []
        }
      } catch (error) {
        console.error('删除会话失败', error)
      }
    },

    createNewSession() {
      this.currentSessionKey = null
      this.messages = []
    },
  },

  persist: {
    key: 'ai-store',
    storage: localStorage,
    paths: ['currentSessionKey'],
  },
})
