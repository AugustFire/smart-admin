package com.autoadmin.modules.system.biz;

import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.modules.system.dto.request.DictDataAddReq;
import com.autoadmin.modules.system.dto.request.DictDataUpdateReq;
import com.autoadmin.modules.system.dto.request.DictTypeAddReq;
import com.autoadmin.modules.system.dto.request.DictTypeUpdateReq;
import com.autoadmin.modules.system.dto.response.DictDataResp;
import com.autoadmin.modules.system.dto.response.DictTypeResp;
import com.autoadmin.modules.system.entity.SysDictData;
import com.autoadmin.modules.system.entity.SysDictType;
import com.autoadmin.modules.system.service.SysDictDataService;
import com.autoadmin.modules.system.service.SysDictTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 字典管理业务类
 */
@Component
@RequiredArgsConstructor
public class DictBiz {

    private final SysDictTypeService dictTypeService;
    private final SysDictDataService dictDataService;

    // ==================== 字典类型 ====================

    /**
     * 获取所有字典类型列表
     */
    public List<DictTypeResp> listAllTypes() {
        List<SysDictType> list = dictTypeService.lambdaQuery()
                .orderByAsc(SysDictType::getId)
                .list();
        return list.stream()
                .map(this::convertTypeToResp)
                .collect(Collectors.toList());
    }

    /**
     * 获取字典类型详情
     */
    public DictTypeResp getTypeById(Long id) {
        SysDictType dictType = dictTypeService.getByIdOrThrow(id);
        return convertTypeToResp(dictType);
    }

    /**
     * 新增字典类型
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addType(DictTypeAddReq req) {
        // 检查字典类型是否已存在
        if (dictTypeService.existsByType(req.getType())) {
            throw new BusinessException("字典类型已存在");
        }

        SysDictType dictType = new SysDictType();
        dictType.setName(req.getName());
        dictType.setType(req.getType());
        dictType.setStatus(req.getStatus() != null ? req.getStatus() : 1);
        dictType.setRemark(req.getRemark());
        dictTypeService.save(dictType);
        return dictType.getId();
    }

    /**
     * 更新字典类型
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateType(DictTypeUpdateReq req) {
        dictTypeService.getByIdOrThrow(req.getId());

        // 检查字典类型是否被其他类型使用
        if (dictTypeService.existsByType(req.getType(), req.getId())) {
            throw new BusinessException("字典类型已存在");
        }

        SysDictType dictType = new SysDictType();
        dictType.setId(req.getId());
        dictType.setName(req.getName());
        dictType.setType(req.getType());
        dictType.setStatus(req.getStatus());
        dictType.setRemark(req.getRemark());
        dictTypeService.updateById(dictType);
    }

    /**
     * 删除字典类型
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteType(Long id) {
        dictTypeService.getByIdOrThrow(id);
        dictTypeService.removeById(id);
    }

    // ==================== 字典数据 ====================

    /**
     * 根据字典类型查询字典数据列表
     */
    public List<DictDataResp> listDataByDictType(String dictType) {
        List<SysDictData> list = dictDataService.listByDictType(dictType);
        return list.stream()
                .map(this::convertDataToResp)
                .collect(Collectors.toList());
    }

    /**
     * 获取字典数据详情
     */
    public DictDataResp getDataById(Long id) {
        SysDictData dictData = dictDataService.getByIdOrThrow(id);
        return convertDataToResp(dictData);
    }

    /**
     * 新增字典数据
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addData(DictDataAddReq req) {
        SysDictData dictData = new SysDictData();
        dictData.setDictType(req.getDictType());
        dictData.setLabel(req.getLabel());
        dictData.setValue(req.getValue());
        dictData.setSort(req.getSort() != null ? req.getSort() : 0);
        dictData.setStatus(req.getStatus() != null ? req.getStatus() : 1);
        dictData.setCssClass(req.getCssClass());
        dictData.setListClass(req.getListClass());
        dictData.setIsDefault(req.getIsDefault());
        dictData.setRemark(req.getRemark());
        dictDataService.save(dictData);
        return dictData.getId();
    }

    /**
     * 更新字典数据
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateData(DictDataUpdateReq req) {
        dictDataService.getByIdOrThrow(req.getId());

        SysDictData dictData = new SysDictData();
        dictData.setId(req.getId());
        dictData.setLabel(req.getLabel());
        dictData.setValue(req.getValue());
        dictData.setSort(req.getSort());
        dictData.setStatus(req.getStatus());
        dictData.setCssClass(req.getCssClass());
        dictData.setListClass(req.getListClass());
        dictData.setIsDefault(req.getIsDefault());
        dictData.setRemark(req.getRemark());
        dictDataService.updateById(dictData);
    }

    /**
     * 删除字典数据
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteData(Long id) {
        dictDataService.getByIdOrThrow(id);
        dictDataService.removeById(id);
    }

    private DictTypeResp convertTypeToResp(SysDictType entity) {
        return DictTypeResp.builder()
                .id(entity.getId())
                .name(entity.getName())
                .type(entity.getType())
                .status(entity.getStatus())
                .remark(entity.getRemark())
                .createTime(entity.getCreateTime())
                .updateTime(entity.getUpdateTime())
                .build();
    }

    private DictDataResp convertDataToResp(SysDictData entity) {
        return DictDataResp.builder()
                .id(entity.getId())
                .dictType(entity.getDictType())
                .label(entity.getLabel())
                .value(entity.getValue())
                .sort(entity.getSort())
                .status(entity.getStatus())
                .cssClass(entity.getCssClass())
                .listClass(entity.getListClass())
                .isDefault(entity.getIsDefault())
                .remark(entity.getRemark())
                .createTime(entity.getCreateTime())
                .updateTime(entity.getUpdateTime())
                .build();
    }
}