use v6;
use Haku;
use HakuActions;
use Raku;
#四十二沿い。
#

my $hon_str_21 = "本とは
カズは四十二沿い見せる「大丈夫」、
因にカズを見せて
の事です。";
#
# my $hon_str_2="カズは四十二沿い見せる「大丈夫」、";
my $hon_str_2 = $hon_str_21.lines.grep({ not /^ '#' / }).join("");
say $hon_str_2;
# my $hon_parse_2 = Haku.parse($hon_str_2, :rule('bind-ha'));
# say $hon_parse_2;
my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
# say $hon_parse_2;
# exit;
say ppHakuProgram($hon_parse_2.made);