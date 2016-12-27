#!/bin/sh

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password mobilink2010<<EOF



insert into alerts.status (Class,Type,OmcEms,Identifier, Severity,Manager, Summary,Node,ImpactFlag,NodeAlias) values (2057,1,'sunfire4','XXXSubNetwork=sunfire4,ManagedElement=vsMotRXCDR_89,vsMotRXCDR.rdnInstance=89,vsMotRXCDR_SITE.rdnInstance=0,vsMotRXCDR_SITE_MSI.rdnInstance=19,vsMotRXCDR_SITE_MMS.rdnInstance=0 20417 Communication Alarm 1 Motorola 3GPP OMCR GSR9  : alarm_r5 motorola_3gpp_omc', 5, 'motorola-Test','Motorola transcoder event test','::SITE:89',0,'vsMotRXCDR12345');


go
quit
EOF
