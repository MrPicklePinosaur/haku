# Haku, a toy functional programming language based on Japanese

use v6;
# use Grammar::Tracer;

our $reportErrors = True;

role Characters {


    # I might allow A-Z as well for identifiers
    token dai-romaji {
        <[A..Z]>
    }    
    token ko-romaji {
        <[a..z]>
    }    
    
    
    # I might allow ordinary digits in identifier names
    token digits {
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' 
    }    


    token word {
        \w
    }
} # End of role Characters

# I think I will use the full stop and semicolon as equivalent for newline.
role Punctuation {

    token full-stop { ';' 
        { self.highwater(';'); }
    }
    token comma { ','
        { self.highwater(','); }
    }
    token semicolon { ';' 
        { self.highwater(';'); }
    }    
    token colon { ':' 
        { self.highwater(':'); }
    }
    token interpunct { ':' } # nakaguro 
      
    token punctuation { <full-stop> | <comma> | <semicolon> | <colon> }
    token delim { 
            [<full-stop> | <comma> | <semicolon>] <ws>?
    }
    # kuromaru is not full-width!
    # So I use 'period' as alternative
    token kuromaru { '*'  }
    # Marukakko (丸括弧) 
    token open-maru { '(' }
    token close-maru { ')' }
    # Namikakko (波括弧)
    token open-nami { '{' }
    token close-nami { '}' }

    # Kakukakko (角括弧)
    token open-kaku {  '[' }
    token close-kaku {  ']' }

    token open-sen { '<' }
    token close-sen { '>' }


}  # End of role Punctuation

role Particles {

    token ga { ' ga ' 
        { self.highwater( ' ga ' ); }
    }
    token ha { ' ha ' 
        { self.highwater( ' ha ' ); }
    }
    token no { ' no ' 
        { self.highwater( ' no '); }
    }
    token to-particle { ' to ' }

    token mo { ' mo ' }

    token wo { ' wo ' 
        { self.highwater( ' wo '); }
    }
    token de { ' de ' 
        { self.highwater( ' de '); }
    }
    token ni { ' ni ' 
        { self.highwater( ' ni '); }
    }
    token ka { ' ka ' }
    token kara { ' kara ' 
        { self.highwater( ' kara ' ); }
    }
    token made-particle { ' made ' }
    token deha { ' deha ' }
    token node { ' node ' }
    token noha { ' noha ' }
    token dake { ' dake ' } 
        
    method highwater($p) {
        # if self.pos > $*HIGHWATER {
        #     $*HIGHWATER = self.pos;
        #     $*PARTICLE = $p;
        #     $*LASTRULE = callframe(1).code.name;
        # }
    }

}  # End of role Particles

role Nouns does Characters {
    token noun { <dai-romaji> <ko-romaji>+ }
}

# の-adjectives are not supported because there is a fundamental ambiguity in function application:
# e.g.
# ORENJI no Densha => (ORENJI Densha)
# but
# MAPPU no Nagasa => (Nagasa MAPPU)
# In these examples, ORENJI and MAPPU are nouns in my Grammar
role Adjectives does Characters {


    token i-adjective {
        <noun> 'i'
    }

    # A na-adjective is treated as a Noun unless it is followed by な
    token na-adjective { <noun> 'na' }

    token adjective {
        <i-adjective> | <na-adjective>
    }
}

