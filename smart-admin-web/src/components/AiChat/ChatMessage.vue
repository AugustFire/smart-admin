<template>
  <div class="chat-message" :class="{ 'is-user': message.role === 'user' }">
    <div class="message-avatar">
      <el-icon v-if="message.role === 'user'" :size="20"><User /></el-icon>
      <el-icon v-else :size="20"><MagicStick /></el-icon>
    </div>
    <div class="message-content">
      <div class="message-bubble" v-html="renderContent(message.content)" />
      <div v-if="message.createTime" class="message-time">
        {{ formatTime(message.createTime) }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { User, MagicStick } from '@element-plus/icons-vue'
import MarkdownIt from 'markdown-it'
import type { ChatMessage } from '@/api/ai'

defineProps<{
  message: ChatMessage
}>()

const formatTime = (time: string) => {
  const date = new Date(time)
  return date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
}

// 配置 markdown-it 支持 GFM 表格
const md = new MarkdownIt({
  html: true,
  linkify: true,
  typographer: true,
  breaks: true,
})

const renderContent = (content: string) => {
  return md.render(content)
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

.is-user .message-bubble {
  :deep(pre) {
    background: rgba(0, 0, 0, 0.2);
    color: #fff;
  }
  :deep(code) {
    background: rgba(0, 0, 0, 0.15);
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 13px;
  }
}

.message-bubble {
  padding: 10px 14px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.5;
  word-break: break-word;

  :deep(p) {
    margin: 0 0 8px 0;
    &:last-child {
      margin-bottom: 0;
    }
  }

  :deep(ul), :deep(ol) {
    margin: 8px 0;
    padding-left: 20px;
    li {
      margin: 4px 0;
    }
  }

  :deep(pre) {
    background: var(--el-fill-color-dark);
    color: var(--el-text-color-primary);
    padding: 12px;
    border-radius: 8px;
    overflow-x: auto;
    margin: 8px 0;
    code {
      background: none;
      padding: 0;
      font-size: 13px;
      line-height: 1.5;
    }
  }

  :deep(code) {
    background: var(--el-fill-color-light);
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 13px;
    font-family: 'Fira Code', 'Consolas', monospace;
  }

  :deep(strong) {
    font-weight: 600;
  }

  :deep(em) {
    font-style: italic;
  }

  :deep(a) {
    color: var(--el-color-primary);
    text-decoration: none;
    &:hover {
      text-decoration: underline;
    }
  }

  :deep(table) {
    border-collapse: collapse;
    width: 100%;
    margin: 10px 0;
    font-size: 13px;
    display: block;
    overflow-x: auto;
    max-width: 100%;
    background: var(--el-bg-color);
    border-radius: 8px;
    border: 1px solid var(--el-border-color);

    th, td {
      border: 1px solid var(--el-border-color);
      padding: 10px 14px;
      text-align: left;
      white-space: nowrap;
    }

    th {
      background: var(--el-fill-color-light);
      font-weight: 600;
      color: var(--el-text-color-primary);
    }

    tr:nth-child(even) {
      background: var(--el-fill-color-lighter);
    }

    tr:hover:not(:nth-child(1)) {
      background: var(--el-fill-color-light);
    }

    td:first-child {
      font-weight: 500;
      color: var(--el-text-color-primary);
    }
  }
}

.message-time {
  font-size: 11px;
  color: #999;
}
</style>
