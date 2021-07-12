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

    token identifier { \w+  }
    token list_operator { ',' }
    token reserved_words {
         'if' | 'then' | 'else' | 'let' | 'in' 
    }
    token atomic_expression {
        <number> | 
        <identifier> 
    }
    token arg_expression_list {
        <arg_expression> [<list_operator> <arg_expression>]*
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
        make "EXPR: $/";
    }
    method condition_expression($/) {
         
        
        if not $<operator_expression> ~~ Nil  {
            make "COND EXPR: OP " ~ $<operator_expression>
        } 
        elsif 
        not $<apply_expression> ~~  Nil {
            make "COND EXPR: APPLY " ~ $<apply_expression>
        }
        elsif
        not $<parens_expression> ~~ Nil {
            make "COND EXPR: PARENS " ~ $<parens_expression>
        } elsif 
        not $<atomic_expression> ~~ Nil {
            make "COND EXPR: ATOMIC " ~ $<atomic_expression>
        }

    }
    method ifthen_expression($/) {
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
y=7
in
x*y
");
say $let1;


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
my $if1 = Expression.parse('if{x<y}then{6*7}else{vv}',:actions(ExpressionActions));
say $if1;
