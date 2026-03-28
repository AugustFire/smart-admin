<template>
  <div class="er-diagram" ref="erDiagramRef">
    <!-- 顶部工具栏 -->
    <div class="toolbar">
      <div class="toolbar-left">
        <el-select v-model="currentDatabaseId" placeholder="选择数据库" clearable style="width: 180px;" @change="handleDatabaseChange">
          <el-option v-for="db in databaseList" :key="db.id" :label="db.name" :value="db.id" />
        </el-select>
        <el-divider direction="vertical" />
        <el-button-group>
          <el-button type="primary" @click="addAllTables" :disabled="!currentDatabaseId || tableList.length === 0">显示全部</el-button>
          <el-button @click="clearAll" :disabled="nodeList.length === 0">清空</el-button>
          <el-button @click="autoLayout" :disabled="nodeList.length === 0">自动布局</el-button>
        </el-button-group>
        <el-divider direction="vertical" />
        <el-button-group>
          <el-button @click="zoomIn" :icon="ZoomIn" title="放大" />
          <el-button @click="zoomOut" :icon="ZoomOut" title="缩小" />
        </el-button-group>
      </div>
      <div class="toolbar-right">
        <el-button-group>
          <el-button @click="toggleFullscreen" :icon="isFullscreen ? Close : FullScreen" :title="isFullscreen ? '退出全屏' : '全屏'" />
        </el-button-group>
        <el-divider direction="vertical" />
        <el-tag type="info" v-if="currentDatabaseName">
          {{ currentDatabaseName }} - {{ nodeList.length }} 张表
        </el-tag>
      </div>
    </div>

    <!-- 主体区域 -->
    <div class="main-content">
      <!-- 左侧表列表 -->
      <div class="table-panel">
        <div class="panel-header">
          <span class="panel-title">选择表</span>
          <el-input v-model="searchKeyword" placeholder="搜索表名" clearable size="small" />
        </div>
        <div class="panel-content">
          <div v-if="!currentDatabaseId" class="empty-tip">请先选择数据库</div>
          <div v-else-if="filteredTables.length === 0" class="empty-tip">暂无数据表</div>
          <div v-else class="table-list">
            <div
              v-for="table in filteredTables"
              :key="table.id"
              class="table-item"
              :class="{ 'is-selected': isTableSelected(table.id) }"
              @click="toggleTable(table)"
            >
              <el-checkbox :model-value="isTableSelected(table.id)" />
              <el-icon class="table-icon"><Grid /></el-icon>
              <span class="table-name">{{ table.name }}</span>
              <span class="table-code">{{ table.code }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧画布 -->
      <div class="canvas-panel" ref="canvasPanelRef">
        <div v-if="!currentDatabaseId" class="canvas-placeholder">
          <el-icon :size="64" color="#dcdfe6"><DataAnalysis /></el-icon>
          <p>请先选择数据库</p>
        </div>
        <div v-else-if="nodeList.length === 0" class="canvas-placeholder">
          <el-icon :size="64" color="#dcdfe6"><CirclePlus /></el-icon>
          <p>从左侧选择表显示到画布</p>
        </div>

        <!-- 画布区域 -->
        <div v-else class="canvas-wrapper"
             :style="canvasStyle"
             @mousedown="handleCanvasMouseDown"
             @mousemove="handleCanvasMouseMove"
             @mouseup="handleCanvasMouseUp"
             @mouseleave="handleCanvasMouseUp"
             @wheel.prevent="handleWheel">

          <!-- SVG 连线层 -->
          <svg class="svg-layer" :width="canvasWidth" :height="canvasHeight">
            <defs>
              <marker id="arrow-end" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto" markerUnits="strokeWidth">
                <path d="M0,0 L0,6 L9,3 z" fill="#909399" />
              </marker>
            </defs>
            <g v-for="edge in edgeList" :key="edge.id">
              <path
                :d="edge.path"
                fill="none"
                :stroke="edge.color"
                stroke-width="2"
                marker-end="url(#arrow-end)"
              />
              <rect
                :x="edge.labelX - 18"
                :y="edge.labelY - 10"
                width="36"
                height="20"
                :fill="isDarkTheme ? '#1e293b' : '#fff'"
                :stroke="edge.color"
                stroke-width="1"
                rx="10"
                opacity="0.95"
              />
              <text
                :x="edge.labelX"
                :y="edge.labelY"
                text-anchor="middle"
                dominant-baseline="middle"
                font-size="11"
                font-weight="600"
                :fill="edge.color"
              >{{ edge.label }}</text>
            </g>
          </svg>

          <!-- 表节点 -->
          <div
            v-for="node in nodeList"
            :key="node.tableId"
            class="er-node"
            :class="{
              'is-dragging': draggingNodeId === node.tableId,
              'is-selected': selectedNodeId === node.tableId
            }"
            :style="{
              left: node.x + 'px',
              top: node.y + 'px',
              width: node.width + 'px'
            }"
            @mousedown.stop="handleNodeMouseDown($event, node)"
            @dblclick="showTableDetail(node)"
            @click.stop="selectNode(node.tableId)"
          >
            <div class="node-header">
              <span class="node-title">{{ node.name }}</span>
              <el-icon class="node-close" @click.stop="removeTable(node.tableId)"><Close /></el-icon>
            </div>
            <div class="node-body">
              <div
                v-for="col in getCoreColumns(node.columns)"
                :key="col.id"
                class="node-field"
                :class="{ 'is-pk': col.isPrimary, 'is-fk': col.isForeign }"
              >
                <span class="field-icon">{{ getFieldIcon(col) }}</span>
                <span class="field-name">{{ col.name }}</span>
                <span class="field-type">{{ col.dataType }}</span>
              </div>
              <div v-if="node.columns.length > getCoreColumns(node.columns).length" class="field-more">
                +{{ node.columns.length - getCoreColumns(node.columns).length }} 个字段
              </div>
            </div>
          </div>
        </div>

        <!-- 图例 -->
        <div v-if="nodeList.length > 0" class="legend">
          <div class="legend-title">图例</div>
          <div class="legend-item"><span class="legend-icon">🔑</span><span>主键</span></div>
          <div class="legend-item"><span class="legend-icon">🔗</span><span>外键</span></div>
        </div>

        <!-- 缩放指示器 -->
        <div v-if="nodeList.length > 0" class="zoom-indicator">
          {{ Math.round(scale * 100) }}%
        </div>
      </div>
    </div>

    <!-- 表详情弹窗 -->
    <el-dialog v-model="detailVisible" :title="currentTable?.name + ' - 字段列表'" width="700px">
      <el-table :data="currentTable?.columns" size="small" border stripe>
        <el-table-column prop="name" label="字段名" width="120" />
        <el-table-column prop="code" label="编码" width="120" />
        <el-table-column prop="dataType" label="类型" width="100" />
        <el-table-column label="属性" width="120" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.isPrimary" type="danger" size="small">主键</el-tag>
            <el-tag v-if="row.isForeign" type="warning" size="small">外键</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" show-overflow-tooltip />
      </el-table>
    </el-dialog>

    <!-- 文本描述面板 -->
    <div class="description-panel" v-if="nodeList.length > 0">
      <div class="panel-header">
        <span class="panel-title">📋 数据模型描述</span>
        <div class="panel-actions">
          <el-button type="primary" size="small" @click="copyDescription" :disabled="!descriptionText">
            {{ copied ? '已复制' : '复制' }}
          </el-button>
        </div>
      </div>
      <div class="panel-body">
        <textarea class="description-text" :value="descriptionText" readonly></textarea>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ZoomIn, ZoomOut, FullScreen, Grid, DataAnalysis, CirclePlus, Close } from '@element-plus/icons-vue'
