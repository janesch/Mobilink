#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF


insert into alerts.status (Class,Type,Identifier, Severity,Manager, Summary,Node,ImpactFlag,OmcEms) values (2057,1,'XXXSubNetwork=sunfire4,ManagedElement=BssFunction_47,BssFunction=47,BtsSiteMgr=24,GsmCell=2147483645 12910 Quality of Service Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omcr_gsr9 Probe@corba1XX$$', 5, 'motorola-Test','Motorola event test 1','47:24::',0,'sunfire4');


go
quit
EOF
