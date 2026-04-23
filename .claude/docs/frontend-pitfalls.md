# 前端踩坑记录

本文档记录前端开发中遇到的各类踩坑经验，供开发者查阅参考。

---

## Element Plus 组件踩坑

### Tooltip 深色模式下文字看不清

**问题描述**：Element Plus 的 Tooltip 组件默认使用 `effect="dark"`，在项目开启深色模式时，tooltip 背景与文字对比度不够，导致汉字看不清。

**解决方案**：显式设置 `effect="light"`

```vue
<!-- ❌ 错误：深色模式下看不清 -->
<el-tooltip content="吃得很满足">
  <el-button>😄</el-button>
</el-tooltip>

<!-- ✅ 正确：使用 effect="light" -->
<el-tooltip content="吃得很满足" effect="light">
  <el-button>😄</el-button>
</el-tooltip>
```

**参考案例**：`brainstorm/index.vue` 中的标签选择器、饮食记录的，心情选择器。

---

### el-dialog 关闭按钮垂直居中偏移

**问题描述**：覆盖 el-dialog 样式时，如果选择器格式不对，关闭按钮会偏离正常位置。

**原因**：Element Plus 内部 `.el-dialog__headerbtn` 使用 `position: absolute` + `transform: translateY(-50%)` 实现垂直居中。如果外层选择器嵌套层级不对，transform 的基准元素会错误。

**错误写法**：
```scss
/* ❌ 错误：父级选择器作为基准，导致 transform 偏移 */
.detail-dialog {
  :deep(.el-dialog__header) {
    .el-dialog__headerbtn { ... }
  }
}
```

**正确写法**：
```scss
/* ✅ 正确：使用 :deep(.xxx.el-dialog) 格式，与 Element Plus 内部选择器格式一致 */
:deep(.detail-dialog.el-dialog) {
  .el-dialog__header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-right: 0;

    .el-dialog__title {
      font-size: 16px;
      font-weight: 600;
    }

    .el-dialog__headerbtn {
      position: static;  /* 重置绝对定位 */
      top: auto;
      right: auto;
      font-size: 18px;

      .el-dialog__close {
        color: var(--text-secondary);
        &:hover {
          color: var(--el-color-primary);
        }
      }
    }
  }
}
```

**关键点**：
1. 使用 `:deep(.父级类.el-dialog)` 格式
2. `.el-dialog__header` 设置 `margin-right: 0`
3. `.el-dialog__headerbtn` 设置 `position: static; top: auto; right: auto;`

---

## 布局踩坑

### 嵌套滚动容器内容被裁剪

**问题描述**：父容器 flex 布局 + overflow，子容器内容超出时无法滚动，内容被裁剪。

**错误示例**：
```scss
.outer-container {
  flex: 1;
  overflow-y: auto;  /* 外层滚动 */
  display: flex;
  flex-direction: column;

  .inner-content {
    height: 100%;      /* ❌ 错误：撑满父容器 */
    overflow-y: auto;  /* 这个永远触不到 */
  }
}
```

**正确示例**：
```scss
.outer-container {
  flex: 1;
  min-height: 0;      /* ✅ 关键：允许收缩 */
  overflow: hidden;   /* 外层不滚动 */
  display: flex;
  flex-direction: column;

  .inner-content {
    flex: 1;
    min-height: 0;     /* ✅ 关键：允许收缩以适应空间 */
    overflow-y: auto;  /* 内层滚动 */
    padding: 20px;
  }
}
```

**关键点**：
- 外层 `overflow: hidden` 防止自身滚动
- 内层 `flex: 1` + `min-height: 0` 让内容区自动扩展高度
- 内层 `overflow-y: auto` 提供滚动能力

---

## 样式踩坑

### 禁止使用硬编码颜色值

**原则**：颜色能使用 CSS 变量，优先使用变量，支持亮色/暗黑主题自动切换。

**错误示例**：
```scss
/* ❌ 错误：硬编码颜色 */
.my-component {
  color: #333;
  background: #fff;
  border-color: #e2e8f0;
}
```

**正确示例**：
```scss
/* ✅ 正确：使用 CSS 变量 */
.my-component {
  color: var(--text-primary);
  background: var(--bg-primary);
  border-color: var(--border-color);
}
```

**项目 CSS 变量**（定义在 `src/styles/index.scss`）：

| 变量 | 亮色值 | 暗黑值 | 用途 |
|------|--------|--------|------|
| `--el-color-primary` | #FE4066 | #FE4066 | 主题色 |
| `--text-primary` | #0f172a | #f1f5f9 | 主文字 |
| `--text-secondary` | #64748b | #94a3b8 | 次要文字 |
| `--bg-primary` | #ffffff | #1e293b | 主背景 |
| `--bg-secondary` | #f8fafc | #0f172a | 次背景 |
| `--border-color` | #e2e8f0 | #334155 | 边框色 |

---

## 待补充

更多踩坑经验持续补充中...