import {
  getDatabaseListApi,
  getTableListApi,
  getColumnListApi,
  getRelationListApi
} from '@/api/datamodel'

// 节点类型
interface NodeData {
  tableId: number
  name: string
  code: string
  x: number
  y: number
  width: number
  columns: any[]
}

// 数据状态
const databaseList = ref<any[]>([])
const tableList = ref<any[]>([])
const relationList = ref<any[]>([])
const currentDatabaseId = ref<number | null>(null)
const currentDatabaseName = ref('')
const currentDatabaseType = ref('mysql')
const searchKeyword = ref('')

// 节点数据 - 使用数组保证响应式
const nodeList = ref<NodeData[]>([])

// 画布状态
const canvasPanelRef = ref<HTMLElement>()
const scale = ref(1)
const canvasOffset = ref({ x: 0, y: 0 })  // 画布整体偏移

// 动态计算画布尺寸
const canvasWidth = computed(() => {
  if (nodeList.value.length === 0) return 2000
  let maxX = 0
  nodeList.value.forEach(node => {
    maxX = Math.max(maxX, node.x + node.width + 100)
  })
  return Math.max(2000, maxX)
})

const canvasHeight = computed(() => {
  if (nodeList.value.length === 0) return 1500
  let maxY = 0
  nodeList.value.forEach(node => {
    const nodeHeight = getNodeHeight(node.columns)
    maxY = Math.max(maxY, node.y + nodeHeight + 100)
  })
  return Math.max(1500, maxY)
})

// 拖拽状态
const draggingNodeId = ref<number | null>(null)
const selectedNodeId = ref<number | null>(null)
const dragStartPos = ref({ x: 0, y: 0 })
const dragOffset = ref({ x: 0, y: 0 })
const isPanning = ref(false)
const panStart = ref({ x: 0, y: 0 })

// 详情弹窗
const detailVisible = ref(false)
const currentTable = ref<NodeData | null>(null)

// 复制状态
const copied = ref(false)

// 全屏状态
const isFullscreen = ref(false)
const erDiagramRef = ref<HTMLElement>()

onMounted(() => {
  loadDatabases()
  // 添加键盘快捷键监听
  document.addEventListener('keydown', handleKeyDown)
  document.addEventListener('click', handleDocumentClick)
  // 监听全屏变化
  document.addEventListener('fullscreenchange', handleFullscreenChange)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeyDown)
  document.removeEventListener('click', handleDocumentClick)
  document.removeEventListener('fullscreenchange', handleFullscreenChange)
})

// 计算属性
const filteredTables = computed(() => {
  if (!searchKeyword.value) return tableList.value
  const keyword = searchKeyword.value.toLowerCase()
  return tableList.value.filter(t =>
    t.name.toLowerCase().includes(keyword) ||
    t.code.toLowerCase().includes(keyword)
  )
})

