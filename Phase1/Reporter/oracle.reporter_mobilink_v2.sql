-- Update 21.Feb.2005 Modified by Stuart Cook
-- 1) Added additional columns from the Omnibus V7 Object Server.
-- 2) Changed DATE column types back to TIMESTAMP WITH LOCAL TIME ZONE.
-- 3) Optimized column sizes to match with size of Object Server columns.
--
-- Update 27.May.2004 Modified by Zane Bray
-- 1) Replaced TIMESTAMP WITH LOCAL TIME ZONE data type back to DATE
-- to allow for Oracle 8i, 9i cross-compatibility.
-- 2) Added autosequencing fields to each of the audit tables to
-- resolve unique constraint violation issues and deadlock issues caused
-- by IDUC client latency.  This is made up of the following:
--    a) Add extra primary key fields - AuditKey: NUMBER(16) - to tables:
--           REP_AUDIT_OWNERUID
--           REP_AUDIT_OWNERGID
--           REP_AUDIT_SEVERITY
--           REP_AUDIT_ACK
--    b) Add individual sequences for each
--    c) Add AuditKey to procedures that populate the audit tables
-- 3) Added autosequencing field to journal table to avoid unique constraint
-- violation errors when two journal entries are added to an event within
-- the same one second window.
-- 4) Added ServerName to RJ_INDEX
-- 5) Added trigger to populate JournalKey field in reporter_journal

-- Update 07.May.2004 Modified by Stuart
-- Replaced DATE data type with TIMESTAMP WITH LOCAL TIME ZONE to address 
-- constraint violation and deadlock issues.

-- Updated 04.Apr.2003 by Stuart Cook
-- Removed gateway specific components.
-- Reduced the size of extents, which will have the effect of a smaller 
-- reporter database footprint.
-- Tided up presentation and enhanced maintainability.
--
-- Update 12.Aug.2000 Modified by Stuart Cook.
-- Combined all scripts in to a single script.

-- Update 18.May.2000 Modified by Adam.
-- Reporter_Status serial no longer defined as PRIMARY KEY (now NULL)
-- Added REPORTER_NAMES and REPORTER_GROUPS tables
-- Fixed the English and spelling where I could.
-- Improved commenting of static tables (REPORTER_CLASSES and so on)

-- Update 10.Apr.2000 Modified by Adam. Made ServerSerial and ServerName on
-- Journal and Details not null.

-- Update 05.Apr.2000 Modified by Roland

-------------------------------------------------------------------------------
-- HOW TO RUN THIS SCRIPT:

-- This script will create all the schema objects needed
-- to store data processed by the Gateway.
--    This includes  tables, indexes and constraints.

-- To run this script, you must do the following:
--   (1) Put this script in directory of your choice.

--   (2) Logon via SQLPLUS to the database with the same Username/password 
--       used to run the gateway.  - (Do this from the same directory)

--   (3) At the Sqlplus prompt, run this script eg    @oracle9i.reporter.sql

--  EXAMPLE      SQLPLUS>  @oracle9i.reporter.sql
--------------------------------------------------------------------------------

-- User tablespace.
DROP TABLESPACE REPORTER INCLUDING CONTENTS;
CREATE TABLESPACE REPORTER
DATAFILE 'REPORTER_DATA' SIZE 256K REUSE
AUTOEXTEND ON NEXT 128K
DEFAULT STORAGE (
                INITIAL 256K
                NEXT   128K
                MINEXTENTS 1 
                MAXEXTENTS 999
                PCTINCREASE 0) 
                LOGGING
                ONLINE;
COMMIT;

-- Temporary tablespace.
DROP TABLESPACE REPORTER_TEMP INCLUDING CONTENTS;
CREATE TEMPORARY TABLESPACE REPORTER_TEMP
TEMPFILE 'REPORTER_TEMP_DATA' SIZE 256K REUSE
AUTOEXTEND ON NEXT 128K MAXSIZE UNLIMITED
UNIFORM SIZE 128K;

COMMIT;

-- Create user.
DROP USER reporter CASCADE;

CREATE USER reporter IDENTIFIED BY reporter
DEFAULT TABLESPACE REPORTER 
TEMPORARY TABLESPACE REPORTER_TEMP
PROFILE DEFAULT ACCOUNT UNLOCK;
GRANT CONNECT TO reporter;
GRANT RESOURCE TO reporter;
GRANT SELECT_CATALOG_ROLE TO reporter;
GRANT SELECT ANY TABLE TO reporter;
GRANT UNLIMITED TABLESPACE TO reporter;

-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- Added By Alex Silva in order to allow the 3 Views creation at the en of this script
GRANT create view to reporter


CONNECT reporter/reporter

set serveroutput on
set echo on

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- This section sets up the sequences used by Oracle to ensure
-- audit table entries do not experience unique constraint
-- violations as a result of IDUC latency.  I have also created a
-- sequence that is used on insert into the journal table to
-- catch unique constraint violations as a result of multiple journal
-- entries occurring within the same one second window. ZB
--///////////////////////////////////////////////////////////////////