role Verbs does Characters {
    token verb-ending {
        <sura> || <verb-ending-masu> || [
        'ru'| 'su'| 'mu'| 'ku'| 'gu'| 'tsu'| 'nu' | 'u' |
        'tta'| 'ta'| 'ida'| 'nda' |  
         'tte'| 'te'| 'ide' | 'nde' 
        ]

    }
    token verb-ending-dict {
        'ru'| 'su'| 'mu'| 'ku'| 'gu'| 'tsu'| 'nu' | 'u' 
    }
    token verb-ending-masu {
        'ma' [[　'su'　| 'shita'| 'shou'] | 'sen'] 'ka'?
    }
    token verb-ending-ta {
        'tta'| 'ta'| 'ida'| 'nda'
    }
    token verb-ending-te {
        'tte'| 'te'| 'ide' | 'nde'
    }    
    
    token verb-stem {
        <dai-romaji> <ko-romaji>+? <?before <verb-ending> >
    }
    token verb-dict { <verb-stem> <verb-ending-dict> }
    token verb-masu { <verb-stem> <verb-ending-masu> }
    token verb-ta { <verb-stem> <verb-ending-ta> }
    token verb-te { <verb-stem> <verb-ending-te> }
    token verb-sura { <verb-stem> <sura> }

# This fails on e.g. su.teru because the te is seen as -te form
# We should have a rule for a -te after a kanji and before te/ru/masu/ta 
# su.tete, su.teru <>  ki.te
# but to complicate it : wasu.rekakete(i)ta
    token verb { 
        <verb-te> [ <.kureru> | <.morau> ]? [<.kudasai> | <.shimau> | <.imashita>]?
     || <verb-sura>
     || [
          <verb-dict> 
        | <verb-masu> 
        | <verb-ta>        
        ]
    }

}  # End of role Verbs

role Variables does Characters {
    # Variables must start with katakana then katakana, number kanji and 達 
    # But kanji with a "haku" on-reading are also supported.
    token variable { 
        <dai-romaji> 
        [ <dai-romaji>  | <digit>  ]* <tachi>? 
    }
    # To indicate plural
    token tachi { 'tachi' }    
}

role Identifiers 
does Verbs 
does Nouns 
does Adjectives 
does Variables 
{
    token nominaliser {
        <.mo>? <no> <!before <koto> > |<koto> <!before <desu> > 
    }
    # Identifiers are variabletoken ides noun-style and verb-style function names
    token identifier { <variable> | <verb> <nominaliser>? | <noun> <.sura>? | <adjective> }
    token adjectival {
        <verb> | <adjective>
    }

}

