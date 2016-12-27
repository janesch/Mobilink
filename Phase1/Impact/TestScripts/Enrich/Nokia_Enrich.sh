#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

NODE='201712'
NODEALIAS=$NODE
EVENTTYPE='Environmental Alarm'
SEVERITY=4
TYPE=1
CLASS=600
SUMMARY='Test Event for Enrichment of Nokia Event'
ADDTEXT='Synthetic Text Event '


IDENTIFIER=$NODE+$TTPE+'BSS_ENV'+$SUMMARY

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
