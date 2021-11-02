use v6;
unit module Raku;
use HakuAST;
use Romaji;
use JapaneseNumberParser;

# enum Kakikata <Romaji Kanji Kana Nai>;

our $KK=0;
our $toRomaji= True;

our $V=False; 

our $nspaces = 4;
my $indent = ' ' x $nspaces;

# I could put all predefined functions in here
our %defined-functions;

sub ppHakuProgram(HakuProgram $p) is export {
    $Romaji::V=$V;
    # die $KK==1;    
    $toRomaji = $KK==1;
     my @comments = $p.comments;
     my $comment_str = @comments.map({ '#' ~ $_}).join("\n") ~ "\n";
     my $function_strs = '';
     my @functions = $p.funcs;
         for @functions -> $function {
            $function_strs ~= ppFunction($function) ~ "\n";
         }     
     my $hon = $p.hon;
     my $hon_str = ppHon($hon);
     my $prelude_str = Q:to/ENDPREL/;
use v6;
#unit module Hon;
use lib ('runtime-lib');
use HakuPrelude;
    
ENDPREL

     return $prelude_str ~  $function_strs ~ $comment_str ~ $hon_str;

}

sub ppFunction($f) {
    
    my Identifier $name = $f.name ;
    my Variable @args = $f.args;
    my $args_str = @args.map({ '\\' ~ ppHakuExpr($_) }).join( ', ' ); # say $f.name;
    if $name ~~ Verb {
            %defined-functions{$name.verb.substr(0,1)} = [$name.verb,@args];
    } elsif $name ~~ Noun {
            %defined-functions{$name.noun} =  [$name.noun,@args];
    } elsif $name ~~ Adjective {
            %defined-functions{$name.adjective} =  [$name.adjective,@args];
    }

    my HakuExpr $body = $f.body;
    my $body_str = ppHakuExpr($body);
    my @comments = $f.comments;
    my $comment_str = @comments.map({ '#' ~ $_}).join("\n") ;
    my $sig_str = $args_str ?? '( '~ $args_str ~ ' )' !! '';
    $comment_str ~ "\n" ~
    'sub ' ~ ppFunctionName($name) ~ $sig_str ~ ' {' ~ $body_str ~ '}';
}