drop sequence owneruid_seq;
create sequence owneruid_seq
start with 1
increment by 1
nomaxvalue;

drop sequence ownergid_seq;
create sequence ownergid_seq
start with 1
increment by 1
nomaxvalue;

drop sequence severity_seq;
create sequence severity_seq
start with 1
increment by 1
nomaxvalue;

drop sequence ack_seq;
create sequence ack_seq
start with 1
increment by 1
nomaxvalue;

drop sequence journal_seq;
create sequence journal_seq
start with 1
increment by 1
nomaxvalue;

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- THIS SECTION OF THE SCRIPT  CREATES ALL THE TABLES DIRECTLY
-- ACCESSED BY THE REPORTER GATEWAY

-- TABLES:
--        REPORTER_DETAILS
--        REPORTER_JOURNAL
--        REPORTER_STATUS
--//////////////////////////////////////////////////////////////////////


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_DETAIL table is one of the three tables directly written 
-- to by the Gateway.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DROP  TABLE reporter_details CASCADE CONSTRAINTS;

-- ServerName and ServerSerial made NOT NULL 10.Apr.2000 ADB

CREATE TABLE reporter_details (
        Identifier	VARCHAR2(255),
        AttrVal		NUMBER(4),
        Sequence	NUMBER(16),
        Name		VARCHAR2(255),
        Detail		VARCHAR2(255),
        ServerName	VARCHAR2(255)	NOT NULL,
        ServerSerial	NUMBER(16)	NOT NULL
)
/

-- Create the Indexes for REPORTER_DETAILS

CREATE UNIQUE INDEX RD_INDEX
 ON reporter_details ( 
	ServerSerial,
	ServerName,
	Sequence 
)
/

-- Create the Constraints for REPORTER_DETAILS

ALTER TABLE reporter_details
 ADD PRIMARY KEY (
 	ServerSerial,
	ServerName,
	Sequence
)
/


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_JOURNAL table is another of the three tables directly 
-- written to by the Gateway.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ServerName and ServerSerial made NOT NULL 10.Apr.2000 ADB

-- Create the Table REPORTER_JOURNAL
DROP  TABLE reporter_journal CASCADE CONSTRAINTS;

CREATE TABLE reporter_journal (
        JournalKey	NUMBER(24)	NOT NULL,
        Serial		NUMBER(16)	NOT NULL,
        UserID		NUMBER(16)	NOT NULL,
        Chrono		DATE		NOT NULL,
        Text1		VARCHAR2(255)	NULL,
        Text2		VARCHAR2(255)	NULL,
        Text3		VARCHAR2(255)	NULL,
        Text4		VARCHAR2(255)	NULL,
        Text5		VARCHAR2(255)	NULL,
        Text6		VARCHAR2(255)	NULL,
        Text7		VARCHAR2(255)	NULL,
        Text8		VARCHAR2(255)	NULL,
        Text9		VARCHAR2(255)	NULL,
        Text10		VARCHAR2(255)	NULL,
        Text11		VARCHAR2(255)	NULL,
        Text12		VARCHAR2(255)	NULL,
        Text13		VARCHAR2(255)	NULL,
        Text14		VARCHAR2(255)	NULL,
        Text15		VARCHAR2(255)	NULL,
        Text16		VARCHAR2(255)	NULL,
        ServerName	VARCHAR2(64)	NOT NULL,
        ServerSerial	NUMBER(16)	NOT NULL
)
/

-- Create the Indexes for REPORTER_JOURNAL

CREATE INDEX RJ_INDEX
 ON reporter_journal (
	ServerSerial,
	ServerName
)
/

-- Create the Constraints for REPORTER_JOURNAL

