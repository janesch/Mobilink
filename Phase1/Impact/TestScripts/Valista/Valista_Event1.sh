#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

MANAGER='Synthetic'
NODE='GJR9852'
NODEALIAS=$NODE
EVENTTYPE='QualityOfService Alarm'
SEVERITY=3
TYPE=1
CLASS=40425
SUMMARY='PayWorkerProc_260:There is a great portion ( > 100 per mill) of failed transactions.'
ADDTEXT='Synthetic Text Event '+$SUMMARY
#EVENTID='Valista_001'
EVENTID=''

IDENTIFIER=$NODE+$TYPE+'Valista'+$ADDTEXT

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
