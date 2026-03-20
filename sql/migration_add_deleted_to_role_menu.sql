-- ============================================
-- 迁移脚本：为 sys_role_menu 表添加 deleted 字段
-- 执行时间：2026-03-19
-- ============================================

USE `auto_admin`;

-- 添加 deleted 字段
ALTER TABLE `sys_role_menu`
ADD COLUMN `deleted` TINYINT DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除' AFTER `create_time`;
