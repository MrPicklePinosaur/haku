use v6;

# We can either be radical and always assume tategaki, but that would be quite restrictive for those wanting to test the language
# Another approach is to assume first that it is not tategaki, and check for the pattern 本では. If that is not present, try tategaki.
# If the result of that does not contain 本では, give up.
sub hakuReader (Str $file --> Str) {
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
if $horiz_str ~~ /本では/ {
    return $horiz_str;
} else {
    return Nil;
}

}

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
my $horiz_str='';
for 0 .. $max_length - 1 -> $idx {
for @lines -> @chars {
    if @chars[$idx]  {
        $horiz_str~=@chars[$idx];
    }
}
}

if $horiz_str ~~ /本では/ {
    return $horiz_str;
} else {
    return Nil;
}
}



