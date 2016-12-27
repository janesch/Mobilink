#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'
NODE='10:14:IAS:0'
CLASS=2057
OMCEMS='somcsys2'

MANAGER='Synthetic'
#NODE='GJR9852'
NODEALIAS=$NODE
EVENTTYPE='Communication Alarm'
SEVERITY=4
TYPE=1
#CLASS=8891
SUMMARY='Cell long time no access'
ADDTEXT='Synthetic Text Event '+$SUMMARY
#EVENTID='CellPer_001'
EVENTID=''
ALERTGROUP='CellPer'
ALERTKEY=""



IDENTIFIER=$NODE+$TTPE+'BSS_ENV'+$ALERTGROUP+$ALERTKEY

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, EventId, Manager, AlertGroup, OmcEms ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$EVENTID', '$MANAGER', '$ALERTGROUP', '$OMCEMS');

go

quit

EOF
