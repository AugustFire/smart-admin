package com.smartadmin.common.pojo;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 通用分页响应
 */
@Data
@Schema(description = "分页响应")
public class PageResp<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "数据列表")
    private List<T> list;

    @Schema(description = "总记录数")
    private Long total;

    @Schema(description = "当前页码")
    private Integer pageNum;

    @Schema(description = "每页数量")
    private Integer pageSize;

    @Schema(description = "总页数")
    private Integer pages;

    /**
     * 从 MyBatis Plus Page 创建分页响应
     */
    public static <T> PageResp<T> of(Page<T> page) {
        PageResp<T> resp = new PageResp<>();
        resp.setList(page.getRecords());
        resp.setTotal(page.getTotal());
        resp.setPageNum((int) page.getCurrent());
        resp.setPageSize((int) page.getSize());
        resp.setPages((int) page.getPages());
        return resp;
    }

    /**
     * 从数据列表和总数创建分页响应（用于内存分页）
     */
    public static <T> PageResp<T> of(List<T> list, Long total, Integer pageNum, Integer pageSize) {
        PageResp<T> resp = new PageResp<>();
        resp.setList(list);
        resp.setTotal(total);
        resp.setPageNum(pageNum);
        resp.setPageSize(pageSize);
        resp.setPages((int) Math.ceil((double) total / pageSize));
        return resp;
    }
}
