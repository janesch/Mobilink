#!/usr/bin/perl
#
###################################################################################
#
# MLGeneric.cgi - Runs an external Script
# 
#
# Script that gets AlarmNumber from User,  before it passes it to SC11B_KEN_D_2
#	
#
#	V 0.0	20100215	Chris Janes 	Original Development
#
###################################################################################

$PageTitle = " Test Page for doing stuff":
$RunScriptMessage = "Doing System Call ";

# Set the following Variables for use throughout the scripts
$OutFile = "/tmp/outfile";
$CmdString = "/opt/netcool/omnibus/utils/testScript.sh > " . $OutFile;
$JournalScript = "/opt/netcool/omnibus/utils/JournalWrite.sh ";

# Get the data being passed to script in the URL
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

####################################################################
# Parameters saved from highlighted event for later use in the tool
####################################################################


####################################################################
# Form used for user input defined below
#################################################################### 
# Write the begining of the HTML Page
print "Content-type: text/html\n\n";
print "<HTML>";
print "<HEAD>";
print "<TITLE>$PageTitle</TITLE>";

print "</HEAD>";
print "<BODY>";

print "$RunScriptMessage<br><br> ";
# Run the externalscript
$SysReturn = system $CmdString;

#	Collect togetehr the Journal information
$JournalText = "";
open(OUTFILE, $OutFile);
@Results = <OUTFILE>;
close(OUTFILE);
print "The following was returned<br><table> ";
foreach $Line (@Results)
{
	print "<tr><td></td><td>$Line </td></tr>";
	$JournalText = $JournalText . "\n" . $Line;
}
print"</table>";
$JournalChrono = time();
$JournalUID = 2;
$JournalSerial = $FORM{"Serial"};

#prepare the comand line to write a journal entry
$text = " $JournalScript $JournalSerial $JournalChrono $JournalUID '$JournalText' > /tmp/sh.out";
#Call the script that write the Journal Entry
$SysReturn = system  $text ;

print "<br><br>";

print "</BODY></HTML>";
