use v6;

=begin pod
This module contains the functionality to convert verbs into their dictionary form.
We use the verb stem and kanji following the stem to identify the type of verb and its form.

For example 
｢着ます｣
｢着きます｣

The stemmer will give 着

  verb-stem => ｢着｣
  hiragana => ｢ま｣
  verb-ending-dict => ｢す｣

  verb-stem => ｢着｣
  hiragana => ｢き｣
  verb-ending-masu => ｢ます｣  

So we look up 着
From 'ri' we get 'ru';  from 'ki' we get 'ku'

So we have 着る or 着く. If this is a defined function, we're done. If not, we go to the dictionary.

So we find ki.seru, ki.ru and tsu.ku, tsu.keru
I think I can safely take the version with the shortest stem. 
'着' ,<きせる きる つく つける>,

｢間違います｣
 verb-masu => ｢間違います｣
  verb-stem => ｢間違｣
   non-number-kanji => ｢間｣
   kanji => ｢違｣
  hiragana => ｢い｣
  verb-ending-masu => ｢ます｣

So we should take the last character of the stem and look that up

'違' ,<ちがう ちがえる>,

Then the 'i' gives us 'u' from the table, so we have 違う
So looking up the entry which ends in 'u', we get chiga.u





For example 
着らない
着かない

｢写像して｣
 verb-te => ｢写像して｣
  verb-stem => ｢写像｣
   non-number-kanji => ｢写｣
   kanji => ｢像｣
  verb-stem-hiragana => ｢し｣
   hiragana => ｢し｣
  verb-ending-te => ｢て｣

This is incorrect: it will lead to 写像す instead of 写像する
So I think for any verb ending in su, we should test suru as well.

    token verb-dict { <verb-stem> <verb-stem-hiragana>? <verb-ending-dict> }
    token verb-masu { <verb-stem> <hiragana>*? <verb-ending-masu> }
    token verb-ta { <verb-stem> <hiragana>*? <verb-ending-ta> }
    token verb-te { <verb-stem> <verb-stem-hiragana>? <verb-ending-te> }
    token verb-sura { <verb-stem> <verb-stem-hiragana>?  <sura> }

    # token imashita { ['い']? ['まし']? 'た' }
    
    # all these are Auxiliaries I guess
    token iru { 'い'? [ <masu> | 'る' }
    token kuru { ['く'|'来'] 'る' | ['来'|'き'] [<masu>|'た'|'て'　}
    token iku { ['い'|'行'] ['く' | 'き' <masu> | 'った' | 'って' }
    
    token tarari {
        'た' [　'ら'　|　'り' ]?
    }
    token verb-ending-tai {
        'た' 'くな'? [ 'い | 'かった' ]        
    }

    token after-te-verbs {
        | [<.kureru> | <.morau> ]? [<.kudasai> 
        | <.shimau> 
        | <.iru> 
        | <.kuru>
        | <.iku>
    }

    token verb-ending-a {
        | 'ない' 'で'? <.after-te-verbs>? 
        | 'なかっ' <tarari>        
        | 'なければ' 
        | [　'せ'　| 'れ' ]　[　'ば'　|　'る'　|　<masu>　|　'た'　|　'て'　<.after-te-verbs>? ] 
    }  
    token verb-a { <verb-stem> <hiragana-a>?  <verb-ending-a>  }

    token verb-ending-e {
        | 'れ' [　'ば'　|　'る'　|　<masu>　|　'た'　|　'て'　<.after-te-verbs>? ]
    }  
    token verb-e { <verb-stem> <verb-stem-hiragana>?  <verb-ending-e>  }

So first we try if they are ichidan, and if that fails we treat them as godan

But first-first, we should make sure we can parse these forms


=end

my %dict-ending-for-te-form is Map = {
    'いて' =>　<く>,
    'って' =>　<う　つ　る>,
    'して' =>　<す>,
    'んで' =>　<む　ぬ　ぶ>,
    'いで' =>　<ぐ>
};

my %dict-ending-for-ta-form is Map = {
    'いた' =>　<く>,
    'った' =>　<う　つ　る>,
    'した' =>　<す>,
    'んだ' =>　<む　ぬ　ぶ>,
    'いだ' =>　<ぐ>
};
# not just masu, also tai!
my %dict-ending-for-masu-form is Map = {
    'き' =>　<く>,
    'ち' =>　<つ>,
    'い' =>　<う>,
    'り' =>　<る>,
    'し' =>　<す>,
    'み' =>　<む>,
    'に' =>　<ぬ>,
    'び' =>　<ぶ>,
    'ぎ' =>　<ぐ>
};
# other forms are a, e and o
# a-form is nai, nakatta, passive (-rareru), causative (-saseru)
my %dict-ending-for-a-form is Map = {
    'か' =>　<く>,
    'た' =>　<つ>,
    'わ' =>　<う>,
    'ら' =>　<る>,
    'さ' =>　<す>,
    'ま' =>　<む>,
    'な' =>　<ぬ>,
    'ば' =>　<ぶ>,
    'が' =>　<ぐ>
};

# e-form is potential ( -reru, 'can' ), conditional (-eba, 'if'),
my %dict-ending-for-e-form is Map = {
    'け' =>　<く>,
    'て' =>　<つ>,
    'え' =>　<う>,
    'れ' =>　<る>,
    'せ' =>　<す>,
    'め' =>　<む>,
    'ね' =>　<ぬ>,
    'べ' =>　<ぶ>,
    'げ' =>　<ぐ>
};
# o-form is volitional
my %dict-ending-for-o-form is Map = {
    'こ' =>　<く>,
    'と' =>　<つ>,
    'お' =>　<う>,
    'よ' =>　<る>,
    'ろ' =>　<る>,
    'そ' =>　<す>,
    'も' =>　<む>,
    'の' =>　<ぬ>,
    'ぼ' =>　<ぶ>,
    'ご' =>　<ぐ>
};