use v6;

# role HakuExpr {...}
role HakuExpr {
    # has $.comment is rw;
}
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
role Noun[ $noun] does Identifier does HakuExpr　{
    has Str $.noun=$noun;
}

# I could enumerate them here instead
role BinOp[ $op] {
    has Str $.op=$op;
}

role ConsExpr {}
role ConsVar[Str $var] does ConsExpr {
    has Str $.var = $var;
}
role ConsNil does ConsExpr does HakuExpr {
}

role LhsExpr {}
role Tuple[ @tuple] does LhsExpr {
    has LhsExpr @.tuple = @tuple;
}
role Cons[ @cons] does LhsExpr {
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

# data HakuExpr = LetExpr | IfExpr | ListExpr | MapExpr | AtomicExpr | LambdaExpr | FunctionApplyExpr | LambdaApplyExpr | ParensExpr | BinOpExpr
# role HakuExpr {}

# data BinOpExpr = mkBinOpExpr BinOp HakuExpr HakuExpr
role BinOpExpr[ $op, $lhs-expr,  $rhs-expr] does HakuExpr {
    has BinOp $.op=$op;
    has HakuExpr @.args = $lhs-expr, $rhs-expr;
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
role MapExpr[ @exprs] does HakuExpr {
    has  @.elts = @exprs;
}

role RangeExpr[ $from-expr,$to-expr] does HakuExpr {
    has $.from = $from-expr;
    has $.to = $to-expr;
}


role AtomicExpr does HakuExpr {} 
# data LambdaExpr = mkLambdaExpr [Variable] HakuExpr
role LambdaExpr[ @lambda-args, $expr] does HakuExpr {
    has Variable @.args = @lambda-args;
    has HakuExpr $.expr = $expr;
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
role Identifier[ $id] does AtomicExpr {
    has Str $.id = $id;
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
