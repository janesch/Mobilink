#!/bin/sh
 

SERVER='AGG_P_1'
USER='root'
PASSWORD='mobilink2010'

NODE='AAK6991'
NODEALIAS=$NODE
EVENTTYPE='Environmetal Alarm'
EVENTID='MSD999'
SEVERITY=4
TYPE=1
CLASS=999999
ADDTEXT='BTS-EXTERNAL [9]External Temperature [89]'
SUMMARY='Synthetic Text Event '+$ADDTEXT


IDENTIFIER=$NODE+$TTPE+'MSD'+$EVENTID


/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server $SERVER -user $USER -passwd $PASSWORD<<EOF

insert into alerts.status (Identifier, Severity, Summary, Node, NodeAlias, Class, EventType, Type, EventId ) values

('$IDENTIFIER', $SEVERITY, '$SUMMARY', '$NODE','$NODEALIAS', $CLASS, '$EVENTTYPE', $TYPE, '$EVENTID');

go

quit

EOF
