#!/usr/bin/perl
#
###################################################################################
#
# SC11B_OVE_U_2.cgi
# 
#
# Script that takes AlarmNumber from SC11B_KEN_U_1, processes it through SC11B_KEN_S.sh
#	and then allow the user to mofify all but the key field before passing it to 
#	SC11B_KEN_U_3.cgi which writes the data to  the OS table
#
#	V 0.0	20100215	Chris Janes 	Original Development
#	V 0.1	20100217	Chris Jannes	IncludeAddInfo field added
#
###################################################################################



###################################################################################
#
#	This is where the Functions Go
#
###################################################################################

sub GetFieldData
{
    my $FieldName = $_[0];
    my $AlarmNo = $_[1];
	$sysError = system "/opt/netcool/webtop/config/cgi-bin/SC11B_KEN_S.sh $FieldName $AlarmNo > /opt/netcool/omnibus/log/SC11B_KEN_S.tmp";
	open(SELECT,"/opt/netcool/omnibus/log/SC11B_KEN_S.tmp");
	@Select = <SELECT>;
	close(SELECT);
	return $Select[2];
}




###################################################################################
#
#	Here we set up our variables
#
###################################################################################

$Debug = 0;



$buffer = $ENV{'QUERY_STRING'};

@pairs = split(/&/, $buffer);

foreach $pair (@pairs)
{
    ($name, $value) = split(/=/, $pair);
    # Un-Webify plus signs and %-encoding
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $name =~ tr/+/ /;
    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg; 
    $FORM{$name} = $value;
    
}


# get the variables that arrived from the previous page and put into local variables
$KentoKey = $FORM{"KentoKey"};

$Title = 'Update record into Kenton EnrichmentTable';



# Call the script that sends the sql to the objectserver
$sysError = system " rm -f /opt/netcool/omnibus/log/SC11B_KEN_S.tmp";

$ACTIONREQUIRED = GetFieldData("ActionRequired", $KentoKey);
$ALARMCLASS = GetFieldData("AlarmClass", $KentoKey);
$ALARM_CLASS =~ s/\s+$//;
$ALARM_CLASS =~ s/^\s+//;
$ALERTGROUP = GetFieldData("AlertGroup", $KentoKey);
#$ALERTGROUP =~ s/\s+$//;
#$ALERTGROUP =~ s/^\s+//;
$RESILIENCEAFFECTING = GetFieldData("ResilienceAffecting", $KentoKey);
$SERVICEAFFECTING = GetFieldData("ServiceAffecting", $KentoKey);
$SEVERITY = GetFieldData("Severity", $KentoKey);
$TYPE = GetFieldData("Type", $KentoKey);



#############################################################################################
# Pass back confirmation page back to user
#############################################################################################
print "Content-type: text/html\n\n";
print <<__HTML__;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<TITLE> Update a row in custom.Kenton_lookup</TITLE>
<LINK REL="stylesheet" type="text/css" href="/Innovise.css">

</HEAD>
<BODY>
<img src="/images/InnoviseESM.jpg">
<HR>
<div align=center>
<br>
<STRONG>Update Kenton table</STRONG>

__HTML__


print "<centre><br><br><br>";
print "<table border=\"0\" width=\"500\" align=\"center\">";

if ($Debug)
{
	print "<tr><td>SEVERITY = $SEVERITY</td></tr>";
	print "<tr><td>TYPE = $TYPE</td></tr>";
	print "<tr><td>ACTIONREQUIRED = $ACTIONREQUIRED</td></tr>";
	print "<tr><td>ALARMCLASS = $ALARMCLASS</td></tr>";
	print "<tr><td>ALERTGROUP = $ALERTGROUP</td></tr>";
	print "<tr><td>RESILIENCEAFFECTING = $RESILIENCEAFFECTING</td></tr>";
	print "<tr><td>SERVICEAFFECTING = $SERVICEAFFECTING</td></tr>";
}

