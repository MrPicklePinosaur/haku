use v6;

grammar Expression {
    token TOP { <expression> }

    token expression  {
        <let_expression> |
        <ifthen_expression> |
        
        [
            <operator_expression> ||
            <apply_expression>
        ] |
        <parens_expression> |
        <atomic_expression> 
    }
    token open_maru { '('}
    token close_maru { ')'}
    token number {
        \d+
    }
    token string_char {
        \w | <[,;.!?\s]>
    }
    token string {
        '"' <string_char>+ '"'
        
    }
    token identifier { \w+  }
    token list_operator { ',' }
    token reserved_words {
         'if' | 'then' | 'else' | 'let' | 'in' 
    }
    token atomic_expression {
        <number> | <string> |
        <identifier> 
    }
    token arg_expression_list {
        <arg_expression> [<.list_operator> <arg_expression>]*
    }

    token parens_expression { <.open_maru>  <operator_expression>  <.close_maru> }

    token apply_expression {
        <identifier> '(' <arg_expression_list> ')'
    }
    token arg_expression {
        <parens_expression> |
        <apply_expression> |
        <atomic_expression>
    }
    token arith_operator {
        '+' | '-' | '*' | '/'
    }
    token comparison_operator {
        '==' | '<' | '>' | '!=' | '>=' | '<='
    }    
    token binop {
        <arith_operator> | <comparison_operator> # and some others
    }
    token operator_expression {
        <arg_expression> <binop> <arg_expression>
    }

    token let_expression {
        'let' <.ws> <bind_expression>+ 'in' <.ws> <expression> <.ws>
    }

    token bind_expression {
        <identifier> '=' <expression> <.ws>?
    }

    token ifthen_expression {    
        'if{' <condition_expression> '}then{' <expression> '}else{' <expression> '}'
    }
    # - An `if-then` condition can be one of the following:

    token condition_expression {    
        <operator_expression> |
        <apply_expression> |   
        # <operator_expression> |
        <parens_expression> |
        <atomic_expression>
    }
    # - A `comparison_expression` cannot contain if-then or let in its sub-epxressions
    # token comparison_expression {
    #     <comparison_expression_arg> <comparison_operator> <comparison_expression_arg>
    # }
    # token comparison_expression_arg {
    #     <parens_expression> |
    #     <apply_expression> |
    #     # <operator_expression> |
    #     # <parens_expression> |
    #     <atomic_expression>
    # }
}

class ExpressionActions {
    method expression ($/) {
        if $<atomic_expression> {
            make 'E:AE>'~$<atomic_expression>.made
        } elsif  $<operator_expression> {
            make 'E:OP>'~$<operator_expression>.made
        } else {

            make "E:EXPR>>$/";
        }
    }
    method number($/) {
        make "$/"*1;
    }
    method string($/) {
        my @chars= map({$_.Str},$<string_char>);
        make @chars;
    }
    method atomic_expression($/) {
        # say 'HERE:'~$/;
        if $<number>  {            
            make "ATE:NR(" ~ $<number>.made ~')';
        }
        if $<string>  {            
            make "ATE:ST(" ~ $<string>.made ~')';
        }
         $<identifier> &&
            make "ATE:ID(" ~ $<identifier>~')';
        
    }
    method arg_expression($/) {
        if $<parens_expression> {
            make 'ARE:PAE>'~$<parens_expression>.made;
        }
        if $<apply_expression> {
            make 'ARE:APE>'~$<apply_expression>.made;
        }
        if $<atomic_expression> {
            make 'ARE:ATE>'~$<atomic_expression>.made;
        }
        
    }
    method operator_expression($/) {
        make 'OPE:'~$<binop>~'('~$<arg_expression>[0].made~','~$<arg_expression>[1].made~')';
    }
    method condition_expression($/) {
         
        
        if $<operator_expression>   {
            make "CE:OPE>" ~ $<operator_expression>
        } 
        elsif $<apply_expression> {
            make "CE:APE>" ~ $<apply_expression>
        }
        elsif $<parens_expression>  {
            make "CE:PAE>" ~ $<parens_expression>
        } elsif $<atomic_expression>  {
            make "CE:ATE>" ~ $<atomic_expression>.made
        }

    }
    method ifthen_expression($/) {
        # say $/.raku;
        # say 'HASH:'~$<expression>[0].raku;
        say 'IF '~$<condition_expression>.made ~ ' THEN '~ $<expression>[0].made ~  ' ELSE ' ~ $<expression>[1].made ~ 'END IF';
        # say 'DONE';
    }
}
# my $var1 = Expression.parse("var",:rule("atomic_expression"));
# my $var2 = Expression.parse("then",:rule("atomic_expression"));
# say $var1; 
# say $var2;
# die;

my $let1 = Expression.subparse("let
x=6
y=\"zeven\"
in
x*y
",:actions(ExpressionActions));
say $let1;
# die;

my $let2 = Expression.parse("let
x=let
a=3
in
a*a
y=h(11)+(f(7)+3)
in
x*y
");
say $let2;

# my $let3 = Expression.subparse("x=f(7)+g(11)",:rule('bind_expression'));
# say $let3;
my $ast={};
my $if1 = Expression.parse('if{x<y}then{6*"zeven"}else{vv}',:actions(ExpressionActions));
say $if1;
