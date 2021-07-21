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

    # token kaku-parens-expression { <list-expression> | <range-expression> }

    # it should be possible to put parens around function applications and lambdas as well!
    method parens-expression($/) {
        make $<operator-expression>.made;
    }
    method arg-expression($/) {
        if $<parens-expression> {
            make $<parens-expression>.made;
        }
        if $<atomic-expression> {
            make $<atomic-expression>.made;
        }
    }

    method operator-noun($/) {
        my $op-kanji= $/.Str;
        my %nbinops = < '和' '+' '差' '-' '積' '*' '除' '/'>;
        make BinOp[%nbinops{$op-kanji}].new;    
    }

    method operator-verb($/) {
        my $op-kanji= $<operator-verb-kanji>.Str;
        my %vbinops = < '足' '+' '引' '-' '掛' '*' '割' '/'>;
        make BinOp[%vbinops{$op-kanji}].new;
    }

    method noun-operator-expression ($/) {
        my $op=$<operator-noun>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }
    # token verb-operator-expression { <arg-expression> <ni>　<arg-expression> <wo> <operator-verb> }
    method verb-operator-expression ($/) {
        my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }
    # token verb-operator-expression-infix { <arg-expression> <operator-verb> <arg-expression> }
    method verb-operator-expression-infix ($/) { 
        my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
                    # say 'HERE:'~$op.raku~'('~$lhs-expr.raku~','~$rhs-expr.raku~')';
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new;
    }

    method operator-expression($/) {
        if $<noun-operator-expression> {
            make $<noun-operator-expression>.made;
        }
        elsif $<verb-operator-expression> {
            make $<verb-operator-expression>.made;
        }
        elsif $<verb-operator-expression-infix> {
            make $<verb-operator-expression-infix>.made;
        }
    }
    method expression($/) {
        if ($<atomic-expression>) {
            # say $<atomic-expression>.made; 
            make $<atomic-expression>.made
        } elsif $<list-expression> {
            # say "LIST "~$<list-expression>.made.raku;
            make $<list-expression>.made
        } elsif $<lambda-expression> {
            my @args = map({$_.made},$<variable-list>);
            my $expr = $<expression>.made;
            make LambdaExpr[@args,$expr].new;
        } elsif $<cons-list-expression> {
            my @cons = map({$_.made},$<variable>);
            if $<kuu> or $<empty> {
                @cons.push(ConsNil.new);
            }
            make Cons[@cons].new    
        } elsif $<operator-expression> {
            make $<operator-expression>.made;
        } else {
            make "EXPR: "~$/;
        }
=begin pod
        | <let-expression>  
        | <apply-expression> 
        | <operator-expression>
        | <comparison-expression>
        | <function-comp-expression>
        | <range-expression>
        | [<comment>+ <expression>]   
=end pod
    }
    method bind-ha($/) {
#bind-ha { [ <variable> | <cons-list-expression>] <.ha> <expression>
        my $lhs-expr;
        if $<variable> {
            $lhs-expr = $<variable>.made;
        } elsif $<cons-list-expression> {
            $lhs-expr = $<cons-list-expression>.made;
        }
        my $rhs-expr=$<expression>.made;
        make BindExpr[$lhs-expr,$rhs-expr].new;
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
            # make 'Haku error: '~$/
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

