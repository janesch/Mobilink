#!/usr/bin/perl -w

my $debug = 1;

my $dir = $ARGV[0];
unless ($dir) { print "Directory argument required\n"; exit 1; }

print "Running against $dir\n";

my @dirlist = dir_scan($dir);
my @list;
foreach (@dirlist) {
	$totest = $dir . "/" . $_;
	if ($totest =~ /\.rules/) { 
		push(@list, $totest);
	}
}

foreach (@list) {
	print "Editing $_\n";
	edit_rules($_);
}

sub dir_scan {

my $file = shift;

opendir (DIR, "$file");
my @content = map "$_",
	sort grep !/^\.\.?$/,
	readdir DIR;
closedir DIR;
return (@content);

}

sub edit_rules {

my $file = shift;
open (FILE, "<$file");
my @content = <FILE>;
close FILE;

unlink $file;

open (NEWFILE, ">$file");
foreach (@content) {
	my $newline = $_;
	if ($newline =~ m/details/) {
		$newline = "#" . $newline;
	}
	print NEWFILE $newline;
}
close NEWFILE;

}

exit 0;
