# Haku

A toy functional programming language based on Japanese 

## About the name

I call it 'haku' because that can be written many ways and mean many things in Japanese. I was definitely thinking about Haku from Spirited Away. Also, I like the resemblance with [Raku](https://rakulang.org), the implementation language. 

## Motivation

[The Wikipedia page on Non-English-based programming languages](https://en.wikipedia.org/wiki/Non-English-based_programming_languages#Based_on_non-English_languages) lists eight different languages based on Japanese. So why make a ninth one? The short answer is, to see what I would end up with. The slightly longer answer is that these other eight languages serve a practical purpose: they want to make programming easier for Japanese native speakers, and most of them target education. 

My motivation to create Haku is very different. I don't want to create a practical language. I want to explore what the result is of creating a programming language based on a non-English language, in terms of syntax, grammar and vocabulary. In particular, I want to give the programmer to control the register of the language to some extent (informal/polite/formal).
I also want the language to be closer, at lease visually, to literary Japanese. Therefore Haku does not use Roman letters, Arabic digits or common arithmetic, logical and comparison operators. 

The main motivation for Haku is the difference in grammar between Japanese and most Indo-European languages. This makes the familiar constructs quite different.

A few weeks ago I ran a poll about how coders perceive function calls, and 3/4 of respondents answered "imperative" (other options were infinitive, noun, -ing form). 

In Japanese, the imperative (命令形, "command form") is rarely used. Therefore in Haku you can't use this form. Instead, you can use the plain form, -masu form or -te form, including -te kudasai. Whether a function is perceived as a verb or a noun is up to you, and the difference is clear from the syntax. If it is a noun, you can turn it into a verb by adding suru, and if it is a verb, you can add the 'no' or 'koto' nominalisers. 

## Core language

Haku is a simple pure, untyped, strict functional language. The core constructs are 

### Identifiers 
    - variables: first character must be _katakana_; further characters katakana or number kanji. Last character can be 達. Also, variables can be any _kanji_ with "haku" as _on_-reading.
    - function names: must start with a kanji. If they are nouns, further characters are also kanji; if they are verbs, further characters are hiragana verb endings
### Constants
    - integer: written using number kanji. For zero, either 零, ゼロ or ◯. Negative number prefix is マイナス, optional positive number prefix is プラス
    - rational: two integers separated by 点
    - string: 「」or 『』 
    - list: consist of identifiers or constants separated by と or 、

### Named function definitions

In Haku, named function definitions are statements. The structure is

    <function-name> とは <argument-list> で <expression> のことです。

### Lambdas

或　<argument-list> で <expression>

### Let binding

この <expression> に <variable> が <expression> 、... 。

### Partial application

I will mark partial application using the particle だけ:

<argument-list> だけ　を <function-name or lambda-expression>

### Conditional expressions

Similar to other Japanese natural programming languages, we use もし as the keyword to introduce an if-then-else. The condition can be either なら, ならば or 〜たら. The 'true' expression can optionally be followed by ですけれども or variants; the 'false' branch is is introduced by そうでなければ or そうでないなら.

For example

もし <cond-expression> ならば <expression> そうでなければ <expression> 。


### Operators

Haku provides a minimal set of arithmetic and logical operations and numerical comparisons.
Built-in operators in Haku can have a different syntax from ordinary function calls.
There is no operator precedence handling, so combined expressions need parentheses.

#### Arithmetic

#### Logical

#### Comparison


### Lists
- lists with a small set of list manipulation functions: 
    length, 
    head, 
    tail, 
    cons
    concatenation 
    nesting

### I/O
- minimal I/O: open/close files, read from/write to files, print to stdout

In addition:
- map and fold are primitives because I want to give them separate syntax
- partial application is supported with special syntax
- function composition operator
- limited pattern matching with cons on the LHS

## Types

Haku is untyped but I could easily add types as no-adjectives with the "rui" keyword:

整数類のサムは
文字列類のナマエは

I could also have such qualifiers for verbs, maybe 文字列類用に

The 類 is not really required but it makes it very clear that it is the type.

## Examples

アとサを合わせて下さい。

A to SA wo awasete kudasai.

"Please join A and SA"

An addition can be written as:

アとサの和 with optional copula forms です,でございます,である and even だ
ア足すサ
アにサを足す or ます, てor て下さい

Functions can be nouns or verbs, and their application is different:

Verb-style function application:

アとサを繋げる
A to SA wo tsunageru (and again, -masu, -te etc are also OK)

アとサの接続です or アとサの接続する or して or して下さい
A to SA no setsuzoku desu or suru/shite/shite kudasai

## Writing system and variants

Standard Haku is written in a mixture of kanji, katakana and hiragana and some punctuation. Ideally I would like to allow people to write romaji and even a kind of English.  But I don't fancy having to deal with whitespace, as that makes the grammar a bit too different.  So we'll have identifiers in uppercase, keywords in lowercase. I'll include some space in the keywords for readability. 

### Comments

Comment line: 註 or 注 or even just 言, must end with 。

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
Also, although variables have to be katakana, I will allow any kanji with a "haku" reading as variable name too, just because I can. 

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


More like a where:
この　Y に X  して

このX足すYにXが四十で、Yがニです。

or

そのXが四十で、YがニではX足すY


or one I like even if it is not really let ... in:
もし　or 若し
エクスは何々
ワイは何々
なら or ならば
エクスにワイを足て下さい。


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



So the question is how to nest expression tokens for Haku

A function declaration is currently not treated as an expression
As my idea is to emit Scheme so function declarations will map to `define`

For operator expressions, I think I will keep it simple: parentheses are mandatory.
We can do the same for function application. So an operator expression can contain:



So what is the highest-level expression? That would be a let or an if-then;

let is either "moshi ..." or "●..." so that can't be mistaken for if-then which must start with a condition. However, in principle that condition could be a let; I can save myself a world of trouble by not allowing this:
- An `if-then` condition can be one of the following:

    token condition_expression {    
    <comparison_expression> |
    <apply_expression> |   
    <operator_expression> |
    <parens_expression> |
    <atomic_expression>
    }
    
- The next level is the RHS of a binding and the final return expression of the let. In principle, both of these should be allowed to contain their own let_expressions
So it is rather crucial that

token expression = {
    <let_expression> |
    <operator_expression> |
    <apply_expression> |
    <operator_expression> |
    <parens_expression> |
    <atomic_expression> 
}

should work. 

So let's design that first

token let_expression {
    'let' <bind_expression>+ 'in' <expression>
}

token bind_expression {
    <variable> '=' <expression>
}





Looking at the three others, 

- comparison_expression cannot contain if-then or let in its sub-epxressions, so what remains are
    <atomic_expression>
    <apply_expression>
    <operator_expression>
    <parens_expression>

- apply cannot contain if-then or let or apply in its sub-epxressions, so what remains are 
    <atomic_expression>
    <operator_expression>
    <parens_expression>
    
and then of course also things like
    <list_expression>

I think I can required that anywhere but on the LHS, the cons-expression is parenthesised; same for function composition.


I think I need a simple test case:

[a , b] , [c , d] , e

token kaku_parens_expression { <.open_kaku> <list_expression>  <.close_kaku> }

token list_elt_expression {
    <kaku_parens_expression> | <atomic_expression>
}

token list_expression { <list_elt_expression> [ <list_operator> <list_elt_expression> ]+ }

## Lists

There is a difference between an argument list for a function, which can have one (or even zero) arguments, and a list datastructure which with my current syntax must have at least two elements.
I introduce square brackets so we can have a list with a single element or no elements. 
The brackets can be omitted when not necessary
    lst = a,b
    lst = [a,b] -- optional
    lst = [a] -- necessary, otherwise not a list
    lst = [] -- necessary, otherwise not a list
    lst = a,[b,c] -- necessary for nested lists

To append or prepend an element to a list I will simply use the list operator:
    lst' = elt,lst
    lst' = lst,elt
This is a flattening operation so it appends or prepends. To get nesting, use []

## Modules and imports

加群のモジュル２
輸入は
    モジュル１から皆
    ...
です。｜で、｜である
輸出は
    ... the names of the functions to be exported, separated by comma or と
です。｜で、｜である

How do I keep the grammar and have sensible English?

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


https://andrewshitov.com/creating-a-compiler-with-raku/

use Haku;
use HakuActions;

my $code = 'test.lng'.IO.slurp();
Haku.parse($code, :actions(HakuActions));

class HakuActions {
    has %.var;

    method variable-declaration($/) {
        %var{$<variable-name>} = 0;
    }

    method assignment($/) {
        %var{~$<variable-name>} = +$<value>;
    }

    method function-call($/) {
        say %var{$<variable-name>}
            if $<function-name> eq 'say';
    }   
}

Let's assume we build a datatype for this. 

data HakuStmt = Function | Hon
data Function = mkFunction [FunctionArg] FunctionBody
type FunctionArg = Variable
data FunctionBody = HakuExpr
data Hon = mkHon [HakuExpr]

data HakuExpr = LetExpr | IfExpr | AtomicExpr | LambdaExpr
data LetExpr = mkLetExpr [BindExpr] ResultExpr
data LambdaExpr = mk LambdaExpr [Variable] HakuExpr
data BindExpr = mkBindExpr LhsExpr RhsExpr 
type LhsExpr = Variable
type RhsExpr = HakuExpr
type ResultExpr = HakuExpr

data IfExpr = mkIfExpr CondExpr ThenExpr ElseExpr
type ThenExpr = HakuExpr
type ElseExpr = HakuExpr
data CondExpr = 
        CompExr |
        ApplyExpr |   
        OperatorExpr |
        ParensExpr |
        AtomicExpr
type CompExpr = BinOpExpr
data BinOpExpr = mkBinOpExpr BinOp OpArgExpr OpArgExpr
data OpArgExpr =     
        ApplyExpr |   
        ParensExpr |
        AtomicExpr
data AtomicExpr =
    Number |
    Identifier 
data Identifier = Variable | Verb | Noun    

In other languages:

もし
--
なら
ならば
--
違えば
そうでなければ

でなければ
でないなら

Terminology: http://www.scripts-lab.co.jp/mind/ver8/doc/02-Program-Hyoki.html



-----

A practical question is if it makes sense to parse built-in functions such as 見せて different from other verbs. I guess it would if we have dedicated nodes in the AST for them. But why would we? Basically, if a function is not defined, we can look if it occurs in the list of built-in functions, and if not we throw an error. 
So there is no reason to have them different.