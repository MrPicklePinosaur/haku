# Haku, a toy functional programming language based on Japanese

use v6;
#use Grammar::Tracer;

role Characters {
    token reserved-kanji {
        '或' |
        '和' | '差' | '積' | '除' |
        '後' | '為' | '等' | '若' | '不' | '下' |
        '本' | '事' | 
        '皆' | '空' | '若' |
        '因' |　'沿' 
    }
   
    token kanji {  
        # Using Block hangs
        <:Block('CJK Unified Ideographs') - reserved-kanji >
        # See Kanji.rakumod for a list instead of the Unicode block
        }  

    token number-kanji { 
        | '一' | '二' | '三' | '四' | '五' | '六' | '七' | '八' | '九' | '十' 
        | '壱' | '弐' | '参' | '肆' | '伍' | '陸' | '漆' | '捌' | '玖' | '拾'                  
        | '弌' | '弍' | '弎'                      | '柒'       
        | '壹' | '貳' 
               | '貮' 
        | '百' | '千' | '万' | '億' 
        |               '萬' 
        | '兆' | '京' | '垓' | '𥝱' | '穣' | '溝' | '澗' | '正' | '載' | '極' 
# See https://www.tofugu.com/japanese/counting-in-japanese/ for <1e-12
        | '分' | '厘' | '毛' | '糸' | '忽' | '微' | '繊' | '沙' | '塵' | '埃' | '渺' | '漠'

        }
    
    token haku-kanji {
        '白' | '泊' | '箔' | '伯' | '拍' | '舶' | 
        '迫' | '岶' | '珀' | '魄' | '柏' | '帛' | '博'
    }

    token katakana { 
        # Using Block hangs
        # <:Block('Katakana')> 
        <[ア..ヺー]>
    }

    # I might allow A-Z as well for identifiers
    token romaji {
        <[A..Z]>
    }    
    
    # 算用数字
    token sanyousuji {
        '０' | '１' | '２' | '３' | '４' | '５' | '６' | '７' | '８' | '９'
    }
    
    # I might allow ordinary digits in identifier names
    token digits {
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' 
    }    

    token hiragana {
        <:Block('Hiragana')>
        # <[あ..を]>
    }    

    token word {
        \w
    }
} # End of role Characters

# I think I will use the full stop and semicolon as equivalent for newline.
role Punctuation {

    token full-stop { '。' 
        { self.highwater('。'); }
    }
    token comma { '、'
        { self.highwater('、'); }
    }
    token semicolon { '；' 
        { self.highwater('；'); }
    }    
    token colon { '：' 
        { self.highwater('：'); }
    }
    token interpunct { '・' } # nakaguro 
    token punctuation { <full-stop> | <comma> | <semicolon> | <colon> }
    token delim { 
            [<full-stop> | <comma> | <semicolon>] <ws>?
    }
    
    # Marukakko (丸括弧) 
    token open-maru { '（' }
    token close-maru { '）' }
    # Namikakko (波括弧)
    token open-nami { '｛' }
    token close-nami { '｝' }

    # Kakukakko (角括弧)
    token open-kaku { '［' }
    token close-kaku { '］' }

    token open-sen { '〈' }
    token close-sen { '〉' }

    # Sumitsukikakko (隅付き括弧)
    token open-sumitsuki { '【' }
    token close-sumitsuki { '】' }
    
    #  etc, see https://ja.wikipedia.org/wiki/%E6%8B%AC%E5%BC%A7

}  # End of role Punctuation

role Particles {

    token ga { 'が' 
        { self.highwater('が'); }
    }
    token ha { 'は' 
        { self.highwater('は'); }
    }
    token no { 'の' 
        { self.highwater('の'); }
    }
    token to-particle { 'と' }

    token mo { 'も' }

    token wo { 'を' 
        { self.highwater('を'); }
    }
    token de { 'で' 
        { self.highwater('で'); }
    }
    token ni { 'に' 
        { self.highwater('に'); }
    }
    token ka { 'か' }
    token kara { 'から' 
        { self.highwater('から'); }
    }
    token made-particle { '迄' | 'まで' }
    token deha { 'では' }
    token node { 'ので' }
    token noha { 'のは' }
    token dake { '丈' | 'だけ' } 
        
    method highwater($p) {
        if self.pos > $*HIGHWATER {
            $*HIGHWATER = self.pos;
            $*PARTICLE = $p;
            $*LASTRULE = callframe(1).code.name;
        }
    }

}  # End of role Particles

