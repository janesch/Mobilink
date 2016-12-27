#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

MANAGER='Synthetic'
NODE='GJR8820'
NODEALIAS=$NODE
EVENTTYPE='QualityOfService Alarm'
SEVERITY=3
TYPE=1
CLASS=999999
SUMMARY='CellGPRS Synthetic Test Event'
ADDTEXT='Synthetic Text Event '+$SUMMARY
EVENTID='CellGPRS_001'
ALERTKEY="Cell_002"
#EVENTID=''
ALERTGROUP='CellGPRS'


IDENTIFIER=$NODE+$TYPE+'CellGPRS'+$ALERTGROUP+$ALERTKEY

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, EventId, AlertGroup ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$EVENTID', '$ALERTGROUP');

go

quit

EOF
