import axios, { type AxiosInstance, type AxiosRequestConfig, type AxiosResponse } from 'axios'
import { ElMessage } from 'element-plus'

// 响应数据接口
export interface Result<T = any> {
  code: number
  message: string
  data: T
  timestamp?: number
}

// 创建 axios 实例
const service: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8',
  },
})

// 请求拦截器
service.interceptors.request.use(
  (config) => {
    // 从 localStorage 直接读取 token，避免循环依赖
    const userStoreStr = localStorage.getItem('user-store')
    let token: string | undefined
    if (userStoreStr) {
      try {
        const userStore = JSON.parse(userStoreStr)
        token = userStore.token
      } catch (e) {
        console.error('解析 user-store 失败:', e)
      }
    }

    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }

    return config
  },
  (error) => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器 - 优化错误提示
service.interceptors.response.use(
  (response) => {
    const res = response.data

    // 如果是文件下载，直接返回
    if (response.config.responseType === 'blob' || response.config.responseType === 'arraybuffer') {
      return response
    }

    // 成功
    if (res.code === 200) {
      return res
    }

    // 未授权
    if (res.code === 401) {
      ElMessage.warning('登录状态已过期，请重新登录')
      localStorage.removeItem('user-store')
      setTimeout(() => {
        window.location.href = '/login'
      }, 1500)
      return Promise.reject(new Error(res.message || 'Error'))
    }

    // 禁止访问
    if (res.code === 403) {
      ElMessage.warning(res.message || '暂无访问权限')
      return Promise.reject(new Error(res.message || 'Error'))
    }

    // 其他错误 - 使用优化后的消息提示
    ElMessage.error(res.message || '请求失败')
    return Promise.reject(new Error(res.message || 'Error'))
  },
  (error) => {
    let message = '网络错误，请稍后重试'

    if (error.response) {
      const status = error.response.status
      switch (status) {
        case 400:
          message = '请求参数有误'
          break
        case 404:
          message = '请求的资源不存在'
          break
        case 500:
          message = '服务器繁忙，请稍后重试'
          break
        case 502:
          message = '网关异常'
          break
        case 503:
          message = '服务暂时不可用'
          break
        case 504:
          message = '请求超时'
          break
        default:
          message = `网络异常 (${status})`
      }
    } else if (error.request) {
      message = '网络连接失败，请检查网络'
    }

    ElMessage({
      type: 'error',
      message,
      duration: 3000,
      offset: 60,
    })
    return Promise.reject(error)
  }
)

// 导出请求方法
export const http = {
  get<T = any>(url: string, config?: AxiosRequestConfig): Promise<Result<T>> {
    return service.get(url, config)
  },

  post<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<Result<T>> {
    return service.post(url, data, config)
  },

  put<T = any>(url: string, data?: any, config?: AxiosRequestConfig): Promise<Result<T>> {
    return service.put(url, data, config)
  },

  delete<T = any>(url: string, config?: AxiosRequestConfig): Promise<Result<T>> {
    return service.delete(url, config)
  },

  download(url: string, config?: AxiosRequestConfig): Promise<AxiosResponse> {
    return service.get(url, { ...config, responseType: 'blob' })
  },
}

export default service
