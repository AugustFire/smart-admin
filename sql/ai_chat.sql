-- AI 聊天会话表
CREATE TABLE IF NOT EXISTS `ai_chat_session` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '会话ID',
    `session_key`   VARCHAR(64) NOT NULL COMMENT '会话唯一标识',
    `user_id`       BIGINT NOT NULL COMMENT '用户ID',
    `title`         VARCHAR(255) DEFAULT '新对话' COMMENT '会话标题',
    `model`         VARCHAR(64) COMMENT '模型名称',
    `status`        TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
    `create_time`   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT DEFAULT 0 COMMENT '删除标志',
    UNIQUE KEY `uk_session_key` (`session_key`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI聊天会话表';

-- AI 聊天消息表
CREATE TABLE IF NOT EXISTS `ai_chat_message` (
    `id`            BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    `session_id`    BIGINT NOT NULL COMMENT '会话ID',
    `user_id`       BIGINT NOT NULL COMMENT '用户ID',
    `role`          VARCHAR(16) NOT NULL COMMENT '角色 user/assistant/system',
    `content`       TEXT NOT NULL COMMENT '消息内容',
    `model`         VARCHAR(64) COMMENT '模型名称',
    `tokens`        INT DEFAULT 0 COMMENT '消耗token数',
    `create_time`   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT DEFAULT 0 COMMENT '删除标志',
    INDEX `idx_session_id` (`session_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AI聊天消息表';
