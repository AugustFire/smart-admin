<template>
  <div
    v-if="aiStore.isDrawerOpen"
    class="ai-chat-window"
    :style="{ left: windowPos.left + 'px', top: windowPos.top + 'px' }"
    @mousedown="startDrag"
  >
    <!-- 标题栏 -->
    <div class="window-header">
      <el-dropdown trigger="click" @command="handleCommand">
        <span class="title">
          {{ currentSessionTitle }}
          <el-icon class="el-icon--right"><ArrowDown /></el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="new">
              <el-icon><Plus /></el-icon>
              新对话
            </el-dropdown-item>
            <el-dropdown-item v-if="aiStore.sessions.length" divided disabled>
              <span class="session-label">历史会话</span>
            </el-dropdown-item>
            <el-dropdown-item
              v-for="session in aiStore.sessions.slice(0, 10)"
              :key="session.sessionKey"
              :command="session.sessionKey"
            >
              {{ session.title || '新对话' }}
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
      <div class="actions">
        <el-button text size="small" @click="handleNewChat">
          <el-icon><Plus /></el-icon>
        </el-button>
        <el-button text size="small" @click="aiStore.closeDrawer">
          <el-icon><Close /></el-icon>
        </el-button>
      </div>
    </div>

    <!-- 聊天内容 -->
    <div class="window-body">
      <div v-if="!aiStore.hasMessages" class="welcome">
        <div class="welcome-icon">
          <el-icon size="40"><ChatLineSquare /></el-icon>
        </div>
        <p class="welcome-text">你好！我是 AI 助手</p>
        <div class="suggestions">
          <div class="suggestion" @click="handleSuggestion('帮我查下北京天气')">查天气</div>
          <div class="suggestion" @click="handleSuggestion('查询用户ID=1的信息')">查用户</div>
          <div class="suggestion" @click="handleSuggestion('1+2*3等于多少')">计算</div>
        </div>
      </div>

      <div v-else ref="messageListRef" class="message-list">
        <ChatMessage
          v-for="(msg, index) in aiStore.messages"
          :key="index"
          :message="msg"
        />
        <div v-if="aiStore.isGenerating" class="generating">
          <el-icon class="is-loading"><Loading /></el-icon>
          <span>AI 思考中...</span>
          <el-button size="small" type="danger" @click="aiStore.stopGeneration">
            停止
          </el-button>
        </div>
      </div>
    </div>

    <!-- 输入框 -->
    <div class="window-footer">
      <el-input
        v-model="inputText"
        placeholder="输入消息，Enter 发送..."
        :disabled="aiStore.isLoading && !aiStore.isGenerating"
        @keyup.enter="handleSend"
      >
        <template #append>
          <el-button
            v-if="aiStore.isGenerating"
            type="danger"
            @click="aiStore.stopGeneration"
          >
            <el-icon><Close /></el-icon>
          </el-button>
          <el-button
            v-else
            :disabled="!inputText.trim() || aiStore.isLoading"
            @click="handleSend"
          >
            <el-icon><Promotion /></el-icon>
          </el-button>
        </template>
      </el-input>
    </div>
  </div>

  <div v-else class="ai-chat-fab" @click="aiStore.openDrawer">
    <div class="ai-icon">
      <div class="ai-ring"></div>
      <div class="ai-ring ai-ring-2"></div>
      <div class="ai-core">
        <svg viewBox="0 0 40 40" fill="none">
          <!-- AI 艺术字 -->
          <text x="20" y="28" text-anchor="middle" fill="white" font-size="22" font-weight="bold" font-family="Arial, sans-serif">AI</text>
        </svg>
      </div>
      <div class="ai-pulse"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick, watch, onMounted, onUnmounted, computed } from 'vue'
import { Plus, Close, ChatLineSquare, Promotion, Loading, ArrowDown } from '@element-plus/icons-vue'
import { useAiStore } from '@/store/modules/ai'
import ChatMessage from './ChatMessage.vue'

const aiStore = useAiStore()
const inputText = ref('')
const messageListRef = ref<HTMLElement>()

const windowWidth = 400
const windowHeight = 560
const windowPos = ref({ left: 0, top: 0 })

onMounted(() => {
  resetPosition()
  aiStore.loadSessions()
})

const resetPosition = () => {
  windowPos.value = {
    left: window.innerWidth - windowWidth - 24,
    top: window.innerHeight - windowHeight - 24,
  }
}

const currentSessionTitle = computed(() => {
  if (!aiStore.currentSessionKey || aiStore.messages.length === 0) {
    return '新对话'
  }
  const session = aiStore.sessions.find(s => s.sessionKey === aiStore.currentSessionKey)
  return session?.title || '新对话'
})

const isDragging = ref(false)
const dragStart = ref({ x: 0, y: 0 })

const startDrag = (e: MouseEvent) => {
  if ((e.target as HTMLElement).closest('.window-footer')) return
  if ((e.target as HTMLElement).closest('.el-dropdown')) return

  isDragging.value = true
  dragStart.value = {
    x: e.clientX - windowPos.value.left,
    y: e.clientY - windowPos.value.top,
  }

  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
}

