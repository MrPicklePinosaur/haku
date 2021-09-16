use v6;

grammar Test {
 token TOP { <kanji>+ }
 token reserved-kanji {
        '或' |
        '和' | 
        '本' | 
        '事'  
 }
   
 token number-kanji { 
    '一' | '二' | '三' | '四' | '五' | '六' | '七' | '八' | '九' | '十' 
 }   
 token kanji {  
    <:Block('CJK Unified Ideographs') - reserved-kanji >
 }
 
 token wahon {
    <[和本]>+
 }

 
 token non-number-kanji {
     <reserved-kanji> && !<wahon>
 }
    
} 

#say Test.parse('和本');
#say Test.parse('邪魔') ;
#say Test.parse('邪魔',:rule('wahon')) ;
say Test.parse('和本',:rule('non-number-kanji'));
say Test.parse('邪魔',:rule('non-number-kanji'));
say Test.parse('或事',:rule('non-number-kanji'));

