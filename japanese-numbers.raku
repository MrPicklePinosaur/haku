use v6;

# There are two number systems: the traditional one:

# [ ニ .. 九 ]?　億　[ ニ .. 九 ]? 万　[ ニ .. 九 ]?　千　[ ニ .. 九 ]?　百　[ ニ .. 九 ]?　十　[ ニ .. 九 ]？

# This I think we should handle as follows: a kanji of k=2..9 becomes k*
# a kanji of m=oku/man/sen/hyaku/juu becomes m+

my %digits;
%digits<一> = 1;
%digits<ニ> = 2;
%digits<三> = 3;
%digits<四> = 4;
%digits<五> = 5;
%digits<六> = 6;
%digits<七> = 7;
%digits<八> = 8;
%digits<九> = 9;

my %magnitudes;
%magnitudes<十> = 10;
%magnitudes<百> = 100;
%magnitudes<千> = 1000;
%magnitudes<万> = 10000;
%magnitudes<億> = 100000000;


my Str $gogo = '三千五十五万七千一百八十八';
my @gogo_kanji = $gogo.split('');
my $expr = '0';
my $acc = 0;
my $m=0;
my $par=0;
if ($gogo ~~ /万/) {
$par=1;
}
if $par {
    $expr = '(0';
}
for 1..(@gogo_kanji.elems-2)  -> $k {    
    if %digits{@gogo_kanji[$k]}:exists {
        $expr ~= '+'~%digits{@gogo_kanji[$k]};
        $m = %digits{@gogo_kanji[$k]};
    } elsif %magnitudes{@gogo_kanji[$k]}:exists {
        if @gogo_kanji[$k] eq '万' and $par {
            $acc+=$m;
            $acc*=10000;
            $expr ~= ')*10000';
        } else {
            $expr ~= '*'~%magnitudes{@gogo_kanji[$k]};
            $acc+=$m*%magnitudes{@gogo_kanji[$k]};
        }
        $m=0;
    }

}
$acc+=$m;
say $expr;
say $acc;