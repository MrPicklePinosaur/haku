use v6;
use HakuAST;
use JapaneseNumberParser;

our $V=True;

class HakuActions {
    
    my %defined-functions;

    method variable($/) {
        # say "VAR $/";
        make Variable[$/.Str].new;        
    }

    method verb($/) {

        # So wonderful
        my $verb-str = ($<verb-dict> // $<verb-masu> // $<verb-ta> // $<verb-te> // $/).Str ;
        my $verb-kanji = substr($verb-str,0,1);
        if not $<verb-dict>  and %defined-functions{$verb-kanji}:exists {
            $verb-str = %defined-functions{$verb-kanji};
        }
        
        my %vbinops is Map = < 足 + 引 - 掛 * 割 /　>;

        if %vbinops{$verb-kanji}:exists {
            make BinOp[%vbinops{$verb-kanji}].new;
        } else {
            make Verb[$verb-str].new;
        }
    }
    
    method noun($/) {
        make Noun[$/.Str].new;
    }

    method identifier($/) {
        make $/.values[0].made;
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
        if $<mu> { # Null
            make Null.new;
        }
        elsif $<kuu> { # ConsNil
            make ConsNil.new;
        } else {
            make $/.values[0].made;
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
    method map-expression($/) {
              
        my @exprs= map({$_.made},$<atomic-expression>);
        # say "MAP EXPR: "~@exprs.raku;  
        if @exprs.elems==1 and @exprs[0] ~~ ConsNil {
            make MapExpr[()].new;
        } else {
            make MapExpr[@exprs].new;
        }
                
    }
    method kaku-parens-expression($/) { make $/.values[0].made }

    # it should be possible to put parens around function applications and lambdas as well!
    method parens-expression($/) {
        make $<expression>.made;
    }

    method arg-expression($/) {
        make $/.values[0].made
    }

    method operator-noun($/) {
        my $op-kanji= $/.Str;
        my %nbinops is Map = < 和 + 差 - 積 * 除 />;
        make BinOp[%nbinops{$op-kanji}].new;
    }

    method operator-verb($/) {
        my $op-kanji= $<operator-verb-kanji>.Str;

        my %vbinops is Map = < 足 + 引 - 掛 * 割 /　>;
        make BinOp[%vbinops{$op-kanji}].new;
    }

    method noun-operator-expression ($/) {
        my $op=$<operator-noun>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;        
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }
    
    method verb-operator-expression ($/) {
        my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }

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
    method has-expression($/) {
        my $map-expr = $<identifier>[0].made;
        my $key-expr = $<identifier>[1].made;
        make FunctionApplyExpr[Verb['has'].new, [$map-expr,$key-expr],False].new
    }
    method comparison-expression($/) {

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
        make BinOpExpr[BinOp[$op].new, $lhs-expr,$rhs-expr].new
    }

    method condition-expression($/) {
        make $/.values[0].made; 
    } 
    
    method baai-ifthen ($/) {
        my $cond = $<condition-expression>.made;
        my $true-expr = $<expression>[0].made;  
        my $false-expr = $<expression>[1].made;
        make IfExpr[ $cond, $true-expr,  $false-expr].new;
    }

    method moshi-ifthen ($/) {
        # die $<condition-expression>.raku,$<expression>.raku;
        my $cond = $<condition-expression>.made;
        my $true-expr = $<expression>[0].made;  
        my $false-expr = $<expression>[1].made;

        make IfExpr[ $cond, $true-expr,  $false-expr].new;
    }

    method ifthen($/) {
        make $/.values[0].made;        
    }    

    method arg-expression-list($/) {
        my @args = map({$_.made},$<arg-expression>);
        make @args;
    }

    method non-verb-apply-expression($/) {    
        my @args =  map({$_.made},$<arg-expression-list>).flat;
        my $partial = $<dake> ?? True !! False;
        
        if $<operator-noun> {
            my $op=$<operator-noun>.made;   
            make BinOpExpr[$op, @args[0],@args[1]].new;
        } 
        elsif $<noun> {
            my $function-name=$<noun>.made;   
            make FunctionApplyExpr[$function-name, @args, $partial].new;
        } 
        elsif $<variable> {
            my $function-name=$<variable>.made;   
            make FunctionApplyExpr[$function-name, @args, $partial].new;
        }        
    }

    method adjectival-verb-apply-expression($/) {        
        my $partial = $<dake> ?? True !! False;
        my @args =  $<arg-expression-list> ?? 
            [map({$_.made},$<arg-expression-list>).flat,$<arg-expression>.made]
            !! [$<arg-expression>.made];
        my $function-name=$<verb>.made;   
        make FunctionApplyExpr[$function-name, @args, $partial].new;
    }

    method apply-expression($/) {
        my $partial = $<dake> ?? True !! False;
        if $<adjectival-verb-apply-expression> {
            make $<adjectival-verb-apply-expression>.made;
        } elsif $<non-verb-apply-expression> {        
            my @args= [ $<non-verb-apply-expression>.made ];
            if $<verb> {
                my $function-name=$<verb>.made;   
                make FunctionApplyExpr[$function-name, @args, $partial].new;
            } 
            elsif $<lambda-expression> {
                my $lambda-expr=$<lambda-expression>.made;
                make LambdaApplyExpr[$lambda-expr, @args, $partial].new;
            }   
        } else {
            
            my @args =  map({$_.made},$<arg-expression-list>).flat;            
            if $<identifier> {                
                my $function-name=$<identifier>.made;   
                if $function-name ~~ BinOp {
                    make BinOpExpr[$function-name, @args[0],@args[1]].new
                } else {
                    make FunctionApplyExpr[$function-name, @args, $partial].new;
                }
            } 
            elsif $<lambda-expression> {
                my $lambda-expr=$<lambda-expression>.made;
                make LambdaApplyExpr[$lambda-expr, @args, $partial].new;
            }   
        }     
    }

    method comment($/) {
        make $<comment-chars>.map({$_.Str}).join('');
    }

    # This is not practical. I need comments to be part of expressions. 
    method comment-then-expression($/) { 
         my $comment_str = $<comment>.map({ '#' ~ $_.made ~ "\n"}).join('') // '';
        #  say $comment_str;
        my $expr = $<expression>.made;
        # $expr.comment = $comment_str;
        # say $expr.raku;
        make CommentedExpr[$expr,$comment_str].new;
    }

    method range-expression($/) {
        my $from = $<atomic-expression>[0].made;
        my $to = $<atomic-expression>[1].made;
        make RangeExpr[$from,$to].new;
    }
 
    method bind-ga($/) {
        my $comment = $<comment>.map({ '#' ~ $_.made ~ "\n"}).join('') // '';
        my $lhs-expr;
        if $<variable> {
            $lhs-expr = $<variable>.made;
        } elsif $<cons-list-expression> {
            $lhs-expr = $<cons-list-expression>.made;
        }
        if $<zoi> {
            my $expr = $<expression>[0].made;
            my $zoi-expr = $<expression>[1].made;
            make BindExpr[$lhs-expr, ZoiExpr[$expr,$zoi-expr].new, $comment].new;
        } else {
            if $<expression> ~~ Array {
            # say $<expression>[0].made;
                my @rhs-exprs = map({$_.made},$<expression>);
                if @rhs-exprs.elems == 1 {
                    make BindExpr[$lhs-expr,@rhs-exprs[0],$comment].new;
                } else {
                    die 'TODO!' ~ @rhs-exprs.raku;
                }            
            } else {            
                my $rhs-expr=$<expression>.made;
                make BindExpr[$lhs-expr,$rhs-expr,$comment].new;
            }

            # my $rhs-expr=$<expression>.made;
            # make BindExpr[$lhs-expr,$rhs-expr,$comment].new;
        }                
    } 
    method kono-let($/) {
        my $result = $<expression>.made;         
        my @bindings = map({$_.made},$<bind-ga>);
        make LetExpr[ @bindings, $result].new;
    }

    method bind-ha($/) {
        my $comment = $<comment>.map({ '#' ~ $_.made ~ "\n"}).join('') // '';
        my $lhs-expr;
        if $<variable> {            
            $lhs-expr = $<variable>.made;
        } elsif $<noun> {
            $lhs-expr = $<noun>.made;
        } elsif $<cons-list-expression> {
            $lhs-expr = $<cons-list-expression>.made;
        }
        if $<zoi> {
            my $expr = $<expression>[0].made;
            my $zoi-expr = $<expression>[1].made;
            make BindExpr[$lhs-expr, ZoiExpr[$expr,$zoi-expr].new, $comment].new;
        } else {
            # say '<'~$/.Str~'>';
            if $<expression> ~~ Array {
            # say $<expression>[0].made;
                my @rhs-exprs = map({$_.made},$<expression>);
                if @rhs-exprs.elems == 1 {
                    make BindExpr[$lhs-expr,@rhs-exprs[0],$comment].new;
                } else {
                    die 'TODO!' ~ @rhs-exprs.raku;
                }            
            } else {            
                my $rhs-expr=$<expression>.made;
                make BindExpr[$lhs-expr,$rhs-expr,$comment].new;
            }
        }
    } 

    method kuromaru-let($/) {
        my $result = $<expression>.made;         
        my @bindings = map({$_.made},$<bind-ha>);
        make LetExpr[ @bindings, $result].new;
    }

    method let-expression($/) {
#        say $/.values[0].made;
        make $/.values[0].made;
    }

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

    method chinamini-expression($/) {
        make ChinaminiExpr[$<expression>.made].new;
    }

    method expression($/) { 
            make $/.values[0].made;
    }
    method  hontoha($/) {
        make $<hon>.Str ~ ( $<ma> ?? $<ma>.Str !! '');
    }
    method hon-definition($/) {
        # say 'HON action';
        my @comments = ();
        my @bindings = ();
        if $<bind-ha> {
            # In general an array, iterate
            @bindings = map({$_.made}, $<bind-ha>); 
        }
        my @exprs = ();
        if $<comment-then-expression> {
            
            # In general an array, iterate
            @exprs = map({$_.made}, $<comment-then-expression>);
            
        }
        my @haku-exprs = |@bindings,|@exprs;
        # say 'EXPRS: '~@haku-exprs.raku;
        if $<comment> {
            # In general an array, iterate
            @comments = map({$_.made}, $<comment>);
        }
        my $name = $<hontoha>.made; 
        make Hon[$name, @bindings,@exprs,@comments].new;
        # make should return a tuple of a list of  HakuExpr and a list of Comment
    }
    method function($/) {
        my @comments = ();
        if $<comment> {
            # In general an array, iterate
            @comments = map({$_.made}, $<comment>);
        }
        my $name=
         $<verb> ?? $<verb>.made.verb
        !! $<noun> ?? $<noun>.made.noun
        !! '_';        
        %defined-functions{$name.substr(0,1)}=$name;
        my $fname=
         $<verb> ?? $<verb>.made
        !! $<noun> ?? $<noun>.made
        !! die "Not a Verb or Noun: "~$/.Str;
        my @args = $<variable-list>.made;
        # die @args.raku;
        my $body = $<expression>.made;
        make Function[ $fname, @args,  $body,@comments].new;        
    }
    method haku-program($/) {
        # say "PROGRAM $/";
        # TODO: handle functions
        my @functions=();
        my @comments=();
        if $<function> {
            @functions = map({$_.made},$<function>);
        }
        if $<comment> {
            @comments = map({$_.made}, $<comment>);
        }
        if $<hon-definition> {
            # say 'HAKU PROGRAM';
            make HakuProgram[@functions,$<hon-definition>.made,@comments].new;
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

