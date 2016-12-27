#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF

delete from status where Manager = 'motorola-Test';
go


insert into alerts.status (Class,Type,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'SubNetwork=sunfire4,ManagedElement=BssFunction_47,BssFunction=47,BtsSiteMgr=24,GsmCell=2147483645 12910 Quality of Service Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX', 5, 'motorola-Test','Motorola event test 1','47:24::',0);
insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'sunfire4','SubNetwork=sunfire4,ManagedElement=BssFunction_23,BssFunction=23,BtsSiteMgr=15,vsMotBSS_DRIGroup.rdnInstance=2,vsMotBSS_DRI.rdnInstance=0 9549 Equipment Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX', 5, 'motorola-Test','Motorola event test 1','23:15:DRIGroup:2',0);
insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'sunfire4','SubNetwork=sunfire4,ManagedElement=BssFunction_36,BssFunction=36,BtsSiteMgr=0,vsMotBSS_SITE_MSI.rdnInstance=31,vsMotBSS_SITE_MMS.rdnInstance=0 17553 Communication Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX', 5, 'motorola-Test','Motorola event test 1','36:0:SITE:31',0);


go
quit
EOF
