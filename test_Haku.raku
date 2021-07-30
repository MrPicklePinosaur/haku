use v6;
use Haku;
use HakuActions;
# use HakuAST;
use Scheme;

my $hon_str = "本とは
注　算数　。
カズ達は六と七で、
六足す七、
四十弐
のことです。";

my $hon_parse = Haku.parse($hon_str, :actions(HakuActions));
say $hon_parse.made.hon.raku;
say ppHakuProgram($hon_parse.made);
#die;

my $hon_str_2 = "注 なに何か　test テスト。

本とは
カズ達は六と七で、
カズ達を聴こえる、
イ・ロ・空はカズ達で、
シンカズはイとロの和で、
カズ達を聞く、
シンカズを見せる
のことです。";

my $hon_parse_2 = Haku.parse($hon_str_2, :actions(HakuActions));
say $hon_parse_2.made.hon.raku;
say ppHakuProgram($hon_parse_2.made);
die;

# say "Try parsing 六"と七の積";
# my $m = Haku.parse("六と七の積");
# say $m;
# say "Try parsing 六に七を掛ける";
# my $m2 = Expression.parse("六に七を掛ける");
# say $m2;
 
my $let_kuromaru = Expression.subparse("●エクスは三。
●ワイは四千。
では
エクスとワイの積。");#,:rule('let-expression'));
# ");
say $let_kuromaru;
# をエッフする
# 
my $kono_let = Expression.subparse("この【エクスとワイの積】を試すに
エクスが三、",:rule('kono-let'));
# ワイが四千、
# エッフが或アでアにアを掛ける。");#
say $kono_let;

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


=begin pod

Comment line: 注 or 註 or even just 言

 = : は…です。
 
Lambda:  
→： で

For ease of parsing:

\ : 或（ある）but we don't need this if we use で


, : と or 、
““ : 『』
‘’ : 「」
() : （）
[] : ＜＞

if cond then xtrue else xfalse
cond場合はxtrue、そうでない場合はxfalse

function calls:

f x y
x to y wo f shite (kudasai)
エクスとワイを何々して　

or a lambda:

f = \x y → ...

f wa x to y de ...

I could of course implement map as a recursive function but I’d rather have it as a primitive, and the same for fold. I guess I can do:

map f xs

xs no kaku-x de nani-nani shite 
エクス達の各エクスで何々して下さい

Strings and numbers are easy. 

Logic:

A も B も : A && B (and allow A mo B)
A また B : A || B
不A : not A

What about lists? I must have some kind of syntax for the start and end of a list.［］is fine I guess

head, tail is of course just that: 頭、尾
length is 長さ
For tuples just parens （）? No, we don't need tuples.

## IO

For files we need open, close and some way to iterate over a handle, which I guess we could so with map 
開ける akete
閉める shimete
assuming that the file is a list of strings.

## Strings

Strings will be lists I guess. 
Quickly we might need some way to manipulate strings
割る to split a string 
str wo pattern de warite (kudasai)

str を pattern で 割りて (kudasai)

But I would like it if an assigment would be

chunksはstr を pattern で 割るのです。
( ~no because then I can always use dictionary form for any function.
Basically, ~te form is for functions not returning a result, dict+no is when assigned)

But a string should be a list, so we need some list operations, at least 
head, tail and ++
の頭
の尾
lst1とlst2を合わせて


Lambda

\x -> 2*x
x ga expr in x desu。
アでア掛ける二です。

Map

x2s = map (\x -> 2*x) xs
ニア達はア達から皆んな或アがア二倍です。
x2s ha 
    xs kara minna 
        x de x nibai desu.
        
Or
x2s ha 
    xs no kaku-x de x nibai desu.

With a named function, e.g. 増える
ニア達はア達から皆んなを増える
x2s ha 
    xs kara minna 
        wo fueru 

から皆
の各

Conditionals
\x y -> if x<y then x else y

if cond then xtrue else xfalse
cond場合はxtrue、そうでない場合はxfalse

2,3: x,y -> x < y then x else y
二、三はア、カがアはカより少ないの場合はアでそうでない場合はカです。

Print
x を見せて

I would make 下さい optional

Named function definition

アを増えるは　
x wo fueru ha
 a*x*x to b*x to c no wa desu
a とxとxの積と、bとxの積と、cの 和です

+: Tasu (足す)
-: Hiku (ひく or 引く)
*: Kakeru (掛ける or かける)
/: Waru (割る or わる)
product 積　せき
sum 和
difference : 差 さ
A fun one is the equivalent of $s x $n in Perl: we use the counter tsu

xsはx nつです。

Fold

fold function accumulator list 

I could use a word like “combine” or “reduce” I suppose
Or I could try to say it like for map

res ha acc to xs kara minna  wo 
レスはアックとエクス達から皆んなをヴァーブ

or again

res ha acc to xs no kaku-x de wo 

〇をフィボるのは一です。一をフィボるのは一です。
エンをフィボるのはエンと一の差をフィボてとエンと二の差をフィボてです。
十三をフィボるのを見せて下さい。

Example: Fibonacci

fibo 0 = 1
fibo 1 = 1
fibo n = fibo n-1 + fibo n-2

sum xs = fold (+) 0 xs 
sum toha xs de acc to xs no kaku-x de acc to x wo tasu

fold [ (+) | plus | \x y -> x+y ] 0 xs

xs kara minna wa wo rei to oru 
ア達から皆和を零と折る
atachi kara minna tasuno wo zero to oru

Now what we need to glue it all together is a let expression.


let
X
in
Y

この　Y に X  して

or one I like even if it is not really let ... in:
もし　or 若し
エクスは何々
ワイは何々
なら or ならば
エクスにワイを足て下さい。

or

sono X dewa Y

or maybe a typgraphic list:

●エクスは何々
●ワイは何々
では
エクスとワイの和です
or
エクスにワイを足て

moshi
f ha x de x to x no seki nara
f 6

moshi
f ha x de x ni x wo katetara
f 6

Let's try a proper, simple recursion:

f xs acc = 
    if length xs == 0 
        then acc 
        else 
            let
                x:xs' = xs
            in
                f xs' (acc+x)

多い (ooi): many / more than   [10より多い  = more than 10]
少ない (sukunai): few / less than  [5より少ない = less than 5]
等しい (hitoshii): equal   [also イコール]

5足す5
5に５を足す
５と５の私

は10に等しいです

加えるとは
    ア達とサで
        ア達の長さが零に等しい場合は
        サで、
        そうでない場合は
            もし
                ア・アア達はア達だったら、
                アア達とサ足すアを加える
                のことです。




=end pod


