use v6;
use Haku;
use HakuActions;
# use Scheme;
use Raku;

# say Haku.parse("見せてくれて下さい",:rule('verb'));
# say Haku.parse("見せる",:rule('verb'));
# say Haku.parse("見せませんか",:rule('verb'));
# say Haku.parse("触れる",:rule('verb'));
# say Haku.parse("捨てる",:rule('verb'));
# say Haku.parse("捨てて",:rule('verb'));
# say Haku.parse("忘れかけて",:rule('verb'));
# リストとリストモを合わせる
my $hon_str_2 = "本とは
リストは壱〜十、
リスト一は十壱〜二十、
ナガサはリストの長さ、
アタマはリストの頭、
シッポはリストの尻尾、
リスト二はリストとリスト一を合わせる、
ナガサを見せる、
アタマを見せる、
シッポを見せる、
リスト二を見せる
の事です。";


my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
if $hon_parse_2 ~~ Match {

    say ppHakuProgram($hon_parse_2.made);
} else {

    my $hon_subparse_2 = Haku.subparse($hon_str_2);
    say $hon_subparse_2.chunks;
    say $hon_subparse_2.raku;
}
