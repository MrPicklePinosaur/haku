# Haku

A toy functional programming language based on literary Japanese 

## About the name

I call it 'haku' because I like the sound of it, and also because that word can be written in many ways and mean many things in Japanese. I was definitely thinking about Haku from Spirited Away. Also, I like the resemblance with [Raku](https://rakulang.org), the implementation language. I would write it 珀 (amber) or 魄 (soul, spirit).

## Motivation

[The Wikipedia page on Non-English-based programming languages](https://en.wikipedia.org/wiki/Non-English-based_programming_languages#Based_on_non-English_languages) lists eight different languages based on Japanese. So why make a ninth one? The short answer is, to see what I would end up with. The slightly longer answer is that these other eight languages serve a practical purpose: they want to make programming easier for Japanese native speakers, and most of them target education. 

My motivation to create Haku is very different. I don't want to create a practical language. I want to explore what the result is of creating a programming language based on a non-English language, in terms of syntax, grammar and vocabulary. In particular, I want to allow the programmer to control the register of the language to some extent (informal/polite/formal).

### Syntax

I also want the language to be closer, at lease visually, to literary Japanese. Therefore Haku does not use Roman letters, Arabic digits or common arithmetic, logical and comparison operators.
And it supports top-to-bottom, right-to-left writing. 

### Grammar

The main motivation for Haku is the difference in grammar between Japanese and most Indo-European languages. In particular, it has subject-object-verb order. This makes the familiar programming constructs quite different.

Some time ago I ran a poll about how coders perceive function calls, and 3/4 of respondents answered "imperative" (other options were infinitive, noun, -ing form). 

In Japanese, the imperative (命令形, "command form") is rarely used. Therefore in Haku you can't use this form. Instead, you can use the plain form, -masu form or -te form, including -te kudasai. Whether a function is perceived as a verb or a noun is up to you, and the difference is clear from the syntax. If it is a noun, you can turn it into a verb by adding suru, and if it is a verb, you can add the 'no' or 'koto' nominalisers. And you can conjugate the verb forms.

### Naming and giving meaning

In principle, programming language does not need to be based on natural language at all. The notorious example is APL, which uses symbols for everything. Agda programmers also tends to use lots of mathematical symbols. It works because they are very familiar with those symbols. An interesting question is if an experienced programmer who does not know Japanese could understand a Haku program; or if not, what the minimal changes would be to make it understandable. 

To allow to investigate that question, the Scheme and Raku emitters for Haku supports (limited) transliteration to Romaji. And there is also Roku, but more about that later ...

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

* Haku is a simple, mostly-pure, implicitly typed, strict functional language. 
* Think Scheme with a sprinkling of Haskell.
* TODO: At the moment, all type checking is defered to Raku, the implementation language. So the currently Haku is not really strict and more dynamically typed.

The core constructs are :

### Identifiers 
    
- variables: the first character must be _katakana_; further characters katakana or number kanji. The last character can be 達, to indicate a plural. 
- function names: must start with a kanji. If they are nouns, further characters are also kanji; if they are verbs, further characters are hiragana verb endings.
    
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

### Function application

There are a few forms of function application:

* Verb form:

        <arg-list> を [ <arg-list> で ] <function>

* Adjectival verb form (single argument only):

        <function> <arg>

* Noun form:

        <arg-list> の [ 、 <arg-list> での ] <function>
          
The argument list can optionally be followed by の皆. This is used in particular when applying map or fold.

### Map and Fold

Haku has built-in map and foldl:
                
    foldl: 畳み込む

    <list>と<accumulator>を<function>ので畳み込む

    map: 写像する
    
    <list>の皆を<function>ので写像する

### Partial application

TODO

The arg list can be followed by 岳 to indicate partial application.

### Let binding

    この <expression> に <variable> が <expression> 、... 。

or

    ●<variable>は <expression>、
    ●...
    では<expression>

### Conditional expressions

Similar to other Japanese natural programming languages, we use もし as the keyword to introduce an if-then-else. The condition can be either なら, ならば or 〜たら. The 'true' expression can optionally be followed by ですけれども or variants; the 'false' branch is introduced by そうでなければ or そうでないなら.

For example

    もし <cond-expression> ならば <expression> そうでなければ <expression> 。


### Operators

Haku provides a minimal set of arithmetic and logical operations and numerical comparisons.
Built-in operators in Haku can have a different syntax from ordinary function calls.
There is no operator precedence handling, so combined expressions need parentheses.

#### Arithmetic

Verb form:

    <expression> <verb> <expression>

or

    <expression> と <expression> を <verb>

    +: 足す
    -: 引く
    *: 掛ける
    /: 割る

Noun form: 

    <expression> と <expression> の <noun>

    +: 和
    -: 差
    *: 積
    /:　除

#### Logical

TODO

#### Comparison

    <expression> が <expression> <comparison-operation>

    ==: に等しい    
    >: より多い
    <: より少ない

TODO:

    >=: 以上
    <=: 以下

### Lists

* Haku list are simply expressions separated by と, without parentheses. 
* Square brackets (角括弧) ［］ are used for nesting lists. 
* The empty list is 空.
* Lists have a minimal set of list manipulation functions: 

    length: 長さ
    head:　頭
    tail: 尻尾
    cons:・(中黒)　
    concatenation: 後

TODO: 

    reverse: を反転する or の逆引き　    
    

### Maps

* Maps ("dictionaries") are created from lists of pairs,
    
        <key1>と<value1>と...で図を作る

    or from an empty list

        空で図を作る

    or shorter

        空図

* Maps support the following functions:
        
        has:　<map>に<key>が有る
        insert:　<map>に<key>と<value>を入れる
        lookup:　<map>に<key>を正引きする (TODO: 探索する)
        delete:　<map>から<key>を消す
        length: <map>の長さ 
        keys:    <map>の鍵
        values:  <map>の値


### System call

TODO:

    機関で「ls」する

For interpolation: 《バリュー》; returns a string.

### I/O

* The print function is called 見せる, and returns the stringified argument.

        <arg>を見せる

TODO:

* Minimal file I/O for text files only. 

        open: 
            <file>を<mode>の為に開ける
            where
            <mode>: 読む (read) or 書く (write)
            or
            <file>を開ける
            for read-write

        write: ＜string>を<filehandle>で書く
        read: 
            a single line: 一線を<filehandle>で読む、
            all lines: 全線を<filehandle>で読む、

        close: <filehandle>を閉める

        eof: <filehandle>の終了 (TODO)


## Verb conjugation

Haku lets you conjugate the verbs. For example:

* Given a function send:

        送るとは... 

    and an argument message:
    
        メッセージ  

* In Scheme: 

        (send message)


* Plain Haku 

        メッセージを送る。
        “To send a message”

* Polite Haku

        メッセージを送って下さい。
        “Please send the message”

* Insistent Haku

        メッセージを送なさい。
        “Do send the message”

* Adverbial 

        送ったメッセージ。
        “The sent message”

TODO: Not all of this works yet, currently you can do dictionary form (adjectival or plain), -te form with or without 下さい and even くれて. And です can be で御座います. 

## Types

TODO

## Modules and imports

TODO

## Example

Consider the following Haku program:

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

which compiles to the following Scheme code:

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

    註 ... 。
    
is a comment.

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
