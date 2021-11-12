use v6;
use HakuDict;
use HakuKanjiDict;

our $V = True;

my %dictionary := dictionary;
my %joyo_kun_verb_readings := joyo_kun_verb_readings;



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

=begin pod
TODO: plain volitional is not supported
Strategy for normalisation:
0. If the verb is parsed as verb-dict, we're done
1. Treat the verb as ichidan.
That means that we have a fixed stem + any ending

    token verb { 
        <verb-te> 
     || <verb-sura>
     || <verb-na>
     || [
          <verb-dict> 
        | [<verb-masu> | <verb-tai> | <verb-kakeru>]
        | <verb-ta>    
        
        ]
    }

=end pod

sub normalise-verb ($verb-match, %defined-verbs) is export {
    # say "VERB: " ~ $verb-match.Str;
    if $verb-match<verb-dict> {        
        return $verb-match.Str
    } else {
        
        my $vm1 = $verb-match<verb-te> // $verb-match<verb-sura> // $verb-match<verb-tai> // $verb-match<verb-kakeru>;
        my $vm2 =  $verb-match<verb-na> // $verb-match<verb-masu> // $verb-match<verb-ta> ;
        my $vm = $vm1 // $vm2;
        
        my $stem = $vm<verb-stem>;
        my $is-ichidan = True;
        # Then, treat it as noun + suru
        if $verb-match<verb-sura> { 
            my $maybe-noun = $stem ~ ($vm1<verb-stem-hiragana> // '');
            if %defined-verbs{$maybe-noun~ 'する'}:exists or %dictionary{$maybe-noun}:exists {
                say "Noun + suru" if $V;
                return $maybe-noun ~ 'する';
            }
            # Assuming it really is suru, because sareru is valid for godan as well
            # So we should lookup the stem in the dict            
        }
      
        # Then, treat it as ichidan        
        # But this needs refining. 
        # E.g. wasu.reru is ichidan, and so wasu.remasu also. In fact, the -re is
        # just like the -be in ta.beru
        # So we need to make sure it is treated as such. 
        
        # For example tabe.saseru and kurikae.saseru 
        # Problem is that kurikae.ru actually exists, but that should have been kae.raseru
        # Whereas for tabe.saseru, tabe.ru is fine.
        my $maybe-ichidan-verb-hiragana = $vm1 ?? ($vm1<verb-stem-hiragana> // '')
        !! $vm2 ?? ($vm2<hiragana> // '')  !! die 'No match: ' ~ $verb-match.Str;
        
        my $hiragana = $maybe-ichidan-verb-hiragana ~ 'る' ;
        if $verb-match<verb-te> and $vm1<verb-stem-hiragana> ~ $vm1<verb-ending-te> ~~/ないで/
        { # -te form of -nai form
            $hiragana = ($vm1<verb-stem-hiragana> ~ $vm1<verb-ending-te>).substr(0,*-3)  ~ 'る';
            say "-te form of -nai form: $hiragana" if $V;
        }        
        my $maybe-ichidan-verb = $stem ~ $hiragana;
        say "Maybe ichidan: $maybe-ichidan-verb" if $V;
        # So now we need to look this up. First in %defined-verbs
        if %defined-verbs{$maybe-ichidan-verb}:exists or %dictionary{$maybe-ichidan-verb}:exists {
            return $maybe-ichidan-verb
        } 
        
        # else {
        #     # We'd better skip this and keep it as a last resort
        #     # If that fails, try the kanji dictionary
        #     # For that we need the last character of the stem
        #     say "Looking up ichidan VERB via kanji dict: $stem|$hiragana";
        #     my $res = lookup-in-kanji-dict($stem,$hiragana);
        #     if $res {
        #         say "Found ichidan VERB in kanji dict: $res";
        #         return $res 
        #         }
        # }
        # If we are here it means there was no match when assuming the verb was ichidan
        say 'Not ichidan: ' ~ $verb-match.Str if $V;        
        if $verb-match<verb-na> {
            say "Godan -na form: " ~ $verb-match.Str if $V;
            my $stem-hiragana = $stem ~ ($vm2<hiragana> // '');
            if %defined-verbs{ $stem-hiragana }:exists or %dictionary{$stem-hiragana}:exists {
                say "Found stem as noun in dict: " ~ $stem-hiragana if $V;
                return  $stem-hiragana ~ 'する';
            }
            my $hiragana = $vm2<hiragana> ?? $vm2<hiragana>[*-1] !! '';
            my $verb-ending = $vm2<verb-ending-na>;
            # say "Godan verb ending: " ~ $verb-ending　~ ' <> ' ~$vm2<hiragana> ~ ' <> ' ~ $hiragana;
            # Not quite sure about this but worth a try:
            say  $vm2<hiragana> ~ " ; " ~ $vm2<verb-ending-na> if $V;
            my $dict-ending = do {
                if $hiragana {
                    %dict-ending-for-a-form{$hiragana} 
                }                
                else {
                    my $verb-ending-start =  $verb-ending.substr(0,1);
                    if %dict-ending-for-a-form{$verb-ending-start}:exists {
                        say "Verb ending is -a: $verb-ending-start" if $V;
                        %dict-ending-for-a-form{$verb-ending-start}
                    } 
                    elsif %dict-ending-for-e-form{$verb-ending-start}:exists {
                        say "Verb ending is -e: $verb-ending-start" if $V;
                        %dict-ending-for-e-form{$verb-ending-start}
                    } 
                    else {                  
                        say "Fallback: last char of verb ending " ~ $verb-ending.substr(*-1) if $V;
                        $verb-ending.substr(*-1)
                    }
                }
            };
            say "Godan hiragana: " ~ $hiragana ~ ' => ' ~  $dict-ending if $V;
            my $verb-stem-hiragana = $vm2<hiragana>.elems > 1 ??  $vm2<hiragana>[0..*-1].join('') !! '';
            return $stem ~ $verb-stem-hiragana ~ $dict-ending;
        }
        elsif $verb-match<verb-te> {
            say "Godan -te form: " ~ $vm.Str if $V;
            
            my $hiragana = $vm1<verb-stem-hiragana> ~ $vm1<verb-ending-te>;
            if %defined-verbs{$stem}:exists or %dictionary{$stem}:exists {
                return $stem ~ 'する';
            }
            my $dict-ending = %dict-ending-for-te-form{$hiragana}//[];
            
            for |$dict-ending -> $ending {                
                my $maybe-godan-verb = $stem ~ $ending;
                if %defined-verbs{$maybe-godan-verb}:exists or %dictionary{$maybe-godan-verb}:exists {
                    say "Godan -te via dict lookup: " ~ $maybe-godan-verb if $V;
                    return $maybe-godan-verb;
                } else {                    
                    my $res =  lookup-in-kanji-dict($stem,$ending);
                    if $res {
                        say "Godan -te via kanji dict lookup" if $V;
                        return $res 
                        }
                }
            }            
            # It is possible that this -te form is a te form of a -nai form
            if $vm.Str ~~ /ないで/ {
                say $hiragana;
                # I guess to be correct it should be 
                my $dict-ending = %dict-ending-for-a-form{$vm.Str.substr(*-4,1)};
                # my $dict-ending = %dict-ending-for-a-form{$hiragana.substr(0,1)};
                return  $stem ~ $dict-ending;
            } 
            say "Godan -te, not in dicts, take -ru: " ~ $stem ~ 'る' if $V;
            # my $verb-stem-hiragana = $vm1<hiragana>.elems > 1 ??  $vm2<hiragana>[0..*-1].join('') !! '';
            return  $stem ~ 'る';
            
        } 
        elsif $verb-match<verb-ta> {
            say "Godan -ta form: " ~ $verb-match.Str if $V;
            my $hiragana-ta = ($vm2<hiragana> ?? $vm2<hiragana>[*-1] !! '') ~ $vm2<verb-ending-ta>;
            my $hiragana = ($vm2<hiragana> && $vm2<hiragana>.elems > 1) ?? (|$vm2<hiragana>)[0 .. *-2].join('') !! '';
            say "hiragana: <$hiragana>"  if $V;
            if %defined-verbs{$stem ~ $hiragana }:exists or %dictionary{$stem ~ $hiragana}:exists {
                return $stem ~ $hiragana ~ 'する';
            }

            my $dict-ending = %dict-ending-for-ta-form{$hiragana-ta};
            say $hiragana-ta ~ ' => ' ~ $dict-ending;
            for |$dict-ending -> $ending {
                say "ending: $ending" if $V;           
                my $maybe-godan-verb = $stem ~  $hiragana ~ $ending;
                if %defined-verbs{$maybe-godan-verb}:exists or %dictionary{$maybe-godan-verb}:exists {
                    say "Godan -ta via dict lookup: " ~ $maybe-godan-verb if $V;
                    return $maybe-godan-verb;
                } else {                                        
                    my $res =  lookup-in-kanji-dict($stem,"$hiragana$ending");
                    if $res {
                        say "Godan -ta via kanji dict lookup: $stem,$hiragana|$ending" if $V;
                        return $res;
                    }
                }
            }            
            say "Godan -ta, not in dicts, take -ru " ~ $stem ~  $hiragana ~ 'る' if $V;
            return $stem ~  $hiragana ~ 'る';
        } 
        elsif $verb-match<verb-tai> {
            say "Godan -tai form: " ~ $verb-match.Str if $V;
            my $hiragana = $vm1<verb-stem-hiragana>;
            my $dict-ending =  %dict-ending-for-masu-form{$hiragana};
            say "Godan hiragana: " ~ $hiragana ~ ' => ' ~  $dict-ending if $V;
            my $verb-stem-hiragana = $vm2<hiragana>.elems > 1 ??  $vm2<hiragana>[0..*-1].join('') !! '';
            return $stem ~ $verb-stem-hiragana ~ $dict-ending;
        }
        elsif $verb-match<verb-kakeru> {
            say "Godan -kakeru form: " ~ $verb-match.Str if $V;
            my $hiragana = $vm1<verb-stem-hiragana>;
            my $dict-ending =  %dict-ending-for-masu-form{$hiragana};
            say "Godan hiragana: " ~ $hiragana ~ ' => ' ~  $dict-ending if $V;
            my $verb-stem-hiragana = $vm2<hiragana>.elems > 1 ??  $vm2<hiragana>[0..*-1].join('') !! '';
            return $stem ~ $verb-stem-hiragana ~ $dict-ending;
        }
        elsif $verb-match<verb-masu> {
            say "Godan -masu form: " ~ $verb-match.Str if $V;
        if $vm2<hiragana> {
            
            my $hiragana = $vm2<hiragana>[*-1] ;
            my $dict-ending =  %dict-ending-for-masu-form{$hiragana};
            say "Godan hiragana: " ~ $hiragana ~ ' => ' ~  $dict-ending if $V;
            my $verb-stem-hiragana = $vm2<hiragana>.elems > 1 ??  $vm2<hiragana>[0..*-1].join('') !! '';
            return $stem ~ $verb-stem-hiragana ~ $dict-ending;
        } else {
            say "Godan -masu form but no hiragana to derive dict form, default to る";
            return $stem ~ 'る';
        }
        }
        elsif $verb-match<verb-sura> {
            say 'Noun + suru: ' ~ $verb-match.Str  if $V;
            my $hiragana = $vm1<verb-stem-hiragana> // '';
            return $stem ~ $hiragana ~ 'する';
        }
        else {
            say "Godan but unsupported form: " ~ $verb-match.Str if $V;
        }
        return $verb-match.Str;
    }
}

sub lookup-in-kanji-dict($stem,$hiragana) {
    my @entries = %joyo_kun_verb_readings{$stem.substr(*-1)} //[];
    # Then we need to check if the end any of the entries matches the hiragana
    for @entries -> $entry {
        say "$stem,$hiragana : $entry" if $V; 
        if $entry.chars >= $hiragana.chars and $entry.substr(*-$hiragana.chars) eq $hiragana {    
            say "returning " ~ $stem ~ $hiragana if $V;
            return $stem ~ $hiragana
        }
    }
    return Nil;    
}                     
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


=end pod