import { defineStore } from 'pinia'
import type { RouteRecordRaw } from 'vue-router'

interface PermissionState {
  routes: RouteRecordRaw[]
  addRoutes: RouteRecordRaw[]
}

export const usePermissionStore = defineStore('permission', {
  state: (): PermissionState => ({
    routes: [],
    addRoutes: [],
  }),

  getters: {
    // 无额外 getter，直接使用 state 中的 routes 和 addRoutes
  },

  actions: {
    // 根据菜单生成路由
    generateRoutes(menus: any[]) {
      const routes: RouteRecordRaw[] = []

      menus.forEach((menu) => {
        // 只处理目录和菜单类型，跳过按钮
        if (menu.type === 1 || menu.type === 2) {
          const route = this.buildRoute(menu)
          routes.push(route)
        }
      })

      this.addRoutes = routes
      this.routes = routes
      console.log('生成的动态路由:', routes)
      return routes
    },

    // 构建单个路由
    buildRoute(menu: any): any {
      const route: any = {
        path: menu.path,
        name: this.toCamelCase(menu.name),
        meta: {
          title: menu.name,
          icon: menu.icon,
          menuId: menu.id,
          type: menu.type,
          hidden: menu.visible === 0, // visible=0 表示隐藏，不在侧边栏显示
        },
      }

      // 目录类型 - 只作为父容器
      if (menu.type === 1) {
        // 如果有子菜单，设置 redirect 到第一个子菜单
        if (menu.children && menu.children.length > 0) {
          const firstChild = menu.children.find((c: any) => c.visible === 1 && c.type === 2)
          if (firstChild) {
            route.redirect = firstChild.path
          }
        }
      } else if (menu.type === 2) {
        // 菜单类型 - 加载组件
        route.component = this.loadComponent(menu.component)
      }

      // 递归处理子菜单
      if (menu.children && menu.children.length > 0) {
        route.children = this.buildChildrenRoutes(menu.children)
      }

      return route
    },

    // 构建子路由
    buildChildrenRoutes(children: any[]): RouteRecordRaw[] {
      const routes: RouteRecordRaw[] = []

      children.forEach((child: any) => {
        // 跳过按钮
        if (child.type === 3) {
          return
        }

        const route = this.buildRoute(child)
        routes.push(route)
      })

      return routes
    },

    // 转换为驼峰命名
    toCamelCase(str: string): string {
      if (!str) return ''
      return str.replace(/-(\w)/g, (_, c) => c.toUpperCase())
    },

    // 动态加载组件
    loadComponent(path: string) {
      if (!path) {
        return () => import('@/views/Error/404.vue')
      }
      // 处理 Layout 特殊情况
      if (path === 'Layout') {
        return () => import('@/layout/index.vue')
      }
      // Vite 要求动态导入路径必须是静态的或使用映射
      // 使用映射方式加载组件
      const componentMap: Record<string, () => Promise<any>> = {
        'dashboard/index': () => import('@/views/Dashboard/index.vue'),
        'profile/index': () => import('@/views/Profile/index.vue'),
        'system/user/index': () => import('@/views/System/User/index.vue'),
        'system/role/index': () => import('@/views/System/Role/index.vue'),
        'system/menu/index': () => import('@/views/System/Menu/index.vue'),
        'system/api/index': () => import('@/views/System/Api/index.vue'),
        'system/dict/index': () => import('@/views/System/Dict/index.vue'),
        'system/loginlog/index': () => import('@/views/System/Loginlog/index.vue'),
        'system/operlog/index': () => import('@/views/System/Operlog/index.vue'),
        'devtools/datamodel/index': () => import('@/views/DevTools/DataModel/index.vue'),
      }

      return componentMap[path] || (() => import('@/views/Error/404.vue'))
    },
  },
})
