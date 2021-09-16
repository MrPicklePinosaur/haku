use v6;
use Haku;
use HakuActions;
use Raku;

my $hon_str_2 = "註 例のはくのプログラム。

本とは
ラムダは或エクスでエクス掛けるエクスです、
カズ達は八十八と七千百と五十五で、
注意　カズ達を聴こえる。
イ・ロ・ハ・空はカズ達で、
シンカズはイとロの和で、
注　カズ達を聞く。
シンカズを見せる、
ケッカは〈七百四十壱をラムダする〉足す九百十九、
【ケッカとシンカズの和】を見せる
のことです。";

my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
say ppHakuProgram($hon_parse_2.made);

