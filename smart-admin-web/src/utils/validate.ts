/**
 * 判断是否是外部链接
 */
export function isExternal(path: string): boolean {
  return /^(https?:|mailto:|tel:)/.test(path)
}

/**
 * 验证是否是合法的邮箱
 */
export function isValidEmail(email: string): boolean {
  const reg = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
  return reg.test(email)
}

/**
 * 验证是否是合法的手机号
 */
export function isValidPhone(phone: string): boolean {
  const reg = /^1\d{10}$/
  return reg.test(phone)
}
