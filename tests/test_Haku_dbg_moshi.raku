use v6;

use Haku;
use HakuActions;
use Raku;
# マップにカギが有る
# my $hon_str_2="もしエクなら一そうでない零";
my $hon_str_2="〈カズ達の長さ〉が零に等しい場合は、
サムですけれど、
そうでない場合は、
このノコカズ達とシンサムを加えるに
カズ・ノコカズ達がカズ達、
シンサムがサムにカズを足する";


# my $hon_str_2="このノコとシンを加えるに
# カズ・ノコがカズ、
# シンサムがサムにカズを足する";

# my $hon_str_2="〈カズ達の長さ〉が零に等しい";
# my $hon_str_2="〈カズ達の長さ〉";
# の長さ
 say $hon_str_2;
# my $hon_parse_2 = Haku.parse($hon_str_2,:rule('expression'));
# my $hon_parse_2 = Haku.parse($hon_str_2,:rule('condition-expression'));
# my $hon_parse_2 = Haku.parse($hon_str_2,:rule('baai-ifthen'));
# my $hon_parse_2 = Haku.parse($hon_str_2,:rule('kono-let'));
my $hon_parse_2 = Haku.parse($hon_str_2,:rule('expression'));

say $hon_parse_2;
exit;

# my $hon_parse_3 = Haku.parse($hon_str_2, :actions(HakuActions));#,:rule('bind-ha'));#
# say ppHakuProgram($hon_parse_3.made);

