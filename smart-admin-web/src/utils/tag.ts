/**
 * 解析逗号分隔的标签字符串为数组
 */
export function formatTags(tagsStr: string | undefined, delimiter = ','): string[] {
  if (!tagsStr) return []
  return tagsStr.split(delimiter).filter(t => t.trim())
}