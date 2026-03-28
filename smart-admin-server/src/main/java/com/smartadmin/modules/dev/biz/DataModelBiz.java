package com.smartadmin.modules.dev.biz;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.dev.dto.request.*;
import com.smartadmin.modules.dev.dto.response.*;
import com.smartadmin.modules.dev.entity.*;
import com.smartadmin.modules.dev.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 数据模型业务层
 */
@Service
@RequiredArgsConstructor
public class DataModelBiz {

    private final DevDmDatabaseService databaseService;
    private final DevDmTableService tableService;
    private final DevDmColumnService columnService;
    private final DevDmRelationService relationService;

    // ==================== 数据库管理 ====================

    public PageResp<DmDatabaseResp> pageDatabases(DmDatabasePageQueryReq req) {
        Page<DevDmDatabase> page = new Page<>(req.getPageNum(), req.getPageSize());
        LambdaQueryWrapper<DevDmDatabase> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(StringUtils.hasText(req.getName()), DevDmDatabase::getName, req.getName())
                .like(StringUtils.hasText(req.getCode()), DevDmDatabase::getCode, req.getCode())
                .orderByAsc(DevDmDatabase::getSort);

        Page<DevDmDatabase> result = databaseService.page(page, wrapper);

        List<DmDatabaseResp> list = result.getRecords().stream().map(this::convertDatabaseResp).collect(Collectors.toList());
        return PageResp.of(list, result.getTotal(), (int) result.getCurrent(), (int) result.getSize());
    }

