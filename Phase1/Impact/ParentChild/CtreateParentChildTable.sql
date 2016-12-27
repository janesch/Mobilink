CREATE TABLE custom.ParentChild PERSISTENT 
(
	Source_Event_ID		varchar(256) PRIMARY KEY,
	Parent_Event_IDs	varchar(256),
	Child_Event_IDs		varchar(256),
	AlarmClass		varchar(128),
	Manager			varchar(64),
	Parent_Filters		varchar(512),
	Child_Filters		varchar(512),
	Enrichment_Source	varchar(64)
)