role Nouns does Characters {
    token sa { 'さ' }
    token ki { 'き' }
    token noun { <kanji>+ [<sa>|<ki>]? }
}

role Verbs does Characters {
    token verb-ending {
        <sura> || <verb-ending-masu> || [
        'る'| 'す'| 'む'| 'く'| 'ぐ'| 'つ'| 'ぬ' | 'う' |
        'った'| 'た'| 'いだ'| 'んだ' |  
         'って'| 'て'| 'いで' | 'んで' 
        ]

    }
    token verb-ending-dict {
        'る'| 'す'| 'む'| 'く'| 'ぐ'| 'つ'| 'ぬ' | 'う' 
    }
    token verb-ending-masu {
        'ま' [ 'す'| 'し' ['た'| 'ょう'] | 'せん'] 'か'?
    }
    token verb-ending-ta {
        'った'| 'た'| 'いだ'| 'んだ'
    }
    token verb-ending-te {
        'って'| 'て'| 'いで' | 'んで'
    }    
    
    token verb-stem {
        <kanji> <hiragana>?? <kanji>? #<hiragana>*?
    }

    token verb-stem-hiragana {
         <hiragana>+? <?before <verb-ending> >
    }

    token verb-dict { <verb-stem> <verb-stem-hiragana>? <verb-ending-dict> }
    token verb-masu { <verb-stem> <hiragana>*? <verb-ending-masu> }
    token verb-ta { <verb-stem> <hiragana>*? <verb-ending-ta> }
    token verb-te { <verb-stem> <verb-stem-hiragana>? <verb-ending-te> }
    token verb-sura { <verb-stem> <verb-stem-hiragana>? <sura> }

# This fails on e.g. su.teru because the te is seen as -te form
# We should have a rule for a -te after a kanji and before te/ru/masu/ta 
# su.tete, su.teru <>  ki.te
# but to complicate it : wasu.rekakete(i)ta
    token verb { 
        <verb-te> [ <.kureru> | <.morau> ]? [<.kudasai> | <.shimau>]?
        || <verb-sura>
       || [
         <verb-dict> 
       | <verb-masu> 
       | <verb-ta>        
       ]
#| <verb-te> [ <.kureru> | <.morau> ]? [<.kudasai> | <.shimau>]?
#        <verb-stem>
#        [
#            <verb-ending> | 
#            <verb-ending-te> [ <.kureru> | <.morau> ]? [<.kudasai> | <.shimau>]Y?
#        ] 
    }

}  # End of role Verbs

role Variables does Characters {
    # Variables must start with katakana then katakana, number kanji and 達 
    # But kanji with a "haku" on-reading are also supported.
    token variable { 
        [ <katakana> | <haku-kanji> ]
        [ <katakana>  | <haku-kanji> | <number-kanji> ]* <tachi>? 
    }
    # To indicate plural
    token tachi { '達' }    
}

role Identifiers does Verbs does Nouns does Variables {
    
    # Identifiers are variables noun-style and verb-style function names
    token identifier { <variable> | <verb> [<.no>|<.koto>]? | <noun> <.sura>?  }

}

role Auxiliaries {
    token kudasai { [　'下' | 'くだ' ] 'さい' }    
    token masu { 'ま' [ 'す' | 'した' ] }

    token shite-kudasai { 'して' [ '下' | 'くだ' ] 'さい' }
    token suru { 'する' | '為る' | 'した' }
    token shimasu { 'しま' | [ 'す' | 'した' ] }
    token sura {
        <suru> | <shimasu> | <shite-kudasai> 
    }
    token desu { 'です' | 'だ'  | 'である' |　'で或る' |　'でございます' |　'で御座います'　 }

    token shimau { ['しま'|'仕舞'|'終'|'了'|'蔵'] ['う' | ['っ'|'いまし'] 'た'] };            
    token kureru { [ 'く'| '呉'] 'れ'　[ 'て' | 'た' | <masu> ]};
    token morau { [ '貰'|'もら'] }; 
    
}  # End of role Auxiliaries

# +: Tasu (足す)
# -: Hiku (ひく or 引く)
# *: Kakeru (掛ける or かける)
# /: Waru (割る or わる)

# product 積　せき
# sum 和 わ
# division　除 じょ
# difference : 差 さ

# number times <x>: <x> <number> 倍 ばい

