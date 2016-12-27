#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF



insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag) values (2057,1,'sunfire4','XXXSubNetwork=sunfire4,ManagedElement=BssFunction_36,BssFunction=36,BtsSiteMgr=0,vsMotBSS_SITE_MSI.rdnInstance=31,vsMotBSS_SITE_MMS.rdnInstance=0 17553 Communication Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX', 5, 'motorola-Test','Motorola event test 1','36:0:SITE:31',0);


go
quit
EOF
