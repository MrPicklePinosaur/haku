use v6;
use HakuAST;
use JapaneseNumberParser;

class HakuActions {
    # has %var;
    method variable($/) {
        make Variable[$/.Str].new;
    }
    method verb($/) {
        make Verb[$/.Str].new;
    }
    method noun($/) {
        make Noun[$/.Str].new;
    }

    method identifier($/) {
        if $<variable> {
            $<variable>.made;
        }
        elsif $<noun> {
            $<noun>.made;
        }
        elsif $<verb> {
            $<verb>.made;
        }

    }
    method number($/) {
            my $number = parseJapaneseNumbers($/.Str);
            make Number[$number].new;        
    }

    method atomic-expression($/) {
        if $<number> { # Number
            # make ''~$<number>;
        }
        if $<mu> { # Null
            make Null.new;
        }
        if $<kuu> { # ConsNil
            make ConsNil.new;
        }
        if $<identifier> { # Variable, Noun or Verb
            make $<identifier>.made;
        }
        if $<string> { # String
            make String[''~$<string>].new;            
        } 
    }
    
    method hon($/) {
        if $<bind-ha> {
            # In general an array, iterate
            
        }
        if $<expression> {
            # In general an array, iterate
        }
        if $<comment> {
        }
        # make should return a tuple of a list of  HakuExpr and a list of Comment
    }

    # method apply-expression($/) {
        
    #     my $apply 
    # }

    # method function-call($/) {
                     

    #     say %var{$<variable-name>}
    #         if $<function-name> eq 'say';
    # }   
}