const edgeList = computed(() => {
  const nodeIds = new Set(nodeList.value.map(n => n.tableId))
  const edges = relationList.value.filter(r =>
    nodeIds.has(r.sourceTableId) && nodeIds.has(r.targetTableId)
  )

  // 统计每对节点之间的连线数量，用于偏移
  const pairCount = new Map<string, number>()
  const pairIndex = new Map<string, number>()

  return edges.map((relation, index) => {
    const source = nodeList.value.find(n => n.tableId === relation.sourceTableId)
    const target = nodeList.value.find(n => n.tableId === relation.targetTableId)
    if (!source || !target) return null

    // 生成节点对的唯一标识（小的ID在前）
    const minId = Math.min(relation.sourceTableId, relation.targetTableId)
    const maxId = Math.max(relation.sourceTableId, relation.targetTableId)
    const pairKey = `${minId}-${maxId}`

    // 获取该节点对的连线索引
    const count = pairCount.get(pairKey) || 0
    pairCount.set(pairKey, count + 1)
    const edgeIndex = pairIndex.get(pairKey) || 0
    pairIndex.set(pairKey, edgeIndex + 1)

    const pathInfo = calculatePath(source, target, count, edgeIndex)
    return {
      id: `rel-${relation.id}`,
      path: pathInfo.path,
      labelX: pathInfo.midX,
      labelY: pathInfo.midY,
      label: getRelationLabel(relation.relationType),
      color: getRelationColor(relation.relationType)
    }
  }).filter(Boolean) as any[]
})

const canvasStyle = computed(() => ({
  transform: `scale(${scale.value}) translate(${canvasOffset.value.x}px, ${canvasOffset.value.y}px)`,
  transformOrigin: '0 0',
  width: canvasWidth.value + 'px',
  height: canvasHeight.value + 'px'
}))

// 检测深色主题
const isDarkTheme = computed(() => {
  return document.documentElement.getAttribute('data-theme') === 'dark'
})

// 文本描述 - 用于 AI 生成 SQL
const descriptionText = computed(() => {
  if (nodeList.value.length === 0) return ''

  const lines: string[] = []
  const dbTypeLabel: Record<string, string> = {
    'mysql': 'MySQL',
    'sqlserver': 'SQL Server',
    'postgresql': 'PostgreSQL'
  }

  // 数据库名称和类型
  lines.push(`【数据库】${currentDatabaseName.value} (${dbTypeLabel[currentDatabaseType.value] || currentDatabaseType.value})`)
  lines.push('')

  // 表结构
  lines.push('【表结构】')
  nodeList.value.forEach((node, index) => {
    lines.push(`${index + 1}. ${node.name} (${node.code})`)
    node.columns.forEach(col => {
      const flags: string[] = []
      if (col.isPrimary) flags.push('PK')
      if (col.isForeign) flags.push('FK')
      const flagStr = flags.length > 0 ? `, ${flags.join(',')}` : ''
      const typeStr = col.length ? `${col.dataType}(${col.length})` : col.dataType
      const desc = col.description ? ` - ${col.description}` : ''
      lines.push(`   - ${col.code} (${typeStr}${flagStr})${desc}`)
    })
    lines.push('')
  })

  // 表关系（仅显示画布中存在的关系）
  const nodeIds = new Set(nodeList.value.map(n => n.tableId))
  const visibleRelations = relationList.value.filter(r =>
    nodeIds.has(r.sourceTableId) && nodeIds.has(r.targetTableId)
  )

  if (visibleRelations.length > 0) {
    lines.push('【表关系】')
    visibleRelations.forEach(rel => {
      const sourceNode = nodeList.value.find(n => n.tableId === rel.sourceTableId)
      const targetNode = nodeList.value.find(n => n.tableId === rel.targetTableId)

      // 从节点的 columns 中查找字段名
      const sourceCol = sourceNode?.columns.find(c => c.id === rel.sourceColumnId)
      const targetCol = targetNode?.columns.find(c => c.id === rel.targetColumnId)

      const sourceColName = sourceCol?.code || rel.sourceColumnName || '未知字段'
      const targetColName = targetCol?.code || rel.targetColumnName || '未知字段'

      const relLabel = getRelationLabel(rel.relationType)
      lines.push(`- ${sourceNode?.name}.${sourceColName} → ${targetNode?.name}.${targetColName} (${relLabel})`)
    })
  }

  return lines.join('\n')
})

// 数据加载
async function loadDatabases() {
  const { data } = await getDatabaseListApi()
  databaseList.value = data || []
}

async function handleDatabaseChange(val: number | null) {
  currentDatabaseId.value = val
  nodeList.value = []
  scale.value = 1
  canvasOffset.value = { x: 0, y: 0 }

  if (val) {
    const db = databaseList.value.find(d => d.id === val)
    currentDatabaseName.value = db?.name || ''
    currentDatabaseType.value = db?.type || 'mysql'
    await loadTables()
  } else {
    currentDatabaseName.value = ''
    currentDatabaseType.value = 'mysql'
    tableList.value = []
    relationList.value = []
  }
}

async function loadTables() {
  if (!currentDatabaseId.value) return
  const { data } = await getTableListApi(currentDatabaseId.value)
  tableList.value = data || []
  await loadRelations()
}

async function loadRelations() {
  if (!currentDatabaseId.value) return
  const { data } = await getRelationListApi(currentDatabaseId.value)
  relationList.value = data || []
}

