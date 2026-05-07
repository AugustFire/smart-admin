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
// AI 助手专用 CSS 变量
$ai-primary: var(--el-color-primary, #409eff);
$ai-neon-hue: calc(var(--el-color-primary-hue, 210) * 1deg);
$ai-cyan: hsl($ai-neon-hue, 100%, 65%);
$ai-violet: hsl(calc($ai-neon-hue + 60deg), 80%, 60%);
$ai-glow: hsla($ai-neon-hue, 100%, 65%, 0.4);

.chat-message {
  display: flex;
  gap: 12px;
  max-width: 85%;
  animation: message-in 0.4s cubic-bezier(0.16, 1, 0.3, 1);

  &.is-user {
    flex-direction: row-reverse;
    align-self: flex-end;

    .message-bubble {
      background: linear-gradient(
        135deg,
        var(--el-color-primary, #409eff) 0%,
        var(--el-color-primary-light-3, #79bbff) 100%
      );
      color: #fff;
      border-radius: 18px 18px 4px 18px;
      box-shadow:
        0 0 20px hsla(var(--el-color-primary-hue, 210), 100%, 50%, 0.25),
        0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .message-time {
      text-align: right;
    }

    .message-avatar {
      background: linear-gradient(135deg, $ai-cyan 0%, $ai-violet 100%);
      border: 1px solid $ai-cyan;
      box-shadow: 0 0 12px $ai-glow;
    }
  }

  &:not(.is-user) {
    align-self: flex-start;

    .message-bubble {
      background: hsla($ai-neon-hue, 60%, 50%, 0.1);
      backdrop-filter: blur(10px);
      border: 1px solid hsla($ai-neon-hue, 60%, 50%, 0.2);
      border-radius: 18px 18px 18px 4px;
      color: var(--el-text-color-primary);
      box-shadow:
        0 0 15px hsla($ai-neon-hue, 80%, 60%, 0.1),
        0 4px 12px rgba(0, 0, 0, 0.08);
    }

    .message-avatar {
      background: linear-gradient(135deg, $ai-violet 0%, $ai-cyan 100%);
      border: 1px solid $ai-violet;
      box-shadow: 0 0 12px hsla(calc($ai-neon-hue + 60deg), 80%, 60%, 0.4);
    }
  }
}

@keyframes message-in {
  from {
    opacity: 0;
    transform: translateY(16px) scale(0.96);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.message-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  :deep(.el-icon) {
    font-size: 18px;
  }
}

.is-user {
  .message-avatar {
    background: var(--el-color-primary);
    color: #fff;
    box-shadow: 0 0 12px hsla(var(--el-color-primary-hue, 210), 100%, 50%, 0.4);
  }
}

.chat-message:not(.is-user) {
  .message-avatar {
    background: linear-gradient(135deg, $ai-violet 0%, $ai-cyan 100%);
    color: #fff;
    box-shadow: 0 0 12px hsla(calc($ai-neon-hue + 60deg), 80%, 60%, 0.4);
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
    background: rgba(0, 0, 0, 0.4);
    border: 1px solid hsla($ai-neon-hue, 60%, 50%, 0.25);
    border-radius: 10px;
    padding: 14px 16px;
    overflow-x: auto;
    margin: 10px 0;
    box-shadow:
      inset 0 1px 3px rgba(0, 0, 0, 0.3),
      0 0 20px hsla($ai-neon-hue, 100%, 65%, 0.05);

    code {
      background: none;
      padding: 0;
      font-size: 13px;
      line-height: 1.6;
      color: #a5f3fc;
    }
  }

  :deep(code) {
    background: hsla($ai-neon-hue, 100%, 65%, 0.12);
    color: $ai-cyan;
    padding: 3px 8px;
    border-radius: 6px;
    font-size: 13px;
    font-family: 'Fira Code', 'JetBrains Mono', Consolas, monospace;
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
