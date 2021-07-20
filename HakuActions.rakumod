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
            make $<string>.made;            
        } 
    }
    method list-expression($/) {
        # say $/.raku;
        my @exprs= map({$_.made},$<atomic-expression>);
        # say 'ELTS:'~@exprs.raku;  
        if @exprs.elems==1 {
            make @exprs[0];
        } else {
            make ListExpr[@exprs].new;
        }
    }
    method expression($/) {
        if ($<atomic-expression>) {
            # say $<atomic-expression>.made; 
            make $<atomic-expression>.made
        } elsif $<list-expression> {
            # say "LIST "~$<list-expression>.made.raku;
            make $<list-expression>.made
        } else {
            make "EXPR: "~$/;
        }
    }
    
    method hon($/) {
        # say 'HON action';
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
        # say 'EXPRS: '~@haku-exprs.raku;
        if $<comment> {
            # In general an array, iterate
            @comments = map({$_.made}, $<comments>);
        }
         
        make Hon[@haku-exprs,@comments].new;
        # make should return a tuple of a list of  HakuExpr and a list of Comment
    }

    method haku-program($/) {
        # TODO: handle functions
        my @functions=();
        my @comments=();
        if $<hon> {
            # say 'HAKU PROGRAM';
            make HakuProgram[@functions,$<hon>.made,@comments].new;
        } else {
            die 'A Haku program must have a 本 main routine';
            make 'HAKU: '~$/
        }
    }

    method TOP ($/) {
        if ($<haku-program>) {
            make $<haku-program>.made;
        }
    }
    # method apply-expression($/) {
        
    #     my $apply 
    # }

    # method function-call($/) {
                     

    #     say %var{$<variable-name>}
    #         if $<function-name> eq 'say';
    # }   
}

