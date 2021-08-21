use v6;
use HakuAST;
use Romaji;
our $toRomaji=False;
sub ppHakuProgram(HakuProgram $p) is export {
     my @comments = $p.comments;
     my $comment_str = @comments.map({';' ~ $_}).join("\n") ~ "\n";
     my $function_strs = '';
     my @functions = $p.funcs;
         for @functions -> $function {
            $function_strs ~= ppFunction($function) ~ "\n";
         }     
     my $hon = $p.hon;
     my $hon_str= ppHon($hon);
     my $prelude_str = '(define (displayln str) (display str) (newline))' ~ "\n\n";
     return $prelude_str ~ $comment_str ~ $function_strs ~ $hon_str;

}

sub ppFunction($f) {
    # die $f.name;
    my Identifier $name = $f.name ;
    my @args = $f.args;
    # die $f.args.raku;
    my $args_str = @args.map(&ppHakuExpr).join( ' ' );
    my HakuExpr $body = $f.body;
    my $body_str = ppHakuExpr($body);
    '(define (' ~ ppFunctionName($name) ~ ' ' ~  $args_str ~ ') ' ~ $body_str ~ ')';
}

sub ppFunctionName(\fn) {
    given fn {
        when Verb { 
            my $f_name = $toRomaji ?? kanjiToRomaji(fn.verb) !! fn.verb;
            if $f_name ~~ / ^ mise / {
                return 'displayln'
            } else {
                $f_name
            }
        }
        when Noun {  $toRomaji ?? kanjiToRomaji(fn.noun)  !! fn.noun }
        when Variable { $toRomaji ?? katakanaToRomaji(fn.var) !! fn.var}
    }
}


sub ppHon($hon) {
    my @comments = $hon.comments;
    my $comment_str = @comments.map({';' ~ $_}).join("\n");

    my HakuExpr @bind_exprs = $hon.bindings;
    my HakuExpr @body_exprs = $hon.exprs;
    my $bindings_str = join("\n",map(&ppHakuExpr,@bind_exprs));
    my $body_str = join("\n",map(&ppHakuExpr,@body_exprs));    
    if $toRomaji {
    "(define (hon)\n(let*\n(\n$bindings_str\n)\n$body_str\n))\n\n(hon)\n";
    } else {
    "(define (本)\n(let*\n(\n$bindings_str\n)\n$body_str\n))\n\n(本)\n";
    }
}

sub ppConsLhsBindExpr(\h) {
    my @elts = h.lhs.cons;
    die 'Only 4 consecutive cons operations are supported' if @elts.elems>5;
    my $rhs = ppHakuExpr(h.rhs);
    my @crs =<car cadr caddr cadddr cadddr>;
    my @cons_bindings=();
# FIXME: if the last elt is Nil, this is OK, but otherwise the final var is the cdr or equivalent.
# So we should remove the last elt and check it. Then we decide on cdr etc  based on the number of elts
    for @elts -> $elt {
        given $elt {
            when ConsVar {
                @cons_bindings.push( '(' ~ ( $toRomaji ?? katakanaToRomaji($elt.var) !! $elt.var)~ ' (' ~ @crs.shift ~ ' ' ~ $rhs ~ '))' )
            }
            # when ConsNil {

            # }
        }            
    }
    return @cons_bindings.join("\n");
}

sub ppHakuExpr(\h) {
    given h {
        when BindExpr { 
            given h.lhs {
                when Cons {
                    ppConsLhsBindExpr(h);
                }
                default {
                    '(' ~ ppHakuExpr(h.lhs) ~ ' ' ~ ppHakuExpr(h.rhs) ~ ')' 
                }

            }
            
            }
        when FunctionApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
            } else {
                '(' ~ ppFunctionName(h.function-name) ~ ' ' ~ join( ' ' , h.args.map({ppHakuExpr($_)}) ) ~ ')'
            }            
        }
        when ListExpr {
            '(list '~ join( ' ' , map(&ppHakuExpr,h.elts)) ~ ')'
        }
        when  IfExpr { 
            '(if ' ~ 
                ppHakuExpr(h.cond) ~ ' ' ~
                ppHakuExpr(h.if-true) ~ ' ' ~
                ppHakuExpr(h.if-false) ~ ' ' ~
                ')';
        }   
        when LetExpr {
            '(let* (' ~  join( ' ' , map(&ppHakuExpr,h.bindings)) ~  ') ' ~  ppHakuExpr(h.result)  ~ ')'
        }
        when LambdaExpr {
                '(lambda ('  ~ join( ' ' , h.args.map({ppHakuExpr($_)}) ) ~ ') '
             ~ ppHakuExpr(h.expr) ~ ')'; 

        }

        when LambdaApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
            } else {
                '(lambda ' ~ ppHakuExpr(h.lambda) ~  ' ' ~ join( ' ' , h.args.map({ppHakuExpr($_)}) ) ~ ')'
            }            
        }
        when Number { h.num }
        when String { join('',h.chars) }
        when Variable { $toRomaji ?? katakanaToRomaji(h.var) !! h.var }
        when Verb {  $toRomaji ?? kanjiToRomaji(h.verb) !! h.verb }
        when Noun {  $toRomaji ?? kanjiToRomaji(h.noun) !! h.noun }
        when BinOpExpr {
            '(' ~ h.op.op ~ ' ' ~ ppHakuExpr(h.args[0]) ~ ' ' ~ ppHakuExpr(h.args[1]) ~ ' )' 
        }
        default {
            die "TODO:" ~ h;
        }
    }
}