ALTER TABLE reporter_journal
 ADD PRIMARY KEY (
	JournalKey,
	ServerSerial,
	ServerName,
	UserID,
	Chrono
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_STATUS table is the main one of the three tables directly 
-- written to by the Gateway.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Mod 18.5.2000. Serial made NULL (previously PRIMARY KEY).

-- Create the Table REPORTER_STATUS
DROP  TABLE reporter_status CASCADE CONSTRAINTS;

CREATE TABLE reporter_status
(
       Identifier        VARCHAR2(255)  NULL,
       Serial            NUMBER(16)     NULL,
       Node              VARCHAR2(64)   NULL,
       NodeAlias         VARCHAR2(64)   NULL,
       Manager           VARCHAR2(64)   NULL,
       Agent             VARCHAR2(64)   NULL,
       AlertGroup        VARCHAR2(64)   NULL,
       AlertKey          VARCHAR2(255)  NULL,
       Severity          NUMBER(4)      NULL,
       Summary           VARCHAR2(255)  NULL,
       LastModified      DATE           NULL,
       FirstOccurrence   DATE           NULL,
       LastOccurrence    DATE           NULL,
       Poll              NUMBER(4)      NULL,
       Type              NUMBER(4)      NULL,
       Tally             NUMBER(16)     NULL,
       Class             NUMBER(16)      NULL,
       Grade             NUMBER(8)      NULL,
       Location          VARCHAR2(64)   NULL,
       OwnerUID          NUMBER(16)     NULL,
       OwnerGID          NUMBER(16)     NULL,
       Acknowledged      NUMBER(4)      NULL,
       EventId           VARCHAR(255)   NULL,
       ExpireTime        NUMBER(8)      NULL,
       ProcessReq        NUMBER(4)      NULL,
       SuppressEscl      NUMBER(4)      NULL,
       Customer          VARCHAR(64)    NULL,
       Service           VARCHAR(64)    NULL,
       PhysicalSlot      NUMBER(4)      NULL,
       PhysicalPort      NUMBER(4)      NULL,
       PhysicalCard      VARCHAR(64)    NULL,
       TaskList          NUMBER(4)      NULL,
       NmosSerial        VARCHAR(64)    NULL,
       NmosObjInst       NUMBER(4)      NULL,
       NmosCauseType     NUMBER(4)      NULL,
       LocalNodeAlias    VARCHAR(64)    NULL,
       LocalPriObj       VARCHAR(255)   NULL,
       LocalSecObj       VARCHAR(255)   NULL,
       LocalRootObj      VARCHAR(255)   NULL,
       RemoteNodeAlias   VARCHAR(64)    NULL,
       RemotePriObj      VARCHAR(255)   NULL,
       RemoteSecObj      VARCHAR(255)   NULL,
       RemoteRootObj     VARCHAR(255)   NULL,
       X733EventType     NUMBER(4)      NULL,
       X733ProbableCause NUMBER(8)      NULL,
       X733SpecificProb  VARCHAR(64)    NULL,
       X733CorrNotif     VARCHAR(255)   NULL,
       DeletedAt         DATE           NULL,
       OriginalSeverity  NUMBER(4)      NULL,
         AddText            VARCHAR2(255) NULL,
         AdvCorrCauseType       NUMBER(4)  NULL,
         AdvCorrServerName    VARCHAR2(64) NULL,
         AdvCorrServerSerial      NUMBER(4)  NULL,
         AggregationFirst         DATE  NULL,
         CauseType             VARCHAR2(512) NULL,
         CollectionFirst     DATE  NULL,
         CorrScore         NUMBER(4)  NULL,
         CovCity       VARCHAR2(64) NULL,
         DisplayFirst  DATE  NULL,
         Domain        VARCHAR2(64) NULL,
         ExtendedAttr   VARCHAR2(1024) NULL,
         Flash          NUMBER(4)  NULL,
         ImpactFlag     NUMBER(4)  NULL,
         LocalObjRelate   NUMBER(4)  NULL,
         LocalTertObj     VARCHAR2(255) NULL,
         ManCity          VARCHAR2(64) NULL,
         MaximoInfo       VARCHAR2(255) NULL,
         MaximoStatus     NUMBER(4)  NULL,
         NePriority       VARCHAR2(64) NULL,
         NmosDomainName   VARCHAR2(64) NULL,
         NmosEntityId      NUMBER(4)  NULL,
         NmosEventMap      VARCHAR2(64) NULL,
         NmosManagedStatus   NUMBER(4)  NULL,
         NoSimilarAlm        VARCHAR2(64) NULL,
         NotifiedFlag      NUMBER(4)  NULL,
         OldRow            NUMBER(4)  NULL,
         OmcEms            VARCHAR2(64) NULL,
         ProbeSubSecondId  NUMBER(8)  NULL,
         Region            VARCHAR2(64) NULL,
         RemoteObjRelate   NUMBER(4)  NULL,
         RemoteTertObj     VARCHAR2(255) NULL,
         SourceServerName   VARCHAR2(64) NULL,
         SourceServerSerial  NUMBER(16)  NULL,
         SourceStateChange      DATE  NULL,
       ServerName        VARCHAR2(64)   NOT NULL,
       ServerSerial      NUMBER(16)     NOT NULL
)
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- Added By Alex Silva to improve performance on a VLDB
-- Oracle.UsePartitioning must be set to TRUE in oracle gateway props

PARTITION BY RANGE (FirstOccurrence)
(
PARTITION JUN10_2 VALUES LESS THAN (TO_DATE('01/07/2010','DD/MM/YYYY')),
PARTITION JUL10_1 VALUES LESS THAN (TO_DATE('16/07/2010','DD/MM/YYYY')),
PARTITION JUL10_2 VALUES LESS THAN (TO_DATE('01/08/2010','DD/MM/YYYY')),
PARTITION AUG10_1 VALUES LESS THAN (TO_DATE('16/08/2010','DD/MM/YYYY')),
PARTITION AUG10_2 VALUES LESS THAN (TO_DATE('01/09/2010','DD/MM/YYYY')),
PARTITION SEP10_1 VALUES LESS THAN (TO_DATE('16/09/2010','DD/MM/YYYY')),
PARTITION SEP10_2 VALUES LESS THAN (TO_DATE('01/10/2010','DD/MM/YYYY')),
PARTITION OCT10_1 VALUES LESS THAN (TO_DATE('16/10/2010','DD/MM/YYYY')),
PARTITION OCT10_2 VALUES LESS THAN (TO_DATE('01/11/2010','DD/MM/YYYY')),
PARTITION NOV10_1 VALUES LESS THAN (TO_DATE('16/11/2010','DD/MM/YYYY')),
PARTITION NOV10_2 VALUES LESS THAN (TO_DATE('01/12/2010','DD/MM/YYYY')),
PARTITION DEC10_1 VALUES LESS THAN (TO_DATE('16/12/2010','DD/MM/YYYY')),
PARTITION DEC10_2 VALUES LESS THAN (TO_DATE('01/01/2011','DD/MM/YYYY')),
PARTITION JAN11_1 VALUES LESS THAN (TO_DATE('16/01/2011','DD/MM/YYYY')),
PARTITION JAN11_2 VALUES LESS THAN (TO_DATE('01/02/2011','DD/MM/YYYY')),
PARTITION FEB11_1 VALUES LESS THAN (TO_DATE('16/02/2011','DD/MM/YYYY')),
PARTITION FEB11_2 VALUES LESS THAN (TO_DATE('01/03/2011','DD/MM/YYYY')),
PARTITION MAR11_1 VALUES LESS THAN (TO_DATE('16/03/2011','DD/MM/YYYY')),
PARTITION MAR11_2 VALUES LESS THAN (TO_DATE('01/04/2011','DD/MM/YYYY')),
PARTITION APR11_1 VALUES LESS THAN (TO_DATE('16/04/2011','DD/MM/YYYY')),
PARTITION APR11_2 VALUES LESS THAN (TO_DATE('01/05/2011','DD/MM/YYYY')),
PARTITION MAY11_1 VALUES LESS THAN (TO_DATE('16/05/2011','DD/MM/YYYY')),
PARTITION MAY11_2 VALUES LESS THAN (TO_DATE('01/06/2011','DD/MM/YYYY')),
PARTITION JUN11_1 VALUES LESS THAN (TO_DATE('16/06/2011','DD/MM/YYYY')),
PARTITION JUN11_2 VALUES LESS THAN (TO_DATE('01/07/2011','DD/MM/YYYY'))
)
/


-- Create the Constraints for REPORTER_STATUS

ALTER TABLE reporter_status
 ADD PRIMARY KEY ( 
	ServerSerial, 
	ServerName 
)
/

-- Create the Indexes for REPORTER_STATUS

CREATE UNIQUE INDEX RS_INDEX
 ON reporter_status (
 	ServerSerial,
	ServerName,
	FirstOccurrence
)
/

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--  THIS SECTION LISTS THE AUDIT TABLES WHICH ACT AS SECEOND
--  LEVEL TABLES FOR THE GATEWAY.   THESE ARE NOT DIRECTLY ACCESSED BY
--  THE GATEWAY.   THEY ARE POPULATED OFF THE REPORTER_STATUS TABLE

--  TABLES:
--        REP_AUDIT_OWNERUID
--        REP_AUDIT_OWNERGID
--        REP_AUDIT_SEVERITY
--        REP_AUDIT_ACK
--/////////////////////////////////////////////////////////////////////


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_AUDIT_OWNERUID table is used to hold the User details
-- if the User id of a record is changed.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DROP  TABLE rep_audit_owneruid CASCADE CONSTRAINTS;

CREATE TABLE rep_audit_owneruid (
	AuditKey	NUMBER(16)	NOT NULL,
	Serial		NUMBER(16)	NOT NULL,
	StateChange	DATE 		NOT NULL,
	OldOwnerUID	NUMBER(16)	NOT NULL,
	OwnerUID	NUMBER(16)	NOT NULL,
	ServerName	VARCHAR2(64)	NULL,
	ServerSerial	NUMBER(16)	NULL
)
/


-- Create Constraints for REP_AUDIT_OWNERUID

ALTER TABLE rep_audit_owneruid
 ADD PRIMARY KEY (
	AuditKey,
 	ServerSerial,
	ServerName,
	StateChange
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_AUDIT_OWNERGID table is used to hold the User Group details
-- if the group id of a record is changed.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DROP  TABLE rep_audit_ownergid CASCADE CONSTRAINTS;

CREATE TABLE rep_audit_ownergid (
	AuditKey	NUMBER(16)	NOT NULL,
	Serial		NUMBER(16)	NOT NULL,
	StateChange	DATE 		NOT NULL,
	OldOwnerGID	NUMBER(16)	NOT NULL,
	OwnerGID	NUMBER(16)	NOT NULL,
	ServerName	VARCHAR2(64)	NULL,
	ServerSerial	NUMBER(16)	NULL
)
/

-- Create Constraints for REP_AUDIT_OWNERGID

ALTER TABLE rep_audit_ownergid
 ADD PRIMARY KEY (
	AuditKey,
 	ServerSerial,
	ServerName,
	StateChange
)
/


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_AUDIT_SEVERITY table is used to record the changes in severity
-- of a record in the Reporter_status table.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Create the Table REP_AUDIT_SEVERITY
DROP  TABLE rep_audit_severity CASCADE CONSTRAINTS;

CREATE TABLE rep_audit_severity (
	AuditKey	NUMBER(16)	NOT NULL,
	Serial		NUMBER(16) 	NOT NULL,
	StartDate	DATE 		NOT NULL,
	EndDate		DATE, 
	Severity	NUMBER(4),
	State		NUMBER(4),
	ServerName	VARCHAR2(64)	NOT NULL,
	ServerSerial	NUMBER(16)	NOT NULL
)
/

-- Create the Constraints for REP_AUDIT_SEVERITY

ALTER TABLE rep_audit_severity
 ADD PRIMARY KEY (
	AuditKey,
 	ServerSerial,
	ServerName,
	StartDate
)
/



--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_AUDIT_ACK table is used to record each acknowledgement
-- made to a record in the reporter_status table.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- Create table used for storing audit trail of Acknowledgement changes
DROP TABLE rep_audit_ack CASCADE CONSTRAINTS;

CREATE TABLE rep_audit_ack (
	AuditKey	NUMBER(16)	NOT NULL,
	Serial		NUMBER(16)	NOT NULL,
	StartDate	DATE 		NOT NULL,
	EndDate		DATE 		NULL,
	OwnerUID	NUMBER(16)	NULL,
	State		NUMBER(4)	NULL,
	ServerName	VARCHAR2(64)	NULL,
	ServerSerial	NUMBER(16)	NULL
)
/

ALTER TABLE rep_audit_ack
 ADD PRIMARY KEY (
	AuditKey,
 	ServerSerial,
	ServerName,
	StartDate
)
/

-- Create Supplementary Tables to Store Object Server Information
-- Create table to store UserNames for Netcool Users

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_NAMES table is used to hold the user details
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

DROP TABLE reporter_names CASCADE CONSTRAINTS;

CREATE TABLE reporter_names (
	Name		VARCHAR(64)	NOT NULL,
	OwnerUID	NUMBER(16)	NOT NULL,
	OwnerGID	NUMBER(16)	NOT NULL,
	Password	VARCHAR(64)	NULL,
	Type		NUMBER(4)	NOT NULL
)
/

ALTER TABLE reporter_names
 ADD PRIMARY KEY (
	Name
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_GROUPS table is used to hold the user group details
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Create table to store Groups for Netcool Groups
DROP TABLE reporter_groups CASCADE CONSTRAINTS;

CREATE TABLE reporter_groups (
	Name		VARCHAR2(64) 	NOT NULL,
	OwnerGID	NUMBER(16)	NOT NULL
)
/

ALTER TABLE reporter_groups
 ADD PRIMARY KEY (
 	Name
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_MEMBERS table is used to hold the STATIC group members details
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-- Create table to store Groups for Netcool Members Lists
DROP TABLE reporter_members CASCADE CONSTRAINTS;

CREATE TABLE reporter_members (
	OwnerUID	NUMBER(16)	NOT NULL,
	OwnerGID	NUMBER(16)	NOT NULL,
	PRIMARY KEY(OwnerUID, OwnerGID)
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_CLASSES  is used to hold the STATIC group class details
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Create table to store Groups for Netcool Classes
DROP TABLE reporter_classes CASCADE CONSTRAINTS;

CREATE TABLE reporter_classes (
	Class	NUMBER(4)	NOT NULL,
	Name	VARCHAR2(64)	NOT NULL,
	Icon	VARCHAR2(255)	NULL,
	Menu	VARCHAR2(64)	NULL
)
/

ALTER TABLE reporter_classes
 ADD PRIMARY KEY (
 	Class
)
/


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REPORTER_CONVERSIONS  is used to hold the STATIC conversion records
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Create table to store Groups for Netcool Conversions
DROP TABLE reporter_conversions CASCADE CONSTRAINTS;

CREATE TABLE reporter_conversions (
	Conversion_Key	VARCHAR2(255)	NOT NULL,
	Column_Name	VARCHAR2(255)	NOT NULL,
	Value		NUMBER(4)	NOT NULL,
	Conversion	VARCHAR2(255)	NOT NULL
)
/

ALTER TABLE reporter_conversions
 ADD PRIMARY KEY (
 	Conversion_Key
)
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_SEVERITY_TYPES is used to hold the STATIC severity types data
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Create table to store Groups for Netcool Severity Text Values
DROP TABLE rep_severity_types;

CREATE TABLE rep_severity_types (
	Severity	NUMBER(4)	NOT NULL,
	Name		VARCHAR2(64)	NOT NULL
)
/

ALTER TABLE rep_severity_types
 ADD PRIMARY KEY (
 	Severity
)
/

INSERT INTO rep_severity_types VALUES ( 0, 'Clear' );
INSERT INTO rep_severity_types VALUES ( 1, 'Indeterminate' );
INSERT INTO rep_severity_types VALUES ( 2, 'Warning' );
INSERT INTO rep_severity_types VALUES ( 3, 'Minor' );
INSERT INTO rep_severity_types VALUES ( 4, 'Major' );
INSERT INTO rep_severity_types VALUES ( 5, 'Critical' );

commit;

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- The following table is spacific to reporter and is 
-- referenced in the canned reports.
--
--//////////////////////////////////////////////////////////////////
DROP TABLE rep_time_periods;
			
CREATE TABLE rep_time_periods (
	ELAPSED_PERIOD	NUMBER(4)	NOT NULL, 
	PERIOD_NAME	VARCHAR2(64)	NOT NULL
)
/

INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(1,'1 Day');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(2,'2 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(3,'3 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(4,'4 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(5,'5 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(6,'6 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(7,'7 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(14,'14 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(21,'21 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(28,'28 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(30,'30 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(60,'60 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(90,'90 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(120,'120 Days');
INSERT INTO rep_time_periods(ELAPSED_PERIOD, PERIOD_NAME) VALUES(365,'365 Days');

commit;

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- This section lists the triggers and stored procedures that are the 
-- back-bone the gateway audit

-- there is only two  triggers acting on the reporter_status table.
-- Thay are called REP_AUDIT,
--		   REP_AUDIT_ACKNOWLEDGE.

-- there are five store procedure that gets activated from the single 
-- trigger. The stored procedures are:   
--
--			acknowledged,
--			deletedat,
--			ownergid,
--			owneruid,
--			severity
-- 
--///////////////////////////////////////////////////////////////////

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The acknowledged procedure is used to record each acknowledgement
-- made to a record in the reporter_status table.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE PROCEDURE acknowledged(
	newserial	reporter_status.Serial%TYPE,
	newuserid	reporter_status.OwnerUID%TYPE,
	newlastmodified	reporter_status.LastModified%TYPE,
	newseverity	reporter_status.Severity%TYPE , 
	newacknowledged	reporter_status.Acknowledged%TYPE,
	newservername	reporter_status.ServerName%TYPE,
	newserverserial	reporter_status.ServerSerial%TYPE
) IS
BEGIN
	IF (newlastmodified IS NOT NULL ) THEN
		UPDATE rep_audit_ack SET 
			rep_audit_ack.EndDate = newlastmodified,
			rep_audit_ack.State = 1
		WHERE
                	rep_audit_ack.ServerSerial = newserverserial AND
			rep_audit_ack.ServerName = newservername AND
			rep_audit_ack.State = 0;
    	
        	INSERT INTO rep_audit_ack VALUES (
			ack_seq.nextval,
			newserial, 
			newlastmodified, 
			NULL, 
			newuserid, 
			0, 
			newservername, 
			newserverserial );
	END IF;
END acknowledged;
/

show errors;




--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The severity procedure table is used to record the changes in severity
-- of a record in the Reporter_status table.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


CREATE OR REPLACE PROCEDURE severity (
	newserial	reporter_status.Serial%TYPE,
	newlastmodified	reporter_status.LastModified%TYPE,
	newseverity	reporter_status.Severity%TYPE , 
	newservername	reporter_status.ServerName%TYPE,
	newserverserial	reporter_status.ServerSerial%TYPE
) IS
BEGIN
	IF ( newlastmodified IS NOT NULL ) THEN
		UPDATE rep_audit_severity SET
			rep_audit_severity.EndDate = newlastmodified,
			rep_audit_severity.State = 1
		WHERE
			rep_audit_severity.ServerSerial = newserverserial AND
			rep_audit_severity.Servername = newservername AND
			rep_audit_severity.State = 0;
                
		INSERT INTO rep_audit_severity VALUES (
			severity_seq.nextval,
			newserial, 
			newlastmodified, 
			NULL, 
			newseverity,
			0,
			newservername,
			newserverserial );
	END IF;
END  severity;
/

show errors;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The deletedat procedure is used to record the last status (after a delete)
-- of a record in the Reporter_status table.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--
-- The where clause was changed by Roland to be servername and serverserial 
-- instead of just serial.
--
CREATE OR REPLACE PROCEDURE deletedat (
	newserial	reporter_status.Serial%TYPE,
	newlastmodified	reporter_status.LastModified%TYPE,
	newOwnerUID	reporter_status.OwnerUID%TYPE ,
	newservername	reporter_status.ServerName%TYPE,
	newserverserial	reporter_status.ServerSerial%TYPE
) IS
BEGIN
	If ( newlastmodified IS NOT NULL ) THEN
		UPDATE rep_audit_severitY SET  
			rep_audit_severitY.EndDate = newlastmodified,
			rep_audit_severitY.State = 1
		WHERE
                  	rep_audit_severitY.ServerSerial = newserverserial AND
			rep_audit_severitY.ServerName = newservername AND
			rep_audit_severitY.State = 0;
                 
		UPDATE rep_audit_ack SET
			rep_audit_ack.EndDate = newlastmodified
		WHERE
			rep_audit_ack.ServerName = newservername  AND
			rep_audit_ack.ServerSerial = newServerSerial  AND
			rep_audit_ack.State = 0;
	END IF;
END  deletedat;
/

show errors;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The OWNERUID procedure is used to record the User id details
-- if the User id of a record is changed.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE PROCEDURE owneruid (
	newserial	reporter_status.Serial%TYPE,
	oldowneruid	reporter_status.OwnerUID%TYPE,
	newowneruid	reporter_status.OwnerUID%TYPE,
	newlastmodified	reporter_status.LastModified%TYPE,
	newservername	reporter_status.ServerName%TYPE,
	newserverserial	reporter_status.ServerSerial%TYPE
) IS
BEGIN
	IF ( newlastmodified IS NOT NULL ) THEN
		INSERT INTO rep_audit_owneruid VALUES (
			owneruid_seq.nextval,
			newserial,
			newlastmodified,
			oldowneruid,
			newowneruid,
			newservername,
			newserverserial );
	END IF;
END owneruid;
/

show errors;


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The OWNERGID procedure is used to record the User Group id details
-- if the group id of a record is changed.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE PROCEDURE ownergid (
	newserial	reporter_status.Serial%TYPE,
	oldownergid	reporter_status.OwnerGID%TYPE,
	newownergid	reporter_status.OwnerGID%TYPE,
	newlastmodified	reporter_status.LastModified%TYPE,
	newservername	reporter_status.ServerName%TYPE,
	newserverserial	reporter_status.ServerSerial%TYPE
) IS
BEGIN
	IF ( newlastmodified IS NOT NULL ) THEN
		INSERT INTO REP_AUDIT_OWNERGID VALUES (
			ownergid_seq.nextval,
			newserial,
			newlastmodified,
			oldownergid,
			newownergid,
			newservername,
			newserverserial );
	END IF;
END ownergid;
/

show errors;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE TRIGGER REP_AUDIT_ACKNOWLEDGE
AFTER INSERT ON reporter_journal
FOR EACH ROW
BEGIN
	IF ( :NEW.Text1 LIKE 'Alert acknowledged%' ) THEN
		UPDATE rep_audit_ack
		SET
			rep_audit_ack.EndDate = :NEW.Chrono,
			rep_audit_ack.State = 1,
			rep_audit_ack.OwnerUID = :NEW.UserID
		WHERE
			rep_audit_ack.ServerSerial = :NEW.ServerSerial AND
			rep_audit_ack.ServerName = :NEW.ServerName AND
			rep_audit_ack.State = 0;
        END IF;
END;
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_JOURNAL_KEY trigger is designed to automatically populate the 
-- JournalKey field in journal table records with an incremented value to
-- avoid unique constraint violations from journal entries that get
-- inserted.
-- To do this, it uses the sequence variable 'journal_seq'.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE TRIGGER rep_journal_key 
BEFORE INSERT ON reporter_journal
FOR EACH ROW
BEGIN
  SELECT journal_seq.NEXTVAL
  INTO :new.JournalKey
  FROM dual;
END;
/

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- The REP_AUDIT trigger is the only one that fires off the REPORTER_STATUS 
-- table.  It is used to record all types of changes a record may undergo
-- whether manually performed or carried out by automation in the Object Server.
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CREATE OR REPLACE TRIGGER rep_audit
AFTER INSERT OR UPDATE
  OF Acknowledged,
	DeletedAt,
	OwnerGID,
	OwnerUID,
	Severity
ON reporter_status
FOR EACH ROW
BEGIN
   	IF ( INSERTING ) THEN
		acknowledged( 
			:NEW.Serial,
			:NEW.OwnerUID,
			:NEW.LastModified, 
			:NEW.Severity, 
			:NEW.Acknowledged, 
			:NEW.ServerName,
			:NEW.ServerSerial );
  
		severity(
			:NEW.Serial,
			:NEW.LastModified,
			:NEW.Severity,
			:NEW.ServerName,
			:NEW.ServerSerial );
	ELSIF ( UPDATING ) THEN
		IF ( :OLD.Severity <> :NEW.Severity ) THEN
			severity(
				:NEW.Serial,
				:NEW.LastModified,
				:NEW.Severity,
				:NEW.ServerName,
				:NEW.ServerSerial );
		END IF;
        
		IF ( :OLD.DeletedAt IS NULL AND :NEW.DeletedAt IS NOT NULL ) THEN
			deletedat(
				:NEW.Serial,
				:NEW.DeletedAt,
				:NEW.OwnerUID,
				:NEW.ServerName,
				:NEW.ServerSerial );
		END IF;

		IF ( :OLD.OwnerUID <> :NEW.OwnerUID ) THEN
			owneruid( 
				:NEW.Serial,
				:OLD.OwnerUID,
				:NEW.OwnerUID,
				:NEW.LastModified,
				:NEW.ServerName,
				:NEW.ServerSerial );
		END IF;

		IF ( :OLD.OwnerGID <> :NEW.OwnerGID ) THEN
			ownergid(
				:NEW.Serial,
				:OLD.OwnerGID,
				:NEW.OwnerGID,
				:NEW.LastModified,
				:NEW.ServerName,
				:NEW.ServerSerial );
		END IF;
  
		IF ( :OLD.Acknowledged <> :NEW.Acknowledged ) THEN
			acknowledged(
				:NEW.Serial,
				:NEW.OwnerUID,
				:NEW.LastModified, 
				:NEW.Severity, 
				:NEW.Acknowledged, 
				:NEW.ServerName,
				:NEW.ServerSerial );
		END IF;
	END IF;
END;
/
show errors;

-- ////////////////////////////////////////////////////////////////////
-- The final three views are spicific to reporter and are referenced
-- by the canned reports.
--
-- \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
CREATE OR REPLACE VIEW REP_REFERENCE_DATE AS 
SELECT sysdate Ref_Date FROM dual; 

CREATE OR REPLACE VIEW status_vw (
	Identifier,
	ServerSerial,
	ServerName,
	Node,
	NodeAlias,
	Manager,
	Agent,
	AlertGroup,
	AlertKey,
	Summary,
	Location,
	Class,
	Poll,
	Type,
	Tally,
	Severity,
	Severity_Names,
	OwnerUID,
	OwnerGID,
	Acknowledged,
	LastModified,
	LastModified_DT,
	FirstOccurrence,
	FirstOccurrence_DT,
	LastOccurrence,
	LastOccurrence_DT,
	LastOccurrence_YR,
	LastOccurrence_MT,
	LastOccurrence_DY,
	DeletedAt,
	Serial,
	OriginalSeverity
) AS SELECT 
	Identifier,
	ServerSerial,
 	ServerName,
 	Node,
 	NodeAlias,
 	Manager,
 	Agent,
 	AlertGroup,
 	AlertKey,
 	Summary,
 	Location,
 	Class,
 	Poll,
 	Type,
 	Tally,
 	reporter_status.Severity AS Severity,
 	CONCAT( CONCAT( TO_CHAR(reporter_status.Severity), ' ' ), rep_severity_types.Name ) AS Severity_Names,
 	OwnerUID,
 	OwnerGID,
 	Acknowledged,
 	LastModified,
 	TO_CHAR( LastModified, 'HH24:MI:SS DD/MM/YYYY' ) AS LastModified_DT,
 	FirstOccurrence,
 	TO_CHAR( FirstOccurrence, 'HH24:MI:SS DD/MM/YYYY' ) AS FirstOccurrence_DT,
 	Lastoccurrence,
 	TO_CHAR( LastOccurrence, 'HH24:MI:SS DD/MM/YYYY' ) AS LastOccurrence_DT,
 	TO_CHAR( LastOccurrence, 'YYYY' ) AS LastOccurrence_YR,
 	SUBSTR( LastOccurrence, 4,3 ) AS LastOccurrence_MT,
 	TO_CHAR( LastOccurrence, 'DD' ) AS LastOccurrence_DY,
 	DeletedAt,
 	Serial,
 	OriginalSeverity
FROM 
	reporter_status, rep_severity_types
WHERE
	reporter_status.Severity = rep_severity_types.Severity;


CREATE OR REPLACE VIEW rep_audit (
	ServerSerial, 
	ServerName, 
	StartDate, 
	Value_Ack, 
	Value_Severity, 
	Value_Owner, 
	Value_Group) 
AS SELECT
	rep_audit_ack.ServerSerial,
	rep_audit_ack.ServerName,
	rep_audit_ack.StartDate,
	rep_audit_ack.state AS Value_Ack,
	TO_NUMBER(NULL) AS Value_Severity,
	TO_NUMBER(NULL) AS Value_Owner,
	TO_NUMBER(NULL) AS Value_Group
FROM rep_audit_ack 
UNION SELECT
	rep_audit_severity.ServerSerial,
	rep_audit_severity.ServerName,
	rep_audit_severity.StartDate,
	TO_NUMBER(NULL) AS Value_Ack,
	rep_audit_severity.severity AS Value_Severity,
	TO_NUMBER(NULL) AS Value_Owner,
	TO_NUMBER(NULL) AS Value_Group
FROM rep_audit_severity 
UNION SELECT
	rep_audit_owneruid.ServerSerial,
	rep_audit_owneruid.ServerName,
	rep_audit_owneruid.StateChange AS StartDate,
	TO_NUMBER(NULL) AS Value_Ack,
	TO_NUMBER(NULL) AS Value_Severity,
	rep_audit_owneruid.owneruid AS Value_Owner,
	TO_NUMBER(NULL) AS Value_Group
FROM rep_audit_owneruid 
UNION SELECT 
	rep_audit_ownergid.ServerSerial,
	rep_audit_ownergid.ServerName,
	rep_audit_ownergid.StateChange AS StartDate,
	TO_NUMBER(NULL) AS Value_Ack,
	TO_NUMBER(NULL) AS Value_Severity,
	TO_NUMBER(NULL) AS Value_Owner,
	rep_audit_ownergid.ownergid AS Value_Group
FROM rep_audit_ownergid;

show errors;
