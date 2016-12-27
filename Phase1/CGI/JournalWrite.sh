#!/usr/bin/ksh
###################################################################################
#
# 	JournalEntry.sh
# 
#	this script inserts a journal entry into an ObjectServer
#	it requires the following parameters to be passed to it
#	PLEASE note that there is no error checking as it is assumed that
#	error checking will be done by the calling procedure
#
#	$1 = serial
#	$2 = Chrono
#	$3 = UID
#	$4 = Text1
#	KeyField is derived as Serial:UID:Chrono ($1:$3:$2)
#
# 
#
#	V 0.0	20100622	Chris Janes 	Original Development
#
###################################################################################

#	please set the following for the objectserver you are using
HOST="matuta"
SERVER="VMASTER"
USERNAME="netcool"
PASSWORD="netcool"


# Run sql
/opt/netcool/omnibus/bin/nco_sql -server ${SERVER} -username ${USERNAME} -password ${PASSWORD}<< __END__
insert into alerts.journal (Serial,KeyField,Chrono,UID,Text1) values ($1,'$1:$3:$2',$2,$3,'$4')
go
quit
__END__