role Operators does Characters does Punctuation 
{
#                         +       -      *      /
    token operator-noun { '和' | '差' | '積' | '除' }
    token operator-verb-kanji { '足' | '引' | '掛' | '割' }
    token operator-verb { <operator-verb-kanji> <hiragana>*? <verb-ending> }    
    token list-operator { <ni> | <to-particle> | <kara> | <made-particle> } # NOT comma, conflicts with delimiter! | <comma>}
    token nochi { '後' | 'のち' } # g . f
    token aru { '或' } # the \ operator
    token cons { <interpunct> | <colon> }
    # Maybe technically this is not an operator?
    token chinamini { 'ちなみに' | '因みに' | '因に' }
    token zoi { 'ぞい' | '沿い' }
}


role Keywords 
does Operators
does Particles
does Auxiliaries
does Verbs 
does Nouns
# I might split these out further
{
    # For an empty list
    token kuu { '空' }
    # For Nil
    token mu { '無' }

    # For Ranges
    token nyoro { '〜' }

    # For Comparisons 

    token hitoshii { '等しい' } # ==
    token yori { 'より' } 
    token ooi { '多い' }    # >
    token sukunai { '少ない' } # <
    

    # For Let
    token kono {
        'この'
    }
    # See design doc
    token moshi { 
        [ 'もし' | '若し' ] <mo>?　<ws>?
    }
    token nara { 'なら' }
    token tara { 'たら' }

    token dattara { 'だったら' }
    token moshi-nanira { <dattara> |　<tara> | <nara> }
    
    token kuromaru { '●' }    

    # For IfThenElse

    token kedo { 'けど' | 'けれど' <mo>? }
    token baaiha { '場合は' }
    token soudenai { 'そうでない' }
    token soudenakereba { 'そうでなければ' }

    # For Maps and Folds

    token nokaku { 'の各' }
    token nominna { 'の皆' }
    token shazou { '写像' <sura> }     
    token tatamikomu { '畳み込む' <mu-endings> }

    # For IO
    # ファイルを{読む|書く}のために開く
    # ハンドル を  開く | 閉じる
    token tame { 'ため' | '為' | '爲' }
    # For Function and Hon
    
    token toha { 'とは' }

    token toiu { 'という' | 'と言う' }

    token koto { 'こと' | '事' }

    # For Haku
    token hon {'本'} 
    token ma {'真'} 
    token hontoha {
        <hon> <ma>? <.toha> <.ws>? 
    }

    # Built-in verbs
    token u-endings {
        'う' | 'って' <kudasai>? | 'い' <masu>
    }
    token mu-endings {
        'む' | 'んで' <kudasai>? | 'み' <masu>
    }

    token ru-endings {
         'る' | 'て' <kudasai>? | 'り' <masu>
    }

    token ku-endings {
         'く' | 'いて' <kudasai>? | 'き' <masu>
    }

    token tsu-endings {
         'つ' | 'って' <kudasai>? | 'ち' <masu>
    }

    # Say
    token miseru { '見せ' <ru-endings> }

    # Built-in nouns

    # List operations; strings are lists.
    # length
    token nagasa { '長さ' }
    # reverse:  
    #配列を反転する
    #リストの逆引き　
    
    # head, 
    token atama { '頭' }
    # tail, 
    token shippo  { '尻尾' }
    # concatenation     
    token awaseru { '合わせ' <ru-endings> }
    # split
    token waru { '割' <ru-endings> }
 
    
    # Map operations
    
    # length 長さ , see abive
    
    # has　マップにカギがあったら
    token attara { 'あったら' | '有ったら' }
    token ga-aru { 'がある' | 'が有る' }
    
    #insert　マップにカギとバリューを入れる
    token ireru { '入れ' <ru-endings> }

    #lookup　マップにカギを正引きする・探索する
    token seibiki { '正引き' <suru> }
    token tansaku { '探索' <suru> }
    
    #delete　マップからカギを消す
    token kiesu { '消' <su-endings> }
    
    #keys    マップの鍵
    token kagi { '鍵' }
    
    #values  マップの対応値:w
    token chi { '値' }

    # empty map 空 

    # map creation (from a list) で図を作る 
    # I could use 連想配列 rensouhairetsu but that is really long.
    token zuwotsukuru { '図' 'を' '作' <ru-endings> }


    # File operations
    token akeru { '開け' <ru-endings> }
    token shimeru { '閉め' <ru-endings> }
    token kaku { '書' <ku-endings> }
    token yomu { '読' <mu-endings> }

    # For comparisons
    token chigau { '違' <u-endings> }
    
    # System call
    

    token kikan { '機関' } #で「ls」する

} # End of role Keywords

