use v6;
use HakuAST;
use Romaji;

sub ppHakuProgram(HakuProgram $p) is export {
     my @comments = $p.comments;
     my $comment_str = @comments.map({';' ~ $_}).join("\n");
     my @functions = $p.funcs;
         for @functions -> $function {
            ppFunction($function)
         }     
     my $hon = $p.hon;
     ppHon($hon);

}

sub ppFunction($f) {
    my Str $name = $f.name ;
    my Variable @args = $f.args;
    my $args_str = @args.join( ' ' );
    my HakuExpr $body = $f.body;
    my $body_str = ppHakuExpr($body);
    '(define (' ~ $name ~ $args_str ~ ') ' ~ $body_str ~ ')';
}

sub ppFunctionName(\fn) {
    given fn {
        when Verb { 
        my $f_name = kanjiToRomaji(fn.verb);
        if $f_name ~~ / ^ mise / {
        return 'displayln'
        } else {
        $f_name
        }
        }
        when Noun { kanjiToRomaji(fn.noun) }
        when Variable { katakanaToRomaji(fn.var)}
    }
}


sub ppHon($hon) {
    my @comments = $hon.comments;
    my $comment_str = @comments.map({';' ~ $_}).join("\n");

    my HakuExpr @bind_exprs = $hon.bindings;
    my HakuExpr @body_exprs = $hon.exprs;
    my $bindings_str = join("\n",map(&ppHakuExpr,@bind_exprs));
    my $body_str = join("\n",map(&ppHakuExpr,@body_exprs));
    '(define (displayln str) (display str) (newline))' ~
    "(define (hon)\n(let*\n(\n$bindings_str\n)\n$body_str\n))\n\n(hon)\n";
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
                @cons_bindings.push( '(' ~ katakanaToRomaji($elt.var) ~ ' (' ~ @crs.shift ~ ' ' ~ $rhs ~ '))' )
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
            '(list '~ join(' ',map(&ppHakuExpr,h.elts)) ~')'
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
        when Variable { katakanaToRomaji(h.var)}
        when Verb { h.verb }
        when Noun { h.noun }
        when BinOpExpr {
 '(' ~ h.op.op ~ ' ' ~ ppHakuExpr(h.args[0]) ~ ' ' ~ ppHakuExpr(h.args[1]) ~ ' )' 
        }
    }
}

