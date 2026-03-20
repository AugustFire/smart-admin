import { defineStore } from 'pinia'

interface TagsViewState {
  visitedViews: Array<{
    path: string
    title: string
    name?: string
    fullPath?: string
    affix?: boolean
    meta?: {
      title?: string
      icon?: string
      affix?: boolean
    }
  }>
  cachedViews: string[]
}

export const useTagsViewStore = defineStore('tagsView', {
  state: (): TagsViewState => ({
    visitedViews: [],
    cachedViews: [],
  }),

  actions: {
    addVisitedView(view: any) {
      // 如果已经存在，不重复添加
      if (this.visitedViews.some((v) => v.path === view.path)) {
        return
      }

      // 确保 title 正确设置
      const viewToStore = {
        path: view.path,
        fullPath: view.fullPath,
        title: view.title || view.meta?.title || '未命名页面',
        name: view.name,
        affix: view.meta?.affix,
        meta: view.meta,
        query: view.query,
      }

      // 如果是 affix 的标签，添加到开头
      if (view.meta?.affix) {
        this.visitedViews.unshift(viewToStore)
      } else {
        this.visitedViews.push(viewToStore)
      }
    },

    addCachedView(view: any) {
      if (!view.name) return
      if (this.cachedViews.includes(view.name)) return
      this.cachedViews.push(view.name)
    },

    delVisitedView(view: any) {
      const index = this.visitedViews.findIndex((v) => v.path === view.path)
      if (index > -1) {
        return this.visitedViews.splice(index, 1)[0]
      }
    },

    delCachedView(view: any) {
      if (!view.name) return
      const index = this.cachedViews.indexOf(view.name)
      if (index > -1) {
        return this.cachedViews.splice(index, 1)[0]
      }
    },

    delOthersViews(view: any) {
      this.visitedViews = this.visitedViews.filter((v) => {
        return v.meta?.affix || v.path === view.path
      })
      const index = this.cachedViews.indexOf(view.name)
      if (index > -1) {
        this.cachedViews = this.cachedViews.slice(index, index + 1)
      } else {
        this.cachedViews = []
      }
    },

    delAllViews() {
      this.visitedViews = this.visitedViews.filter((v) => v.meta?.affix)
      this.cachedViews = []
    },

    updateVisitedView(view: any) {
      const index = this.visitedViews.findIndex((v) => v.path === view.path)
      if (index > -1) {
        this.visitedViews.splice(index, 1, view)
      }
    },

    // 添加标签页
    addView(view: any) {
      this.addVisitedView(view)
      this.addCachedView(view)
    },

    // 删除标签页
    delView(view: any) {
      return new Promise((resolve) => {
        this.delVisitedView(view)
        this.delCachedView(view)
        resolve({
          visitedViews: [...this.visitedViews],
          cachedViews: [...this.cachedViews],
        })
      })
    },

    // 删除其他标签页
    delOthersViewsAsync(view: any) {
      return new Promise((resolve) => {
        this.delOthersViews(view)
        resolve({
          visitedViews: [...this.visitedViews],
          cachedViews: [...this.cachedViews],
        })
      })
    },

    // 删除所有标签页
    delAllViewsAsync() {
      return new Promise((resolve) => {
        this.delAllViews()
        resolve({
          visitedViews: [...this.visitedViews],
          cachedViews: [...this.cachedViews],
        })
      })
    },
  },

  persist: {
    key: 'tags-view-store',
    storage: sessionStorage,
  },
})