# Comment line: 註 or 注 or even just 言, must end with 。
role Blanks {
    token blank {  '　' | ' ' | \n | \t }
}

role Comments does Punctuation does Blanks {
    token comment-start { '註' | '注' | '言' }
    token comment-chars { 
         <hiragana> | <katakana> | <kanji> | <word> | <blank>
    }
    token comment { <.comment-start> <comment-chars>+ <.full-stop> <.ws>? }
}

role Numbers does  Characters {
# role Constants does Characters {    
    token zero { '〇' | '零' | 'ゼロ' | 'マル'  }
    token minus {'マイナス'}
    token plus {'プラス'}
    token integer { [<number-kanji> | <zero>]+ }
    token signed-integer { (<minus> | <plus>) <integer> }
    token ten { '点' }
    token rational { <signed-integer>+ <.ten> <integer>+ }
    token number { 
        <rational> | <signed-integer> | <integer> 
    }
}

role Strings does Characters {
    token string-chars { 
         <hiragana> 
         | <katakana>
          | <kanji> | <word> | ' ' | '　' | \n
        #   | <blank> 
    }
    token string { 
         '「」' |
         '『』' |    
        [ '「'  <string-chars>+ '」' ] |
        [ '『'  <string-chars>+ '』' ]         
    }
    
    token string-interpol-left {
         ['『' | '「' ] <string-chars>* '《'

    }
    token string-interpol-right {
            '》' <string-chars>* ['』' | '」' ]
    }
    token string-interpol-middle {
            '》' <string-chars>* '《'
    }
    token string-interpol { 
        <string-interpol-left>
          <expression>  
        [ <string-interpol-middle>
        <expression> ]*
        <string-interpol-right>
    }

}

