# Haku design TODO
## Sum and product

- sum and product should be array operations when not called infix. Essentially, if there are more than 2 args, it is a list; if only one argument, it must be a list
- also, I should parenthesise all binops so that there are no problems of precedence.
=> 2021-09-28 this is done: I have precedence and all noun operators are list operators

## Logical values and operations

A も B も : A && B (and allow A mo B)
A また B : A || B
不A : not A
### Logical 

ろんりち
論理値
n, comp, math
 Logical value (true or false), truth value.

True 陽 正 (proper but is used in principle in number 10^40)
False　陰 

XOR: 排他的論理和 
OR: は (または) 論理和 
AND:共に　ともに 論理積
NOT: 不 論理否定

### System call

    機関で「ls」する

For interpolation: 《バリュー》
Returns a string.

## Types

### Type inference

Haku is implicitly typed and full type inference should be possible. Haku has only three types of constants:
- Integer
- Rational
- String

Function type constructors are the lambda, the named functions, function composition
Function application is a reduction of the type.
In principle, file handles must be a separate type but they can be integers

The key change I think is that a variable, noun, verb or adjective needs to have not just a name but also a type. 
And the key operation is to infer the type for the binding based on the expression


### Annotations

I could easily add types as no-adjectives with the "rui" keyword:

整数類のサムは
文字列類のナマエは

I could also have such qualifiers for verbs, maybe 文字列類用に

The 類 is not really required but it makes it very clear that it is the type.

## IO

For files we need open, close and some way to iterate over a handle, which I guess we could so with map 
開ける akete
閉める shimete
assuming that the file is a list of strings.

ハンドルはファイルを読むの為に開ける
my \HANDORU = FAIRU.IO.open: :w;
ハンドルはファイルを書くの為に開ける
my \HANDORU = FAIRU.IO.open: :r;
ハンドルはファイルを開ける
my \HANDORU = FAIRU.IO.open: :rw;

言葉をハンドルで書く
HANDORU.put: KOTOBA;

ラインはハンドルを読む
my \line = HANDORU.get；

But we can be specific and say that we want a single line, any number of lines in fact, or all lines:

ラインは一線をハンドル一で読む、
ライン達は全線をハンドル一で読む、

ハンドルを閉める
HANDORU.close;

Maybe we need an eof as well. I will use 

しゅうりょう
終了

ハンドル一の終了

## Strings

### String Comparison

How to handle string comparison? Either create a function and match on the type or do type inference.

### More string operations?

We might need some way to manipulate strings
割る to split a string 
str wo pattern de warite (kudasai)

str を pattern で 割りて (kudasai)

But I would like it if an assigment would be

chunks は str を pattern で 割るのです。

( ~no because then I can always use dictionary form for any function.
Basically, ~te form is for functions not returning a result, dict+no is when assigned)

I don't have a join operator, inconvenient though it may be, instead it is

    lst1 と lst2 を 合わせて 

arg1 to arg2 wo arg3 to arg4 de verb
arg1 to arg2 no arg3 to arg4 de noun

## Haskell-style multiple-definition functions

Currently we have 

f toha x de ... 

What we need is to allow values in x, and to allow multiple definition lines.

〇をフィボるのは一です。一をフィボるのは一です。
エンをフィボるのはエンと一の差をフィボてとエンと二の差をフィボてです。
十三をフィボるのを見せて下さい。

Example: Fibonacci

fibo 0 = 1
fibo 1 = 1
fibo n = fibo n-1 + fibo n-2

Maybe a relatively simple way would be:

fibo toha n deha
0 to 
1 to
n to 

## Modules and imports

加群のモジュル２
輸入は
    モジュル１から皆
    ...
です。｜で、｜である
輸出は
    ... the names of the functions to be exported, separated by comma or と
です。｜で、｜である

## How do I keep the grammar and have sensible English?

C baaiha
X desukedo,
soudenai baai ha
Y desu

maybe
C entails Y but otherwise X

Function

