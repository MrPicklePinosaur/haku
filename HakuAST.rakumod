use v6;

role HakuExpr {...}
role LhsExpr {...}
# data Identifier = Variable | Verb | Noun 
role Identifier {}
role Variable[ $var] does Identifier does LhsExpr {
    has Str $.var=$var;
}
role Verb[ $verb] does Identifier {    
    has Str $.verb=$verb;
}
role Noun[ $noun] does Identifier {
    has Str $.noun=$noun;
}

# I could enumerate them here instead
role BinOp[ $op] {
    has $.op=$op;
}

role ConsExpr {}
role ConsVar[Str $var] does ConsExpr {
    has Str $.var = $var;
}
role ConsNil does ConsExpr {
}

role LhsExpr {}
# role Variable[$var] does LhsExpr {
#     has Str $.var = $var;
# }
role Tuple[ @tuple] does LhsExpr {
    has LhsExpr @.tuple = @tuple;
}
role Cons[ @cons] does LhsExpr {
    has ConsExpr @.cons = @cons;
}

# data HakuStmt = Function | Hon
role HakuStmt[] {}
role Function[] does HakuStmt {}
role Hon[] does HakuStmt {}

# data BindExpr = mkBindExpr LhsExpr RhsExpr 
#  does HakuExpr because of Hon, not very nice. Could be we need a separate bind expr for this.
role BindExpr[ $lhs-expr,  $rhs-expr]  does HakuExpr {
    has LhsExpr $.lhs = $lhs-expr;
    has HakuExpr $.rhs = $rhs-expr;
} 

# data HakuExpr = LetExpr | IfExpr | ListExpr | AtomicExpr | LambdaExpr | FunctionApplyExpr | LambdaApplyExpr | ParensExpr | BinOpExpr
role HakuExpr {}

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
role AtomicExpr does HakuExpr {} 
# data LambdaExpr = mkLambdaExpr [Variable] HakuExpr
role LambdaExpr[ @lambda-args, $expr] {
    has Variable @.args = @lambda-args;
    has HakuExpr $.expr = $expr;
} 

role FunctionApplyExpr[ @args-exprs, $function-name, $partial] does HakuExpr {
    has HakuExpr @.args=@args-exprs; 
    has Identifier $.function-name=$function-name;
    has Bool $.partial = $partial;
}
role LambdaApplyExpr[@args-exprs, $lambda-expr, $partial] does HakuExpr {
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
role Function[ $name, @args,  $body] {
    has Str $.name = $name;
    has Variable @.args = @args;
    has HakuExpr $.body = $body;
}

# data Hon = mkHon [HakuExpr]
role Hon[ @main,  @comments] {
    has  @.exprs = @main;
    has @.comments = @comments;
}

role HakuProgram[ @functions, $hon, @comments] {
    has @.funcs = @functions;
    has $.hon = $hon;
    has @.comments = @comments;
}
