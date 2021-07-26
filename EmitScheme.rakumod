use v6;
use HakuAST;
sub ppHakuProgram(HakuProgram $p) {
     my @comments = $p.comments;
     my $comment_str = @comments.map({';' ~ $_}).join("\n");
     my @functions = $p.functions;
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

    my HakuExpr $body = $hon.body;
    my $body_str = ppHakuExpr($body);
    '(define (本) (let' ~ $body_str ~ '))';
}

sub ppHakuExpr(\h) {
    given h {
        when BindExpr {}
        when FunctionApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
            } else {
                '(' ~ h.function-name ~ join( ' ' , h.args) ~ ')'
            }            
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
        when Variable { h.var}
        when Verb { h.verb }
        when Noun { h.noun }
        when BinOpExpr {
            '(' ~ h.op.op ~ ' ' ~ ppHakuExpr() ~ ' ' ~ ppHakuExpr() ~ ' )' 
        }
    }
}