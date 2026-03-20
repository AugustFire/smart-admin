import type { Directive, DirectiveBinding } from 'vue'
import { useUserStore } from '@/store/modules/user'

/**
 * v-permission 指令
 * 用于控制按钮/操作的权限显示
 * 用法：v-permission="['user:add']"
 */
function checkPermission(el: HTMLElement, binding: DirectiveBinding) {
  const { value } = binding
  const userStore = useUserStore()
  const permissions = userStore.permissions || []
  const roles = userStore.roles || []

  // 如果是空数组或者没有值，不做权限检查
  if (value && value.length > 0) {
    const permissionTypes = value

    // 检查是否有 super_admin 角色（超级管理员拥有所有权限）
    const hasSuperAdminRole = roles.includes('super_admin')
    if (hasSuperAdminRole) {
      return
    }

    // 检查是否有对应的权限
    const hasPermission = permissionTypes.some((permission: string) => {
      return permissions.includes(permission)
    })

    if (!hasPermission) {
      // 没有权限，移除元素
      el.parentNode?.removeChild(el)
    }
  }
}

const permission: Directive = {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding)
  },
  updated(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding)
  },
}

export default permission
