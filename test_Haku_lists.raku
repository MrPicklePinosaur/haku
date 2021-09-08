use v6;
use Haku;
use HakuActions;
# use Scheme;
use Raku;

#リストは壱〜十、

say Haku.parse("見せてくれて下さい",:rule('verb'));
say Haku.parse("見せる",:rule('verb'));
say Haku.parse("見せませんか",:rule('verb'));
say Haku.parse("触れる",:rule('verb'));
say Haku.parse("捨てる",:rule('verb'));
say Haku.parse("捨てて",:rule('verb'));
say Haku.parse("忘れかけて",:rule('verb'));
exit;
my $hon_str_2 = "本とは
ナガサはリストの長さ、
ナガサを見せてくれて下さい
の事です。";


my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
if $hon_parse_2 ~~ Match {

    say ppHakuProgram($hon_parse_2.made);
} else {

    my $hon_subparse_2 = Haku.subparse($hon_str_2);
    say $hon_subparse_2.chunks;
    say $hon_subparse_2.raku;
}
