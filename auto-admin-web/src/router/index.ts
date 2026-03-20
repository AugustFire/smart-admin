import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { createRouterGuard } from './guard'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' },
  },
  {
    path: '/',
    name: 'layout',
    component: () => import('@/layout/index.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard/index.vue'),
        meta: { title: '首页', icon: 'House' },
      },
    ],
  },
  // 404 页面
  {
    path: '/:pathMatch(.*)*',
    redirect: '/404',
  },
  {
    path: '/404',
    name: '404',
    component: () => import('@/views/Error/404.vue'),
    meta: { title: '404' },
  },
  // 个人中心 - 静态路由，不显示在菜单中但可访问
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile/index.vue'),
    meta: { title: '个人中心' },
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

// 添加路由守卫
createRouterGuard(router)

export default router