print "<table border=\"0\" width=\"600\" align=\"center\">";
print " <FORM action=\"/cgi-bin/SC11B_KEN_U_3.cgi\" method=\"get\">";
print " <INPUT type=hidden name=KentoKey value=$KentoKey>";
 	print "<tr>";
		print "<td align=left width=200 <STRONG> Alarm Number</STRONG></td>";
		print "<td align=left>$KentoKey</td>";
	print "</tr>";
	print "<tr>";
	   if($ACTIONREQUIRED =~ /1/)
	   {
		print "<td align=left width=200 <STRONG> Action Required </STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"AR\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"AR\" value=\"0\" </td>No";
	   }
	   else
	   {
		print "<td align=left width=200 <STRONG> Action Required </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"AR\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio checked name=\"AR\" value=\"0\" </td>No";
	   }
	print "</tr>";
 	print "<tr>";
		print "<td align=left width=200 <STRONG> Alarm Class</STRONG></td>";
		print "<td align=left><INPUT type=\"text\" name = \"ALARM_CLASS\" size=15 value = \"$ALARMCLASS\"></td>";
	print "</tr>";
 	print "<tr>";
		print "<td align=left width=200 <STRONG> Alert Group</STRONG></td>";
		print "<td align=left><INPUT type=\"text\" name = \"ALERTGROUP\" size=15 value = \"$ALERTGROUP\"</td>";
	print "</tr>";
	print "<tr>";
	   if($RESILIENCEAFFECTING =~ /1/)
	   {
		print "<td align=left width=200 <STRONG> Resilience Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"RA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	   elsif($RESILIENCEAFFECTING =~ /2/)
	   {
		print "<td align=left width=200 <STRONG> Resilience Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio checked name=\"RA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	   elsif($RESILIENCEAFFECTING =~ /3/)
	   {
		print "<td align=left width=200 <STRONG> Resilience Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio checked name=\"RA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	   else
	   {
		print "<td align=left width=200 <STRONG> Resilience Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"RA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"RA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	print "</tr>";
	print "<tr>";
	   if($SERVICEAFFECTING =~ /1/)
	   {
		print "<td align=left width=200 <STRONG> Service Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"SA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";

	   }
	   elsif($SERVICEAFFECTING =~ /2/)
	   {
		print "<td align=left width=200 <STRONG> Service Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio checked name=\"SA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	   elsif($SERVICEAFFECTING =~ /3/)
	   {
		print "<td align=left width=200 <STRONG> Service Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio checked name=\"SA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	   else
	   {
		print "<td align=left width=200 <STRONG> Service Affecting </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"1\" </td>Yes";
		print "<td align=left><INPUT type=radio  name=\"SA\" value=\"2\" </td>No";
		print "<td align=left><INPUT type=radio name=\"SA\" value=\"3\" </td>Possible";
		print "</tr><tr>";
		print "<td align=left width=200 <STRONG></STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"SA\" value=\"0\" </td>Not Set";
		print "<td></td><td></td>";
	   }
	print "</tr>";
	print "<tr>";
	   if($SEVERITY =~ /0/)
	   {
		print "<td align=left width=200 <STRONG> Severity </STRONG></td>";
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"0\" </td>Clear";
	   }
	   else
	   {
		print "<td align=left width=200 <STRONG> Severity </STRONG></td>";
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"1\" </td>Clear";
	   }
	   if($SEVERITY =~ /1/)
	   {
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"1\" </td>Indeterminate";
	   }
	   else
	   {
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"1\" </td>Indeterminate";
	   }
	   if($SEVERITY =~ /2/)
	   {
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"2\" </td>Warning";
	   }
	   else
	   {
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"2\" </td>Warning";
	   }
	print "</tr>";
	print "<tr>";
	   if($SEVERITY =~ /3/)
	   {
		print "<td align=left width=200 <STRONG>  </STRONG></td>";
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"3\" </td>Minor";
	   }
	   else
	   {
		print "<td align=left width=200 <STRONG>  </STRONG></td>";
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"3\" </td>Minor";
	   }
	   if($SEVERITY =~ /4/)
	   {
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"4\" </td>Major";
	   }
	   else
	   {
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"4\" </td>Major";
	   }
	   if($SEVERITY =~ /5/)
	   {
		print "<td align=left><INPUT type=radio  checked name=\"SEVERITY\" value=\"5\" </td>Critical";
	   }
	   else
	   {
		print "<td align=left><INPUT type=radio  name=\"SEVERITY\" value=\"5\" </td>Critical";
	   }
	print "</tr>";
	print "<tr>";
	   if($TYPE =~ /13/)
	   {
	   	print "<td align=left width=200 <STRONG> Type </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"1\" </td>Problem";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"2\" </td>Resolution";
		print "<td align=left><INPUT type=radio checked name=\"TYPE\" value=\"13\" </td>Information";
	   }
	   elsif($TYPE =~ /1/)
	   {
	   	print "<td align=left width=200 <STRONG> Type </STRONG></td>";
		print "<td align=left><INPUT type=radio checked name=\"TYPE\" value=\"1\" </td>Problem";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"2\" </td>Resolution";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"13\" </td>Information";
	   }
	   elsif($TYPE =~ /2/)
	   {
	   	print "<td align=left width=200 <STRONG> Type </STRONG></td>";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"1\" </td>Problem";
		print "<td align=left><INPUT type=radio checked name=\"TYPE\" value=\"2\" </td>Resolution";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"13\" </td>Information";
	   }
	   else
	   {
	   	print "<td align=left width=300 <STRONG> Type </STRONG></td>";
		print "<td align=left><INPUT type=radio  name=\"TYPE\" value=\"1\" </td>Problem";
		print "<td align=left><INPUT type=radio  name=\"TYPE\" value=\"2\" </td>Resolution";
		print "<td align=left><INPUT type=radio name=\"TYPE\" value=\"13\" </td>Information";
	   }
	   
	   
	print "</tr>";
	print "<tr>";
		print "<td align=center width=200 ><button type=\"submit\" style=\"border-style:ridge;color:#08938A;background-color:#EEEEEE\" name=\"Update\" title=\"Update\">Update</button></td>";
	print "</tr>";
		
		
  print "</FORM>";
 print "</table>";

print "</body></html>";
