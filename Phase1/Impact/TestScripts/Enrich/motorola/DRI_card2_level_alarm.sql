#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF


insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'sunfire4','SubNetwork=sunfire4,ManagedElement=BssFunction_19,BssFunction=19,BtsSiteMgr=11,vsMotBSS_DRIGroup.rdnInstance=2,vsMotBSS_DRI.rdnInstance=0 19507 Equipment Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1', 4, 'motorola_3gpp_omcr_gsr9 Probe@corba1','Motorola event test 1','19:11:DRIGroup:2',0);

go
quit
EOF