sub ppFunctionName(\fn) {
    # say "ppFunctionName: " ~ fn.raku ;#if $V;
    given fn {
        when Verb { 
        my $f_name_ =  fn.verb;
        say "ppFunctionName: VERB: " ~ $f_name_ ~ "=>" ~  kanjiToRomaji($f_name_) if $V;
        if $f_name_ ~~ / <[a..z]>+ / { return $f_name_ }
        my $verb-kanji = $f_name_.substr(0,1);
#        if %defined-functions{$verb-kanji}:exists {
#            $f_name_ = %defined-functions{$verb-kanji};            
#        } #else {        
          #  $f_name_ ~~ s/ [ 'くだ' | '下' ] 'さい' //;
        #}
            
            # my $f_name = 
            $toRomaji ?? kanjiToRomaji($f_name_) !! $f_name_;
            
            # given $f_name {
            #     # I/O
            #     when / ^ [ 見 |mise] / { die 'show' } 
            #     when / ^ [ 書 | kaku] / { 'write' }
            #     when / ^ [ 読 | yomu] / { 'read' }
            #     when / ^ [ 開 | aku] / { 'fopen' } 
            #     when / ^ [ 閉 | sima] / { 'close' }                 
            #     # map/fold
            #     when / ^ [ 畳 | tata] / { 'foldl' }             
            #     when / ^ [ 写像 | shazou|SHAZOU] / { 'map' } 
            #     # lists and maps 
            #     when / ^ [ 合わせ|awaseru] / { 'concat' } 
            #     when / ^ [ 入れ|ireru] / { 'insert' } 
            #     when / ^ [ 消|kesu] / { 'delete' } 
            #     when m:i/ ^ [ 正引 | tadasiiINkisuru] / { 'lookup' } 
            #     default { $f_name }      
            # }            
        }
        when Noun {  

            say "ppFunctionName: NOUN: " ~ fn.noun ~ "=>" ~  kanjiToRomaji(fn.noun) if $V;
            
            # my $f_name = 
            $toRomaji ?? kanjiToRomaji(fn.noun).lc  !! fn.noun ;
            # given $f_name {
            #      # lists
            #     when / 頭 | atama/ { 'head' } 
            #     when / 尻尾 | sirio / { 'tail' }            
            #      # lists and maps
            #     when / 長さ | nagasa / { 'length' } 
            #      # maps
            #     when / 鍵 | kagi / {'keys'}
            #     when / 値 | atai / {'values'}
            #     when m:i/ ^ [ 正引 | tadasiiINki] / { 'lookup' }
            #     default { $f_name }      
            # }            
        }
        when Adjective {  

            say "ppFunctionName: ADJECTIVE: " ~ fn.adjective ~ "=>" ~  kanjiToRomaji(fn.adjective) if $V;
            
            # my $f_name = 
            $toRomaji ?? kanjiToRomaji(fn.adjective).lc  !! fn.adjective ;
            # die $f_name;
            # given $f_name {                
            #     when /逆 | saka / {'reverse'}
            #     default { $f_name }
            # }
            
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
    my $hon_str = 'sub '~$hon_name~'() is export {' ~  "\n" ~
    $bindings_str ~  "\n" ~
    $body_str ~ "\n" ~ '}' ~"\n\n" ~$hon_name~"();\n";
    return $hon_str;
}

# TODO: Cons now supports nested lists, but not (yet) on the LHS
sub ppConsLhsBindExpr(\h) {
    my @elts = h.lhs.cons;
    my @pp_elts = @elts
            .grep( {$_ ~~ ConsVar})
            .map({  ppVariable($_.var.var) }); # TODO: overkill, simplify to .var
    my $last_elt = '@' ~ @pp_elts.tail ~ '_a';
    my @init_elts = @pp_elts.head(@pp_elts.elems-1).map({ '\\' ~ $_ });     

    my $elts_str = 
        'my (' ~ @init_elts.join(',')
        ~ ',' ~ $last_elt
        # @elts
        #     .grep( {$_ ~~ ConsVar})
        #     .map({ '\\' ~ ppVariable($_.var) })
            # .join(',') 
            ~ ') ';
    my $rhs = ppHakuExpr(h.rhs);
    return $elts_str ~ ' = ' ~ $rhs ~ ';' ~ "\n" ~ 'my \\' ~ @pp_elts.tail ~ ' = ' ~ $last_elt ~ ';';
}
sub ppIdentifier(\h) {
    # die 'TODO: needs ppVerb, ppNoun, ppAdjective';
    given h {
        when ConsVar {
           ppVariable h.var.var;
        }
        when Variable {
            ppVariable h.var;
        }
        when Verb {    
            ppVerb(h.verb);
        }
        when Noun　{
            ppNoun(h.noun);
        }
        when Adjective　{
            ppAdjective(h.adjective);
        }        
    }
}
sub ppListExprLhsBindExpr(\h) {
    my @elts = h.lhs.elts;
    my @pp_elts = @elts
            # .grep( {$_ ~~ ConsVar})
            .map({  '\\' ~ ppIdentifier($_) });
            # .map({ $_.raku });
    # my $last_elt = '@' ~ @pp_elts.tail ~ '_a';
    # my @init_elts = @pp_elts.head(@pp_elts.elems-1).map({ '\\' ~ $_ });     

    my $elts_str = 
        'my (' ~ @pp_elts.join(',')
        # ~ ',' ~ $last_elt
        # @elts
        #     .grep( {$_ ~~ ConsVar})
        #     .map({ '\\' ~ ppVariable($_.var) })
            # .join(',') 
            ~ ') ';
    my $rhs = ppHakuExpr(h.rhs);
    return $elts_str ~ ' = ' ~ $rhs ~ '; ';
}

sub ppVariable($var) {
            my $tvar = $var;
            $tvar ~~ s/達/tachi/ if $toRomaji;

            my $ttvar = $toRomaji ?? substituteKanjiToDigits($tvar) !! $tvar; 
            $toRomaji ?? katakanaToRomaji($ttvar).lc !! $ttvar; 
}

sub ppVerb (\h) {
    $toRomaji ?? kanjiToRomaji(h) !! h ;
}

sub ppNoun (\h) {
    say "ppHakuExpr: NOUN: " ~ h ~ ( $toRomaji  ?? "=>" ~  kanjiToRomaji(h) !! '') if $V;
    
    # if h eq '逆'　{ '&reverse'
    
    if h ~~ m:i/^ <[a..z]>/　{
        if %defined-functions{h}:exists {
            %defined-functions{h}[1] 
            ?? '&' ~ h  
            !! h  
        } else {
        '&' ~ h  
        }
    } else {
        my $n = $toRomaji ?? kanjiToRomaji(h).lc !! h ;
        if $n eq '無' or $n eq 'nai' {
            'Nil' 
        } elsif %defined-functions{h}:exists {
            # say "ppHakuExpr: ACTUAL NOUN: $n";
            %defined-functions{h}[1] ?? '&' ~ $n !! $n;
        } else {
            $n
        }
    }                            
}

sub ppAdjective (\h) {

    say "ppHakuExpr: ADJECTIVE: " ~ h ~ ( $toRomaji  ?? "=>" ~  kanjiToRomaji(h) !! '') if $V;
    
    # if h.noun eq '逆'　{ '&reverse'
    
    if h ~~ m:i/^ <[a..z]>/　{
        if %defined-functions{h}:exists {
            %defined-functions{h}[1] 
            ?? '&' ~ h  
            !! h  
        } else {
        '&' ~ h  
        }
    } else {
        my $n = $toRomaji ?? kanjiToRomaji(h).lc !! h ;
        if $n eq '無' or $n eq 'nai' {
            'Nil' 
        } elsif %defined-functions{h}:exists {
            say "ppHakuExpr: ACTUAL ADJECTIVE: $n" if $V;
            %defined-functions{h}[1] ?? '&' ~ $n !! $n;
        } else {
            $n
        }
    }
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
                when ListExpr {
                    $comment ~ ppListExprLhsBindExpr(h);
                }                
                default {
                    $comment ~ 'my \\' ~ ppHakuExpr(h.lhs)~' = '~ppHakuExpr(h.rhs)~';'
                } 

            }                        
        }
        # when FunctionCompApplyExpr {
        #     # Unused because currently we don't allow this in function application            
        #     # f nochi g nochi h
        #     # In Haskell we would have (h . g . f) x y z
        #     # In Raku I guess we can simply do h(g(f()))
        #     # TODO: partial
        #     my $ncalls = h.function-names.elems;
        #     my $function-call-seq=''
        #     for h.function-names.reverse -> $function-name {
        #         my $maybeDot = h.function-name ~~ Variable ?? '.' !! '';
        #         $function-call-seq ~= ppFunctionName($function-name) ~ $maybeDot ~'(';
        #     }
        #     my $closing-parens = ')' x $ncalls;
        #     $function-call-seq ~ 
        #     join( ', ' , h.args.map({ppHakuExpr($_)}) )
        #     ~ $closing-parens;
        # }
        # when FunctionCompExpr {
        #     # This is for unapplied composition. 
        #     # i.e. fg = g . f 
        #     # In Raku : my \fg = sub(\x) { }
        #     for h.function-names.reverse -> $function-name {
        #         my $maybeDot = $function-name ~~ Variable ?? '.' !! '';
        #         $function-call-seq ~= ppFunctionName($function-name) ~ $maybeDot ~'(';
        #     }
        #     my $closing-parens = ')' x $ncalls;
        #     ' -> \x { ' ~
        #     $function-call-seq ~ 
        #     join( ', ' , h.args.map({ppHakuExpr($_)}) )
        #     ~ $closing-parens
        #     ~ '}';
        # }

        when FunctionApplyExpr {
            
            if h.partial {
                '&' ~ ppFunctionName(h.function-name) ~ '.assuming' ~ '(' ~ join( ', ' , h.args.map({ppHakuExpr($_)}) )~ ')';
            } else {
                # I think I need to check if this function is in the table!
                my $maybeDot = h.function-name ~~ Variable ?? '.' !! '';
                say "FNAME: " ~ h.function-name.raku if $V;
                say "FARGS: " ~ h.args.raku if $V;
                ppFunctionName(h.function-name) ~ $maybeDot ~'('~ join( ', ' , h.args.map({ppHakuExpr($_)}) )~ ')';
            }            
        }
        when ListExpr {        
            '[' ~ join(', ' , map(&ppHakuExpr,h.elts)) ~ ']'
        }
        when MapExpr {
            '{' ~ join(' => ' , map(&ppHakuExpr,h.elts)) ~ '}'
        }        
        when  IfExpr {             
            my $if-str = ('do if (' ~ ppHakuExpr(h.cond) ~ ') {' ,
                $indent ~ ppHakuExpr(h.if-true) ,
                '}',
            ).join("\n");
            if not h.if-false ~~ Null {    
                $if-str ~ (
                ' else {' ,
                $indent ~ppHakuExpr(h.if-false),
                '}'
            ).join("\n");
            } else {
                $if-str;
            }
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
        when Boolean { h.bool }
        when String { "'" ~ join('',h.chars) ~ "'" }
        when Variable {
            ppVariable(h.var)
        }
        when Verb {  

            # TODO: kaku/yomu 
            # I think we generate 01 for read, 10 for write, assuming 11 for rw             
            # my $vn = 
            $toRomaji ?? kanjiToRomaji(h.verb) !! h.verb ;
            
            # if $vn ~~ / 読 | yomu / {
            #     'read';
            # }
            # elsif $vn ~~ / 書 | kaku / {
            #  'write';
            # }
            # else {
            #     $vn
            # }
        }
        when FunctionAsArg {            
            # %defined-functions{$name.adjective} =  [$name.adjective,@args];
            # say "ppHakuExpr: FUNCTION AS ARG: " ~ h.verb;
            '&' ~ ppHakuExpr(h.verb);
        }
        when Noun {  
            say "ppHakuExpr: NOUN: " ~ h.noun ~ ( $toRomaji  ?? "=>" ~  kanjiToRomaji(h.noun) !! '') if $V;
            
            # if h.noun eq '逆'　{ '&reverse'
            
            if h.noun ~~ m:i/^ <[a..z]>/　{
                if %defined-functions{h.noun}:exists {
                    %defined-functions{h.noun}[1] 
                    ?? '&' ~ h.noun  
                    !! h.noun  
                } else {
                '&' ~ h.noun  
                }
            } else {
                my $n = $toRomaji ?? kanjiToRomaji(h.noun).lc !! h.noun ;
                if $n eq '無' or $n eq 'nai' {
                    'Nil' 
                } elsif %defined-functions{h.noun}:exists {
                    # say "ppHakuExpr: ACTUAL NOUN: $n";
                    %defined-functions{h.noun}[1] ?? '&' ~ $n !! $n;
                } else {
                    $n
                }
            }                            
        }
        when Adjective {  
            say "ppHakuExpr: ADJECTIVE: " ~ h.adjective ~ ( $toRomaji  ?? "=>" ~  kanjiToRomaji(h.adjective) !! '') if $V;
            
            # if h.noun eq '逆'　{ '&reverse'
            
            if h.adjective ~~ m:i/^ <[a..z]>/　{
                if %defined-functions{h.adjective}:exists {
                    %defined-functions{h.adjective}[1] 
                    ?? '&' ~ h.adjective  
                    !! h.adjective  
                } else {
                '&' ~ h.adjective  
                }
            } else {
                my $n = $toRomaji ?? kanjiToRomaji(h.adjective).lc !! h.adjective ;
                if $n eq '無' or $n eq 'nai' {
                    'Nil' 
                } elsif %defined-functions{h.adjective}:exists {
                    say "ppHakuExpr: ACTUAL ADJECTIVE: $n" if $V;
                    %defined-functions{h.adjective}[1] ?? '&' ~ $n !! $n;
                } else {
                    $n
                }
            }                            
        }        
        when Null {
            'Nil'   
        }
        when Infinity {
            '∞'
        }
        when BinOpExpr {
             '(' ~ ppHakuExpr(h.args[0]) ~ ' ' ~h.op.op~' '~ ppHakuExpr(h.args[1]) ~ ')'
        }
        when ListOpExpr {
            my $list-op = '[' ~h.op.op~']';
            my $args_str = h.args.map({ ppHakuExpr($_) }).join( ', ' );
            $list-op ~ ' ' ~ $args_str;            
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
        # when ConsNil {
        #     '[]'
        # }
        when EmptyList {
            '[]'
        }
        when ConsVar {
            ppHakuExpr(h.var)
        }    
        when ConsList {
            '' ~ ppHakuExpr(h.list) ~ ''
        }            
        when Cons {
            my @pp_elts = h.cons.map(&ppHakuExpr);
            if @pp_elts.elems == 1 {
                '' ~ @pp_elts[0] ~ '';
            } else {
            my $last_elt = '|' ~ @pp_elts.tail ;
            my @init_elts = @pp_elts.head(@pp_elts.elems-1);#.map({ '\\' ~ $_ }); 
            '[' ~ @init_elts.join(',') ~ ', ' ~ $last_elt ~ ']'
            }
        }  
        default {
            die "TODO:" ~ h.raku;
        }        
    }
} # End of ppHakuExpr
