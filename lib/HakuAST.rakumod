use v6;

# role HakuExpr {...}
role HakuExpr {}
role CommentedExpr[$e,$c] does HakuExpr {
    has HakuExpr $.expr = $e;
    has Str $.comment = $c;
}
role LhsExpr {...}
# data Identifier = Variable | Verb | Noun 
role Identifier {}
role Variable[ $var] does Identifier does LhsExpr does HakuExpr {
    has Str $.var=$var;
}
role Verb[ $verb] does Identifier does HakuExpr {    
    has Str $.verb=$verb;
}
role Noun[ $noun] does Identifier does LhsExpr does HakuExpr　{
    has Str $.noun=$noun;
}

role Adjective[ $adjective] does Identifier does LhsExpr does HakuExpr　{
    has Str $.adjective=$adjective;
}

role FunctionAsArg[$verb] does HakuExpr {
    has Verb $.verb = $verb;
}
# I could enumerate them here instead
role Operator[ $op] {
    has Str $.op=$op;
}

# The allowed expressions in a cons: variable, [...], []
role ConsExpr {}
role ConsVar[ $var] does ConsExpr {
    has Variable $.var = $var;
}
role ConsList[ $lst] does ConsExpr {
    has HakuExpr $.list = $lst;
}

role ConsNil does ConsExpr does HakuExpr {
}

role LhsExpr {}
role Tuple[ @tuple] does LhsExpr {
    has LhsExpr @.tuple = @tuple;
}
role Cons[ @cons] does LhsExpr does HakuExpr {
    has ConsExpr @.cons = @cons;
}

# data HakuStmt = Function | Hon
# role HakuStmt[] {}
# role Function[] does HakuStmt {}
# role Hon[] does HakuStmt {}

# data BindExpr = mkBindExpr LhsExpr RhsExpr 
#  does HakuExpr because of Hon, not very nice. Could be we need a separate bind expr for this.
role BindExpr[ $lhs-expr, $rhs-expr, $comment]  does HakuExpr {
    has LhsExpr $.lhs = $lhs-expr;
    has HakuExpr $.rhs = $rhs-expr;
    has Str $.comment = $comment;
} 

# data HakuExpr = LetExpr | IfExpr | ListExpr | MapExpr | AtomicExpr | LambdaExpr | FunctionApplyExpr | LambdaApplyExpr | ParensExpr | BinOpExpr | ListOpExpr
# role HakuExpr {}

# data BinOpExpr = mkBinOpExpr BinOp HakuExpr HakuExpr
role BinOpExpr[ $op, $lhs-expr,  $rhs-expr] does HakuExpr {
    has Operator $.op=$op;
    has HakuExpr @.args = $lhs-expr, $rhs-expr;
}

role ListOpExpr[ $op, @args] does HakuExpr {
    has Operator $.op=$op;
    has HakuExpr @.args = @args;
}

# data LetExpr = mkLetExpr [BindExpr] ResultExpr
role LetExpr[ @bindings, $result] does HakuExpr  {
    has BindExpr @.bindings = @bindings;
    has HakuExpr $.result = $result;
} 

# data IfExpr = mkIfExpr CondExpr ThenExpr ElseExpr
role IfExpr[ $cond, $true-expr,  $false-expr] does HakuExpr  {
    has HakuExpr $.cond=$cond;
    has HakuExpr $.if-true=$true-expr;
    has HakuExpr $.if-false=$false-expr;
}
role ListExpr[ @exprs] does HakuExpr {
    has  @.elts = @exprs;
}

role EmptyList does ConsExpr does HakuExpr {}
role MapExpr[ @exprs] does HakuExpr {
    has  @.elts = @exprs;
}

role RangeExpr[ $from-expr,$to-expr] does HakuExpr {
    has $.from = $from-expr;
    has $.to = $to-expr;
}

# This *must* be here or else it goes horribly wrong
role AtomicExpr does HakuExpr {} 
# data LambdaExpr = mkLambdaExpr [Variable] HakuExpr
role LambdaExpr[ @lambda-args, $expr] does HakuExpr {
    has Variable @.args = @lambda-args;
    has HakuExpr $.expr = $expr;
} 

role FunctionCompExpr[ @function-names] does HakuExpr {
    has Identifier @.function-names=@function-names;
}

role FunctionCompApplyExpr[ @function-names, @args-exprs, $partial] does HakuExpr {
    has Identifier @.function-names=@function-names;
    has HakuExpr @.args=@args-exprs; 
    has Bool $.partial = $partial;
}

role FunctionApplyExpr[ $function-name, @args-exprs, $partial] does HakuExpr {
    has Identifier $.function-name=$function-name;
    has HakuExpr @.args=@args-exprs; 
    has Bool $.partial = $partial;
}
role LambdaApplyExpr[$lambda-expr,  @args-exprs, $partial] does HakuExpr {
    has HakuExpr @.args=@args-exprs;
    has LambdaExpr $.lambda=$lambda-expr;
    has Bool $.partial = $partial;
}
role ParensExpr[ $parens-expr] does HakuExpr {
    has $.expr=$parens-expr;
}

# data AtomicExpr = Number | Identifier | String
role AtomicExpr[\_] does HakuExpr {
    has $._ = _;
}
role Number[ \num_] does AtomicExpr {
    has Num $.num = num_;
}
role String[ @chars] does AtomicExpr {
    has Str @.chars = @chars;
}

role Null does AtomicExpr {}
role Infinity does AtomicExpr {}

role Identifier[ $id] does AtomicExpr {
    has Str $.id = $id;
}

role ChinaminiExpr[\expr] does HakuExpr {
    has HakuExpr $.expr = expr;
}

role ZoiExpr[\expr,\zoi-expr] does HakuExpr {
    has HakuExpr $.expr = expr;
    has HakuExpr $.zoi-expr = zoi-expr;
}

# data Function = mkFunction [FunctionArg] FunctionBody
role Function[ $name, @args,  $body, @comments] {
    has Identifier $.name = $name;
    has Variable @.args = @args;
    has HakuExpr $.body = $body;
    has Str @.comments = @comments;
}

# data Hon = mkHon [HakuExpr]
role Hon[ $name, @bindings, @exprs,  @comments] {
    has Str $.name = $name;
    has HakuExpr @.bindings = @bindings;
    has HakuExpr @.exprs= @exprs;
    has Str @.comments = @comments;
}

role HakuProgram[ @functions, $hon, @comments] {
    has Function @.funcs = @functions;
    has Hon $.hon = $hon;
    has Str @.comments = @comments;
}
