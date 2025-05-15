#!/usr/bin/perl
use strict;
use warnings;
my $dir;
sub process_md
{
    my ($md_fn) = @_;
    my $tex_fn;
    my $line;
    my $half;
    my $mode;
    my $exercise;
    my $item;
    my $fistsection;
    my $svg_size;
    my $svg_fn;
    my $svg_caption;
    my $title;
    my $i;
    $tex_fn = $md_fn;
    $tex_fn =~ s/\.md/\.tex/;
	$md_fn = $dir . '/' . $md_fn;
    open(MDFILE, '<', $md_fn) or die "Could not open file '$md_fn' $!";
    open(TEXFILE, '>', $tex_fn) or die "Could not open file '$tex_fn' $!";
    $mode = 0;
    $item = 0;
    $fistsection = 0;
    $exercise = 0;
    while (<MDFILE>) {
        if(m/^%%/) { next; }
        if(0 == $mode ) {
            $line = $_;
            $line =~ s/^\s+//;
            $line =~ s/\s+$//;
            $line =~ s/_/\\_/g;
            $line =~ s/\$/\\\$/g;
            $line =~ s/\%/\\\%/g;
            $line =~ s/\&/\\\&/g;
            $line =~ s/\{/\\\{/g;
            $line =~ s/\}/\\\}/g;
            $line =~ s/\~/\\\~/g;

            while($line =~ m/LSN\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/LSN\\_([0-9a-z]+)/\\begin\{math\}\{LSN\}_\{$i\}\\end\{math\}/;
            }
            while($line =~ m/G\\_([0-9a-z])/) {
                $i = $1;
                $line =~ s/G\\_([0-9a-z])/\\begin\{math\}G_\{$i\}\\end\{math\}/
            }
            while($line =~ m/H\\_([0-9a-z])/) {
                $i = $1;
                $line =~ s/H\\_([0-9a-z])/\\begin\{math\}H_\{$i\}\\end\{math\}/
            }
            while($line =~ m/N\\_([0-9a-z])/) {
                $i = $1;
                $line =~ s/N\\_([0-9a-z])/\\begin\{math\}N_\{$i\}\\end\{math\}/
            }
            while($line =~ m/L\\_([0-9a-z])/) {
                $i = $1;
                $line =~ s/L\\_([0-9a-z])/\\begin\{math\}L_\{$i\}\\end\{math\}/
            }
            while($line =~ m/B\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/B\\_([0-9a-z]+)/\\begin\{math\}B_\{$i\}\\end\{math\}/
            }
            while($line =~ m/C\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/C\\_([0-9a-z]+)/\\begin\{math\}C_\{$i\}\\end\{math\}/
            }
            while($line =~ m/P\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/P\\_([0-9a-z]+)/\\begin\{math\}P_\{$i\}\\end\{math\}/
            }
            while($line =~ m/F\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/F\\_([0-9a-z]+)/\\begin\{math\}F_\{$i\}\\end\{math\}/
            }
            while($line =~ m/([0-9a-zA-Z]+)\^([0-9a-zA-Z]+)/) {
                $i = $1;
                $line =~ s/([0-9a-zA-Z]+)\^([0-9a-zA-Z]+)/\\begin\{math\}$i\^\{$2\}\\end\{math\}/
            }
            while($line =~ m/([0-9a-zA-Z]+)\^\(([0-9a-zA-Z]-[0-9])\)/) {
                $i = $1;
                $line =~ s/([0-9a-zA-Z]+)\^\(([0-9a-zA-Z]-[0-9])\)/\\begin\{math\}$i\^\{$2\}\\end\{math\}/
            }
            while($line =~ m/XID\\_([0-9a-z]+)/) {
                $i = $1;
                $line =~ s/XID\\_([0-9a-z]+)/\\begin\{math\}XID_\{$i\}\\end\{math\}/
            }
            
            if($line =~ m/^######/) {
                $exercise = 1;
                print TEXFILE "\n\\begin{problemset}\n";
            } elsif($line =~ m/^#####/) {
                $title = $'; $title =~ s/^\s+//; $title =~ s/\s+$//; $title =~ s/\^/\\\^/g;
                print TEXFILE "\n\\hfill\n";
                print TEXFILE "\n{\\bfseries $title}\n\n";                
            } elsif($line =~ m/^####/){
                $title = $'; $title =~ s/^\s+//; $title =~ s/\s+$//; $title =~ s/\^/\\\^/g;
                print TEXFILE "\n\n\\subsubsection{$title}\n\n";
            } elsif ($line =~ m/^###/) {
                $title = $'; $title =~ s/^\s+//; $title =~ s/\s+$//; $title =~ s/\^/\\\^/g;
                print TEXFILE "\n\\subsection{$title}\n\n";
            } elsif ($line =~ m/^##/) {
                $title = $'; $title =~ s/^\s+//; $title =~ s/\s+$//; $title =~ s/\^/\\\^/g;
                if(0 == $fistsection) { print TEXFILE "\n\\newpage\n"; }
                print TEXFILE "\n\\section{$title}\n\n";
            } elsif ($line =~ m/^#/) {
                $title = $'; $title =~ s/^\s+//; $title =~ s/\s+$//; $title =~ s/\^/\\\^/g;
                print TEXFILE "\\chapter{$title}\n\n";
                if(0 == $fistsection) {
                    $fistsection = 1;
                }
            } elsif ($line =~ m/\!\[\]\(([xd][0-9][0-9][0-9][0-9])\.svg\)/) {
                $svg_fn = $1;
                $svg_size = 8;
                $svg_caption = "XXXXX";
                if ($line =~ m/\<\!-- (\S+) (\d+)--\>/) { 
                    $svg_caption = $1; 
                    $svg_size = $2;
                    # print "Found -------$svg_size---------$svg_fn.svg ----- big pic!\n";
                }
                if ($line =~ m/\<\!-- (\S+) --\>/) { $svg_caption = $1;}
                print TEXFILE "\n\n\\begin{figure}[H]\n";
                print TEXFILE "\\centering\n";
                print TEXFILE "\\includegraphics[width=0.$svg_size\\textwidth]{$svg_fn.pdf}\n";
                print TEXFILE "\\caption{$svg_caption}\n";
                print TEXFILE "\\end{figure}\n\n";
            } elsif ($line =~ m/\`\`\`/) {
                # \begin{lstlisting}[numbers=left,firstnumber=0]
                $mode = 1;
                if ($line =~ m/\<\!--(\d+)--\>/) {
                    # print "Found - number $1\n";
                    print TEXFILE "\n\n\\begin{lstlisting}[numbers=left,firstnumber=$1]\n";
                } else {
                    print TEXFILE "\n\n\\begin{lstlisting}\n";
                }
            } else {
                if($line =~ m/^- (\S+)/) {
                    $line =~ s/^- //;
                    if(0 == $item) { 
                        if(0 == $exercise) { print TEXFILE "\n\\begin{itemize}\n"; }
                    }
                    $item = 1; 
                    print TEXFILE "  \\item $line\n"; 
                } else {
                    $line =~ s/\#/\\\#/g;
                    # \begin{math}2^{16}\end{math}
                    if ($line =~ m/([0-9a-zA-Z]+)\^([0-9a-zA-Z]+)/) {
                        print "FOUND: $1 - $2\n";
                        $half = $` . "\\begin{math}" . $1 . "\^{" . $2 . "}\\end{math}";
                        $line = $';
                        while($line =~ m/([0-9a-zA-Z]+)\^([0-9a-zA-Z]+)/) {
                            print "FOUND: $1 - $2\n";
                            $half = $half . $` . "\\begin{math}" . $1 . "\^{" . $2 . "}\\end{math}";
                            $line = $';
                        }
                        $line = $half . $line;
                    }
                    while ($line =~ m/--/) {
                        $line = $` . "-{}-" . $';
                        print "FOUND: --\n";
                    }
                    if(0 != $item) { 
                        if(0 == $exercise) { print TEXFILE "\\end{itemize}\n\n\n\\hfill\n\n";}
                        $item = 0;
                    }
                    if(0 != $exercise) { print TEXFILE "\\end{problemset}\n\n"; $exercise = 0;}
                    
                    print TEXFILE "$line\n";
                }
            }
        } else {
            if (m/\`\`\`/) {
                $mode = 0;
                print TEXFILE "\\end{lstlisting}\n\n";
            } else { print TEXFILE $_; } 
        }
    }
    if(0 != $exercise) { print TEXFILE "\\end{problemset}\n\n"; $exercise = 0;}
    close(TEXFILE);
    close(MDFILE);
}

if($#ARGV != 0) {
    print "Usage: md2tex.pl path\n";
    exit;
}

# if($#ARGV == 0) {
#     process_md($ARGV[0]);
#     exit;
# }

$dir = $ARGV[0];
opendir DIR, $dir;
my @dir = readdir(DIR);
close DIR;
foreach(@dir){
    if(m/\.md/) {
        print "$_ is processing!\n";
        process_md($_);
    }
}
exit;
