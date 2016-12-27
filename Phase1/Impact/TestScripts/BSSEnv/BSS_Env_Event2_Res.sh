#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

NODE='1:11:IAS:0'
OMCEMS='somcsys2'
CLASS=2057
#NODE='GJR8820'
#NODEALIAS=$NODE
EVENTTYPE='Environmental Alarm'
SEVERITY=1
TYPE=2
#CLASS=999999
SUMMARY='BTS-EXTERNAL [9]External Temperature [89]'
ADDTEXT='Synthetic Text Event '+$SUMMARY
ALERTGROUP='BSSEnv'
ALERTKEY=$SUMMARY


IDENTIFIER=$NODE+$TYPE+'BSS_ENV'+$ALERTGROUP+$ALERTKEY

/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, AddText, Manager, OmcEms, AlertGroup, AlertKey ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$ADDTEXT', '$MANAGER', '$OMCEMS', '$ALERTGROUP', '$ALERTKEY')


go

quit

EOF
