use v6;

# We assume first that the source is not in tategaki, and check for the pattern 本では. If that is not present, try tategaki.
# If the result of that does not contain 本では, give up.
sub hakuReader (Str $file --> Str) is export {
    my $try_yoko = yokogakiReader($file);
   if ($try_yoko) {
      return $try_yoko;
   } else {
       my $try_tate= tategakiReader($file);
       if ($try_tate) {
           return $try_tate;
       } else {
           die "The file does not seem to contain a valid Haku program";
       }
   }
}

sub yokogakiReader(Str $file) {

my $input_file = IO::Path.new( $file ) ;
my $horiz_str = $input_file.IO.slurp;
if $horiz_str ~~ /[ '本' '真'? | '俳句' | '詞' | '詩' ]とは/ {
    return $horiz_str.lines.grep({ not /^ [ '#' | '＃' ] / }).join("\n");
} else {
    return Nil;
}

}

my %v2h is Map = < 
 ︽	《     ﹄	』 ︷	｛ ︾	》 
 ︹	〔 ﹂	」 ︸	｝ 
 ︵	（ ︶	） ︿	〈 
 ︗	〖 ︻	【 ︺	〕 
 ﹁	「 ︼	】 ﹃	『 
 ﹇	［ ﹀	〉 ︘	〗 ﹈	］
>;


sub tategakiReader ( Str $file --> Str) {

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

#- Find the length of the longest split line
    my $max_length=0;
    for @lines -> @chars {
        if @chars.elems > $max_length {
            $max_length = @chars.elems;
        }
    }   
#- Transpose
    my @horiz_chars=();
    for 0 .. $max_length - 1 -> $idx {
        for @lines -> @chars {
            if @chars[$max_length - 1 - $idx]  {
                my $c = @chars[$max_length - 1 - $idx];
                if %v2h{$c}:exists {
                    $c = %v2h{$c};
                }
                @horiz_chars.push($c);
            } else {
                @horiz_chars.push( '　' );
            }
        }
        @horiz_chars.push( "\n" );
    }
    my $horiz_str = '';
    my $begin_comment=/<[註注「『《]>/;   # comment or string
    my $end_comment=/<[。」』》]>/;

    my $in_comment=False;
    for @horiz_chars -> $c {
        
        if $c ~~ $begin_comment {
            $in_comment=True;
        } elsif $c ~~ $end_comment {
            $in_comment = False;
        }
        if (($c eq '　' and $in_comment) or $c ne '　') {
            $horiz_str ~= $c;
        }
    }
    if $horiz_str ~~ /[本真?|俳句|詩|詞]とは/ {
        return $horiz_str;
    } else {
        return Nil;
    }
}



