#!/usr/bin/env raku
use v6;
sub USAGE() {
    print Q:c:to/EOH/;
    Usage: {$*PROGRAM-NAME}
        <parse vertical Japanese text>
 EOH
}

#Parsing tategaki would be:

unit sub MAIN(
  Str $file 
);

if (not $file.defined) {
     die "Please provide an input file\n";
}
my $input_file = IO::Path.new( $file ) ;

#- Read all lines
my @lines=();
my $split_on_spaces=False;
my $first=True;
for $input_file.IO.lines -> $line {
#- Split each line on the spacers
    next if $line eq '';
    if $first and $line ~~/[ ' ' | ' ' | ' ' | '|' ]/ {
        $split_on_spaces=True;
        $first=False;
    }
    my @chars = $split_on_spaces 
            ??  $line.split(/[ ' ' | ' ' | ' ' | '|' ]/)
            !! $line.comb();
    @lines.push(@chars);
}

#- find the length of the longest split line
my $max_length=0;
for @lines -> @chars {
    if @chars.elems > $max_length {
        $max_length = @chars.elems;
    }
}   

#- pad all arrays to that length
=begin skip
for @lines -> @chars {
    if @chars.elems < $max_length {
        my @padding = '£' xx ($max_length - @chars.elems); # '　'
        @chars = |@chars,|@padding;
#say @chars.raku;
#say @chars.elems;
    }
}   

say @lines;
=end skip
#- transpose
my $horiz_str='';
for 0 .. $max_length - 1 -> $idx {
for @lines -> @chars {
#say @chars.elems ~ "<>" ~ $max_length;
#say @chars;
    if @chars[$idx]  {
        $horiz_str~=@chars[$idx];
    }
}
}

# WV: TODO: must work for all spaces.
$horiz_str ~~s/^\s+//;
say $horiz_str;