const onDrag = (e: MouseEvent) => {
  if (!isDragging.value) return

  let newLeft = e.clientX - dragStart.value.x
  let newTop = e.clientY - dragStart.value.y

  if (newLeft < 0) newLeft = 0
  if (newTop < 0) newTop = 0
  if (newLeft > window.innerWidth - windowWidth) newLeft = window.innerWidth - windowWidth
  if (newTop > window.innerHeight - windowHeight) newTop = window.innerHeight - windowHeight

  windowPos.value = { left: newLeft, top: newTop }
}

const stopDrag = () => {
  isDragging.value = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
}

onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
})

const scrollToBottom = () => {
  nextTick(() => {
    const el = messageListRef.value
    if (el) {
      const lastMsg = el.lastElementChild
      if (lastMsg) {
        lastMsg.scrollIntoView({ behavior: 'instant', block: 'end' })
      }
    }
  })
}

// 监听消息变化立即滚动
watch(
  () => aiStore.messages.length,
  () => {
    scrollToBottom()
  },
  { flush: 'post' }
)

// 监听正在生成状态，实时滚动
let scrollInterval: ReturnType<typeof setInterval> | null = null
watch(
  () => aiStore.isGenerating,
  (generating) => {
    if (generating) {
      scrollToBottom()
      scrollInterval = setInterval(() => {
        scrollToBottom()
      }, 80)
    } else {
      if (scrollInterval) {
        clearInterval(scrollInterval)
        scrollInterval = null
      }
    }
  }
)

const handleSend = () => {
  if (!inputText.value.trim() || aiStore.isLoading) return
  aiStore.sendMessage(inputText.value)
  inputText.value = ''
}

const handleNewChat = () => {
  aiStore.createNewSession()
}

const handleCommand = (command: string) => {
  if (command === 'new') {
    aiStore.createNewSession()
  } else {
    aiStore.loadHistory(command)
  }
}

const handleSuggestion = (text: string) => {
  inputText.value = text
  handleSend()
}
</script>

<style lang="scss" scoped>
.ai-chat-window {
  position: fixed;
  width: 400px;
  height: 560px;
  background: var(--el-bg-color);
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.18);
  display: flex;
  flex-direction: column;
  z-index: 2025;
  overflow: hidden;
}

.window-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  border-bottom: 1px solid var(--el-border-color-lighter);
  cursor: move;
  user-select: none;
  background: var(--el-fill-color-lighter);

  .title {
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 4px;
  }

  .actions {
    display: flex;
    gap: 2px;
  }
}

.session-label {
  font-size: 12px;
  color: #999;
}

.window-body {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
}

.welcome {
  text-align: center;
  padding: 30px 20px;

  .welcome-icon {
    color: var(--el-color-primary);
    margin-bottom: 16px;
  }

  .welcome-text {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 16px;
  }

  .suggestions {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: center;
  }

  .suggestion {
    padding: 8px 14px;
    background: var(--el-fill-color-light);
    border-radius: 18px;
    cursor: pointer;
    font-size: 13px;
    transition: all 0.2s;

    &:hover {
      background: var(--el-color-primary-light-9);
      color: var(--el-color-primary);
    }
  }
}

.message-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.generating {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  color: #999;
  font-size: 13px;
  background: var(--el-fill-color-light);
  border-radius: 8px;

  .el-button {
    margin-left: auto;
    padding: 4px 8px;
  }
}

.window-footer {
  padding: 10px 12px 14px;
  border-top: 1px solid var(--el-border-color-lighter);

  :deep(.el-input__wrapper) {
    border-radius: 20px;
  }
}

.ai-chat-fab {
  position: fixed;
  right: 24px;
  bottom: 24px;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  cursor: pointer;
  z-index: 2025;

  .ai-icon {
    position: relative;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .ai-ring {
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    border: 2px solid var(--el-color-primary);
    opacity: 0.3;
    animation: pulse-ring 2s ease-out infinite;
  }

  .ai-ring-2 {
    animation-delay: 1s;
  }

  .ai-core {
    position: relative;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--el-color-primary) 0%, #8B5CF6 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 0 25px rgba(254, 64, 102, 0.6), 0 0 50px rgba(139, 92, 246, 0.3);
    transition: all 0.3s ease;

    svg {
      width: 36px;
      height: 36px;
    }
  }

  .ai-pulse {
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--el-color-primary), #8B5CF6);
    opacity: 0;
    animation: pulse-glow 2s ease-out infinite;
  }

  &:hover {
    .ai-core {
      transform: scale(1.15);
      box-shadow: 0 0 40px rgba(254, 64, 102, 0.8), 0 0 60px rgba(139, 92, 246, 0.5);
    }
  }
}

@keyframes pulse-ring {
  0% {
    transform: scale(0.9);
    opacity: 0.5;
  }
  100% {
    transform: scale(1.4);
    opacity: 0;
  }
}

@keyframes pulse-glow {
  0% {
    transform: scale(1);
    opacity: 0.4;
  }
  100% {
    transform: scale(1.6);
    opacity: 0;
  }
}
</style>
