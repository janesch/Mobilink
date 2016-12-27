/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password EBENAHAMBGFBGFFMCNFNFMGA<<EOF
insert into alerts.status (
Identifier, 
Node, 
EventType,
AlertGroup,
Summary,
Severity, 
Type) 
values(
'Maintenance01', 
'HYD498A__CtyzenPlz_2',
'BSSE_001',
'Power',
'Summary : BSC-EXTERNAL [50] Low Voltage [7]',
4, 
1);
go
EOF