async function loadTableColumns(tableId: number) {
  const { data } = await getColumnListApi(tableId)
  return data || []
}

// 表操作
function isTableSelected(id: number) {
  return nodeList.value.some(n => n.tableId === id)
}

async function toggleTable(table: any) {
  const index = nodeList.value.findIndex(n => n.tableId === table.id)
  if (index >= 0) {
    nodeList.value.splice(index, 1)
  } else {
    const columns = await loadTableColumns(table.id)
    const posIndex = nodeList.value.length
    nodeList.value.push({
      tableId: table.id,
      name: table.name,
      code: table.code,
      x: 50 + (posIndex % 4) * 280,
      y: 50 + Math.floor(posIndex / 4) * 220,
      width: 240,
      columns
    })
  }
}

function removeTable(tableId: number) {
  const index = nodeList.value.findIndex(n => n.tableId === tableId)
  if (index >= 0) {
    nodeList.value.splice(index, 1)
  }
}

async function addAllTables() {
  for (let i = 0; i < tableList.value.length; i++) {
    const table = tableList.value[i]
    if (!nodeList.value.some(n => n.tableId === table.id)) {
      const columns = await loadTableColumns(table.id)
      nodeList.value.push({
        tableId: table.id,
        name: table.name,
        code: table.code,
        x: 50 + (i % 4) * 280,
        y: 50 + Math.floor(i / 4) * 220,
        width: 240,
        columns
      })
    }
  }
}

function clearAll() {
  nodeList.value = []
  canvasOffset.value = { x: 0, y: 0 }
}

// 路径计算 - 使用贝塞尔曲线实现平滑连接
function calculatePath(source: NodeData, target: NodeData, totalCount: number, edgeIndex: number) {
  const sourceHeight = getNodeHeight(source.columns)
  const targetHeight = getNodeHeight(target.columns)

  // 节点中心点
  const scx = source.x + source.width / 2
  const scy = source.y + sourceHeight / 2
  const tcx = target.x + target.width / 2
  const tcy = target.y + targetHeight / 2

  const dx = tcx - scx
  const dy = tcy - scy

  // 计算偏移量（多条连线时错开）
  const offset = totalCount > 1 ? (edgeIndex - (totalCount - 1) / 2) * 25 : 0

  // 确定连接点（从节点边缘）
  let sx: number, sy: number, tx: number, ty: number
  let sourceSide: 'left' | 'right' | 'top' | 'bottom'
  let targetSide: 'left' | 'right' | 'top' | 'bottom'

  if (Math.abs(dx) > Math.abs(dy)) {
    // 水平方向为主
    if (dx > 0) {
      sx = source.x + source.width
      sy = scy + offset
      tx = target.x
      ty = tcy + offset
      sourceSide = 'right'
      targetSide = 'left'
    } else {
      sx = source.x
      sy = scy + offset
      tx = target.x + target.width
      ty = tcy + offset
      sourceSide = 'left'
      targetSide = 'right'
    }
  } else {
    // 垂直方向为主
    if (dy > 0) {
      sx = scx + offset
      sy = source.y + sourceHeight
      tx = tcx + offset
      ty = target.y
      sourceSide = 'bottom'
      targetSide = 'top'
    } else {
      sx = scx + offset
      sy = source.y
      tx = tcx + offset
      ty = target.y + targetHeight
      sourceSide = 'top'
      targetSide = 'bottom'
    }
  }

  // 计算控制点，使用贝塞尔曲线
  const distance = Math.sqrt(dx * dx + dy * dy)
  const curvature = Math.min(distance * 0.5, 120) // 控制弯曲程度

  let path: string

  // 两个节点较近时使用简单直线
  if (distance < 100) {
    path = `M ${sx} ${sy} L ${tx} ${ty}`
  } else {
    // 根据连接方向计算控制点
    let cp1x: number, cp1y: number, cp2x: number, cp2y: number

    if (sourceSide === 'right' && targetSide === 'left') {
      // 右 -> 左
      cp1x = sx + curvature
      cp1y = sy
      cp2x = tx - curvature
      cp2y = ty
    } else if (sourceSide === 'left' && targetSide === 'right') {
      // 左 -> 右
      cp1x = sx - curvature
      cp1y = sy
      cp2x = tx + curvature
      cp2y = ty
    } else if (sourceSide === 'bottom' && targetSide === 'top') {
      // 下 -> 上
      cp1x = sx
      cp1y = sy + curvature
      cp2x = tx
      cp2y = ty - curvature
    } else if (sourceSide === 'top' && targetSide === 'bottom') {
      // 上 -> 下
      cp1x = sx
      cp1y = sy - curvature
      cp2x = tx
      cp2y = ty + curvature
    } else {
      // 默认情况
      cp1x = sx + (tx - sx) * 0.3
      cp1y = sy + (ty - sy) * 0.3
      cp2x = tx - (tx - sx) * 0.3
      cp2y = ty - (ty - sy) * 0.3
    }

    // 使用三次贝塞尔曲线
    path = `M ${sx} ${sy} C ${cp1x} ${cp1y}, ${cp2x} ${cp2y}, ${tx} ${ty}`
  }

  // 计算标签位置（在曲线中点）
  const midX = (sx + tx) / 2
  const midY = (sy + ty) / 2

  return { path, midX, midY }
}

