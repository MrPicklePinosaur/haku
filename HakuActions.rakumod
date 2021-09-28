use v6;
use HakuAST;
use JapaneseNumberParser;

our $V=False;

class HakuActions {
    my %predefined-functions is Map = <    
        見 show
        書  write
        読  read
        入力 enter
        一線 one
        全線 all
        開  fopen 
        閉  close                 
        畳  foldl             
        写像  map 
        合  concat 
        頭 head 
        尻尾 tail            
        逆 reverse
        長さ length 
        鍵 　keys
        値 　values
        入  insert 
        消  delete 
        正引 lookup
        正引き lookup  
        探索 lookup       
    >;
    my %special-vars is Map = <件 matter 物 thing 条 item 魄 soul 珀 haku 数 number>;
    my %vbinops is Map = < 足 + 引 - 掛 * 割 /　>; # TODO could add 残る remainder
    my %nbinops is Map = < 和 + 差 - 積 * 除 />; # TODO could add 余 remainder

    my %defined-functions;

    method variable($/) {
        my $var-str = %special-vars{$/.Str} // $/.Str;
        
        make Variable[$var-str].new;        
    }

    method verb($/) {

        # So wonderful
        my $verb-str = ($<verb-dict> // $<verb-masu> // $<verb-ta> // $<verb-te> // $/).Str ;
        my $verb-kanji = substr($verb-str,0,1);
        if not $<verb-dict> and %defined-functions{$verb-kanji}:exists {
            $verb-str = %defined-functions{$verb-kanji};
        }
        
        if %vbinops{$verb-kanji}:exists {
            make Operator[%vbinops{$verb-kanji}].new;
        } else {
            # This is a hack because currently Noun + desu is parsed as a Verb
            if  $verb-str.substr(*-2,2)  eq 'です' and 3 <= $verb-str.chars <= 4   { 
                my $noun-str = $verb-str.substr(0,$verb-str.chars-2);
                my $noun-str-s = %predefined-functions{$noun-str} // $noun-str;
                say "NOUN: $noun-str-s" if $V;
                make Noun[$noun-str-s].new;
            } else {
                
                my $verb-str-s = %predefined-functions{$verb-str.substr(0,1)} // 
                %predefined-functions{$verb-str.substr(0,2)} // $verb-str;
                say "VERB: $verb-str-s" if $V;
                make Verb[$verb-str-s].new;    
            }            
        }
    }
    
    method noun($/) {
        if $/.Str eq '無' {
            make Null.new;
        } elsif $/.Str eq '空' {
            make EmptyList.new;
        } else {
            my $noun-str = $/.Str;
            my $noun-str-s = %predefined-functions{$noun-str} // $noun-str;
            say "NOUN: $noun-str-s" if $V;
            make Noun[$noun-str-s].new;
        }
    }
    
    method adjective($/) {
        my $adj-str = $/.Str;
        my $adj-str-s = %predefined-functions{$adj-str.substr(0,$adj-str.chars-1)} // $adj-str;
        say "ADJECTIVE: $adj-str-s" if $V;
        make Adjective[$adj-str].new;
    }    

    method identifier($/) {
        if not $<nominaliser> {
            make $/.values[0].made;
        } else {
            make FunctionAsArg[$<verb>.made].new;
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
        if $<mu> { # Null
            make Null.new;
        }
        elsif $<mugendai> { # Null
            make Infinity.new;
        }
        elsif $<kuu> { # EmptyList, was ConsNil
            make EmptyList.new;
        } else {
            make $/.values[0].made;
        }
    }
    method list-elt-expression($/) {        
        if $<kaku-parens-expression> {
            # die $<kaku-parens-expression>.raku;
            my @exprs =  map({$_.made},$<kaku-parens-expression>);
            make ListExpr[@exprs].new;
        } elsif $<atomic-expression> {
            # say $<atomic-expression>.made.raku;
            make $<atomic-expression>.made;
        } elsif $<kuu> { 
            make EmptyList.new;
        }
    }
    method list-expression($/) {
       if $<kuu> or $<empty> {
            make EmptyList.new;
       } else {
            my @exprs= map({$_.made},$<list-elt-expression>);
            # say @exprs.raku;
            make ListExpr[@exprs].new;
       }
        #     # die $<kaku-parens-expression>.raku;
        #     my @exprs =  map({$_.made},$<kaku-parens-expression>);
        #     make ListExpr[@exprs].new;
        # } else {
        # my @exprs= map({$_.made},$<atomic-expression>);
        # if @exprs.elems==1 {            
        #     make @exprs[0];
        # } else {
        #     make ListExpr[@exprs].new;
        # }
        # }
    }
    method map-expression($/) {
              
        my @exprs= map({$_.made},$<atomic-expression>);
        # say "MAP EXPR: "~@exprs.raku;  
        if @exprs.elems==1 and @exprs[0] ~~ EmptyList {
            make MapExpr[()].new;
        } else {
            make MapExpr[@exprs].new;
        }                
    }
        # <cons-list-expression> | 
        # <list-expression>  |
        # <atomic-expression> |
        # <range-expression> |
        # <kaku-parens-expression>
    
    # [ a to b ] => just as is
    # [ a . bs ] => idem
    # [ a ~ b] idem
    # [a] => needs a list
    # [ [...] ] => needs a list
    method kaku-parens-expression($/) { 
        if $<atomic-expression> {
            make ListExpr[ [$<atomic-expression>.made] ].new
        } elsif $<kaku-parens-expression> {
            make ListExpr[ [$<kaku-parens-expression>.made] ].new
        } else {
            make $/.values[0].made
        }
    }

    # it should be possible to put parens around function applications and lambdas as well!
    method parens-expression($/) {
        make $<expression>.made;
    }

    method arg-expression($/) {
        make $/.values[0].made
    }

    method operator-noun($/) {
        my $op-kanji= $/.Str;
        
        make Operator[%nbinops{$op-kanji}].new;
    }

    method operator-verb($/) {
        my $op-kanji= $<operator-verb-kanji>.Str;

        # my %vbinops is Map = < 足 + 引 - 掛 * 割 /　>;
        make Operator[%vbinops{$op-kanji}].new;
    }

    method noun-operator-expression ($/) {
        my $op=$<operator-noun>.made;
        my @args =  map({$_.made},$<arg-expression-list>).flat; 
        make ListOpExpr[$op, @args].new
    }
    
    method verb-operator-expression ($/) {
        my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
    }

    method verb-operator-expression-infix ($/) { 
         if $<operator-verb> ~~ Array {
        my @ops=map({$_.made},$<operator-verb>).flat;
        my @args =  map({$_.made},$<arg-expression>).flat; 
        # die (@args,@ops).raku;
        my $nested-expr = binop-expr-two-prec-levs(@args,@ops);
        # die $nested-expr.raku;
        make $nested-expr;
# If there is more than one op we have arg1 `op1` arg2 `op2` arg3 `op3` arg4 `op4` arg5
# We have the following cases: 
# 1. They are all the same => Nest from left
# 2. They are * and / => Nest from left
# 3. They are + and - => Nest from left
# 4. They are * or / and + or - 
# That is the hard one: we need to group them by precedence. 
# But we have only 2 precedence levels. So:



        
         } else {
             my $op=$<operator-verb>.made;
        my $lhs-expr = $<arg-expression>[0].made;
        my $rhs-expr = $<arg-expression>[1].made;
                    # say 'HERE:'~$op.raku~'('~$lhs-expr.raku~','~$rhs-expr.raku~')';
        make BinOpExpr[$op, $lhs-expr,$rhs-expr].new
         }
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
        make BinOpExpr[Operator[$op].new, $lhs-expr,$rhs-expr].new
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
            # make BinOpExpr[$op, @args[0],@args[1]].new;
            make ListOpExpr[$op, @args].new            
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
    
    method adjectival($/) {
             make $/.values[0].made;  
    }

    method adjectival-apply-expression($/) {        
        my $partial = $<dake> ?? True !! False;
        if $<adjectival> ~~ Array {
            # I will be lazy and only support one or two elements
            if $<adjectival>.elems == 1 {
                my $f1-name = $<adjectival>[0].made;
                my @args =  $<arg-expression-list> ?? 
                [map({$_.made},$<arg-expression-list>).flat,$<arg-expression>.made]
                !! [$<arg-expression>.made];
                make FunctionApplyExpr[$f1-name, @args, $partial].new;
            } elsif $<adjectival>.elems == 2 {
                my $f1-name = $<adjectival>[0].made;
                my $f2-name = $<adjectival>[1].made;
                my $f2-as-arg = FunctionApplyExpr[$f2-name, [$<arg-expression>.made], False].new;

                my @args =  $<arg-expression-list> ?? 
                [map({$_.made},$<arg-expression-list>).flat,$f2-as-arg]
                !! [$f2-as-arg];
                make FunctionApplyExpr[$f1-name, @args, $partial].new;
            } else {        
                die 'TODO';
            }                    

        } else {
            my @args =  $<arg-expression-list> ?? 
            [map({$_.made},$<arg-expression-list>).flat,$<arg-expression>.made]
            !! [$<arg-expression>.made];

            my $function-name=  $<adjectival>.made;   
            make FunctionApplyExpr[$function-name, @args, $partial].new;
        }
    }

    method apply-expression($/) {
        my $partial = $<dake> ?? True !! False;
        if $<adjectival-apply-expression> {
            make $<adjectival-apply-expression>.made;
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
                if $function-name ~~ Operator {
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
        if $<expression> {
            
            # if $<expression> ~~ Array {            
            #     my @rhs-exprs = map({$_.made},$<expression>);
            #     if @rhs-exprs.elems == 1 {
            #         die @rhs-exprs.raku;
            #         # make BindExpr[$lhs-expr,@rhs-exprs[0],$comment].new;
            #     } else {
            #         die 'TODO!' ~ @rhs-exprs.raku;
            #     }            
            # } else {
                my $expr = $<expression>.made;
            # $expr.comment = $comment_str;
            # say $expr.raku;
                make CommentedExpr[$expr,$comment_str].new;
            # }
        } elsif $<bind> {
            my $bind = $<bind>.made;
            make CommentedExpr[$bind,$comment_str].new;
        } else {
            die "Comment must come before bind or expression\n";
        }
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

    method bind($/) {
        make $/.values[0].made;
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

    method cons-elt-expression($/) {
            if $<variable> {
                make ConsVar[$<variable>.made].new;
            } elsif $<kaku-parens-expression> {
                make ConsList[$<kaku-parens-expression>.made].new;
            }
            elsif $<kuu> or $<empty> {
                make EmptyList.new;
            }
                
    }

    method cons-list-expression($/) {        
            my @cons = map({$_.made},$<cons-elt-expression>);
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
        !! $<adjective> ?? $<adjective>.made
        !! $<adjectival> ?? $<adjectival>.made
        !! die "Not a Verb, Adjective or Noun: "~$/.Str;
        my @args = $<variable-list>.made // [];
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
        } else {
            die "Not a Haku program: " ~ $/.Str;
        }
    }

    sub binop-expr-two-prec-levs(@args,@ops) {

        my $first-arg = @args[0];
        my $first = True;
        my $l2-args=Nil;#=();
        my @l1-args=();
        my $prev-l1-arg=Nil;
        my $l1-idx=0;
        for  0 .. @args.elems-2 -> $arg-idx {
            my $op = @ops[$arg-idx];
            my $arg = @args[$arg-idx+1];
            
            if $op.op eq ('/'|'*') {
                if $first {
                    $l2-args = BinOpExpr[$op, $first-arg,$arg].new;
                } else {
                    if $l2-args {
                    $l2-args = BinOpExpr[$op,$l2-args,$arg].new;
                    } else {
                        $l2-args = BinOpExpr[$op, $prev-l1-arg,$arg].new;
                    }
                }
            } else { # must be + or -
                if $first {
                    push @l1-args,$first-arg;
                }   
                if $l2-args {
                    push @l1-args, $l2-args; 
                } 
                if @ops[$arg-idx+1] and @ops[$arg-idx+1] eq ('+'|'-')                 
                {
                    push @l1-args,$arg;
                }                
                elsif $arg-idx == @args.elems-2  {
                    # die $arg.raku;
                    push @l1-args,$arg;
                }
                ++$l1-idx;
                $l2-args=Nil;
                $prev-l1-arg=$arg;
            }
            $first=False;    
        }

        my @l1-ops = @ops.grep({$_.op eq ('+'|'-')});
        my $l1-expr = @l1-args[0];
        # die @l1-args.raku;
        for  1 .. @l1-args.elems-1 -> $arg-idx {
            my $op = @l1-ops[$arg-idx-1];
            my $arg = @l1-args[$arg-idx];
            $l1-expr = BinOpExpr[$op, $l1-expr,$arg].new
        }
        return $l1-expr;
    }

}
