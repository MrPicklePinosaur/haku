use v6;
use Haku;
use HakuActions;
use Raku;

my $haku_str="高さとはカズ達とナガサで
若しカズ達が空に等しいなら
ナガサですけど、
そうでない、
【カズ達の尻尾】と【ナガサ足す壱】の高さ
の事です。

本とは
カズ達は壱と弐と三と四、
【カズ達と零の高さ】を見せる
の事です。";

my $hon_str_2 = $haku_str.lines.grep({ not /^ '#' / }).join("");

# $hon_str_2 ="【カズ達の尻尾】と【ナガサ足す壱】の高さ";
# say $hon_str_2;
# my $hon_parse_2 = Haku.subparse($hon_str_2,:rule('apply-expression'));#
# say $hon_parse_2;
# exit;

my $hon_parse_3 = Haku.parse($hon_str_2, :actions(HakuActions));#,:rule('bind-ha'));#
say ppHakuProgram($hon_parse_3.made);

