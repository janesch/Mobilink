#!/usr/bin/ksh
###################################################################################
#
# SC11B_OVE_I.sh
# 
#
# Script that takes Details from SC11B_OVE_I_3, passes it to the Objectserver
#	and tells the user the outcome
#
#	V 0.0	20100218	Chris Janes 	Original Development
#
###################################################################################


# Get the Hostname
HOST=`/usr/bin/hostname`

# Lookup SERVER, USERNAME, PASSWORD dependent on hostname
if [ "${HOST}" = "cole01ncs02" ] 
then
	SERVER="NCOMS_P"
	USERNAME="root"
	PASSWORD="highw4y"
elif [ "${HOST}" = "stqn01bcs01ne0" ] 
then
	SERVER="NCOMS_P"
	USERNAME="root"
	PASSWORD="ha"
elif [ "${HOST}" = "stqn01bcs01" ] 
then
	SERVER="NCOMS_B"
	USERNAME="root"
	PASSWORD="ha"
else
	echo "Unknown Host"
	exit
fi

# Run sql
/opt/netcool/omnibus/bin/nco_sql -server ${SERVER} -username ${USERNAME} -password ${PASSWORD}<< __END__
update custom.Kenton_lookup set ResilienceAffecting = $1, Type = $3, Severity = $4, ServiceAffecting = $5, ActionRequired = $6, AlarmClass = '$7', AlertGroup = '$8'  where KentoKey = '$2'
go
quit
__END__