// 缩放控制
function zoomIn() {
  scale.value = Math.min(scale.value * 1.2, 2)
}

function zoomOut() {
  scale.value = Math.max(scale.value / 1.2, 0.5)
}

// 适应画布 - 计算所有节点的边界，缩放并居中
function fitView() {
  if (nodeList.value.length === 0 || !canvasPanelRef.value) return

  // 重置画布偏移
  canvasOffset.value = { x: 0, y: 0 }

  // 计算所有节点的边界框
  let minX = Infinity, minY = Infinity
  let maxX = -Infinity, maxY = -Infinity

  nodeList.value.forEach(node => {
    const nodeHeight = getNodeHeight(node.columns)
    minX = Math.min(minX, node.x)
    minY = Math.min(minY, node.y)
    maxX = Math.max(maxX, node.x + node.width)
    maxY = Math.max(maxY, node.y + nodeHeight)
  })

  const contentWidth = maxX - minX
  const contentHeight = maxY - minY
  const centerX = (minX + maxX) / 2
  const centerY = (minY + maxY) / 2

  // 获取画布面板尺寸
  const panelRect = canvasPanelRef.value.getBoundingClientRect()
  const panelWidth = panelRect.width - 80 // 留边距
  const panelHeight = panelRect.height - 80

  // 计算合适的缩放比例
  const scaleX = panelWidth / contentWidth
  const scaleY = panelHeight / contentHeight
  scale.value = Math.min(scaleX, scaleY, 1.2) // 最大不超过1.2
  scale.value = Math.max(scale.value, 0.3) // 最小0.3

  // 移动所有节点使其居中
  const scaledWidth = contentWidth * scale.value
  const scaledHeight = contentHeight * scale.value
  const targetCenterX = panelRect.width / 2
  const targetCenterY = panelRect.height / 2

  // 计算需要的偏移
  const offsetX = (targetCenterX - centerX * scale.value) / scale.value
  const offsetY = (targetCenterY - centerY * scale.value) / scale.value

  // 移动所有节点
  nodeList.value.forEach(node => {
    node.x += offsetX
    node.y += offsetY
  })
}

function handleWheel(e: WheelEvent) {
  if (e.deltaY < 0) {
    zoomIn()
  } else {
    zoomOut()
  }
}

// 拖拽处理 - 拖动空白区域移动所有节点
function handleCanvasMouseDown(e: MouseEvent) {
  isPanning.value = true
  panStart.value = { x: e.clientX, y: e.clientY }
}

function handleCanvasMouseMove(e: MouseEvent) {
  if (isPanning.value) {
    // 移动整个画布（使用 transform，SVG 和节点同步移动）
    const dx = (e.clientX - panStart.value.x) / scale.value
    const dy = (e.clientY - panStart.value.y) / scale.value

    canvasOffset.value.x += dx
    canvasOffset.value.y += dy

    panStart.value = { x: e.clientX, y: e.clientY }
  } else if (draggingNodeId.value !== null) {
    const node = nodeList.value.find(n => n.tableId === draggingNodeId.value)
    if (node) {
      const dx = (e.clientX - dragStartPos.value.x) / scale.value
      const dy = (e.clientY - dragStartPos.value.y) / scale.value
      node.x = dragOffset.value.x + dx
      node.y = dragOffset.value.y + dy
    }
  }
}

function handleCanvasMouseUp() {
  if (isPanning.value) {
    // 拖拽结束时，将偏移量应用到所有节点
    if (canvasOffset.value.x !== 0 || canvasOffset.value.y !== 0) {
      // 临时禁用 transition 避免跳跃动画
      const canvasWrapper = document.querySelector('.canvas-wrapper')
      const nodes = canvasWrapper?.querySelectorAll('.er-node')
      nodes?.forEach(node => {
        (node as HTMLElement).style.transition = 'none'
      })

      nodeList.value.forEach(node => {
        node.x += canvasOffset.value.x
        node.y += canvasOffset.value.y
      })

      // 强制刷新 DOM 后恢复 transition
      requestAnimationFrame(() => {
        nodes?.forEach(node => {
          (node as HTMLElement).style.transition = ''
        })
      })

      // 重置偏移量
      canvasOffset.value = { x: 0, y: 0 }
    }
  }
  isPanning.value = false
  draggingNodeId.value = null
}

function handleNodeMouseDown(e: MouseEvent, node: NodeData) {
  if (e.button !== 0) return
  draggingNodeId.value = node.tableId
  selectedNodeId.value = node.tableId
  dragStartPos.value = { x: e.clientX, y: e.clientY }
  dragOffset.value = { x: node.x, y: node.y }
}

// 选择节点
function selectNode(tableId: number) {
  selectedNodeId.value = tableId
}

// 点击文档其他地方取消选择
function handleDocumentClick(e: MouseEvent) {
  const target = e.target as HTMLElement
  if (!target.closest('.er-node') && !target.closest('.canvas-wrapper')) {
    selectedNodeId.value = null
  }
}

