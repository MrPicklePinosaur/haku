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

sub ppHon($hon) {
    my @comments = $hon.comments;
    my $comment_str = @comments.map({';' ~ $_}).join("\n");

    my HakuExpr @bind_exprs = $hon.bindings;
    my HakuExpr @body_exprs = $hon.exprs;
    my $bindings_str = join("\n",map(&ppHakuExpr,@bind_exprs));
    my $body_str = join("\n",map(&ppHakuExpr,@body_exprs));
    "(define (hon)\n(let\n(\n$bindings_str\n)\n$body_str\n))";
}

sub ppHakuExpr(\h) {
    given h {
        when BindExpr { '(' ~ ppHakuExpr(h.lhs) ~ ' ' ~ ppHakuExpr(h.rhs) ~ ')' }
        when FunctionApplyExpr {
            # die h.raku;
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
            } else {
                '(' ~ ppFunctionName(h.function-name) ~ ' ' ~ join( ' ' , h.args.map({ppHakuExpr($_)}) ) ~ ')'
            }            
        }
        when ListExpr {
            '('~ join(' ',map(&ppHakuExpr,h.elts)) ~')'
        }
        when LambdaExpr {
            # h.args 
            # h.expr 

        }
        when LambdaApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
            } else {
                '(lambda ' ~ ppHakuExpr(h.lambda) ~  join( ' ' , h.args) ~ ')'
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

sub ppFunctionName(\fn) {
    given fn {
        when Verb { kanjiToRomaji(fn.verb) }
        when Noun { kanjiToRomaji(fn.noun) }
        when Variable { katakanaToRomaji(fn.var)}
    }
}