    public List<DmDatabaseResp> listDatabases() {
        LambdaQueryWrapper<DevDmDatabase> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DevDmDatabase::getStatus, 1)
                .orderByAsc(DevDmDatabase::getSort);
        return databaseService.list(wrapper).stream().map(this::convertDatabaseResp).collect(Collectors.toList());
    }

    public DmDatabaseResp getDatabaseById(Long id) {
        DevDmDatabase entity = databaseService.getById(id);
        return entity != null ? convertDatabaseResp(entity) : null;
    }

    @Transactional(rollbackFor = Exception.class)
    public Long addDatabase(DmDatabaseAddReq req) {
        DevDmDatabase entity = new DevDmDatabase();
        BeanUtils.copyProperties(req, entity);
        databaseService.save(entity);
        return entity.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateDatabase(DmDatabaseUpdateReq req) {
        DevDmDatabase entity = new DevDmDatabase();
        BeanUtils.copyProperties(req, entity);
        databaseService.updateById(entity);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteDatabase(Long id) {
        databaseService.removeById(id);
    }

    private DmDatabaseResp convertDatabaseResp(DevDmDatabase entity) {
        DmDatabaseResp resp = new DmDatabaseResp();
        BeanUtils.copyProperties(entity, resp);
        return resp;
    }

    // ==================== 数据表管理 ====================

    public PageResp<DmTableResp> pageTables(DmTablePageQueryReq req) {
        Page<DevDmTable> page = new Page<>(req.getPageNum(), req.getPageSize());

        LambdaQueryWrapper<DevDmTable> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(req.getDatabaseId() != null, DevDmTable::getDatabaseId, req.getDatabaseId())
                .like(StringUtils.hasText(req.getName()), DevDmTable::getName, req.getName())
                .like(StringUtils.hasText(req.getCode()), DevDmTable::getCode, req.getCode())
                .orderByAsc(DevDmTable::getSort);

        Page<DevDmTable> result = tableService.page(page, wrapper);

        List<DmTableResp> list = result.getRecords().stream().map(this::convertTableResp).collect(Collectors.toList());
        return PageResp.of(list, result.getTotal(), (int) result.getCurrent(), (int) result.getSize());
    }

    public List<DmTableResp> listTablesByDatabaseId(Long databaseId) {
        LambdaQueryWrapper<DevDmTable> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DevDmTable::getDatabaseId, databaseId)
                .eq(DevDmTable::getStatus, 1)
                .orderByAsc(DevDmTable::getSort);
        return tableService.list(wrapper).stream().map(this::convertTableResp).collect(Collectors.toList());
    }

    public List<DmTableTreeResp> getTableTree() {
        List<DmTableTreeResp> tree = new ArrayList<>();

        // 查询所有数据库
        LambdaQueryWrapper<DevDmDatabase> dbWrapper = new LambdaQueryWrapper<>();
        dbWrapper.eq(DevDmDatabase::getStatus, 1).orderByAsc(DevDmDatabase::getSort);
        List<DevDmDatabase> databases = databaseService.list(dbWrapper);

        for (DevDmDatabase db : databases) {
            DmTableTreeResp dbNode = new DmTableTreeResp();
            dbNode.setId(db.getId());
            dbNode.setName(db.getName());
            dbNode.setCode(db.getCode());

            // 查询该数据库下的表
            LambdaQueryWrapper<DevDmTable> tableWrapper = new LambdaQueryWrapper<>();
            tableWrapper.eq(DevDmTable::getDatabaseId, db.getId())
                    .eq(DevDmTable::getStatus, 1)
                    .orderByAsc(DevDmTable::getSort);
            List<DevDmTable> tables = tableService.list(tableWrapper);

            List<DmTableTreeResp.TableNode> tableNodes = tables.stream().map(table -> {
                DmTableTreeResp.TableNode node = new DmTableTreeResp.TableNode();
                node.setId(table.getId());
                node.setName(table.getName());
                node.setCode(table.getCode());
                return node;
            }).collect(Collectors.toList());

            dbNode.setChildren(tableNodes);
            tree.add(dbNode);
        }

        return tree;
    }

    public DmTableResp getTableById(Long id) {
        DevDmTable entity = tableService.getById(id);
        return entity != null ? convertTableResp(entity) : null;
    }

    @Transactional(rollbackFor = Exception.class)
    public Long addTable(DmTableAddReq req) {
        DevDmTable entity = new DevDmTable();
        BeanUtils.copyProperties(req, entity);
        tableService.save(entity);
        return entity.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateTable(DmTableUpdateReq req) {
        DevDmTable entity = new DevDmTable();
        BeanUtils.copyProperties(req, entity);
        tableService.updateById(entity);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteTable(Long id) {
        tableService.removeById(id);
    }

    private DmTableResp convertTableResp(DevDmTable entity) {
        DmTableResp resp = new DmTableResp();
        BeanUtils.copyProperties(entity, resp);

        // 查询数据库名称
        if (entity.getDatabaseId() != null) {
            DevDmDatabase db = databaseService.getById(entity.getDatabaseId());
            if (db != null) {
                resp.setDatabaseName(db.getName());
            }
        }
        return resp;
    }

    // ==================== 字段管理 ====================

    public List<DmColumnResp> listColumnsByTableId(Long tableId) {
        LambdaQueryWrapper<DevDmColumn> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(DevDmColumn::getTableId, tableId)
                .orderByAsc(DevDmColumn::getSort);
        return columnService.list(wrapper).stream().map(this::convertColumnResp).collect(Collectors.toList());
    }

    @Transactional(rollbackFor = Exception.class)
    public Long addColumn(DmColumnAddReq req) {
        DevDmColumn entity = new DevDmColumn();
        BeanUtils.copyProperties(req, entity);
        columnService.save(entity);
        return entity.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateColumn(DmColumnUpdateReq req) {
        DevDmColumn entity = new DevDmColumn();
        BeanUtils.copyProperties(req, entity);
        columnService.updateById(entity);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteColumn(Long id) {
        columnService.removeById(id);
    }

    private DmColumnResp convertColumnResp(DevDmColumn entity) {
        DmColumnResp resp = new DmColumnResp();
        BeanUtils.copyProperties(entity, resp);

        // 查询表名称
        if (entity.getTableId() != null) {
            DevDmTable table = tableService.getById(entity.getTableId());
            if (table != null) {
                resp.setTableName(table.getName());
            }
        }
        return resp;
    }

    // ==================== 关系管理 ====================

    public List<DmRelationResp> listRelations(Long databaseId) {
        // 获取该数据库下的所有表ID
        LambdaQueryWrapper<DevDmTable> tableWrapper = new LambdaQueryWrapper<>();
        tableWrapper.eq(DevDmTable::getDatabaseId, databaseId);
        List<Long> tableIds = tableService.list(tableWrapper)
                .stream().map(DevDmTable::getId).collect(Collectors.toList());

        if (tableIds.isEmpty()) {
            return new ArrayList<>();
        }

        LambdaQueryWrapper<DevDmRelation> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(DevDmRelation::getSourceTableId, tableIds)
                .or().in(DevDmRelation::getTargetTableId, tableIds);

        return relationService.list(wrapper).stream().map(this::convertRelationResp).collect(Collectors.toList());
    }

    @Transactional(rollbackFor = Exception.class)
    public Long addRelation(DmRelationAddReq req) {
        DevDmRelation entity = new DevDmRelation();
        BeanUtils.copyProperties(req, entity);
        relationService.save(entity);
        return entity.getId();
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateRelation(DmRelationUpdateReq req) {
        DevDmRelation entity = new DevDmRelation();
        BeanUtils.copyProperties(req, entity);
        relationService.updateById(entity);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteRelation(Long id) {
        relationService.removeById(id);
    }

    private DmRelationResp convertRelationResp(DevDmRelation entity) {
        DmRelationResp resp = new DmRelationResp();
        BeanUtils.copyProperties(entity, resp);

        // 设置关系类型名称
        resp.setRelationTypeName(getRelationTypeName(entity.getRelationType()));

        // 查询源表信息
        if (entity.getSourceTableId() != null) {
            DevDmTable table = tableService.getById(entity.getSourceTableId());
            if (table != null) {
                resp.setSourceTableName(table.getName());
                resp.setSourceTableCode(table.getCode());
            }
        }

        // 查询目标表信息
        if (entity.getTargetTableId() != null) {
            DevDmTable table = tableService.getById(entity.getTargetTableId());
            if (table != null) {
                resp.setTargetTableName(table.getName());
                resp.setTargetTableCode(table.getCode());
            }
        }

        // 查询源字段信息
        if (entity.getSourceColumnId() != null) {
            DevDmColumn column = columnService.getById(entity.getSourceColumnId());
            if (column != null) {
                resp.setSourceColumnCode(column.getCode());
            }
        }

        // 查询目标字段信息
        if (entity.getTargetColumnId() != null) {
            DevDmColumn column = columnService.getById(entity.getTargetColumnId());
            if (column != null) {
                resp.setTargetColumnCode(column.getCode());
            }
        }

        return resp;
    }

    private String getRelationTypeName(String type) {
        return switch (type) {
            case "ONE_TO_ONE" -> "一对一";
            case "ONE_TO_MANY" -> "一对多";
            case "MANY_TO_ONE" -> "多对一";
            case "MANY_TO_MANY" -> "多对多";
            default -> type;
        };
    }

    // ==================== E-R 图数据 ====================

    public DmERDiagramResp getERDiagram(Long databaseId) {
        DmERDiagramResp resp = new DmERDiagramResp();

        // 设置数据库信息
        DevDmDatabase db = databaseService.getById(databaseId);
        if (db != null) {
            resp.setDatabaseId(db.getId());
            resp.setDatabaseName(db.getName());
        }

        // 获取该数据库下的所有表
        LambdaQueryWrapper<DevDmTable> tablesWrapper = new LambdaQueryWrapper<>();
        tablesWrapper.eq(DevDmTable::getDatabaseId, databaseId)
                .eq(DevDmTable::getStatus, 1);
        List<DevDmTable> tables = tableService.list(tablesWrapper);

        // 构建节点列表
        List<DmERDiagramResp.Node> nodes = new ArrayList<>();
        double x = 100, y = 100;
        int col = 0;

        for (DevDmTable table : tables) {
            DmERDiagramResp.Node node = new DmERDiagramResp.Node();
            node.setId("table_" + table.getId());
            node.setName(table.getName());
            node.setCode(table.getCode());
            node.setDescription(table.getDescription());

            // 获取该表的字段
            LambdaQueryWrapper<DevDmColumn> columnsWrapper = new LambdaQueryWrapper<>();
            columnsWrapper.eq(DevDmColumn::getTableId, table.getId())
                    .orderByAsc(DevDmColumn::getSort);
            List<DevDmColumn> columns = columnService.list(columnsWrapper);

            List<DmERDiagramResp.ColumnNode> columnNodes = columns.stream().map(colEntity -> {
                DmERDiagramResp.ColumnNode colNode = new DmERDiagramResp.ColumnNode();
                colNode.setId(colEntity.getId());
                colNode.setName(colEntity.getName());
                colNode.setCode(colEntity.getCode());
                colNode.setDataType(colEntity.getDataType());
                colNode.setIsPrimary(colEntity.getIsPrimary());
                colNode.setIsForeign(colEntity.getIsForeign());
                colNode.setIsCore(colEntity.getIsCore());
                return colNode;
            }).collect(Collectors.toList());

            node.setColumns(columnNodes);

            // 简单网格布局
            node.setX(x + col * 250);
            node.setY(y + (col / 3) * 300);
            col++;

            nodes.add(node);
        }
        resp.setNodes(nodes);

        // 构建边列表
        List<Long> tableIds = tables.stream().map(DevDmTable::getId).collect(Collectors.toList());
        if (!tableIds.isEmpty()) {
            LambdaQueryWrapper<DevDmRelation> relWrapper = new LambdaQueryWrapper<>();
            relWrapper.in(DevDmRelation::getSourceTableId, tableIds);
            List<DevDmRelation> relations = relationService.list(relWrapper);

            List<DmERDiagramResp.Edge> edges = relations.stream().map(rel -> {
                DmERDiagramResp.Edge edge = new DmERDiagramResp.Edge();
                edge.setId("rel_" + rel.getId());
                edge.setSource("table_" + rel.getSourceTableId());
                edge.setTarget("table_" + rel.getTargetTableId());
                edge.setRelationType(rel.getRelationType());
                edge.setDescription(rel.getDescription());

                // 获取字段编码
                DevDmColumn sourceCol = columnService.getById(rel.getSourceColumnId());
                DevDmColumn targetCol = columnService.getById(rel.getTargetColumnId());
                if (sourceCol != null) {
                    edge.setSourceColumn(sourceCol.getCode());
                }
                if (targetCol != null) {
                    edge.setTargetColumn(targetCol.getCode());
                }

                return edge;
            }).collect(Collectors.toList());

            resp.setEdges(edges);
        } else {
            resp.setEdges(new ArrayList<>());
        }

        return resp;
    }
}
