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
        make $/.values[0].made;
        # if $<variable> {
        #     $<variable>.made;
        # }
        # elsif $<noun> {
        #     $<noun>.made;
        # }
        # elsif $<verb> {
        #     $<verb>.made;
        # }

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
        # if $<number> { # Number
        #     make $<number>.made
        # }
        if $<mu> { # Null
            make Null.new;
        }
        elsif $<kuu> { # ConsNil
            make ConsNil.new;
        } else {
            make $/.values[0].made;
        }
        # if $<identifier> { # Variable, Noun or Verb
        #     make $<identifier>.made;
        # }
        # if $<string> { # String        
        #     make $<string>.made;            
        # } 
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
        make $<expression>.made;
    }

    method arg-expression($/) {
        make $/.values[0].made
        # if $<parens-expression> {
        #     make $<parens-expression>.made;
        # }
        # if $<atomic-expression> {
        #     make $<atomic-expression>.made;
        # }
    }

    method operator-noun($/) {
        my $op-kanji= $/.Str;
        my %nbinops is Map = < 和 + 差 - 積 * 除 />;
        make BinOp[%nbinops{$op-kanji}].new;    
    }

    method operator-verb($/) {
        my $op-kanji= $<operator-verb-kanji>.Str;

        my %vbinops is Map = < 足 + 引 - 掛 * 割 />;
#say "<$op-kanji>" ~ ' =>  ' ~ %vbinops{$op-kanji};
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
#say "Action:VERB-BINOP:" ~ $op.raku ~ ' ' ~ $lhs-expr.raku ~ ', ' ~ $rhs-expr.raku;
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }
    # token verb-operator-expression-infix { <arg-expression> <operator-verb> <arg-expression> }
    method verb-operator-expression-infix ($/) { 
        my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
                    # say 'HERE:'~$op.raku~'('~$lhs-expr.raku~','~$rhs-expr.raku~')';
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }

    method operator-expression($/) {
        make $/.values[0].made
    }

    method comparison-expression($/) {
        #   my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
        my $op ='';
        if $<hitoshii> {
            $op = '=';
        }
        if $<sukunai> {
            $op = '<'.$op;
        } elsif $<ooi> {
            $op = '>'.$op;
        } else {
            if $op eq '=' {
                $op = '==';
            } else {
                $op = '!=';
            }            
        }
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }

    method arg-expression-list($/) {
#say '<'~$/.Str~'>';
        my @args = map({$_.made},$<arg-expression>);
#       say @args.raku;
        make @args;
    }
    method apply-expression($/) {
        my @args = $<arg-expression-list>.made;
        my $partial = $<dake> ?? True !! False;
        
        if $<identifier> {
            my $function-name=$<identifier>.made;
            make FunctionApplyExpr[$function-name, @args, $partial].new;
        } 
        elsif $<lambda-expression> {
            my $lambda-expr=$<lambda-expression>.made;
            make LambdaApplyExpr[$lambda-expr, @args, $partial].new;
        }        
    }
    method comment($/) {
        make $/.Str;
    }

    method comment-then-expression($/) {
        make $<expression>.made;
    }

    method range-expression($/) {
        my $from = $<atomic-expression>[0].made;
        my $to = $<atomic-expression>[1].made;
        make RangeExpr[$from,$to].new;
    }
=begin pod
        | <let-expression>  
        | <function-comp-expression>
=end pod

    method cons-list-expression($/) {
            my @cons = map({ConsVar[$_.Str].new},$<variable>);
            if $<kuu> or $<empty> {
                @cons.push(ConsNil.new);
            }
            make Cons[@cons].new    
    }
    method variable-list($/) {
        my @args = map({$_.made},$<variable>);
        make @args;
    } 
    method lambda-expression($/) {
#say "VARLIST: "~$<variable-list>.made.raku;
            my @args = $<variable-list>.made;
            my $expr = $<expression>.made;
            make LambdaExpr[@args,$expr].new;
    }
    method expression($/) { 
        # say $/.keys;die;
#        if $<lambda-expression> {
#            my @args = map({$_.made},$<variable-list>);
#            my $expr = $<expression>.made;
#            make LambdaExpr[@args,$expr].new;
#        } elsif $<cons-list-expression> {
#            my @cons = map({$_.made},$<variable>);
#            if $<kuu> or $<empty> {
#                @cons.push(ConsNil.new);
#            }
#            make Cons[@cons].new    
#        } else { 
            make $/.values[0].made;
#}
        # } elsif ($<atomic-expression>) {
        #     # say $<atomic-expression>.made; 
        #     make $<atomic-expression>.made
        # } elsif $<list-expression> {
        #     # say "LIST "~$<list-expression>.made.raku;
        #     make $<list-expression>.made
        # } elsif $<operator-expression> {
        #     make $<operator-expression>.made;
        # } elsif $<comparison-expression> {
        #     make $<comparison-expression>.made;
        # } elsif $<comment-then-expression> {
        #     make $<comment-then-expression>.made;
        # } elsif $<apply-expression> {
        #     make $<apply-expression>.made;
        # } else {
        #     make "EXPR: "~$/;
        # }

    }
    method bind-ha($/) {
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
            @comments = map({$_.made}, $<comment>);
        }
         
        make Hon[@bindings,@exprs,@comments].new;
        # make should return a tuple of a list of  HakuExpr and a list of Comment
    }
    method function($/) {
        my $name=
         $<verb> ?? $<verb>.made
        !! $<noun> ?? $<noun>.made
        !! '_';

        my @args = $<variable-list>.made;
        # die @args.raku;
        my $body = $<expression>.made;
        make Function[ $name, @args,  $body].new;        
    }
    method haku-program($/) {
        # TODO: handle functions
        my @functions=();
        my @comments=();
        if $<function> {
            @functions = map({$_.made},$<function>);
        }
        if $<comment> {
            @comments = map({$_.made}, $<comment>);
        }
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

}

