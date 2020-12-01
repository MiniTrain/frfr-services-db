CREATE SCHEMA IF NOT EXISTS frfr;
CREATE SEQUENCE IF NOT EXISTS  FRFR.BATCH_STEP_EXECUTION_SEQ
    minvalue 0
    maxvalue 9223372036854775807
;

CREATE SEQUENCE IF NOT EXISTS  FRFR.BATCH_JOB_EXECUTION_SEQ
    minvalue 0
    maxvalue 9223372036854775807
;

CREATE SEQUENCE IF NOT EXISTS  FRFR.BATCH_JOB_SEQ
    minvalue 0
    maxvalue 9223372036854775807
;

CREATE SEQUENCE IF NOT EXISTS  FRFR.ASKR_ROLE_SEQ;

CREATE SEQUENCE IF NOT EXISTS  FRFR.ASKR_USER_DEVICE_SEQ;

CREATE SEQUENCE IF NOT EXISTS  FRFR.ASKR_USER_NOTE_SEQ;

CREATE SEQUENCE IF NOT EXISTS  FRFR.ASKR_USER_SEQ;

CREATE SEQUENCE IF NOT EXISTS  FRFR.ASKR_ADMIN_SEQ;

CREATE TABLE IF NOT EXISTS FRFR.AUDIT_REPORT
(
    USER_ID             varchar(40) not null,
    SEARCH_TYPE         varchar(10) not null,
    SEARCH_EQUIPMENT_ID varchar(14),
    ERROR               varchar(1024),
    REQUEST_TS          TIMESTAMP(6) default CURRENT_TIMESTAMP,
    LATITUDE            varchar(40),
    LONGITUDE           varchar(40),
    RESPONSE            text
);

CREATE TABLE IF NOT EXISTS FRFR.TOP_HAZMAT_COMMODITIES
(
    SEQUENCE_NBR numeric(3)     not null,
    UN_NA_ID     varchar(6)   not null,
    DESCRIPTION  varchar(255) not null
);

CREATE TABLE IF NOT EXISTS FRFR.HAZMAT_COMMODITY_RANK
(
    UN_NORTH_AMERICA_CODE varchar(6)                       not null
        constraint HAZMAT_COMMODITY_RANK_CK1
            check (UN_NORTH_AMERICA_CODE IS NOT NULL),
    HAZMAT_SEQ_NBR        numeric(3)                         not null
        constraint HAZMAT_COMMODITY_RANK_CK2
            check (HAZMAT_SEQ_NBR IS NOT NULL),
    UN_NORTH_AMERICA_DESC varchar(250)                     not null
        constraint HAZMAT_COMMODITY_RANK_CK3
            check (UN_NORTH_AMERICA_DESC IS NOT NULL),
    CREATED_TS            TIMESTAMP(6) default CURRENT_TIMESTAMP not null
        constraint HAZMAT_COMMODITY_RANK_CK4
            check (CREATED_TS IS NOT NULL),
    CREATE_USER_NAME      varchar(40),
    MODIFIED_TS           TIMESTAMP(6),
    MODIFY_USER_NAME      varchar(40),
    UN_FRENCH_DESC        varchar(250),
    constraint HAZMAT_COMMODITY_RANK_PK
        primary key (UN_NORTH_AMERICA_CODE, HAZMAT_SEQ_NBR)
);

CREATE TABLE IF NOT EXISTS FRFR.REQUEST_LOG
(
    REQUEST_USER_NAME varchar(50)                      not null
        constraint REQUEST_LOG_CK1
            check (REQUEST_USER_NAME IS NOT NULL),
    SEARCH_TYPE_CODE  varchar(10)                      not null
        constraint REQUEST_LOG_CK2
            check (SEARCH_TYPE_CODE IS NOT NULL),
    SEARCH_EQUIP_ID   varchar(14),
    REQUEST_TS        TIMESTAMP(6) default CURRENT_TIMESTAMP not null,
    GPS_LATITUDE      numeric(12, 9),
    GPS_LONGITUDE     numeric(12, 9),
    RESPONSE_MSG_DATA text,
    ERROR_TEXT        varchar(1000),
    CREATED_TS        TIMESTAMP(6) default CURRENT_TIMESTAMP not null
        constraint REQUEST_LOG_CK3
            check (CREATED_TS IS NOT NULL),
    CREATE_USER_NAME  varchar(40),
    MODIFIED_TS       TIMESTAMP(6),
    MODIFY_USER_NAME  varchar(40),
    USER_TYPE         varchar(40),
    SPONSORING_RR     varchar(10),
    ACCESS_TYPE       varchar(10)
);

CREATE TABLE IF NOT EXISTS FRFR.CONFIG_VALUES
(
    CONFIG_KEY   varchar(255)  not null
        constraint CONFIG_VALUES_PK
            primary key,
    STRING_VALUE varchar(1024) not null,
    DESCRIPTION  varchar(255)  not null
);

