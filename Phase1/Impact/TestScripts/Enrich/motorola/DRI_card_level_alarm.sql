#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF


insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'sunfire4','XXXSubNetwork=sunfire4,ManagedElement=BssFunction_23,BssFunction=23,BtsSiteMgr=15,vsMotBSS_DRIGroup.rdnInstance=2,vsMotBSS_DRI.rdnInstance=0 9549 Equipment Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX$$', 5, 'motorola-Test','Motorola event test 1','23:15:DRIGroup:2',0);

go
quit
EOF
