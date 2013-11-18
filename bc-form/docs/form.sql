/* 清除资源、角色配置数据
delete from BC_IDENTITY_ROLE_RESOURCE where sid in 
	(select id from BC_IDENTITY_RESOURCE where ORDER_ in ('800440'));
delete from BC_IDENTITY_RESOURCE where ORDER_ in ('800440');
*/

--删除表单表索引
DROP INDEX IF EXISTS FORMIDX_FORM_TYPE_PID_CODE;
--删除自定义表单相关表
DROP TABLE IF EXISTS BC_FORM_FIELD_LOG;
DROP TABLE IF EXISTS BC_FORM_FIELD;
DROP TABLE IF EXISTS BC_FORM;

--自定义表单相关表
--自定义表单表
CREATE TABLE BC_FORM
(
	ID INT NOT NULL,
	PID INT NOT NULL,
	UID_ VARCHAR(36) NOT NULL,
	TYPE_ VARCHAR(255) NOT NULL,
	CODE VARCHAR(255) NOT NULL,
	STATUS_ INT NOT NULL,
	SUBJECT VARCHAR(255) NOT NULL,
	TPL_ VARCHAR(255) NOT NULL,
	AUTHOR_ID INT NOT NULL,
	FILE_DATE TIMESTAMP NOT NULL,
	MODIFIER_ID INT NOT NULL,
	MODIFIED_DATE TIMESTAMP NOT NULL,
	CONSTRAINT BCPK_FORM PRIMARY KEY (ID)
);
CREATE TABLE BC_FORM_FIELD
(
	ID INT NOT NULL,
	PID INT NOT NULL,
	NAME_ VARCHAR(20) NOT NULL,
	LABEL_ VARCHAR(40) NOT NULL,
	TYPE_ VARCHAR(20) NOT NULL,
	VALUE_ VARCHAR(4000),
	CONSTRAINT BCPK_FORM_FIELD PRIMARY KEY (ID)
);
CREATE TABLE BC_FORM_FIELD_LOG
(
	ID INT NOT NULL,
	PID INT NOT NULL,
	VALUE_ VARCHAR(4000),
	UPDATOR INT NOT NULL,
	UPDATE_TIME TIMESTAMP NOT NULL,
	BATCH_NO VARCHAR(50) NOT NULL,
	CONSTRAINT BCPK_FORM_FIELD_LOG PRIMARY KEY (ID)
);
ALTER TABLE BC_FORM_FIELD
	ADD CONSTRAINT BCFK_FORM_FIELD_PID FOREIGN KEY (PID)
	REFERENCES BC_FORM (ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;
ALTER TABLE BC_FORM_FIELD_LOG
	ADD CONSTRAINT BC_FORM_FIELD_LOG_PID FOREIGN KEY (PID)
	REFERENCES BC_FORM_FIELD (ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;
ALTER TABLE BC_FORM
	ADD CONSTRAINT BC_FORM_MODIFIER FOREIGN KEY (MODIFIER_ID)
	REFERENCES PUBLIC.BC_IDENTITY_ACTOR_HISTORY (ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;
ALTER TABLE BC_FORM
	ADD CONSTRAINT BC_FORM_AUTHOR FOREIGN KEY (AUTHOR_ID)
	REFERENCES PUBLIC.BC_IDENTITY_ACTOR_HISTORY (ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;
ALTER TABLE BC_FORM_FIELD_LOG
	ADD CONSTRAINT BC_FORM_FIELD_LOG_UPDATOR FOREIGN KEY (UPDATOR)
	REFERENCES PUBLIC.BC_IDENTITY_ACTOR_HISTORY (ID)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT;

-- 表单TYPE、PID、CODE联合索引
CREATE UNIQUE INDEX FORMIDX_FORM_TYPE_PID_CODE ON BC_FORM USING BTREE (TYPE_, PID, CODE);
-- 字段PID和NAME联合索引
CREATE INDEX FORMIDX_FORM_FIELD_PID_NAME ON BC_FORM_FIELD USING BTREE (PID, NAME_);

COMMENT ON TABLE BC_FORM IS '表单';
COMMENT ON COLUMN BC_FORM.ID IS 'ID';
COMMENT ON COLUMN BC_FORM.PID IS 'PID';
COMMENT ON COLUMN BC_FORM.UID_ IS '关联附件的标识号';
COMMENT ON COLUMN BC_FORM.TYPE_ IS '类别 : 用于区分模块，通常使用Domain类名';
COMMENT ON COLUMN BC_FORM.CODE IS '编码';
COMMENT ON COLUMN BC_FORM.STATUS_ IS '状态 : -1-草稿，0-已提交';
COMMENT ON COLUMN BC_FORM.SUBJECT IS '标题';
COMMENT ON COLUMN BC_FORM.TPL_ IS '模板编码';
COMMENT ON COLUMN BC_FORM.AUTHOR_ID IS '创建人ID';
COMMENT ON COLUMN BC_FORM.FILE_DATE IS '创建时间';
COMMENT ON COLUMN BC_FORM.MODIFIER_ID IS '最后修改人ID';
COMMENT ON COLUMN BC_FORM.MODIFIED_DATE IS '最后修改时间';
COMMENT ON TABLE BC_FORM_FIELD IS '表单字段';
COMMENT ON COLUMN BC_FORM_FIELD.ID IS 'ID';
COMMENT ON COLUMN BC_FORM_FIELD.PID IS '所属表单';
COMMENT ON COLUMN BC_FORM_FIELD.NAME_ IS '名称';
COMMENT ON COLUMN BC_FORM_FIELD.LABEL_ IS '标签';
COMMENT ON COLUMN BC_FORM_FIELD.TYPE_ IS '值类型 : int,float,string,date,datetime,boolean等';
COMMENT ON COLUMN BC_FORM_FIELD.VALUE_ IS '值';
COMMENT ON TABLE BC_FORM_FIELD_LOG IS '表单字段审计日志';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.ID IS 'ID';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.PID IS '所属字段';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.VALUE_ IS '值';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.UPDATOR IS '更新人';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.UPDATE_TIME IS '更新时间';
COMMENT ON COLUMN BC_FORM_FIELD_LOG.BATCH_NO IS '批号 : 多个字段同一次更新的标记号';
COMMENT ON TABLE PUBLIC.BC_IDENTITY_ACTOR_HISTORY IS '参与者历史';
COMMENT ON COLUMN PUBLIC.BC_IDENTITY_ACTOR_HISTORY.ID IS 'id';

--	插入资源
insert into BC_IDENTITY_RESOURCE (ID,STATUS_,INNER_,TYPE_,BELONG,ORDER_,NAME,URL,ICONCLASS,PNAME) 
	select NEXTVAL('HIBERNATE_SEQUENCE'), 0, false, 2, m.id, '800440','自定义表单管理', '/bc/formManages/paging', 'i0001','系统维护' 
	from BC_IDENTITY_RESOURCE m 
	where m.ORDER_='800000'
	and not exists (select 0 from BC_IDENTITY_RESOURCE where NAME='自定义表单管理');
--	插入角色与资源之间的关系
insert into BC_IDENTITY_ROLE_RESOURCE (RID,SID) 
	select r.id,m.id 
	from BC_IDENTITY_ROLE r,BC_IDENTITY_RESOURCE m 
	where r.CODE = 'BC_ADMIN' 
	and m.NAME = '自定义表单管理'
	and not exists (select 0 from BC_IDENTITY_ROLE_RESOURCE rm where rm.RID=r.id and rm.SID=m.id);