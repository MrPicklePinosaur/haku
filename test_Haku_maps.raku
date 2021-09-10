use v6;
use Haku;
use HakuActions;
# use Scheme;
use Raku;

# say Haku.subparse("マップにカギの正引き",:rule('apply-expression'));
# say Haku.subparse("マップにカギを探索する",:rule('apply-expression'));
# exit;
=begin pod
    # has　マップにカギあったら
    token attara { 'あったら' | '有ったら' }
    
    #insert　マップにカギとバリューを入れる
    token ireru { '入れ' <ru-endings> }

    #lookup　マップにカギを正引きする・探索する
    token seibiki { '正引き' <suru> }
    token tansaku { '探索' <suru> }
    
    #delete　マップからカギを消す
    token kesu { '消' <su-endings> }
    
    #keys    マップの鍵
    token kagi { '鍵' }
    
    #values  マップの対応値:w
    token chi { '値' }

    # empty map 空 

    # map creation (from a list) から図を作る 
    # I could use 連想配列 rensouhairetsu but that is really long.
    token zuwotsukuru { '図' 'を' '作' <ru-endings> }

=end pod
# 解答とは「四十二」、
# 註Create an empty map。
# 註Create a map with a single pair '42' => 42。
my $hon_str_21 = "本とは
註 an empty map。
マップは空で図を作る、
マップ二は「四十二」と四十二で図を作る、
マップ三は空図、
註 var for key。
カギは「四十二」、バリューは四十二、
解答は「四十二」、
テストはもしマップにカギが有るなら一そうでない零、
シンマップはマップにカギとバリューを入れる、
シンマップ三はマップからカギを消す、
タブンバリューはマップにカギを正引きする、
カギ達はマップの鍵、
アタイ達はマップの値、
シンマップを見せる、
註 show map2。
マップ二を見せる
の事です。";


my $hon_str_2 = $hon_str_21.lines.grep({ not /^ '#' / }).join("");
say $hon_str_2;
my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
if $hon_parse_2 ~~ Match {
    say ppHakuProgram($hon_parse_2.made);
} else {
    my $hon_subparse_2 = Haku.subparse($hon_str_2);
    say $hon_subparse_2.chunks;
    say $hon_subparse_2.raku;
}