role Auxiliaries {
    token kudasai { 'kudasai' }    
    token masu { 'ma' [ 'su' | 'shita' ] }

    token shite-kudasai { 'shitekudasai' }
    token suru { 'suru'  | 'shita' }
    token shimasu { 'shima'  [ 'su' | 'shita' ] }
    token sura {
        <.ws>? [ <suru> | <shimasu> | <shite-kudasai> ] 
    }
    token desu { <.ws>? [ 'desu' | 'da' | 'dearu' | 'degozaimasu' ] }

    token shimau { 'shima' ['u' | ['t'|'imashi'] 'ta'] };            
    token kureru { 'kure'　[ 'te' | 'ta' | <masu> ]};
    token morau { 'mora' [ 'tte' | 'tta' | 'i' <masu> ]}
    token imashita { ['i']? ['mashi']? 'ta' }
    
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
    # Arithmetic
#                         +       -      *      /
    token operator-noun { 'Wa' | 'Sa' | 'Seki' | 'Jo' } # TODO could add 余 remainder
    token operator-verb-kanji { ' Ta' | ' Hi' | ' Kake' | ' Wa' } # TODO could add 残る remainder
    token operator-verb { <operator-verb-kanji> <verb-ending> }    
    # List separator operator
    token list-operator { <ni> | <to-particle> | <kara> | <made-particle> } # NOT comma, conflicts with delimiter! }
    # Function composition
    token nochi { ' nochi ' } # g . f but note order is opposite
    # The \ operator
    token aru { 'aru ' } 
    # The cons operator
    token cons { <interpunct> | <colon> }

    # For Ranges (..)
    token nyoro { '~' }

    # For Comparisons 
    token hitoshii { 'hitoshii' } # ==
    token yori { ' yori ' } 
    token ooi { 'ooi' }    # >
    token sukunai { 'sukunai' } # <

    # Maybe technically this is not an operator?
    token chinamini { 'chinamini ' }
    token zoi { ' zoi ' }
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
    token kuu { 'Kuu' }
    # For Nil
    token mu { 'Mu' }
    token mugendai { 'Mugendai' }    

    # For Let
    token kono {
        'kono '
    }
    # See design doc
    token moshi { 
        [ 'moshi' ] <mo>?　<ws>?
    }
    token nara { ' nara ' }
    token tara { ' tara ' }

    token dattara { 'dattara' }
    token moshi-nanira { <dattara> |　<tara> | <nara> }         

    # For IfThenElse'

    token kedo { 'kedo' | 'keredo' <mo>? }
    token baaiha { 'baaiha' }
    token soudenai { 'soudenai' }
    token soudenakereba { 'soudenakerab' }

    # For Maps and Folds

    token nokaku { 'no kaku' }
    token nominna { 'no minna' }
    token shazou { 'Shazou' <sura> }     
    token tatamikomu { 'Tatamiko' <mu-endings> }

    # For IO
    # ファイルを{読む|書く}のために開く
    # ハンドル を  開く | 閉じる
    token tame { 'tame' }

    # For Function and Hon    
    token toha { ' toha' }
    token toiu { ' toiu '  }
    token koto { 'koto'  }

    # For Haku
    token hon {'Hon'} 
    token ma {'ma'} 
    token hontoha {
        <hon> <ma>? <.toha> <.ws>? 
    }

    # # Built-in verbs, I suspect this is unused
    # token u-endings {
    #     'う' | 'って' <kudasai>? | 'い' <masu>
    # }
    # token mu-endings {
    #     'む' | 'んで' <kudasai>? | 'み' <masu>
    # }

    # token ru-endings {
    #      'る' | 'て' <kudasai>? | 'り' <masu>
    # }

    # token ku-endings {
    #      'く' | 'いて' <kudasai>? | 'き' <masu>
    # }

    # token tsu-endings {
    #      'つ' | 'って' <kudasai>? | 'ち' <masu>
    # }

    # # Say
    # token miseru { '見せ' <ru-endings> }

    # # Built-in nouns

    # # List operations; strings are lists.
    # # length
    # token nagasa { '長さ' }
    # # reverse:  
    # #配列を反転する
    # #リストの逆引き　
    
    # # head, 
    # token atama { '頭' }
    # # tail, 
    # token shippo  { '尻尾' }
    # # concatenation     
    # token awaseru { '合わせ' <ru-endings> }
    # # split
    # token waru { '割' <ru-endings> }
 
    
    # # Map operations
    
    # # length 長さ , see above
    
    # has　マップにカギがあったら
    token attara { 'attara' }
    token ga-aru { 'ga aru'  }
    
    # #insert　マップにカギとバリューを入れる
    # token ireru { '入れ' <ru-endings> }

    # #lookup　マップにカギを正引きする:探索する
    # token seibiki { '正引き' <suru> }
    # token tansaku { '探索' <suru> }
    
    # #delete　マップからカギを消す
    # token kiesu { '消' <su-endings> }
    
    # #keys    マップの鍵
    # token kagi { '鍵' }
    
    # #values  マップの対応値:w
    # token chi { '値' }

    # empty map 空 

    # map creation (from a list) で図を作る 
    # I could use 連想配列 rensouhairetsu but that is really long.
    token zuwotsukuru { 'Zu wo Tsuku' <ru-endings> }


    # File operations
    # token akeru { '開け' <ru-endings> }
    # token shimeru { '閉め' <ru-endings> }
    # token kaku { '書' <ku-endings> }
    # token yomu { '読' <mu-endings> }

    # For comparisons, TODO
    token chigau { 'Chiga' <u-endings> }
    
    # System call, TODO    
    token kikan { 'Kikan' } #で「ls」する

} # End of role Keywords

# Comment line: 註 or 注 or even just 言, must end with .
role Blanks {
    token blank {  '　' | ' ' | \n | \t }
}

role Comments does Punctuation does Blanks {
    token comment-start { 'Chuu '  }
    token comment-chars { 
         <word> | <blank> | '.' | ':' | '/' | '-'  | '#'
    }
    token comment { <.comment-start> <comment-chars>+ <.full-stop> <.ws>? }
}

role Numbers does  Characters {
    token zero {  'zero' | 'maru'  } # '〇' | '零'  are in number-kanji
    token minus {'MAINASU'}
    token plus {'PURASU'}
    token integer { <digit> + }
    token signed-integer { (<minus> | <plus>) <integer> }
    token ten { 'Ten' }
    token rational { <signed-integer>+ <.ten> <integer>+ }
    token number { 
        <rational> | <signed-integer> | <integer> 
    }
}

