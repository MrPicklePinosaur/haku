slide bg: #24364e

# Haku

A toy functional programming language based on literary Japanese 

## About the name

I call it 'haku' because I like the sound of it, and also because that word can be written in many ways and mean many things in Japanese. I was definitely thinking about Haku from Spirited Away. Also, I like the resemblance with [Raku](https://rakulang.org), the implementation language. I would write it 珀 (amber) or 魄 (soul, spirit).

## Motivation

[The Wikipedia page on Non-English-based programming languages](https://en.wikipedia.org/wiki/Non-English-based_programming_languages#Based_on_non-English_languages) lists eight different languages based on Japanese. So why make a ninth one? The short answer is, to see what I would end up with. The slightly longer answer is that these other eight languages serve a practical purpose: they want to make programming easier for Japanese native speakers, and most of them target education. 

My motivation to create Haku is very different. I don't want to create a practical language. I want to explore what the result is of creating a programming language based on a non-English language, in terms of syntax, grammar and vocabulary. In particular, I want to allow the programmer to control the register of the language to some extent (informal/polite/formal).
I also want the language to be closer, at lease visually, to literary Japanese. Therefore Haku does not use Roman letters, Arabic digits or common arithmetic, logical and comparison operators. 

### Grammar

The main motivation for Haku is the difference in grammar between Japanese and most Indo-European languages. This makes the familiar constructs quite different.

Some time ago I ran a poll about how coders perceive function calls, and 3/4 of respondents answered "imperative" (other options were infinitive, noun, -ing form). 

In Japanese, the imperative (命令形, "command form") is rarely used. Therefore in Haku you can't use this form. Instead, you can use the plain form, -masu form or -te form, including -te kudasai. Whether a function is perceived as a verb or a noun is up to you, and the difference is clear from the syntax. If it is a noun, you can turn it into a verb by adding suru, and if it is a verb, you can add the 'no' or 'koto' nominalisers. 

### Naming and giving meaning

In principle, programming language does not need to be based on natural language at all. The notorious example is APL, which uses symbols for everything. Agda programmers also tends to use lots of mathematical symbols. It works because they are very familiar with those symbols. An interesting question is if an experienced programmer who does not know Japanese could understand a Haku program; or if not, what the minimal changes would be to make it understandable. 

To allow to investigate that question, the Scheme emitter for Haku supports (limited) transliteration to Romaji. 

## Parsing

Japanese does not use spaces. So how do we tokenise a string of Japanese? 
- There are three writing systems: katakana (angular), hiragana (squigly) and kanji (complicated). 
- Katakan is used in a similar way as italics
- Nouns, verb, adjectives and adverbs normally start with a kanji
- Hiragana is used for verb/adjective/adverb endings and "particles", small words or suffixes that help identify the words in a sentence. 
- A verb/adjective/adverb can't end with a hiragana character that represents a particle. 

So we have some simple tokenisation rules:
- a sequence of katakana
- a kanji followed by more kanji or hiragana that do not represent particles
- hiragana that represent particles

Where that fails, we can introduce parentheses.
In practice, only specific adverbs and adjectives are used in Haku. For example:

ラムダ|は|或|エクス|で|エクス|掛ける|エクス|です

ラムダ: katakana word
は: particle
或: pre-noun adjective
エクス: katakana word
で: particle
エクス: katakana word
掛ける: verb
エクス: katakana word　
です: verb (copula)

## Core language

Haku is a simple pure, untyped, strict functional language. The core constructs are :

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

or

●<variable>は <expression>
●...
では<expression>

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
    reverse

### Maps

- maps with the following functions:
    length 長さ 
    has　マップにカギあったら
    insert　マップにカギとバリューを入れる
    lookup　マップにカギを正引きする・探索する
    delete　マップからカギを消す
    keys    マップの鍵
    values  マップの対応値

- we create them as an empty map, which I suppose could be the same as an empty list, 空 
- I want a closer binding than と. Maybe I could say k to v no pair 双 which would make it identical to a function call
- But then it means a list of these needs parens: (a to be no sou) to (...) to (...)  〈キーとバリューの双〉と〈キーとバリューの双〉の図
- Instead, I will automatically construct a map from a list: k1 to v1 to k2 to v2 kara zu wo tsukuru
  ケイ壱とヴィー壱とケイ弐とヴィー弐から図を作る

### System call

    機関で「ls」する

For interpolation: 《バリュー》
Returns a string.

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


## Example

I can now write the following Haku program:

    註 例のはくのプログラム。

    本とは
    ラムダは或エクスでエクス掛けるエクスです、
    カズ達は八十八と七千百と五十五で、
    イ・ロ・ハ・空はカズ達で、
    シンカズはイとロの和で、
    シンカズを見せる、
    ケッカは〈七百四十壱をラムダする〉足す九百十九、
      【ケッカとシンカズの和】を見せる
    のことです。

and it compiles to the following Scheme code:

    (define (displayln str) (display str) (newline))(define (hon)

    ; 例のはくのプログラム
    (define (hon)
        (let* (
                (RAMUDA (lambda (EKUSU) (* EKUSU EKUSU )))
                (KAZUTACHI (list 88 7100 55))
                (I (car KAZUTACHI))
                (RO (cadr KAZUTACHI))
                (HA (caddr KAZUTACHI))
                (SHINKAZU (+ I RO ))
                (KEKKA (+ (RAMUDA 741) 919 ))
            )
            (displayln SHINKAZU)
            (displayln (+ KEKKA SHINKAZU ))
        )
    )

    (hon)

Let's take it apart:

註 ... 。is a comment.

The main program (called 本, _hon_) has a fixed begin and end string:

    本とは
    ...
    のことです。

In Romaji this reads "Hon to wa ... no koto desu.", roughly "Main is the following thing(s): ...".

In Scheme I emit a function as body of Hon a let*-binding (i.e. binding is sequential):

    (define (hon)
        (let* (
            ...
            )
            ...
        )
    )

In the example we have an number of different types of assignments:

    ラムダは或エクスでエクス掛けるエクスです、

    "RAMUDA wa aru EKSU de EKSU kakeru EKSU desu"

Katakana is for variables, kanji for functions and keywords, hiragana for keywords and verb endings (e.g. in 掛ける and 見せる).

This roughly reads as "as for RAMUDA, with a given X it is X times X", so RAMUDA binds to a lambda function. In Scheme this becomes:

    (RAMUDA (lambda (EKUSU) (* EKUSU EKUSU )))

Next we have an assignment to a list of number constants:

    カズ達は八十八と七千百と五十五で、

    "KAZUTachi wa 88 to 7100 to 55 de,"

Numbers are written in kanji. The particle _to_ is the list separator. You can use 達 _tachi_ to show that a variable name is plural. In Scheme this becomes:

    (KAZUTACHI (list 88 7100 55))

Next we have a bit of syntactic sugar borrowed from Haskell (cons):

    イ・ロ・ハ・空はカズ達で、

    "I:RO:HA:Kuu wa KAZUTachi de,"

空 _kuu_ means "empty". This means that the list is deconstructed into elements I, RO, HA and and empty list. Scheme does not have this kind of pattern matching so each assignment is generated separately.

The next assignment,

    シンカズはイとロの和で、

    "SHINKAZU wa I to RO no Wa de"

is simply

    "SHINKAZU is the sum of I and RO"

    (SHINKAZU (+ I RO ))

Then we have a print statement:

    シンカズを見せる、

    "SHINKAZU wo Miseru"

    "To show SHINKAZU"
    
In Scheme:
    
    (displayln SHINKAZU)

Then follows another assignment:

    ケッカは〈七百四十壱をラムダする〉足す九百十九、

    "KEKKA wa (741 wo RAMUDA suru) Tasu 919"

    "KEKKA is (RAMUDA of 741) plus 919

    (KEKKA (+ (RAMUDA 741) 919 ))

And finally we show the result of an expression:

    【ケッカとシンカズの和】を見せる

    "(KEKKA to SHINKAZU no Wa) wo Miseru"
    
    "To show the sum of KEKKA and SHINKAZU"

    (displayln (+ KEKKA SHINKAZU ))
