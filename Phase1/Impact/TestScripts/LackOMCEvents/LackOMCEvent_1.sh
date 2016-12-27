#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

#NODE='GJR9852'
NODE='BEL5901'
NODEALIAS=$NODE
EVENTTYPE='QualityOfService Alarm'
SEVERITY=4
TYPE=1
CLASS=999999
SUMMARY='Synthetic Event for Lack of OMC'
OMCEMS='OMC'
ADDTEXT='Synthetic Text Event Lack of OMC Event Testing'+$SUMMARY
ALERTGROUP='BSSEnv'
ALERTKEY=$SUMMARY
MANAGER='Synthetic'
IDENTIFIER=$NODE+$TYPE+'LackOMC'+$ALERTGROUP+$ALERTKEY

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, Manager, OmcEms ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$MANAGER', '$OMCEMS');

go

quit

EOF
