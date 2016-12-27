#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF

delete from status where Identifier like 'XXX' and Manager = 'Test';
go

insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0001-Testing', 4,8891,'MSDSITE_001', 'SPF subboard link failure','SPF subboard link failure','XX10001','LHR855H_Eden_1(BSC03)~ ~ LHR18271__T_JamilSons~ LHR8271__T_Jamil','LHR855H_Eden_1(BSC03)~ ~ LHR18271__T_JamilSons~ LHR8271__T_Jamil','Site No.=24,Cell Index.=45,Site Type=DBS3900 GSM,OutServiceCause=Other causes,Site Name=LHR8271__T_JamilSons,Cell Name=LHR18271__T_JamilSons,Cell CGI=410-01-165-18271, Alarm Attribute=Normal','Testing','Test',0,0);
insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0002-Testing', 4,8891,'MSDSITE_001', 'SPF subboard link failure','SPF subboard link failure','XX10002','LHR174H__MunnuChowk_U_4~ ~ ~ ','LHR174H__MunnuChowk_U_4~ ~ ~ ','Subrack No.=3, Slot No.=17, Port No.=0','Testing','Test',0,0);
insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0003-Testing', 4,4915,'MSDSITE_001', 'Qualify of Service Notification Alarm:','thresoldCrossed','XX10003','"FSD811E__ZiaTwn5 RUR4834__S_FSDSaduWalaMakoanaKWL"','"FSD811E__ZiaTwn5 RUR4834__S_FSDSaduWalaMakoanaKWL"','','Testing','Test',0,0);
insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0004-Testing', 4,4915,'MSDSITE_001', 'Qualify of Service Notification Alarm:','thresoldCrossed','XX10004','"FSD701E__ZiaTwn1 RUR3087__S_FSDGutwala RUR3087C__S_FSDGutwala"','"FSD701E__ZiaTwn1 RUR3087__S_FSDGutwala RUR3087C__S_FSDGutwala"','','Testing','Test',0,0);
insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0005-Testing', 4,2057,'MSDSITE_001', 'Communication Alarm','communicationAlarm','XX10005','ISB677M__BSC92_MSC5_SR_11:ISB677P__PCU_MSC5_SR_11:SITE_MSI=27:SITE_MMS=0','ISB677M__BSC92_MSC5_SR_11:ISB677P__PCU_MSC5_SR_11:SITE_MSI=27:SITE_MMS=0','','Testing','Test',0,0);
insert into alerts.status (Type,Identifier, Severity,Class, EventId,Summary, AlertGroup,AlertKey,Node,NodeAlias,AddText,Site,Manager,MaintFlag,ImpactFlag) values (1,'XXXXSITE0006-Testing', 4,2057,'MSDSITE_001', 'Communication Alarm','communicationAlarm','XX10006','RWP094M__BSC18_ChaklalaSch:RWP094P__PCU_ChaklalaScheme:SITE_MSI=29:SITE_MMS=0','RWP094M__BSC18_ChaklalaSch:RWP094P__PCU_ChaklalaScheme:SITE_MSI=29:SITE_MMS=0','','Testing','Test',0,0);


go
quit
EOF
