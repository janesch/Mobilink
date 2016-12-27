#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

NODE='10:14:IAS:0'
CLASS=2057
OMCEMS='somcsys2'
#NODE='GJR9852'
#NODE='BEL5901'
#NODEALIAS=$NODE
EVENTTYPE='Environmental Alarm'
SEVERITY=4
TYPE=1
#CLASS=999999
SUMMARY='BTS-EXTERNAL [50] Low Voltage [7]'
ADDTEXT='Synthetic Text Event '+$SUMMARY
ALERTGROUP='BSSEnv'
ALERTKEY=$SUMMARY


IDENTIFIER=$NODE+$TYPE+'BSS_ENV'+$ALERTGROUP+$ALERTKEY

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, Manager, OmcEms, AlertGroup, AlertKey ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$MANAGER', '$OMCEMS', '$ALERTGROUP', '$ALERTKEY')

go

quit

EOF
