use v6;
use Haku;
use HakuActions;
use Raku;

my $haku_str="本とは
ファイルは「tmp.txt」、
言葉は「ことば」、
ハンドル一はファイルを読むの為に開ける、
ハンドル二はファイルを書くの為に開ける、
ラインはハンドル一を読む、
# ライン三は一線をハンドル一で読む、
# ライン達は全線をハンドル一で読む、
言葉をハンドル二で書く、
ハンドル一を閉める、
ハンドル二を閉める
のことです。";


my $hon_str_2 = $haku_str.lines.grep({ not /^ '#' / }).join("");

# $hon_str_2 ="ファイルは「tmp.txt」、";
# say $hon_str_2;
# my $hon_parse_2 = Haku.subparse($hon_str_2,:rule('bind-ha'));#
# say $hon_parse_2;
# exit;

my $hon_parse_3 = Haku.parse($hon_str_2, :actions(HakuActions));#,:rule('bind-ha'));#
say ppHakuProgram($hon_parse_3.made);


