use v6;
use HakuAST;
use Romaji;
use JapaneseNumberParser;
our $toRomaji=True;
$V=False;

our $nspaces = 4;
my $indent = ' ' x $nspaces;
our %defined-functions;

sub ppHakuProgram(HakuProgram $p) is export {
     my @comments = $p.comments;
     my $comment_str = @comments.map({ '#' ~ $_}).join("\n") ~ "\n";
     my $function_strs = '';
     my @functions = $p.funcs;
         for @functions -> $function {
            $function_strs ~= ppFunction($function) ~ "\n";
         }     
     my $hon = $p.hon;
     my $hon_str = ppHon($hon);
     my $prelude_str = q:to/ENDPREL/;
use v6;
use HakuPrelude;
    
ENDPREL

     return $prelude_str ~  $function_strs ~ $comment_str ~ $hon_str;

}

sub ppFunction($f) {
    my Identifier $name = $f.name ;
    if $name.verb {
            %defined-functions{$name.verb.substr(0,1)} = $name.verb;
    }
    my Variable @args = $f.args;
    my $args_str = @args.map({ '\\' ~ ppHakuExpr($_) }).join( ', ' );
    my HakuExpr $body = $f.body;
    my $body_str = ppHakuExpr($body);
    my @comments = $f.comments;
    my $comment_str = @comments.map({ '#' ~ $_}).join("\n") ;
    $comment_str ~ "\n" ~
    'sub ' ~ ppFunctionName($name) ~'( '~ $args_str ~ ') {' ~ $body_str ~ '}';
}


sub ppFunctionName(\fn) {
    # say "ppFunctionName: " ~ fn.raku ;#if $V;
    given fn {
        when Verb { 
        my $f_name_ =  fn.verb;
        if $f_name_ ~~ / <[a..z]>+ / { return $f_name_ }
        my $verb-kanji = $f_name_.substr(0,1);
#        if %defined-functions{$verb-kanji}:exists {
#            $f_name_ = %defined-functions{$verb-kanji};            
#        } #else {        
          #  $f_name_ ~~ s/ [ 'くだ' | '下' ] 'さい' //;
        #}
         
            my $f_name = $toRomaji ?? kanjiToRomaji($f_name_) !! $f_name_;
            given $f_name {
                when / ^ [見せ|mise] / { 'show' } 
                when / ^ [畳|tata] / { 'foldl' }            
                when / ^ [写像|shazou|SHAZOU] / { 'map' } 
                when / ^ [合わせ|awaseru] / { 'concat' } 
                when / ^ [入れ|ireru] / { 'insert' } 
                when / ^ [消|kesu] / { 'delete' } 
                when / ^ [ 正引 | tadasiiINkisuru] / { 'lookup' }                 
                default { $f_name }      
            }            
        }
        when Noun {  
            say "NOUN: " ~ fn.noun ~ "=>" ~  kanjiToRomaji(fn.noun) if $V;
            my $f_name = $toRomaji ?? kanjiToRomaji(fn.noun).lc  !! fn.noun ;
            given $f_name {
                when / 頭 | atama/ { 'head' } 
                when / 尻尾 | sirio / { 'tail' }            
                when / 長さ | nagasa / { 'length' } 
                when / 鍵 | kagi / {'keys'}
                when / 値 | atai / {'values'}
                default { $f_name }      
            }            
        }
        when Variable { 
            ppVariable(fn.var)
        }
    }
}

sub ppHon($hon) {
    
    my @comments = $hon.comments;
    my $comment_str = @comments.map({';' ~ $_}).join("\n") ;

    my HakuExpr @bind_exprs = $hon.bindings;
    my HakuExpr @body_exprs = $hon.exprs;
    my $bindings_str = join("\n",map(&ppHakuExpr,@bind_exprs));
    my $body_str = join(";\n",map(&ppHakuExpr,@body_exprs));
    my $hon_name = $toRomaji ?? kanjiToRomaji($hon.name).lc !! $hon.name;
    if $hon_name eq 'honshin' { 
        $hon_name = 'honma';
    }
    my $hon_str = 'sub '~$hon_name~'() {' ~  "\n" ~
    $bindings_str ~  "\n" ~
    $body_str ~ "\n" ~ '}' ~"\n\n" ~$hon_name~"();\n";
#     my $hon_str = qq:to/ENDHON/;
# sub {$hon_name}() {
#     $bindings_str
#     $body_str
# }
# ENDHON
    return $hon_str;
}