// 键盘快捷键处理
function handleKeyDown(e: KeyboardEvent) {
  // Delete - 删除选中节点
  if (e.key === 'Delete' && selectedNodeId.value !== null) {
    e.preventDefault()
    removeTable(selectedNodeId.value)
    selectedNodeId.value = null
    return
  }

  // Ctrl+A - 全选所有节点（仅当画布有焦点时）
  if (e.ctrlKey && e.key === 'a' && nodeList.value.length > 0) {
    e.preventDefault()
    // 这里可以实现多选逻辑，暂时只选第一个
    selectedNodeId.value = nodeList.value[0].tableId
    return
  }

  // +/- 缩放
  if (e.key === '+' || e.key === '=') {
    e.preventDefault()
    zoomIn()
    return
  }
  if (e.key === '-' || e.key === '_') {
    e.preventDefault()
    zoomOut()
    return
  }

  // 方向键移动选中节点
  if (selectedNodeId.value !== null) {
    const node = nodeList.value.find(n => n.tableId === selectedNodeId.value)
    if (!node) return

    const step = e.shiftKey ? 10 : 1
    switch (e.key) {
      case 'ArrowUp':
        e.preventDefault()
        node.y -= step
        break
      case 'ArrowDown':
        e.preventDefault()
        node.y += step
        break
      case 'ArrowLeft':
        e.preventDefault()
        node.x -= step
        break
      case 'ArrowRight':
        e.preventDefault()
        node.x += step
        break
    }
  }
}

// 自动布局 - Sugiyama 层次布局算法改进版
function autoLayout() {
  if (nodeList.value.length === 0) return

  // 重置画布偏移
  canvasOffset.value = { x: 0, y: 0 }

  const nodeMap = new Map(nodeList.value.map(n => [n.tableId, n]))
  const edges = relationList.value.filter(r =>
    nodeMap.has(r.sourceTableId) && nodeMap.has(r.targetTableId)
  )

  if (edges.length === 0) {
    // 无关系时，简单网格布局
    simpleGridLayout()
    fitView()
    ElMessage.success('自动布局完成')
    return
  }

  // 1. 构建有向图
  const outEdges = new Map<number, number[]>()
  const inEdges = new Map<number, number[]>()
  nodeList.value.forEach(n => {
    outEdges.set(n.tableId, [])
    inEdges.set(n.tableId, [])
  })
  edges.forEach(e => {
    outEdges.get(e.sourceTableId)?.push(e.targetTableId)
    inEdges.get(e.targetTableId)?.push(e.sourceTableId)
  })

  // 2. 分层
  const layers: number[][] = []
  const nodeLayer = new Map<number, number>()
  const assigned = new Set<number>()

  const inDegree = new Map<number, number>()
  nodeList.value.forEach(n => inDegree.set(n.tableId, 0))
  edges.forEach(e => inDegree.set(e.targetTableId, (inDegree.get(e.targetTableId) || 0) + 1))

  let remaining = [...nodeList.value.map(n => n.tableId)]

  while (remaining.length > 0) {
    const minInDeg = Math.min(...remaining.filter(id => !assigned.has(id)).map(id => inDegree.get(id) || 0))
    const currentLayer = remaining.filter(id => !assigned.has(id) && (inDegree.get(id) || 0) === minInDeg)

    if (currentLayer.length === 0) break

    currentLayer.forEach(id => {
      assigned.add(id)
      nodeLayer.set(id, layers.length)
      outEdges.get(id)?.forEach(targetId => {
        if (!assigned.has(targetId)) {
          inDegree.set(targetId, Math.max(0, (inDegree.get(targetId) || 1) - 1))
        }
      })
    })

    layers.push(currentLayer)
    remaining = remaining.filter(id => !assigned.has(id))
  }

  // 3. 交叉最小化
  for (let iter = 0; iter < 5; iter++) {
    for (let i = 1; i < layers.length; i++) {
      layers[i] = orderByBarycenter(layers[i], layers[i - 1], inEdges)
    }
    for (let i = layers.length - 2; i >= 0; i--) {
      layers[i] = orderByBarycenter(layers[i], layers[i + 1], outEdges)
    }
  }

  // 4. 坐标分配 - 确保无重叠
  const layerSpacingX = 400
  const nodeSpacingY = 60 // 节点间最小垂直间距

  layers.forEach((layer, layerIndex) => {
    let currentY = 100

    layer.forEach(nodeId => {
      const node = nodeMap.get(nodeId)
      if (node) {
        const nodeHeight = getNodeHeight(node.columns)

        node.x = 100 + layerIndex * layerSpacingX
        node.y = currentY

        // 下一个节点的 Y = 当前 Y + 当前节点高度 + 间距
        currentY += nodeHeight + nodeSpacingY
      }
    })
  })

  fitView()
  ElMessage.success('自动布局完成')
}

// 简单网格布局（无关系时）
function simpleGridLayout() {
  const cols = Math.ceil(Math.sqrt(nodeList.value.length))
  const spacingX = 320
  const spacingY = 220

  nodeList.value.forEach((node, index) => {
    node.x = 100 + (index % cols) * spacingX
    node.y = 100 + Math.floor(index / cols) * spacingY
  })
}

