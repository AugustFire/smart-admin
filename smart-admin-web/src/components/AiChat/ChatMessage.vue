<template>
  <div class="chat-message" :class="{ 'is-user': message.role === 'user' }">
    <div class="message-avatar">
      <el-icon v-if="message.role === 'user'" :size="20"><User /></el-icon>
      <el-icon v-else :size="20"><MagicStick /></el-icon>
    </div>
    <div class="message-content">
      <div class="message-bubble">
        {{ message.content }}
      </div>
      <div v-if="message.createTime" class="message-time">
        {{ formatTime(message.createTime) }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { User, MagicStick } from '@element-plus/icons-vue'
import type { ChatMessage } from '@/api/ai'

defineProps<{
  message: ChatMessage
}>()

const formatTime = (time: string) => {
  const date = new Date(time)
  return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}
</script>

<style lang="scss" scoped>
.chat-message {
  display: flex;
  gap: 10px;
  max-width: 85%;

  &.is-user {
    flex-direction: row-reverse;
    align-self: flex-end;

    .message-bubble {
      background: var(--el-color-primary);
      color: #fff;
    }

    .message-time {
      text-align: right;
    }
  }

  &:not(.is-user) {
    align-self: flex-start;

    .message-bubble {
      background: var(--el-fill-color);
    }
  }
}

.message-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--el-color-primary-light-8);
  color: var(--el-color-primary);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.is-user .message-avatar {
  background: var(--el-color-primary);
  color: #fff;
}

.message-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.message-bubble {
  padding: 10px 14px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.5;
  word-break: break-word;
}

.message-time {
  font-size: 11px;
  color: #999;
}
</style>
