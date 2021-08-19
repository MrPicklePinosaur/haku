use v6;
use Haku;
use HakuActions;
# use HakuAST;
use Scheme;
#(五足す三）
#四足す弐、
# アクセラは（三足す五）を出るで、
# （三足す五）を出るで、
my $hon_str = "【四足す（五を着る）】を出る";
# "本とは
# アクセラは【四足す（五足す三）】、
# （三足す五）を出る、
# アクセラ
# のことです。";

#my $hon_parse =  Expression.subparse($hon_str);#:actions(HakuActions));
#say $hon_parse;
#die;


#（四をラムダする）を見せる

my $hon_str_1 = "本とは
注　算数　。
カズ達は六と七で、
六足す七、
四十弐
のことです。";

#my $hon_parse_1 = Haku.parse($hon_str_1, :actions(HakuActions));
#say $hon_parse_1.made.hon.raku;
#say ppHakuProgram($hon_parse_1.made);
#die;

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


# my $hon_str_2 = "本とは四十二の事です。";

# my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
# if $hon_parse_2 ~~ Match {
#     say ppHakuProgram($hon_parse_2.made);
# } else {
#     my $hon_subparse_2 = Haku.subparse($hon_str_2);
#     say $hon_subparse_2.chunks;
#     say $hon_subparse_2.raku;
# }
# exit;

# say "Try parsing 六"と七の積";
# my $m = Haku.parse("六と七の積");
# say $m;
# say "Try parsing 六に七を掛ける";
# my $m2 = Expression.parse("六に七を掛ける");
# say $m2;
my $let_kuromaru_str =  "本とは
●エクスは三。
●ワイは四千。
では
エクスとワイの積
のことです。";
#my $let_kuromaru = Haku.parse($let_kuromaru_str, :actions(HakuActions));#,:rule('let-expression')
#say $let_kuromaru;
#say ppHakuProgram($let_kuromaru.made);
#exit;
# をエッフする
# 
#my $kono_let = Expression.subparse("この【エクスとワイの積】を試すに
#エクスが三、",:rule('kono-let'));
# ワイが四千、
# エッフが或アでアにアを掛ける。");#
#say $kono_let;

# この【エクスとワイの積】を試すに
# エクスが三掛けるサイン、
# ワイがサイ割る弐
# の返値
# FIXME: 事 instead of こと gives a parse fail!
my $basic_func_str="註 Function　。
試すとはサイとワイでサイのことです。
註 Main　。
本とは 四十弐を試すの事です。";
# my $basic_func = Haku.parse($basic_func_str, :actions(HakuActions));
# say $basic_func ;die;
# say ppHakuProgram($basic_func.made);
# exit;

# この【エクスとワイの積】を試すに。
# 註 Function　。
# 　　　このワイ割る四にワイが三十、サイが
my $kono_let_func_str="試すとはサイとワイで
このワイ割るサイに
ワが四十二
のことです。
註 Main　。
本とは四十弐を試すのことです。
";
# 
# 註 Main　。
# 本とは四十弐を試すのことです。
# :rule('kono-let')
#my $kono_let_func = Haku.parse($kono_let_func_str, :actions(HakuActions));
# say $kono_let_func ;
#say ppHakuProgram($kono_let_func.made);
#exit;
# my $haku = Haku.parse("本とは
#     四十ニを見せる
#     のことです。");#");#四十ニ"); # 
# say $haku;

# my $f = Function.parse("加えるとはア達とサでア達が零に等しいのことです。"); #の長さ does not work as currently restricted to atomic expressions
# に等しい
#  my $c = Expression.parse("市者",:rule('noun'));
#  say $c;
# # my $f = Expression.parse("ア達がサに等しい",:rule('comparison_expression'));#
# say $f;
# my $f1 = Expression.subparse("ア達の長さがサに等しい");#
# say $f1;
        # 場合は
        # サで、
        # そうでない場合は
        # もし
        # ア・アア達はア達だったら、
        # アア達とサ足すアを加える


# をエッフする。

# my $bind_tara = Let.parse("エッフがアでアにアを掛けたら。",:rule('bind_tara'));
# # でアにアを掛け
# say $bind_tara;
# エクスとワイの積。");#をエッフする
# say $let_moshi;

my $moshi_if_str = "もし四十二なら七そうでない六";
#my $moshi_if = Expression.parse($moshi_if_str, :actions('HakuActions'));
#say $moshi_if;

my $baai_if_str = "本とは四十二場合は七そうでない場合は六のことです。";
# my $baai_if = Haku.parse($baai_if_str, :actions(HakuActions));
# say ppHakuProgram($baai_if.made);
# カズとアクを
my $fold_str = "本とはカズとアクを足すので畳み込むのことです。";
my $fold_parse = Haku.parse($fold_str);
say $fold_parse;
my $map_str = "本とはカズを試すので写像するのことです。";
#my $map_str = "写像する";
my $map_parse = Haku.parse($map_str);
say $map_parse;
 my $verb_str1 = "畳み込む";
 my $verb_parse1 = Expression.subparse($verb_str1, :rule('verb'));
 say $verb_parse1;
 my $verb_str2 = "聴こえる";
 my $verb_parse2 = Expression.subparse($verb_str2, :rule('verb'));
 say $verb_parse2;
 my $verb_str3 = "食べる";
 my $verb_parse3 = Expression.subparse($verb_str3, :rule('verb'));
 say $verb_parse3;
 my $verb_str4 = "引く";
 my $verb_parse4 = Expression.subparse($verb_str4, :rule('verb'));
 say $verb_parse4;
 my $verb_str5 = "間違う";
 my $verb_parse5 = Expression.subparse($verb_str5, :rule('verb'));
 say $verb_parse5;