CREATE TABLE IF NOT EXISTS FRFR.HAZMAT_RAM
(
    UN_NORTH_AMERICA_CODE varchar(6)   not null,
    HAZMAT_SEQ_NBR        numeric(3)     not null,
    UN_NORTH_AMERICA_DESC varchar(250) not null,
    CREATED_TS            TIMESTAMP(6)  not null,
    CREATE_USER_NAME      varchar(40),
    MODIFIED_TS           TIMESTAMP(6),
    MODIFY_USER_NAME      varchar(40),
    UN_FRENCH_DESC        varchar(250)
);

CREATE TABLE IF NOT EXISTS FRFR.USER_ACTION_LOG
(
    SSO_USER_EMAIL_ADDR varchar(100)                     not null
        constraint USER_ACTION_LOG_CK6
            check (SSO_USER_EMAIL_ADDR IS NOT NULL),
    SPONSORING_MARK     varchar(4)                       not null
        constraint USER_ACTION_LOG_CK5
            check (SPONSORING_MARK IS NOT NULL),
    ADMIN_EMAIL_ADDR    varchar(100),
    APPROVER_NOTE       varchar(1000),
    REQUEST_MSG_DATA    text                              not null
        constraint USER_ACTION_LOG_CK1
            check (REQUEST_MSG_DATA IS NOT NULL),
    RESPONSE_MSG_DATA   text,
    REQUEST_TYPE_CODE   varchar(40)                      not null
        constraint USER_ACTION_LOG_CK2
            check (REQUEST_TYPE_CODE IS NOT NULL),
    ERROR_TEXT          varchar(1000),
    CREATED_TS          TIMESTAMP(6) default CURRENT_TIMESTAMP not null
        constraint USER_ACTION_LOG_CK3
            check (CREATED_TS IS NOT NULL),
    CREATE_USER_NAME    varchar(40)                      not null
        constraint USER_ACTION_LOG_CK4
            check (CREATE_USER_NAME IS NOT NULL),
    MODIFIED_TS         TIMESTAMP(6),
    MODIFY_USER_NAME    varchar(40)
);

comment on column FRFR.USER_ACTION_LOG.SPONSORING_MARK is 'This is the four-byte symbol for a Mark, either Ralroad, Shop, or Company.';

comment on column FRFR.USER_ACTION_LOG.CREATED_TS is 'Audit column that is generally used to represent the creation timestamp on the DB including fractional seconds.';

