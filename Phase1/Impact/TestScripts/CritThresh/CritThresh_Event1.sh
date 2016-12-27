#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

MANAGER='Synthetic'
NODE='GJR9852'
NODEALIAS=$NODE
EVENTTYPE='Communication Alarm'
SEVERITY=3
TYPE=1
CLASS=8891
SUMMARY='Critical Threshold Test Event'
ADDTEXT='Synthetic Text Event '+$SUMMARY
EVENTID='CritThres_001'
ALERTGROUP='CritThresh'
ALERTKEY=""



IDENTIFIER=$NODE+$TTPE+'CritThresh'+$ALERTGROUP+$ALERTKEY

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, EventId, Manager ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$EVENTID', '$MANAGER');

go

quit

EOF
