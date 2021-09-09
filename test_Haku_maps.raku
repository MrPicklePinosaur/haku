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

my $hon_str_2 = "本とは
マップは空から図を作る、
マップ二は「四十二」と四十二から図を作る、
マップモモは空図、
カギは「四十二」、
バリューは四十二、
テストはもしマップにカギが有るなら一そうでない零、
シンマップはマップにカギとバリューを入れる、
タブンバリューはマップにカギを正引きする、
シンマップを見せる、
マップ二を見せる
の事です。";


my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
if $hon_parse_2 ~~ Match {

    say ppHakuProgram($hon_parse_2.made);
} else {

    my $hon_subparse_2 = Haku.subparse($hon_str_2);
    say $hon_subparse_2.chunks;
    say $hon_subparse_2.raku;
}