// 重心排序
function orderByBarycenter(
  currentLayer: number[],
  neighborLayer: number[],
  edgeMap: Map<number, number[]>
): number[] {
  const neighborPos = new Map<number, number>()
  neighborLayer.forEach((id, index) => neighborPos.set(id, index))

  const nodeBarycenter = currentLayer.map(nodeId => {
    const neighbors = edgeMap.get(nodeId) || []
    const positions = neighbors
      .map(id => neighborPos.get(id))
      .filter(p => p !== undefined) as number[]

    const barycenter = positions.length > 0
      ? positions.reduce((a, b) => a + b, 0) / positions.length
      : Infinity

    return { nodeId, barycenter }
  })

  nodeBarycenter.sort((a, b) => {
    if (a.barycenter === Infinity && b.barycenter === Infinity) return 0
    if (a.barycenter === Infinity) return 1
    if (b.barycenter === Infinity) return -1
    return a.barycenter - b.barycenter
  })

  return nodeBarycenter.map(item => item.nodeId)
}

// 表详情
function showTableDetail(node: NodeData) {
  currentTable.value = node
  detailVisible.value = true
}

// 工具函数
function getFieldIcon(col: any) {
  if (col.isPrimary) return '🔑'
  if (col.isForeign) return '🔗'
  return '•'
}

// 只获取核心字段（主键、外键、核心标记）
function getCoreColumns(columns: any[]) {
  return columns.filter(col => col.isPrimary || col.isForeign || col.isCore)
}

// 计算节点高度（只显示核心字段）
function getNodeHeight(columns: any[]) {
  const coreCount = getCoreColumns(columns).length
  const hasMore = columns.length > coreCount
  return 40 + coreCount * 24 + (hasMore ? 24 : 0)
}

function getRelationLabel(type: string) {
  const map: Record<string, string> = {
    'ONE_TO_ONE': '1:1', 'ONE_TO_MANY': '1:N', 'MANY_TO_ONE': 'N:1', 'MANY_TO_MANY': 'N:M',
    '1:1': '1:1', '1:N': '1:N', 'N:1': 'N:1', 'N:M': 'N:M'
  }
  return map[type] || type
}

function getRelationColor(type: string) {
  const map: Record<string, string> = {
    'ONE_TO_ONE': '#67c23a', 'ONE_TO_MANY': '#409eff', 'MANY_TO_ONE': '#e6a23c', 'MANY_TO_MANY': '#f56c6c',
    '1:1': '#67c23a', '1:N': '#409eff', 'N:1': '#e6a23c', 'N:M': '#f56c6c'
  }
  return map[type] || '#909399'
}

// 复制描述文本
async function copyDescription() {
  if (!descriptionText.value) return
  try {
    await navigator.clipboard.writeText(descriptionText.value)
    copied.value = true
    ElMessage.success('已复制到剪贴板')
    setTimeout(() => { copied.value = false }, 2000)
  } catch (e) {
    ElMessage.error('复制失败')
  }
}

// 切换全屏
function toggleFullscreen() {
  if (!erDiagramRef.value) return

  if (!isFullscreen.value) {
    // 进入全屏
    if (erDiagramRef.value.requestFullscreen) {
      erDiagramRef.value.requestFullscreen()
    }
  } else {
    // 退出全屏
    if (document.exitFullscreen) {
      document.exitFullscreen()
    }
  }
}

// 监听全屏变化
function handleFullscreenChange() {
  isFullscreen.value = !!document.fullscreenElement
}

</script>

<style lang="scss" scoped>
.er-diagram {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: var(--bg-primary);

  // 全屏模式样式
  &:fullscreen {
    padding: 0;
    background: var(--bg-primary);

    .toolbar {
      padding: 16px 24px;
    }

    .main-content {
      height: calc(100vh - 60px);
    }

    .description-panel {
      max-height: 200px;
    }
  }
}

.toolbar {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: var(--bg-secondary);

  .toolbar-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }
}