# role Constants does Numbers does Strings {
#     token constant {
#         <number> | <string>
#     }
# }
grammar Expression 
does Identifiers 
# does Variables
does Keywords 
does Numbers
does Strings
does Comments 
{

    token TOP { <comment-then-expression> }
 
    token atomic-expression {  <number> | <string> | <mu> | <kuu> | <identifier>   }
    token parens-expression { 
       [ [ <.open-maru> <expression> <.close-maru> ] |
        [ <.open-sumitsuki> <expression> <.close-sumitsuki> ] |
        [ <.open-sen> <expression> <.close-sen> ] ] <.ws>
    }
    token kaku-parens-expression { <.open-kaku> [<list-expression> | <range-expression>] <.close-kaku> }

    token verb-operator-expression { <arg-expression> <.ni>　<arg-expression> <.wo> <operator-verb> }
    token verb-operator-expression-infix { <arg-expression> <operator-verb> <arg-expression> }
    token noun-operator-expression { <arg-expression> <.to-particle>　<arg-expression> <.no> <operator-noun> }

    token operator-expression { 
        <noun-operator-expression> | 
        <verb-operator-expression> | 
        <verb-operator-expression-infix> 
    }
    
    token list-expression { <atomic-expression> [ <.list-operator> <atomic-expression> ]* }
    token map-expression { <atomic-expression> [ <.list-operator> <atomic-expression> ]* <.de> <.zuwotsukuru> | <atomic-expression> '図' }
    token arg-expression-list {
        <arg-expression> [<.list-operator> <arg-expression>]*
    }

    # Keeping it simple: everything needs parens
    token arg-expression {
        <parens-expression> |
        # <apply-expression> | # LOOP, needs parens
        # <lambda-expression> | 
        # <range-expression> |        
        <atomic-expression>         
    }
    token empty {
        <open-kaku><close-kaku>
    }
    token cons-list-expression { <variable> [ <.cons> [<variable>|<kuu>|<empty>]]* } #? [<.cons> [<kuu>|<empty>] ]? }
    
    token variable-list { <variable> [ <.list-operator> <variable> ]* }

    # I need to distinguish between verb expressions and noun expressions
    # suppose I have x de x to x no seki , then it is shite (kudasai)
    # suppose I have x de x ni x wo kakeru , then it should really be x de x ni x wo kakete (kudasai)
    
    token lambda-expression { <.aru> <variable-list> <.de> <expression> }
    # token lambda-application { <expression> 'を'　 [ <shite-kudasai> | <te-kudasai> | <sura> ]? }
    token non-verb-apply-expression {
          <arg-expression-list> <.nominna>? <dake>? 
          <.no> <.comma>?
        [ <arg-expression-list> 
         <.de> <.no> 
        ]??
        [ <operator-noun> | <noun> | <variable> ]  [<.shite-kudasai> | <.sura> ]?
    }
    token verb-apply-expression {
          <arg-expression-list> <.nominna>? <dake>? 
          [ <.wo> ]　
        [ <arg-expression-list> 
         [<.de> | <.no> <.tame> <.ni>] 
        ]??
        [ <verb> | <lambda-expression> [<.shite-kudasai> | <.sura> ]?]
    }
    
    token adjectival-verb-apply-expression {
        [<arg-expression-list> <dake>? <.de> ]? <verb> <arg-expression>
    }
    token apply-expression {
        [
          <arg-expression-list> <.nominna>? <dake>? 
          [ <.wo> | <.no> <.comma>?]　
        [ <arg-expression-list> 
         [<.de> <.no>? | <.no> <.tame> <.ni>] 
        ]?
        [ <identifier> | <lambda-expression> ] [<.shite-kudasai> | <.sura> ]?
        ]
        || [ <non-verb-apply-expression> <.wo> [ <verb> | <lambda-expression>  [<.shite-kudasai> | <.sura> ]? ]]
        || <adjectival-verb-apply-expression>
    }
    token apply-expression-TODO {
         [ <non-verb-apply-expression> <.wo> [ <verb> | <lambda-expression>  [<.shite-kudasai> | <.sura> ]? ]]
         || [<verb-apply-expression> | <non-verb-apply-expression> ]  
    }

    token comment-then-expression {
        <comment>* <expression>
    }

    token expression {        
        [  <lambda-expression>         
        | <let-expression>  
        | <apply-expression>         
        | <operator-expression>
        | <comparison-expression>
        | <function-comp-expression>
        | <map-expression>
        | <ifthen>
        | <string-interpol>
        ] || 
        [ <parens-expression>  
        | <range-expression>
        | <list-expression>
        | <cons-list-expression> 
        | <chinamini-expression>               
        | <atomic-expression>
        # | <comment-then-expression>
        ]
    }

    token chinamini-expression {
        <chinamini> <expression>
    }

    token function-comp-expression {
        <identifier> [<nochi> <identifier>]+
    }
    token range-expression {
        <atomic-expression> <.nyoro> <atomic-expression>
    }

    token comparison-expression {
        <arg-expression> <.ga> <arg-expression> 
        [
          [
            [ <.ni> <hitoshii> [ <.ka> <.yori> [ <sukunai> | <ooi> ] ]? ]        
            | [ <.yori> [ <sukunai> | <ooi> ]  ]  <.desu>?
          ]
        | [ <.ni> <chigau> ]
        ]
    }

    # I wanted to use attara but aru nara|baai fits better in the existing conditions
    token has-expression {
        <identifier> <.ni> <identifier> <.ga-aru>
    }

    token bind-ha { <comment>* [ <noun> | <variable> | <cons-list-expression>] [ <.ha> | <.mo> ]
     [<expression> <zoi>]? 
     <expression>  [<.desu> | <.de> ]? 
     [
        <.delim> 
         || {$*MSG = ', missing delimiter'}
     ]
    }

    token bind-ga { <comment>* [ <noun> | <variable> | <cons-list-expression>] [<.ga> | <.mo> ] [<expression> <zoi>]? <expression> [<.desu> | <.de> ]? <.ws>? }
    
    token kono-let {
        <.kono>  <.ws>? <expression> <.ni> <.ws>? <bind-ga> [<.delim>  <bind-ga>]* <.delim>?
    }
    token kuromaru-let {
         [ <kuromaru> <bind-ha> ]+ <.deha> <.ws>? <expression> <.delim>?
    }

    token let-expression { <kuromaru-let> | <kono-let> }

    # IfThen 
    token condition-expression {
        <has-expression> |
        <operator-expression> |
        <comparison-expression> |
        <apply-expression> |   
        <parens-expression> |
        <atomic-expression>
    }


    token baai-ifthen {
        <condition-expression> <.baaiha>   <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        <.soudenai> <.baaiha> <.comma>? <.ws>? <expression>
    }
    token moshi-ifthen {
        <.moshi>
        <condition-expression>  <.nara> <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        <.soudenai> <.comma>? <.ws>?　<expression> <.desu>?
    }

    token ifthen {
        <moshi-ifthen> |
        <baai-ifthen> 
    }

} # End of Expression

