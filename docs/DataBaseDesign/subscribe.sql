﻿DROP TABLE IF EXISTS BC_SUBSCRIBE_ACTOR;
DROP TABLE IF EXISTS BC_SUBSCRIBE;

-- 订阅部署表
CREATE TABLE BC_SUBSCRIBE(
	ID INT NOT NULL,
	STATUS_ INT DEFAULT 0 NOT NULL,
	TYPE_ INT DEFAULT 0 NOT NULL,
	ORDER_ VARCHAR(255),
	SUBJECT VARCHAR(500) NOT NULL,
	EVENT_CODE	VARCHAR(255) NOT NULL UNIQUE,
	AUTHOR_ID INT NOT NULL,
	FILE_DATE TIMESTAMP NOT NULL,
	MODIFIER_ID INT,
	MODIFIED_DATE TIMESTAMP,
	CONSTRAINT BCPK_SUBSCRIBE PRIMARY KEY (ID)
);
COMMENT ON TABLE BC_SUBSCRIBE IS '订阅';
COMMENT ON COLUMN BC_SUBSCRIBE.ID IS 'ID';
COMMENT ON COLUMN BC_SUBSCRIBE.STATUS_ IS '状态 : -1-草稿,0-已发布,1-禁用';
COMMENT ON COLUMN BC_SUBSCRIBE.TYPE_ IS '类型 : 0-邮件,1-短信';
COMMENT ON COLUMN BC_SUBSCRIBE.ORDER_ IS '排序号';
COMMENT ON COLUMN BC_SUBSCRIBE.SUBJECT IS '订阅标题';
COMMENT ON COLUMN BC_SUBSCRIBE.EVENT_CODE IS '事件编码';
COMMENT ON COLUMN BC_SUBSCRIBE.AUTHOR_ID IS '创建人ID';
COMMENT ON COLUMN BC_SUBSCRIBE.FILE_DATE IS '创建时间';
COMMENT ON COLUMN BC_SUBSCRIBE.MODIFIER_ID IS '最后修改人ID';
COMMENT ON COLUMN BC_SUBSCRIBE.MODIFIED_DATE IS '最后修改时间';
ALTER TABLE BC_SUBSCRIBE ADD CONSTRAINT BCFK_SUBSCRIBE_AUTHOR FOREIGN KEY (AUTHOR_ID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE BC_SUBSCRIBE ADD CONSTRAINT BCFK_SUBSCRIBE_MODIFIER FOREIGN KEY (MODIFIER_ID)
	REFERENCES BC_IDENTITY_ACTOR_HISTORY (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;

	
-- 订阅者表
CREATE TABLE BC_SUBSCRIBE_ACTOR(
	PID INT NOT NULL,
	AID INT NOT NULL,
	TYPE_ INT DEFAULT 0 NOT NULL,
	FILE_DATE TIMESTAMP NOT NULL,
	CONSTRAINT BCPK_SUBSCRIBE_ACTOR PRIMARY KEY (PID, AID)
);
COMMENT ON TABLE BC_SUBSCRIBE_ACTOR IS '订阅者';
COMMENT ON COLUMN BC_SUBSCRIBE_ACTOR.PID IS '订阅ID';
COMMENT ON COLUMN BC_SUBSCRIBE_ACTOR.AID IS '订阅者ID : 对应Actor的ID';
COMMENT ON COLUMN BC_SUBSCRIBE_ACTOR.TYPE_ IS '类型: 0-用户订阅，1-系统推送';
COMMENT ON COLUMN BC_SUBSCRIBE_ACTOR.FILE_DATE IS '订阅日期';
ALTER TABLE BC_SUBSCRIBE_ACTOR ADD CONSTRAINT BCFK_SUBSCRIBE_ACTOR_PID FOREIGN KEY (PID)
	REFERENCES BC_SUBSCRIBE (ID) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE BC_SUBSCRIBE_ACTOR ADD CONSTRAINT BCFK_SUBSCRIBE_ACTOR FOREIGN KEY (AID)
	REFERENCES BC_IDENTITY_ACTOR (ID) ON UPDATE RESTRICT ON DELETE RESTRICT;	