.main-content {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.table-panel {
  width: 240px;
  border-right: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  background: var(--bg-primary);
}

.panel-header {
  padding: 12px;
  border-bottom: 1px solid var(--border-color);

  .panel-title {
    font-weight: 600;
    font-size: 14px;
    margin-bottom: 8px;
    display: block;
    color: var(--text-primary);
  }
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}

.empty-tip {
  text-align: center;
  color: var(--text-secondary);
  padding: 40px 16px;
  font-size: 13px;

  &::before {
    content: '';
    display: block;
    width: 48px;
    height: 48px;
    margin: 0 auto 12px;
    background: var(--bg-tertiary);
    border-radius: 50%;
  }
}

.table-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.table-item {
  display: flex;
  align-items: center;
  padding: 8px 10px;
  border-radius: 8px;
  cursor: pointer;
  gap: 8px;
  margin-bottom: 4px;
  transition: all 0.2s ease;
  border: 1px solid transparent;

  &:hover {
    background: var(--bg-secondary);
    border-color: var(--border-color);
    transform: translateX(2px);
  }

  &.is-selected {
    background: var(--el-color-primary-light-9);
    border-color: var(--el-color-primary-light-5);
    box-shadow: 0 2px 8px rgba(254, 64, 102, 0.1);

    .table-icon { color: var(--el-color-primary); transform: scale(1.1); }
    .table-name { color: var(--el-color-primary); font-weight: 600; }
    .table-code {
      background: var(--el-color-primary-light-8);
      border-color: var(--el-color-primary-light-5);
      color: var(--el-color-primary);
    }
  }

  .table-icon {
    color: var(--text-secondary);
    font-size: 14px;
    transition: all 0.2s ease;
    flex-shrink: 0;
  }

  &:hover .table-icon {
    color: var(--el-color-primary);
  }

  .table-name {
    flex: 1;
    font-size: 13px;
    color: var(--text-regular);
    font-weight: 500;
    transition: color 0.2s;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    min-width: 0;
  }

  .table-code {
    font-size: 11px;
    color: var(--text-secondary);
    background: var(--bg-tertiary);
    padding: 2px 6px;
    border-radius: 4px;
    border: 1px solid var(--border-color-light);
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
    font-weight: 500;
    letter-spacing: 0.3px;
    flex-shrink: 0;
    max-width: 80px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  :deep(.el-checkbox) {
    margin-right: 0;
    flex-shrink: 0;

    .el-checkbox__inner {
      width: 14px;
      height: 14px;
    }
  }
}

.canvas-panel {
  flex: 1;
  position: relative;
  background-color: var(--bg-secondary);
  overflow: hidden;
}

.canvas-placeholder {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  text-align: center;
  color: var(--text-secondary);

  .el-icon {
    margin-bottom: 16px;
    opacity: 0.5;
  }

  p {
    margin-top: 12px;
    font-size: 14px;
    color: var(--text-secondary);
  }
}

.canvas-wrapper {
  position: absolute;
  top: 0;
  left: 0;
  transform-origin: 0 0;
  cursor: grab;
  background-color: var(--bg-primary);
  background-image:
    radial-gradient(circle, var(--text-placeholder) 1px, transparent 1px);
  background-size: 20px 20px;

  &:active { cursor: grabbing; }
}

.svg-layer {
  position: absolute;
  top: 0;
  left: 0;
  pointer-events: none;
  z-index: 1;
}

.er-node {
  position: absolute;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--card-radius);
  box-shadow: var(--card-shadow);
  z-index: 10;
  cursor: move;
  user-select: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

  &:hover {
    box-shadow: var(--card-hover-shadow);
    transform: translateY(-2px);
    border-color: var(--el-color-primary-light-5);
  }

  &.is-dragging {
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
    opacity: 0.95;
    transform: scale(1.02);
    z-index: 100;
  }

  &.is-selected {
    border-color: var(--el-color-primary);
    box-shadow: 0 0 0 3px var(--el-color-primary-light-9), var(--card-hover-shadow);
    z-index: 20;

    .node-header {
      background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
    }
  }

  .node-header {
    background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
    color: #fff;
    padding: 10px 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-radius: var(--card-radius) var(--card-radius) 0 0;

    .node-title { font-weight: 600; font-size: 13px; }
    .node-close { cursor: pointer; opacity: 0.8; transition: all 0.2s; &:hover { opacity: 1; transform: scale(1.1); } }
  }

  .node-body { padding: 6px 0; max-height: 220px; overflow-y: auto; }

  .node-field {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 5px 12px;
    font-size: 12px;
    border-bottom: 1px solid var(--border-color-light);
    transition: background 0.15s;

    &:last-child { border-bottom: none; }
    &:hover { background: var(--bg-secondary); }
    &.is-pk { background: var(--el-color-danger-light); }
    &.is-fk { background: var(--el-color-warning-light); }

    .field-icon { font-size: 10px; width: 16px; text-align: center; }
    .field-name { flex: 1; color: var(--text-primary); font-weight: 500; }
    .field-type { color: var(--text-secondary); font-size: 10px; font-family: monospace; background: var(--bg-tertiary); padding: 1px 4px; border-radius: 3px; }
  }

  .field-more {
    padding: 6px 12px;
    font-size: 11px;
    color: var(--text-secondary);
    text-align: center;
    background: var(--bg-secondary);
    border-top: 1px solid var(--border-color);
    font-style: italic;
  }
}

.legend {
  position: absolute;
  bottom: 20px;
  left: 20px;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--card-radius);
  padding: 12px 14px;
  box-shadow: var(--card-shadow);
  backdrop-filter: blur(8px);

  .legend-title { font-weight: 600; font-size: 12px; margin-bottom: 8px; color: var(--text-primary); }
  .legend-item { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--text-regular); margin-bottom: 6px;
    &:last-child { margin-bottom: 0; }
    .legend-icon { font-size: 14px; }
  }
}

.zoom-indicator {
  position: absolute;
  bottom: 20px;
  right: 20px;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: 20px;
  padding: 6px 14px;
  font-size: 12px;
  font-weight: 500;
  color: var(--text-regular);
  box-shadow: var(--card-shadow);
  backdrop-filter: blur(8px);
}

.description-panel {
  border-top: 1px solid var(--border-color);
  background: var(--bg-secondary);

  .panel-header {
    padding: 10px 16px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid var(--border-color);

    .panel-title {
      font-weight: 600;
      font-size: 13px;
      color: var(--text-primary);
    }
  }

  .panel-body {
    padding: 8px 16px;
  }

  .description-text {
    width: 100%;
    height: 180px;
    border: 1px solid var(--border-color);
    border-radius: var(--card-radius);
    padding: 12px;
    font-size: 13px;
    line-height: 1.6;
    color: var(--text-primary);
    background: var(--bg-primary);
    resize: vertical;
    font-family: 'Consolas', 'Monaco', monospace;
    white-space: pre;
    overflow-wrap: normal;
    overflow-x: auto;

    &:focus {
      outline: none;
      border-color: var(--el-color-primary);
    }
  }
}
</style>