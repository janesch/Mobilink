#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

NODE='HYD410A__SiteArea_2'
NODEALIAS=$NODE
EVENTTYPE='Environmetal Alarm'
SEVERITY=1
TYPE=2
CLASS=999999
ADDTEXT='BTS-EXTERNAL [9]External Temperature [89]'
SUMMARY='Synthetic Text Event '+$ADDTEXT


IDENTIFIER=$NODE+$TTPE+'BSS_ENV'+$ADDTEXT

#if [ $# -lt 1 ]; then
#
#        echo "Usage: insert_alarm_node_only.sh <Node> "
#        exit
#fi
#NODE=$1 ; shift
#/opt/netcool/omnibus/bin/nco_sql -server WATEENP -user root<<EOF
/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT');

go

quit

EOF