role Strings does Characters {
    token string-chars { # rather ad-hoc
         <hiragana> 
         | <katakana>
         | <kanji> |  ' ' | '　' | \n | <[! .. ~]>
    }
    token string { 
         '""' |
         "''" |    
        [ '"'  <string-chars>+ '"' ] |
        [ "'"  <string-chars>+ "'" ]         
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

grammar Expression 
does Identifiers 
does Keywords 
does Numbers
does Strings
does Comments 
{

    token TOP { <comment-then-expression> }
 
    token atomic-expression {  <identifier> | <number> | <string> | <mugendai> | <mu> | <kuu>     }
    token parens-expression { 
       [ [ <.open-maru> <expression> <.close-maru> ] |
        # [ <.open-sumitsuki> <expression> <.close-sumitsuki> ] |
        [ <.open-sen> <expression> <.close-sen> ] ] 
        #<.ws>? TODO: support newline!
    }
    token empty {
        <open-kaku><close-kaku>
    }
    token cons-elt-expression { <kaku-parens-expression> | <variable>|<kuu>|<empty> } 
    token cons-list-expression { <cons-elt-expression> [ <.cons> <cons-elt-expression> ]+ } 

     
    token list-elt-expression {
        <kuu>|<empty>|<atomic-expression> | <kaku-parens-expression>
    }
    # TODO: this means that a list of empty lists is not possible
    token list-expression { 
        <kuu>|<empty>| [
        <list-elt-expression>
        [ <.list-operator> <list-elt-expression> ]+ ] 
    }

    token kaku-parens-expression { <.open-kaku> [
        <cons-list-expression> | 
        <list-expression>  |
        <atomic-expression> |
        <range-expression> |
        <kaku-parens-expression>
        ] <.close-kaku> }

    # Keeping it simple: everything needs parens
    token arg-expression {
        <parens-expression> |        
        <kaku-parens-expression> |
        <range-expression> | # Should be safe
        <atomic-expression>         
    }
    
    token arg-expression-list {
        <arg-expression> [<.list-operator> <arg-expression>]*
    }

    token verb-operator-expression { <arg-expression> <.ni>　<arg-expression> <.wo> <operator-verb> }
    token verb-operator-expression-infix { <arg-expression> [<operator-verb> <arg-expression>]+ }
    token noun-operator-expression { <arg-expression-list> <.no> <operator-noun> }

    token operator-expression { 
        <noun-operator-expression> | 
        <verb-operator-expression> | 
        <verb-operator-expression-infix> 
    }
    
    token map-expression { <atomic-expression> [ <.list-operator> <atomic-expression> ]* <.de> <.zuwotsukuru> | <atomic-expression> 'Zu' }
    
    token variable-list { <variable> [ <.list-operator> <variable> ]* }

    # I need to distinguish between verb expressions and noun expressions
    # suppose I have x de x to x no seki , then it is shite (kudasai)
    # suppose I have x de x ni x wo kakeru , then it should really be x de x ni x wo kakete (kudasai)
    
    token lambda-expression { <.aru> <variable-list> <.de> <expression> }

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
    token adjectival-apply-expression {
        [<arg-expression-list> <dake>? <.de> ]? <adjectival>+ <arg-expression> 
    }
    token apply-expression {
        [
          <arg-expression-list> <.nominna>? <dake>? 
          [ <.wo> | <.no> <.comma>?]　
        [ <arg-expression-list> 
         [<.de> <.no>? |  <.tame> <.ni>] # was <.no> <.tame> <.ni>
        ]?
        [ <identifier> | <lambda-expression> ] [<.shite-kudasai> | <.sura> ]?
        ]
        || [ <non-verb-apply-expression> <.wo> [ <verb> | <lambda-expression>  [<.shite-kudasai> | <.sura> ]? ]]
        || <adjectival-apply-expression>
    }
    token apply-expression-TODO {
         [ <non-verb-apply-expression> <.wo> [ <verb> | <lambda-expression>  [<.shite-kudasai> | <.sura> ]? ]]
         || [<verb-apply-expression> | <non-verb-apply-expression> ]  
    }

    token comment-then-expression {
        <comment>* [<bind> || <expression>]
    }

    token expression {        
        [ <lambda-expression>         
        | <let-expression>  
        | <apply-expression>         
        | <operator-expression>        
        | <function-comp-expression>
        | <map-expression>
        | [<ifthen> || <comparison-expression>]
        | <string-interpol>
        ] || 
        [ <parens-expression>  
        | <range-expression>        
        | [<cons-list-expression>||<kaku-parens-expression>]
        |<list-expression>|<atomic-expression>
        | <chinamini-expression>                       
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

    token bind-ha { 
        <comment>* 
        [ <noun> | <variable> | <cons-list-expression>] [ <.ha> | <.mo> ]
     [<expression> <zoi>]? 
     <expression> [<.desu> | <.de> ]? 
     [
        <.delim> 
        #  || {$*MSG = ', missing delimiter'}
     ]
    }

    token bind-ga { <comment>* [ <noun> | <variable> | <cons-list-expression>] [<.ga> | <.mo> ] 
    [<expression> <zoi>]? 
    <expression> [<.desu> | <.de> ]? <.ws>? 
    }

    token bind {
        <bind-ha> | <bind-ga>
    }
    
    token kono-let {
        <.kono>  <.ws>? <expression> <.ni> <.ws>? <bind-ga> [<.delim>  <bind-ga>]* <.delim>?
    }
    token kuromaru-let {
         [ <kuromaru> <bind-ha> ]+ <.deha> <.ws>? <expression> <.delim>?
    }

    token let-expression { <kuromaru-let> | <kono-let> }

    # IfThen 
    token condition-expression {
        <comparison-expression> ||
        [
        <has-expression> |
        <operator-expression> |
        <apply-expression> |   
        <parens-expression> |
        <atomic-expression>
        ]
    }

    token baai-ifthen {
        <condition-expression> <.baaiha> <.comma>? <.ws>? 
        <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        <.soudenai> <.baaiha> <.comma>? <.ws>? <expression> <.desu>?
    }

    token moshi-ifthen {
        <.moshi>
        <condition-expression>  <.nara> <.comma>? <.ws>? <expression> [<.desu> [<.ga> | <.kedo> ]]? <.comma>? <.ws>?
        [<.soudenai>|<.soudenakereba>] <.comma>? <.ws>?　<expression> <.desu>?
    }

    token ifthen {
        <moshi-ifthen> |
        <baai-ifthen> 
    }

} # End of Expression

grammar Functions is Expression 
does Keywords 
does Punctuation 
{ 
    
    token TOP { <function> }
    token function {
        <comment>*
        [ <adjectival> || <noun>] <.toha> <.ws>? 
        [<variable-list> <.de> <.ws>?]? 
        <expression> 
        <.function-end>
    }

    token function-end {
         <.ws>? [<no>|<toiu>]? <koto> <desu> <full-stop> <.ws>?
    }
} # End of Functions


grammar Roku is Functions 
does Comments 
does Keywords 
{
    # For error messages
    my %token-types is Map = <
        . delimiter
        , delimiter
        : delimiter
        ; delimiter
        ha particle
        ga particle
        to particle
        no particle
        ni particle
        de particle
        wo particle
        kara particle
        >;

    token TOP { <haku-program> }
    token haku-program {
        <.ws>?
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
        #     ++$line_counter;k
        #     $context = @context_lines[0] ~ "\n$line_counter\t⏏" ~ @context_lines[1]  ~ "\n\t";
        # }        
        say "$msg after $token-type $*PARTICLE on line $line_counter:\n\n" ~ $parsed_annotated_context ~ $*PARTICLE ~ "⏏" ~$context~"...\n";    
        exit;
    }

    # method parse($target, |c) {
    #     my $*HIGHWATER = 0;
    #     my $*PARTICLE= '';
    #     my $*LASTRULE;
    #     my $*MSG='';

    #     my $match = callsame;
    #     if $reportErrors {
    #         self.error($target) unless $match 
    #     }
    #     return $match;
    # }

    # method subparse($target, |c) {
    #     my $*HIGHWATER = 0;
    #     my $*PARTICLE= '';
    #     my $*LASTRULE;
    #     my $*MSG='';
    #     my $match = callsame;
    #     if $reportErrors {
    #         self.error($target) unless $match;
    #     }
    #     return $match;
    # }

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