a to b wo kakeru
A,B's SUM 
a no nagasa
A's LENGTH


Terminology: http://www.scripts-lab.co.jp/mind/ver8/doc/02-Program-Hyoki.html
Some vocabulary

fold: 畳み込む 

map:　写像。shazou, more common than chizu. 

連想配列（れんそうはいれつ rensouhairetsu: associative array, I could use this, and keep shazou for the function

array: 配列
value: 値

key: キー
pair: ペア 

じょうけんつきひょうげんしき
条件付き表現式
 Conditional expression (programming, programing).

かえりち
返値
n

Return value (from a function, in programming).


## Adjectives: -i, -na and -no

-no "adjectives" can of course be nouns and that syntax could actually be an alternative, neat way to access a hash:

マップにカギを正引きする・探索する would simply be マップのカギ 

Although I need to consider this carefully: what I want is something like

	ORENJI no densha 

And it is not clear at all how this would map to a hash access

	ICHIGO no nioi

Again, not a hash. What it could be is that the thing bound to it has a nioi and that is set to ICHIGO

e.g. more likely with a colour:

	kami ha ORENJI no iro

But the problem here is that this is mutable. 

Immutable would be

	kami' = irodoru kami ORENJI

Which should be

	kami' ha kami wo ORENJI ni irodoru

or maybe

	kami' ha kami wo ORENJI no iro ni suru	

=> What I can do is support ni in the same place as de and also allow ni before suru


Finally

	会えるものならば
	moshi aeru mono naraba

	"If only I could meet you"
	
	(naru au)
	(become meet)

All I need for that is to support 'mono' in addition to no, i.e. have <.mo>? => DONE
	
## Function composition

kyou mo ame nochi hare => kyou = [ame, hare] because nochi means "and later"

But the problem is that I wanted to use it for function composition.　I can still do that, but the order is reversed, i.e. f nochi g = g . f

For function composition we could maybe use 連結 renketsu, but then of course it would be a noun function call


Anyway, for the equivalent of Perl's comma operator, I could use 乍ら　ながら, "while"

答えは四十二乍らコタエを見せて

Or I could use 沿い　ぞい "running alongside", it's shorter, and may be more correct, but requires adjectial verbs

答えは四十二沿い見せるコタエ


I think I will also use 因に　ちなみに for any expression that can actually be omitted from the final program

答えは四十二。
因にコタエを見せて。


- Also, for adjectival verbs we can have 'de' arguments:

ramen wo supoon de taberu
supoon de tabeta ramen

## Closures

I want to generalise the use of nominalisers and verbalisers:
 
    xx to yy to zz wo f-verb

should call f but

    xx to yy to zz wo f koto 

should result in 

    sub f(\x,\y,\z) {x+y+z}

        sub ff {
        my \xx=11;
        my \yy=22;
        my \zz=33;


        -> { say "Only when called";
            f(xx,yy,xx) }
    }

    my \c = ff();
    say c.();

Which should use a verbaliser:


    f-verb toha  x to y to z de x+y+z no koto desu

    ff-verb toha
        - xx ha 11
        - yy ha 22
        - zz ha 33
        de ha
            xx to yy to zz wo f koto
    to iu koto desu
    
    hon toha
        CC ha ff-verb,
        CC suru
    no koto desu    

In principle ff-verb suru should work too, i.e. ff().()

This would mean that a noun-style function needs a verbaliser to work. 
I would say that this is only the case if it does not have a の　argument list

x no f-noun => call
x wo f-noun => closure
x wo f-noun suru => call

### Minimal error handling

open a file 若しくは 「...」を告げる (this is warn, not die)
And this obviously needs string interpolation.

The code generation depends on the target language. In Raku, we'd have

fopen($filepath) or (note($msg) && exit 1) 

This assumes that fopen returns something equivalent to False, so I assume Failure is False?

Possibly an equivalent of "die", e.g. 諦める (give up)

### State

We should keep the program state in the HakuProgram AST node.