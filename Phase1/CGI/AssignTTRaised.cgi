
#!/usr/bin/perl -w
#

$buffer = $ENV{'QUERY_STRING'};
@pairs = split('&', $buffer);

foreach $pair (@pairs)
{
    ($name, $value) = split('=', $pair);
    # Un-Webify plus signs and %-encoding
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $name =~ tr/+/ /;
    $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    $FORM{$name} = $value;
}


$ttnumber = $FORM{'TTNUMBER'};

$serverserial = $FORM{'SERVERSERIAL'};

$Title = 'Ticket Number Stored for Event';

#@cmd = ("/opt/netcool/scripts/AssignTT.sh", $serverserial, $ttnumber);
#system(@cmd);
#print "<p class=\"systemMsg\">Server Serial ".$serverserial." TicketNumber ".$ttnumber."</p>\n";

############################################################################
# We want to send an HTML (web) page back to the operator
############################################################################
print "Content-type: text/html\n\n";
print <<__HTML__;
<html>
<head>
<link rel=stylesheet TYPE="text/css"
                           href="/file.css" title="Default">

</head>
<title>Ticket Number Stored for Event</title>

<body class="base">
<TABLE width=100%>
  <TR>
    <TD class="tableheading" align=center>
    <B><I>
       <FONT FACE="arial" Color="blue">$Title
       </FONT>
    </I></B>
    </TD>
  </TR>
</TABLE>

<P><FONT FACE="ARIAL" color="white"><I>
<table border="0" width="500" align="center">
        <tr>
            <td valign="top" width="100" nowrap><em>Ticket Number:</em></td>
            <td><p align="left" ><B>$ttnumber</B></p></td>
        </tr>
</table>
<br>
<br>
<table border="0" width="500" align="center">
        <tr>
                <FORM method="post">
                <input type="button" value="Close" onclick="window.close()" align="center">
                </FORM>
        </tr>
</body></html>
__HTML__
########################################################
