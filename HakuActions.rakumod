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
    method string($/) {
        if $<string-chars> {
            my @chars= map({$_.Str},$<string-chars>);             
            make String[@chars].new; 
        }

    }
    method number($/) {
            my Num $number = parseJapaneseNumbers($/.Str);
            make Number[$number].new;        
    }

    method atomic-expression($/) {
        if $<number> { # Number
            make $<number>.made
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
        my @comments = ();
        my @bindings = ();
        if $<bind-ha> {
            # In general an array, iterate
            @bindings = map({$_.made}, $<bind-ha>); 
        }
        my @exprs = ();
        if $<expression> {
            # In general an array, iterate
            @exprs = map({$_.made}, $<expression>);
        }
        my @haku-exprs = |@bindings,|@exprs;
        if $<comment> {
            # In general an array, iterate
            @comments = map({$_.made}, $<comments>);
        }
        make (@haku-exprs,@comments);
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