CREATE TABLE IF NOT EXISTS FRFR.BATCH_JOB_INSTANCE
(
    JOB_INSTANCE_ID numeric(19)    not null
        constraint BATCH_JOB_INSTANCE_PK
            primary key,
    VERSION         numeric(19),
    JOB_NAME        varchar(100) not null,
    JOB_KEY         varchar(32)  not null,
    constraint JOB_INST_UN
        unique (JOB_NAME, JOB_KEY)
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_JOB_PARAMS
(
    JOB_INSTANCE_ID numeric(19)    not null
        constraint JOB_INST_PARAMS_FK
            references FRFR.BATCH_JOB_INSTANCE,
    TYPE_CD         varchar(6)   not null,
    KEY_NAME        varchar(100) not null,
    STRING_VAL      varchar(250),
    DATE_VAL        TIMESTAMP(6) default NULL,
    LONG_VAL        numeric(19),
    DOUBLE_VAL      numeric
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_JOB_EXECUTION
(
    JOB_EXECUTION_ID           numeric(19)   not null
        constraint BATCH_JOB_EXECUTION_PK
            primary key,
    VERSION                    numeric(19),
    JOB_INSTANCE_ID            numeric(19)   not null
        constraint JOB_INST_EXEC_FK
            references FRFR.BATCH_JOB_INSTANCE,
    CREATE_TIME                TIMESTAMP(6) not null,
    START_TIME                 TIMESTAMP(6) default NULL,
    END_TIME                   TIMESTAMP(6) default NULL,
    STATUS                     varchar(10),
    EXIT_CODE                  varchar(2500),
    EXIT_MESSAGE               varchar(2500),
    LAST_UPDATED               TIMESTAMP(6),
    JOB_CONFIGURATION_LOCATION varchar(2500)
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_JOB_EXECUTION_PARAMS
(
    JOB_EXECUTION_ID numeric(19)    not null
        constraint JOB_EXEC_PARAMS_FK
            references FRFR.BATCH_JOB_EXECUTION,
    TYPE_CD          varchar(6)   not null,
    KEY_NAME         varchar(100) not null,
    STRING_VAL       varchar(250),
    DATE_VAL         TIMESTAMP(6) default NULL,
    LONG_VAL         numeric(19),
    DOUBLE_VAL       numeric,
    IDENTIFYING      CHAR          not null
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_STEP_EXECUTION
(
    STEP_EXECUTION_ID  numeric(19)    not null
        constraint BATCH_STEP_EXECUTION_PK
            primary key,
    VERSION            numeric(19)    not null,
    STEP_NAME          varchar(100) not null,
    JOB_EXECUTION_ID   numeric(19)    not null
        constraint JOB_EXEC_STEP_FK
            references FRFR.BATCH_JOB_EXECUTION,
    START_TIME         TIMESTAMP(6)  not null,
    END_TIME           TIMESTAMP(6) default NULL,
    STATUS             varchar(10),
    COMMIT_COUNT       numeric(19),
    READ_COUNT         numeric(19),
    FILTER_COUNT       numeric(19),
    WRITE_COUNT        numeric(19),
    READ_SKIP_COUNT    numeric(19),
    WRITE_SKIP_COUNT   numeric(19),
    PROCESS_SKIP_COUNT numeric(19),
    ROLLBACK_COUNT     numeric(19),
    EXIT_CODE          varchar(2500),
    EXIT_MESSAGE       varchar(2500),
    LAST_UPDATED       TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_STEP_EXECUTION_CONTEXT
(
    STEP_EXECUTION_ID  numeric(19)     not null
        constraint BATCH_STEP_EXEC_CONTEXT_PK
            primary key
        constraint STEP_EXEC_CTX_FK
            references FRFR.BATCH_STEP_EXECUTION,
    SHORT_CONTEXT      varchar(2500) not null,
    SERIALIZED_CONTEXT text
);

CREATE TABLE IF NOT EXISTS FRFR.BATCH_JOB_EXECUTION_CONTEXT
(
    JOB_EXECUTION_ID   numeric(19)     not null
        constraint BATCH_JOB_EXEC_CONTEXT_PK
            primary key
        constraint JOB_EXEC_CTX_FK
            references FRFR.BATCH_JOB_EXECUTION,
    SHORT_CONTEXT      varchar(2500) not null,
    SERIALIZED_CONTEXT text
);

CREATE TABLE IF NOT EXISTS FRFR.NODE_PROPS
(
    NODE_ID    varchar(50) not null,
    PROP_NAME  varchar(50) not null,
    PROP_VALUE varchar(1000),
    PROP_TS    TIMESTAMP(6),
    constraint NODE_PROPS_PK
        primary key (NODE_ID, PROP_NAME)
);

CREATE TABLE IF NOT EXISTS FRFR.CONFIGURATION
(
    NAME        varchar(255) not null
        constraint CONFIGURATION_PK
            primary key,
    VALUE       varchar(1000),
    DESCRIPTION varchar(200),
    MODIFIED_TS TIMESTAMP(6) default CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS FRFR.DEVICES_TEMP
(
    DEVICE_APP_ID varchar(50) not null,
    PASSWORD      varchar(100),
    SALT          varchar(100)
);

CREATE TABLE IF NOT EXISTS FRFR.ASKR_ROLE 
   (	ASKR_ROLE_ID numeric(38,0) CONSTRAINT ASKR_ROLE_NN1 NOT NULL , 
	ROLE_TYPE VARCHAR(10) CONSTRAINT ASKR_ROLE_NN2 NOT NULL , 
	ROLE_NAME VARCHAR(50) CONSTRAINT ASKR_ROLE_NN3 NOT NULL , 
	DELETE_FLAG CHAR(1) CONSTRAINT ASKR_ROLE_NN4 NOT NULL , 
	CREATED_TS TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP CONSTRAINT ASKR_ROLE_NN5 NOT NULL , 
	CREATE_USER_NAME VARCHAR(40) CONSTRAINT ASKR_ROLE_NN6 NOT NULL , 
	MODIFIED_TS TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP CONSTRAINT ASKR_ROLE_NN7 NOT NULL , 
	MODIFY_USER_NAME VARCHAR(40) CONSTRAINT ASKR_ROLE_NN8 NOT NULL )
  ;

COMMENT ON COLUMN FRFR.ASKR_ROLE.ASKR_ROLE_ID IS 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';
COMMENT ON COLUMN FRFR.ASKR_ROLE.CREATE_USER_NAME IS 'The identifier of who created the record.';
COMMENT ON COLUMN FRFR.ASKR_ROLE.MODIFY_USER_NAME IS 'The identifier for who last modified the record.';

-- FRFR.ASKR_USER definition

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER 
   (	ASKR_USER_ID numeric(38) CONSTRAINT ASKR_USER_NN1 NOT NULL , 
	USER_NAME varchar(50) CONSTRAINT ASKR_USER_NN2 NOT NULL , 
	EMAIL_ADDR varchar(100) CONSTRAINT ASKR_USER_NN3 NOT NULL , 
	USER_CATEGORY varchar(255), 
	FIRST_NAME varchar(50) CONSTRAINT ASKR_USER_NN5 NOT NULL , 
	LAST_NAME varchar(50) CONSTRAINT ASKR_USER_NN6 NOT NULL , 
	PHONE_NBR varchar(20), 
	JOB_TITLE varchar(100), 
	COMPANY_NAME varchar(100), 
	COMPANY_ADDR varchar(100), 
	CITY_NAME varchar(50), 
	COUNTY_NAME varchar(50), 
	STATE_PROV_CODE CHAR(20), 
	ZIP_CODE varchar(20), 
	COUNTRY_NAME varchar(10), 
	SUPERVISOR_FIRST_NAME varchar(50), 
	SUPERVISOR_LAST_NAME varchar(50), 
	SUPERVISOR_EMAIL_ADDR varchar(100), 
	SUPERVISOR_PHONE_NBR varchar(20), 
	TRAINER_FIRST_NAME varchar(50), 
	TRAINER_LAST_NAME varchar(50), 
	TRAINER_CLASS_ID varchar(30), 
	VALID_FROM_DATE DATE, 
	SPONSORING_RR varchar(10), 
	VALIDATION_DATE DATE, 
	REG_QTY numeric(4), 
	LANGUAGE_CODE varchar(10), 
	ACCESS_NBR numeric(10), 
	USER_STATUS varchar(25), 
	DELETE_FLAG CHAR(1), 
	CREATED_TS TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP CONSTRAINT ASKR_USER_NN31 NOT NULL , 
	CREATE_USER_NAME varchar(40) CONSTRAINT ASKR_USER_NN32 NOT NULL , 
	MODIFIED_TS TIMESTAMP (6) DEFAULT CURRENT_TIMESTAMP CONSTRAINT ASKR_USER_NN33 NOT NULL , 
	MODIFY_USER_NAME varchar(40) CONSTRAINT ASKR_USER_NN34 NOT NULL ) ;

COMMENT ON COLUMN FRFR.ASKR_USER.ASKR_USER_ID IS 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';
COMMENT ON COLUMN FRFR.ASKR_USER.CREATE_USER_NAME IS 'The identifier of who created the record.';
COMMENT ON COLUMN FRFR.ASKR_USER.MODIFY_USER_NAME IS 'The identifier for who last modified the record.';

CREATE INDEX IF NOT EXISTS  ASKR_USER_IDX1
    on FRFR.ASKR_USER (USER_NAME);

CREATE INDEX IF NOT EXISTS ASKR_USER_IDX2
    on FRFR.ASKR_USER (FIRST_NAME, LAST_NAME);

CREATE INDEX IF NOT EXISTS  ASKR_USER_IDX3
    on FRFR.ASKR_USER (EMAIL_ADDR);

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER_DEVICE
(
    ASKR_USER_DEVICE_ID  numeric(38)      constraint ASKR_USER_DEVICE_NN1 not null,
    ASKR_USER_ID         numeric(38),
    DEVICE_APP_ID        varchar(50)      constraint ASKR_USER_DEVICE_NN3  not null,
    USER_NAME            varchar(50)        constraint ASKR_USER_DEVICE_NN4               not null ,
    PHONE_NBR            varchar(20),
    EMAIL_ADDR           varchar(100)      constraint ASKR_USER_DEVICE_NN6                not null,
    EMAIL_VALIDATED_FLAG CHAR,
    EMAIL_CODE           varchar(50),
    EMAIL_VALIDATED_DATE DATE,
    CLIENT_TYPE          varchar(10),
    ALERTING_ID          varchar(250),
    DEVICE_STATUS        varchar(25),
    REGISTERED_DATE      DATE,
    LAST_ACTIVE_DATE     DATE,
    USER_VERSION         varchar(50),
    LANGUAGE_CODE        varchar(10),
    NEED_LINK_ALERT      numeric(1),
    DELETE_FLAG          CHAR,
    CREATED_TS           TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_DEVICE_NN19 not null,
    CREATE_USER_NAME     varchar(40)     constraint ASKR_USER_DEVICE_NN20                not null,
    MODIFIED_TS          TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_DEVICE_NN21 not null,
    MODIFY_USER_NAME     varchar(40)    constraint ASKR_USER_DEVICE_NN22                  not null,
    PASSWORD             varchar(100),
    SALT                 varchar(100)
);

comment on column FRFR.ASKR_USER_DEVICE.ASKR_USER_DEVICE_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_DEVICE.ASKR_USER_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_DEVICE.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_USER_DEVICE.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE TABLE IF NOT EXISTS FRFR.ASKR_DEVICE_ROLE
(
    ASKR_ROLE_ID        numeric(38)     constraint ASKR_DEVICE_ROLE_NN1                   not null
        ,
    ASKR_USER_DEVICE_ID numeric(38)   constraint ASKR_DEVICE_ROLE_NN2                     not null
       ,
    CREATED_TS          TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_DEVICE_ROLE_NN3 not null
        ,
    CREATE_USER_NAME    varchar(40)          constraint ASKR_DEVICE_ROLE_NN4             not null
       ,
    MODIFIED_TS         TIMESTAMP(6) default CURRENT_TIMESTAMP  constraint ASKR_DEVICE_ROLE_NN5 not null
       ,
    MODIFY_USER_NAME    varchar(40)       constraint ASKR_DEVICE_ROLE_NN6               not null
        ,
    constraint ASKR_DEVICE_ROLE_PK
        primary key (ASKR_USER_DEVICE_ID, ASKR_ROLE_ID)
);

comment on column FRFR.ASKR_DEVICE_ROLE.ASKR_ROLE_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_DEVICE_ROLE.ASKR_USER_DEVICE_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_DEVICE_ROLE.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_DEVICE_ROLE.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE  INDEX IF NOT EXISTS  ASK_USER_DEVICE_IDX1
    on FRFR.ASKR_USER_DEVICE (USER_NAME);

CREATE  INDEX IF NOT EXISTS  ASK_USER_DEVICE_IDX2
    on FRFR.ASKR_USER_DEVICE (EMAIL_ADDR);

CREATE  INDEX IF NOT EXISTS   ASK_USER_DEVICE_IDX3
    on FRFR.ASKR_USER_DEVICE (ASKR_USER_ID);

CREATE  TABLE IF NOT EXISTS FRFR.ASKR_USER_NOTE
(
    ASKR_USER_ID      numeric(38) ,
    ASKR_USER_NOTE_ID numeric(38)            constraint ASKR_USER_NOTE_NN2             not null
       ,
    NOTE_TYPE         varchar(10),
    NOTE_TEXT         varchar(4000),
    CREATED_TS        TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_NOTE_NN5 not null
        ,
    CREATE_USER_NAME  varchar(40)       constraint ASKR_USER_NOTE_NN6               not null
        ,
    MODIFIED_TS       TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_NOTE_NN7 not null
        ,
    MODIFY_USER_NAME  varchar(40)        constraint ASKR_USER_NOTE_NN8               not null
       
);

comment on column FRFR.ASKR_USER_NOTE.ASKR_USER_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_NOTE.ASKR_USER_NOTE_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_NOTE.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_USER_NOTE.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER_ROLE
(
    ASKR_USER_ID     numeric(38)     constraint ASKR_USER_ROLE_NN1                   not null
        ,
    ASKR_ROLE_ID     numeric(38)          constraint ASKR_USER_ROLE_NN2              not null
       ,
    CREATED_TS       TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_ROLE_NN3 not null
        ,
    CREATE_USER_NAME varchar(40)        constraint ASKR_USER_ROLE_NN4              not null
        ,
    MODIFIED_TS      TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_ROLE_NN5 not null
        ,
    MODIFY_USER_NAME varchar(40)            constraint ASKR_USER_ROLE_NN6           not null
       ,
    constraint ASKR_USER_ROLE_PK
        primary key (ASKR_ROLE_ID, ASKR_USER_ID)
);

comment on column FRFR.ASKR_USER_ROLE.ASKR_USER_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_ROLE.ASKR_ROLE_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_ROLE.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_USER_ROLE.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE TABLE IF NOT EXISTS FRFR.ASKR_ADMIN
(
    ASKR_ADMIN_ID       numeric(38)      constraint ASKR_ADMIN_NN1                   not null
       ,
    SSO_USER_ID         varchar(20)      constraint ASKR_ADMIN_NN2                not null
        ,
    SSO_USER_EMAIL_ADDR varchar(100)       constraint ASKR_ADMIN_NN3              not null
        ,
    DELETED_FLAG        CHAR            constraint ASKR_ADMIN_NN4                  not null
        ,
    CREATED_TS          TIMESTAMP(6) default CURRENT_TIMESTAMP  constraint ASKR_ADMIN_NN5 not null
       ,
    CREATE_USER_NAME    varchar(40)               constraint ASKR_ADMIN_NN6       not null
        ,
    MODIFIED_TS         TIMESTAMP(6) default CURRENT_TIMESTAMP  constraint ASKR_ADMIN_NN7 not null
       ,
    MODIFY_USER_NAME    varchar(40)     constraint ASKR_ADMIN_NN8                  not null
       
);

comment on column FRFR.ASKR_ADMIN.ASKR_ADMIN_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_ADMIN.SSO_USER_ID is 'Surrogate Key identifier.  Same as Identifier domain from a naming standards perspective, however a Sequence object will NOT be generated for this domain.';

comment on column FRFR.ASKR_ADMIN.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_ADMIN.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE INDEX IF NOT EXISTS  ASKR_ADMIN_IDX1
    on FRFR.ASKR_ADMIN (SSO_USER_EMAIL_ADDR);

CREATE INDEX IF NOT EXISTS  ASKR_ADMIN_IDX2
    on FRFR.ASKR_ADMIN (SSO_USER_ID);

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER_ADMIN
(
    ASKR_USER_ID     numeric(38)       constraint ASKR_USER_ADMIN_NN1                  not null
       ,
    ASKR_ADMIN_ID    numeric(38)     constraint ASKR_USER_ADMIN_NN2                   not null
       ,
    DELETED_FLAG     CHAR                constraint ASKR_USER_ADMIN_NN3               not null
       
         ,
    CREATED_TS       TIMESTAMP(6) default CURRENT_TIMESTAMP  constraint ASKR_USER_ADMIN_NN4 not null
       ,
    CREATE_USER_NAME varchar(40)               constraint ASKR_USER_ADMIN_NN5         not null
      ,
    MODIFIED_TS      TIMESTAMP(6) default CURRENT_TIMESTAMP constraint ASKR_USER_ADMIN_NN6 not null
        ,
    MODIFY_USER_NAME varchar(40)   constraint ASKR_USER_ADMIN_NN7                    not null
       
);

comment on column FRFR.ASKR_USER_ADMIN.ASKR_USER_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_ADMIN.ASKR_ADMIN_ID is 'Surrogate Key identifier for which a Sequence object will be generated by the Naming Standards utility.';

comment on column FRFR.ASKR_USER_ADMIN.CREATE_USER_NAME is 'The identifier of who created the record.';

comment on column FRFR.ASKR_USER_ADMIN.MODIFY_USER_NAME is 'The identifier for who last modified the record.';

CREATE INDEX IF NOT EXISTS  ASKR_USER_ADMIN_IDX1
    on FRFR.ASKR_USER_ADMIN (ASKR_USER_ID);

CREATE INDEX IF NOT EXISTS  ASKR_USER_ADMIN_IDX2
    on FRFR.ASKR_USER_ADMIN (ASKR_ADMIN_ID);

CREATE TABLE IF NOT EXISTS FRFR.STG_ADMINS
(
    ADMIN_ID        numeric,
    MODIFIED_DATE   DATE,
    DELETED         numeric,
    GROUP_ID        numeric,
    PARENT_ADMIN_ID numeric,
    ADMIN_NAME      varchar(100),
    PHONE_numeric    varchar(255),
    EMAIL_ADDRES    varchar(255),
    HASH            varchar(1000),
    STATUS          numeric,
    ADMIN_TYPE      numeric,
    CONSENTED       numeric,
    CONSENTED_ON    DATE,
    TOKEN           varchar(30),
    TICKET          varchar(30)
);

CREATE TABLE IF NOT EXISTS FRFR.STG_FEATURES
(
    FEATURE_ID    numeric not null
        constraint FEATURES_PK
            primary key,
    MODIFIED_DATE DATE   default NULL,
    DELETED       numeric default NULL,
    FEATURE_TYPE  numeric default NULL
);

CREATE TABLE IF NOT EXISTS FRFR.STG_INVITES
(
    INVITE_ID                numeric not null
        constraint INVITES_PK
            primary key,
    MODIFIED_DATE            DATE          default NULL,
    DELETED                  numeric        default NULL,
    NOTES                    varchar(4000),
    EMAIL_ADDRESS            varchar(255) default NULL,
    INVITE_NAME              varchar(255),
    FIRST_NAME               varchar(255),
    LAST_NAME                varchar(255),
    USER_CATEGORY            varchar(255),
    PHONE_numeric             varchar(255),
    JOB_TITLE                varchar(255),
    COMPANY                  varchar(255),
    COMPANY_ADDRESS          varchar(255),
    CITY                     varchar(255),
    COUNTY                   varchar(255),
    STATE                    varchar(10),
    ZIP_CODE                 varchar(255),
    COUNTRY                  varchar(10),
    SUPERVISOR_FIRST_NAME    varchar(255),
    SUPERVISOR_LAST_NAME     varchar(255),
    SUPERVISOR_EMAIL_ADDRESS varchar(255),
    SUPERVISOR_PHONE_numeric  varchar(255),
    TRAINER_FIRST_NAME       varchar(255),
    TRAINER_LAST_NAME        varchar(255),
    CLASS_ID                 varchar(255),
    SPONSORING_RAIL_ROAD     varchar(255),
    APPLICATION_TYPE         numeric        default NULL,
    CODE                     varchar(50)  default NULL,
    CREATED_DATE             DATE          default NULL,
    VALID_FROM_DATE          DATE          default NULL,
    REG_QUANTITY             numeric        default NULL,
    LANGUAGE                 numeric        default NULL,
    REVOKE_NOTES             varchar(255),
    REVOKE_TYPE              numeric        default NULL,
    REVOKE_DATE              DATE          default NULL,
    VALIDATION_DATE          DATE          default NULL,
    ACCESS_numeric            numeric        default NULL,
    PROFILE_UPDATED          DATE          default NULL,
    DENY_TYPE                varchar(255),
    DENY_NOTES               varchar(1000),
    STATUS                   numeric(11)    default NULL
);

create unique index  INVITES_UK1
    on FRFR.STG_INVITES (EMAIL_ADDRESS, APPLICATION_TYPE);

CREATE TABLE IF NOT EXISTS FRFR.STG_INVITE_ADMINS
(
    ADMIN_ID  numeric,
    INVITE_ID numeric
);

CREATE TABLE IF NOT EXISTS FRFR.STG_INVITE_FEATURES
(
    INVITE_ID  numeric not null
        constraint INVITE_FEATURE_ID_FK1
            references FRFR.STG_INVITES,
    FEATURE_ID numeric not null
        constraint INVITE_FEATURE_ID_FK2
            references FRFR.STG_FEATURES,
    constraint INVITE_FEATURES_PK
        primary key (INVITE_ID, FEATURE_ID)
);

CREATE TABLE IF NOT EXISTS FRFR.STG_INVMASS
(
    INVITE_ID                numeric,
    MODIFIED_DATE            DATE          default NULL,
    DELETED                  numeric        default NULL,
    NOTES                    varchar(4000),
    EMAIL_ADDRESS            varchar(255) default NULL,
    INVITE_NAME              varchar(255),
    FIRST_NAME               varchar(255),
    LAST_NAME                varchar(255),
    USER_CATEGORY            varchar(255),
    PHONE_numeric             varchar(255),
    JOB_TITLE                varchar(255),
    COMPANY                  varchar(255),
    COMPANY_ADDRESS          varchar(255),
    CITY                     varchar(255),
    COUNTY                   varchar(255),
    STATE                    varchar(10),
    ZIP_CODE                 varchar(255),
    COUNTRY                  varchar(10),
    SUPERVISOR_FIRST_NAME    varchar(255),
    SUPERVISOR_LAST_NAME     varchar(255),
    SUPERVISOR_EMAIL_ADDRESS varchar(255),
    SUPERVISOR_PHONE_numeric  varchar(255),
    TRAINER_FIRST_NAME       varchar(255),
    TRAINER_LAST_NAME        varchar(255),
    CLASS_ID                 varchar(255),
    SPONSORING_RAIL_ROAD     varchar(255),
    APPLICATION_TYPE         numeric        default NULL,
    CODE                     varchar(50)  default NULL,
    CREATED_DATE             DATE          default NULL,
    VALID_FROM_DATE          DATE          default NULL,
    REG_QUANTITY             numeric        default NULL,
    LANGUAGE                 numeric        default NULL,
    REVOKE_NOTES             varchar(255),
    REVOKE_TYPE              numeric        default NULL,
    REVOKE_DATE              DATE          default NULL,
    VALIDATION_DATE          DATE          default NULL,
    ACCESS_numeric            numeric        default NULL,
    PROFILE_UPDATED          DATE          default NULL,
    DENY_TYPE                varchar(255),
    DENY_NOTES               varchar(1000),
    STATUS                   numeric(11)    default NULL
);

CREATE TABLE IF NOT EXISTS FRFR.STG_USERS
(
    USER_ID                    numeric(11) not null
        constraint USERS_PK
            primary key,
    MODIFIED_DATE              DATE          default NULL,
    DELETED                    numeric(1)     default NULL,
    FIRST_ID                   varchar(50)  default NULL,
    USER_NAME                  varchar(255),
    PHONE_numeric               varchar(255),
    PRIMARY_EMAIL_ADDRESS      varchar(255),
    ALTERNATE_EMAIL_ADDRESS    varchar(255),
    PRIMARY_EMAIL_VALIDATED    numeric(1)     default NULL,
    ALTERNATE_EMAIL_VALIDATED  numeric(1)     default NULL,
    PRIMARY_EMAIL_CODE         varchar(50)  default NULL,
    ALTERNATE_EMAIL_CODE       varchar(50)  default NULL,
    CLIENT_TYPE                numeric(11)    default NULL,
    ALERTING_ID                varchar(255),
    STATUS                     numeric(11)    default NULL,
    REGISTERED_DATE            DATE          default NULL,
    LAST_ACTIVE_DATE           DATE          default NULL,
    PRIMARY_EMAIL_VALIDATED_DT DATE          default NULL,
    APPLICATION_TYPE           numeric(11)    default NULL,
    USER_VERSION               varchar(255) default NULL,
    LANGUAGE                   numeric(11)    default NULL,
    NEED_LINK_ALERT            numeric(1)     default NULL,
    ROOT_USER_ID               numeric(11)    default NULL
        constraint ROOT_USER_ID_FK
            references FRFR.STG_USERS,
    INVITE_ID                  numeric(11)    default NULL
        constraint INVITE_ID_FK
            references FRFR.STG_INVITES
);

CREATE TABLE IF NOT EXISTS FRFR.STG_FEATURE_REQUESTS
(
    FEATURE_REQUEST_ID numeric(11) not null
        constraint FEATURE_REQUESTS_PK
            primary key,
    MODIFIED_DATE      DATE   default NULL,
    DELETED            numeric default NULL,
    USER_ID            numeric default NULL
        constraint USER_ID_FK
            references FRFR.STG_USERS,
    FEATURE_ID         numeric default NULL
        constraint FEATURE_ID_FK
            references FRFR.STG_FEATURES,
    REQUEST_STATUS     numeric default NULL,
    JUSTIFICATION      varchar(2000),
    COMMENTS           varchar(2000),
    NEED_ALERT         numeric default NULL,
    constraint FEATURE_REQUESTS_UK1
        unique (USER_ID, FEATURE_ID)
);

CREATE TABLE IF NOT EXISTS FRFR.RAM_MOBILE_TST
(
    REQUEST_TS TIMESTAMP(6),
    DEVICE_ID  varchar(1000),
    SEQ_NUM    numeric(20),
    NODE       varchar(2)
);

CREATE TABLE IF NOT EXISTS FRFR.REQUEST_LOG_BKUP
(
    REQUEST_USER_NAME varchar(40) not null,
    SEARCH_TYPE_CODE  varchar(10) not null,
    SEARCH_EQUIP_ID   varchar(14),
    REQUEST_TS        TIMESTAMP(6) not null,
    GPS_LATITUDE      numeric(12, 9),
    GPS_LONGITUDE     numeric(12, 9),
    RESPONSE_MSG_DATA text,
    ERROR_TEXT        varchar(1000),
    CREATED_TS        TIMESTAMP(6) not null,
    CREATE_USER_NAME  varchar(40),
    MODIFIED_TS       TIMESTAMP(6),
    MODIFY_USER_NAME  varchar(40),
    USER_TYPE         varchar(40),
    SPONSORING_RR     varchar(10)
);

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER_SUMIT
(
    EMAIL_ADDR    varchar(200) not null
        primary key,
    SPONSORING_RR varchar(20)  not null,
    ACCESS_TYPE   varchar(10)  not null,
    USER_ACTION   varchar(10),
    CREATE_ID     varchar(20),
    CREATE_TS     TIMESTAMP(6),
    UPDATE_ID     varchar(20),
    UPDATE_TS     TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS FRFR.ASKR_USER_SUMIT1
(
    EMAIL_ADDR    varchar(200) not null
        primary key,
    SPONSORING_RR varchar(100) not null,
    USER_ACTION   varchar(10),
    CREATE_ID     varchar(20),
    CREATE_TS     TIMESTAMP(6),
    UPDATE_ID     varchar(20),
    UPDATE_TS     TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS FRFR.LM_2018
(
    ROW_NUM          numeric(10),
    YEAR             numeric(4),
    MARK_NAME        varchar(255) not null,
    CONTROLPOINT_ID  varchar(255),
    TRACK_MESSAGE_ID varchar(255)
);

CREATE TABLE IF NOT EXISTS FRFR.LM_2017
(
    ROW_NUM          numeric(10),
    YEAR             numeric(4),
    MARK_NAME        varchar(255) not null,
    CONTROLPOINT_ID  varchar(255),
    TRACK_MESSAGE_ID varchar(255),
    USER_ACTION      varchar(10)  not null,
    CREATE_ID        varchar(20)  not null,
    CREATE_TS        TIMESTAMP(6)  not null,
    UPDATE_ID        varchar(20)  not null,
    UPDATE_TS        TIMESTAMP(6)  not null
);

create unique index LM_2017_U01
    on FRFR.LM_2017 (ROW_NUM, USER_ACTION, CREATE_ID, CREATE_TS, UPDATE_ID, UPDATE_TS);

--create or replace FUNCTION SQUIRREL_GET_ERROR_OFFSET(query IN varchar) 
--return INTEGER authid current_user is
--   l_theCursor integer default dbms_sql.open_cursor; 
--   l_status integer;
--begin
--    begin
--        dbms_sql.parse(l_theCursor, query, dbms_sql.native);
--    exception
--        when others then l_status := dbms_sql.last_error_position;
--    end;
--    dbms_sql.close_cursor(l_theCursor); 
--   	return l_status;
--end;