grammar Functions is Expression does Keywords does Punctuation { 
    
    token TOP { <function> }
    token function {
        <comment>*
        [ <verb> | <noun> ] <.toha>
        <variable-list> <.de> <.ws>? 
        <expression> 
        <.function-end>
    }

    token function-end {
         <.ws>? [<no>|<toiu>]? <koto> <desu> <full-stop> <.ws>?
    }
} # End of Functions


grammar Haku is Functions does Comments does Keywords {
    my %token-types is Map = <
        。 delimiter
        、 delimiter
        ： delimiter
        ； delimiter
        は particle
        が particle
        と particle
        の particle
        に particle
        で particle
        を particle
        から  particle
        >;
    token TOP { <haku-program> }
    token haku-program {
        # <comment>
        [<function> | <comment>]*? 
        <hon-definition>
        [<function>| <comment>]*?
    }

    # Behaves like an 'do' but without the monads
    token hon-definition { 
        　<hontoha> 
[ 
            | <bind-ha> 
            | <comment-then-expression> <.delim>
            # | <comment>
          ]*?
          <comment-then-expression> <.delim>?
        <.function-end>                 
    }


    method error($target) {
        my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
        # What I should do is split this substring on newlines, and only use the limitation if there are none
        my $context = $target.substr($*HIGHWATER+1);#, 4 max 0);
        my @context_lines = $context.lines;
        if @context_lines.elems == 1  {
            $context = $target.substr($*HIGHWATER+1, 4 max 0);
        } else { # if there are multiple lines after the highwater mark,
            if @context_lines[0].chars < 30 { # take the whole line if it is < 30 chars
                $context = @context_lines[0] ~ "\n\t";
            } else { # otherwise truncate
                $context = @context_lines[0].substr($*HIGHWATER+1, 4 max 0) ~ "...\n\t";
            }
        }
                
        my $pos = $parsed.chars;
        # TODO: make this more general
        if $*MSG ~~ /delimiter/ {
            $context = @context_lines[0] ~ "⏏" ~ "\n\t";
        }

        my $msg = "Error: Cannot parse Haku expression" ~ $*MSG;
        $msg ~= "; error in rule $*LASTRULE" if $*LASTRULE;
        my @parsed_lines = $parsed.lines;
        my $char_counter =0;
        my $line_counter=0;
        my @ann_parsed_lines=();
        for @parsed_lines -> $parsed_line {
            ++$line_counter;
            last if $char_counter > $pos;
            $char_counter += $parsed_line.chars;
            @ann_parsed_lines.push($line_counter ~ "\t" ~ $parsed_line);
        } 
        my $parsed_annotated_context = @ann_parsed_lines[*-3 .. *].join("\n") ;
        my $token-type = %token-types{$*PARTICLE};
        # FIXME: This is weak, will break if there are two expressions on a single line
        # There must be a check that the position is at the end of a line
        # if $token-type eq 'delimiter' {
        #     ++$line_counter;
        #     $context = @context_lines[0] ~ "\n$line_counter\t⏏" ~ @context_lines[1]  ~ "\n\t";
        # }        
        say "$msg after $token-type $*PARTICLE on line $line_counter:\n\n" ~ $parsed_annotated_context ~ $*PARTICLE ~ "⏏" ~$context~"...\n";    
        # exit;
    }

    method parse($target, |c) {
        my $*HIGHWATER = 0;
        my $*PARTICLE= '';
        my $*LASTRULE;
        my $*MSG='';

        my $match = callsame;
        self.error($target) unless $match;
        return $match;
    }

    method subparse($target, |c) {
        my $*HIGHWATER = 0;
        my $*PARTICLE= '';
        my $*LASTRULE;
        my $*MSG='';
        my $match = callsame;
        self.error($target) unless $match;
        return $match;
    }

# for error messages, later.
    # method token-error($msg) {
        # my $parsed = self.target.substr(0, self.pos).trim-trailing;
        # my $context = $parsed.substr($parsed.chars -  2 max 0)
        #     ~ '⏏' ~ self.target.substr($parsed.chars, 2);
        # my $line-no = $parsed.lines.elems;
        # say "Cannot parse expression: $msg\n"
        #     ~ "at line $line-no, around " ~ $context
        #     ~ "\n(error location indicated by ⏏)\n" ;
        #     exit;
    # }

} # End of Haku
