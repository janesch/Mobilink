#!/usr/bin/perl
#
# AssignTT.cgi

print "Content-type: text/html\n\n";

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

############################################################################
# Parameters Saved from Highlighted for later use in the Tool
############################################################################

$serverserial = $FORM{"\$selected_rows.Serial"};


############################################################################
# Form for user input defined below
############################################################################

print <<__HTML__;
<html>
<head>

<link rel=stylesheet TYPE="text/css"
                           href="/file.css" title="Default">

</head>

<title>Assign TT number to an event</title>
<body class="base">
<TABLE width=100%>
  <TR>
    <TD class="tableheading" align=center>
    <B><I>
       <FONT FACE="arial" Color="blue">Assign a trouble ticket number to an event
       </FONT>
    </I></B>
    </TD>
</TR>

<TD align=center>
<FORM action=" https://10.231.105.13:16316/webtop/cgi-bin/AssignTTRaised.cgi" method="get">
<div align="center"><center>

<table border="0" width="500">
    <tr>
        <td>Ticket Number:</td>
        <td align="right"><input type="TEXT" name="TTNUMBER" size="100">
        </td>
    </tr>

</table>
</center></div>
__HTML__


print "\n";
print "<INPUT type=\"hidden\" name=\"SERVERSERIAL\" value=\"$serverserial\">";
print "\n";

print <<__HTML__;

<p align="center"><input type="submit" value="Assign Trouble Ticket Number"> <input type="reset" value="Reset"></p>

</FORM>
</FONT>
</BODY></HTML>
__HTML__