sub ppConsLhsBindExpr(\h) {
    my @elts = h.lhs.cons;
    # die 'Only 4 consecutive cons operations are supported' if @elts.elems>5;
    my $elts_str = 
        'my (' ~ 
        @elts
            .grep( {$_ ~~ ConsVar})
            .map({ '\\' ~ ppVariable($_.var) })
            .join(',') 
            ~ ') ';
    my $rhs = ppHakuExpr(h.rhs);
    return $elts_str ~ ' = ' ~ $rhs ~ ';' ;
}


sub ppVariable($var) {
            my $tvar = $var;
            $tvar ~~ s/達/tachi/;

            my $ttvar = substituteKanjiToDigits($tvar); 
            $toRomaji ?? katakanaToRomaji($ttvar).lc !! $ttvar; 
}

sub ppHakuExpr(\h) {
            
    given h {
        when CommentedExpr {
            # say 'COMMENT: ' ~ h.comment;
            h.comment ~ ppHakuExpr(h.expr);
        }
        when BindExpr {  
            my $comment = h.comment // '';            
            given h.lhs {
                when Cons {
                    $comment ~ ppConsLhsBindExpr(h);
                }
                default {
                    $comment ~ 'my \\' ~ ppHakuExpr(h.lhs)~' = '~ppHakuExpr(h.rhs)~';'
                } 

            }        
        
        }
        when FunctionApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correct number of args
                    # So we need the definition 
                    # So we need state
            } else {
                my $maybeDot = h.function-name ~~ Variable ?? '.' !! '';
                say "FNAME: " ~ h.function-name.raku if $V;
                say "FARGS: " ~ h.args.raku if $V;
                ppFunctionName(h.function-name) ~ $maybeDot ~'('~ join( ', ' , h.args.map({ppHakuExpr($_)}) )~ ')';
            }            
        }
        when ListExpr {
            '['~ join(', ',map(&ppHakuExpr,h.elts)) ~']'
        }
        when MapExpr {
            '{'~ join(' => ',map(&ppHakuExpr,h.elts)) ~'}'
        }        
        when  IfExpr { 
            ('do if ' ~ ppHakuExpr(h.cond) ~ ' {' ,
                $indent ~ ppHakuExpr(h.if-true) ,
                '} else {' ,
                $indent ~ppHakuExpr(h.if-false),
                '}'
            ).join("\n");
        }   
        when LetExpr {
            (
                'do {', 
                join( "\n" , map(&ppHakuExpr,h.bindings)) ,  
                ppHakuExpr(h.result), 
                '}' 
            ).join("\n");
        }
        when LambdaExpr {

            'sub ('  ~ 
            join( ' ' , h.args.map({'\\' ~ ppHakuExpr($_)}) ) ~ 
            ') {' ~ 
            ppHakuExpr(h.expr) ~ 
            '}'; 

        }        
        # when ParensExpr {}
        when LambdaApplyExpr {
            if h.partial {
                    # Tricky! We need to know the correck number of args
                    # So we need the definition 
                    # So we need state
                    die "TODO: partial application using 'assuming' :" ~ h.raku;
            } else {                
                ppHakuExpr(h.lambda) ~ '(' ~ ~ join( ',' , h.args.map({ppHakuExpr($_)}) )~ ')';
            }            
        }
        when Number { h.num }
        when String { "'" ~ join('',h.chars) ~ "'" }
        when Variable {

            ppVariable(h.var)
        }
        when Verb {  $toRomaji ?? kanjiToRomaji(h.verb) !! h.verb }
        when Noun {  $toRomaji ?? kanjiToRomaji(h.noun).lc !! h.noun }
        when BinOpExpr {
             '(' ~ ppHakuExpr(h.args[0]) ~ ' ' ~h.op.op~' '~ ppHakuExpr(h.args[1]) ~ ')'
        }
        when RangeExpr {
            '[' ~ ppHakuExpr(h.from) ~ ' .. '~ ppHakuExpr(h.to) ~ ']'
        }
        when ZoiExpr {
            ('do {' ,
            ppHakuExpr(h.zoi-expr) ~ ';' ,
            ppHakuExpr(h.expr) , '}'    
            ).join("\n");            
        }
        when ChinaminiExpr {
            # TODO make this skippable with a flag!
            ppHakuExpr(h.expr);
        }
        when ConsNil {
            '[]'
        }
        default {
            die "TODO:" ~ h.raku;
        }        
    }
}
