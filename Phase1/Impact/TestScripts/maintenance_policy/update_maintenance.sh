/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql -server AGG_P_1 -user root -password EBENAHAMBGFBGFFMCNFNFMGA<<EOF
update alerts.status set MaintEndTime = (getdate - 259200) where Identifier = 'Maintenance01';
go
EOF
