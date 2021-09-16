use v6;
use Haku;
use HakuActions;
# use Scheme;
use Raku;


# We must allow a newline after any closing parens!

my $hon_str_2 = "註 Function　。
試すとはサイとワイで
【このエクス割るサイに
ワが四十二で御座います、
エクスがワ足すワイで御座います】
と弐を掛けて下さい
と言う事で御座います。
註 Main　。
本とは
〈四十弐と百を試して下さい〉 
を見せて下さい
と言う事で御座います。";


my $hon_str_3 = "註 Main　。
本とは〈四十弐と百を試す〉を見せるのことです。";

my $hon_str_1 = "註 Function　。
試すとはサイとワイで
【このエクス割るサイに
ワが四十二で御座います、
エクスがワ足すワイで御座います】
と弐を掛けて下さい
と言うの事で御座います。
註 Main　。
本真とは〈四十弐と百を試して下さい〉
を見せて下さい
と言うの事で御座います。";


my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
if $hon_parse_2 ~~ Match {

    say ppHakuProgram($hon_parse_2.made);
} else {

    my $hon_subparse_2 = Haku.subparse($hon_str_2);
    say $hon_subparse_2.chunks;
    say $hon_subparse_2.raku;
}
# exit;
