import request from '@/utils/request'

// ==================== 数据库管理 ====================

export function getDatabasePageApi(params: any) {
  return request({
    url: '/datamodel/database/page',
    method: 'get',
    params
  })
}

export function getDatabaseListApi() {
  return request({
    url: '/datamodel/database/list',
    method: 'get'
  })
}

export function getDatabaseByIdApi(id: number) {
  return request({
    url: `/datamodel/database/${id}`,
    method: 'get'
  })
}

export function addDatabaseApi(data: any) {
  return request({
    url: '/datamodel/database',
    method: 'post',
    data
  })
}

export function updateDatabaseApi(data: any) {
  return request({
    url: '/datamodel/database',
    method: 'put',
    data
  })
}

export function deleteDatabaseApi(id: number) {
  return request({
    url: `/datamodel/database/${id}`,
    method: 'delete'
  })
}

// ==================== 数据表管理 ====================

export function getTablePageApi(params: any) {
  return request({
    url: '/datamodel/table/page',
    method: 'get',
    params
  })
}

export function getTableListApi(databaseId: number) {
  return request({
    url: `/datamodel/table/list/${databaseId}`,
    method: 'get'
  })
}

export function getTableTreeApi() {
  return request({
    url: '/datamodel/table/tree',
    method: 'get'
  })
}

export function getTableByIdApi(id: number) {
  return request({
    url: `/datamodel/table/${id}`,
    method: 'get'
  })
}

export function addTableApi(data: any) {
  return request({
    url: '/datamodel/table',
    method: 'post',
    data
  })
}

export function updateTableApi(data: any) {
  return request({
    url: '/datamodel/table',
    method: 'put',
    data
  })
}

export function deleteTableApi(id: number) {
  return request({
    url: `/datamodel/table/${id}`,
    method: 'delete'
  })
}

// ==================== 字段管理 ====================

export function getColumnListApi(tableId: number) {
  return request({
    url: `/datamodel/column/list/${tableId}`,
    method: 'get'
  })
}

export function getTableColumnsApi(tableId: number) {
  return request({
    url: `/datamodel/column/list/${tableId}`,
    method: 'get'
  })
}

export function addColumnApi(data: any) {
  return request({
    url: '/datamodel/column',
    method: 'post',
    data
  })
}

export function updateColumnApi(data: any) {
  return request({
    url: '/datamodel/column',
    method: 'put',
    data
  })
}

export function deleteColumnApi(id: number) {
  return request({
    url: `/datamodel/column/${id}`,
    method: 'delete'
  })
}

// ==================== 关系管理 ====================

export function getRelationListApi(databaseId: number) {
  return request({
    url: '/datamodel/relation/list',
    method: 'get',
    params: { databaseId }
  })
}

export function addRelationApi(data: any) {
  return request({
    url: '/datamodel/relation',
    method: 'post',
    data
  })
}

export function updateRelationApi(data: any) {
  return request({
    url: '/datamodel/relation',
    method: 'put',
    data
  })
}

export function deleteRelationApi(id: number) {
  return request({
    url: `/datamodel/relation/${id}`,
    method: 'delete'
  })
}

// ==================== E-R 图 ====================

export function getERDiagramApi(databaseId: number) {
  return request({
    url: `/datamodel/er-diagram/${databaseId}`,
    method: 'get'
  })
}
