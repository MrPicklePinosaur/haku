use v6;

# Haku, a toy functional programming language based on Japanese


role Characters {
   token character {
       <kanji> | <katakana> | <hiragana> | <romaji>
   }
    token kanji {  
        # Using Block hangs
        # <:Block('CJK Unified Ideographs') - reserved-kanji >
        <:Block('CJK Unified Ideographs')>     
    }    

    
    token haku-kanji {
        '白' | '泊' | '箔' | '伯' | '拍' | '舶' | 
        '迫' | '岶' | '珀' | '魄' | '柏' | '帛' | '博'
    }

    token katakana { 
        # Using Block hangs
        <:Block('Katakana')> 
        # <[ア..ヲ]>
    }

    # I might allow A-Z as well for identifiers
    token romaji {
        <[A..Z]>
    }
    # "１".uniprop('Block');
    # Halfwidth and Fullwidth Forms
    # 算用数字
    token sanyousuji {
        '０' | '１' | '２' | '３' | '４' | '５' | '６' | '７' | '８' | '９'
    }
    
    # I might allow ordinary digits in identifier names
    token digits {
        '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' 
    }    

    token hiragana {
        # Using Block hangs
        <:Block('Hiragana')>
        # <[あ..を]>
    }    
}

grammar Test does Characters {
   token TOP {
       <character>
   } 
}

for ('a','A','あ','ア','亜') -> $c {
    my $p = Test.parse($c);
    say $p;

}