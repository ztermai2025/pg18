#!/usr/bin/perl
use strict;
use warnings;

if($#ARGV != 0) {
    print "Usage: svg2pdf.pl path\n";
    exit;
}

# if($#ARGV == 0) {
#     process_md($ARGV[0]);
#     exit;
# }

my $dir = $ARGV[0];
opendir DIR, $dir;
my @dir = readdir(DIR);
close DIR;

print "set PATH=C:\\Program Files\\Inkscape\\bin;%PATH%\n";
foreach(@dir){
    if(m/\.svg/) {
		my $pdf = $_;
		$pdf =~ s/svg/pdf/;
        print "inkscape -C --export-type=pdf --export-filename=$pdf  d:\\git\\pg18\\svg\\$_ \n";
    }
}
exit;
