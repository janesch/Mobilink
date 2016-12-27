#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

#SERVER='LASER_P'
#USER='scriptuser'
#PASSWORD='netcool'

CLASS=999999
MAINTFLAG=1
EVENTID='NET_IP_BLK_001'
NODE='TEST1'
SUMMARY='BFD Session Down ( bfdSessEntry.2104 )'
TYPE=1
SEVERITY=3
IMPACTFLAG=4



IDENTIFIER=$NODE+$TYPE+$EVENTID+$SUMMARY


/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Class,MaintFlag,EventId,Node,Identifier,Summary,Type,Severity,ImpactFlag) values

($CLASS, $MAINTFLAG, '$EVENTID', '$NODE','$IDENTIFIER', '$SUMMARY', $TYPE, $SEVERITY, $IMPACTFLAG);

go

quit

EOF

