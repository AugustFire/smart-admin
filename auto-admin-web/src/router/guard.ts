import type { Router } from 'vue-router'
import { useUserStore } from '@/store/modules/user'
import { usePermissionStore } from '@/store/modules/permission'
import { getUserMenusApi } from '@/api/auth'

export function createRouterGuard(router: Router) {
  router.beforeEach(async (to, _from, next) => {
    const userStore = useUserStore()
    const permissionStore = usePermissionStore()
    const isLoggedIn = userStore.isLoggedIn

    // 如果访问登录页，且已登录，跳转到首页
    if (to.path === '/login') {
      if (isLoggedIn) {
        next({ path: '/' })
      } else {
        next()
      }
      return
    }

    // 如果未登录，跳转到登录页
    if (!isLoggedIn) {
      next({ path: '/login', query: { redirect: to.fullPath } })
      return
    }

    // 如果是首次加载或 routes 为空，加载用户信息和菜单
    if (!userStore.userInfo || permissionStore.routes.length === 0) {
      try {
        const userStore = useUserStore()
        await userStore.getUserInfo()
        await loadUserMenus(router)
        next({ ...to, replace: true })
      } catch (error) {
        console.error('加载用户信息失败:', error)
        await userStore.logout()
        next({ path: '/login', query: { redirect: to.fullPath } })
      }
      return
    }

    next()
  })

  router.afterEach(() => {
    // 可以在这里设置页面 title
    document.title = 'Smart Admin'
  })
}

// 加载用户菜单并生成动态路由
async function loadUserMenus(router: Router) {
  const permissionStore = usePermissionStore()

  const { data } = await getUserMenusApi()
  const menus = data || []

  console.log('获取到的菜单数据:', menus)

  // 使用 permission store 生成路由
  const dynamicRoutes = permissionStore.generateRoutes(menus)

  console.log('生成的动态路由:', dynamicRoutes)

  // 动态添加路由 - 添加到 layout 路由的 children 中
  dynamicRoutes.forEach(route => {
    router.addRoute('layout', route)
  })
}
