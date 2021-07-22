use v6;

role HakuExpr {...}

# data Identifier = Variable | Verb | Noun 
role Identifier {}
role Variable[Str $var] does Identifier {
    has $.var=$var;
}
role Verb[Str $verb] does Identifier {    
    has $.verb=$verb;
}
role Noun[Str $noun] does Identifier {
    has $.noun=$noun;
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

role RhsExpr {}
role Variable[$var] does RhsExpr {
    has Str $.var = $var;
}
role Tuple[RhsExpr @tuple] does RhsExpr {
    has RhsExpr @.tuple = @tuple;
}
role Cons[ConsExpr @cons] does RhsExpr {
    has ConsExpr @.cons = @cons;
}

# data HakuStmt = Function | Hon
role HakuStmt[] {}
role Function[] does HakuStmt {}
role Hon[] does HakuStmt {}

# data BindExpr = mkBindExpr LhsExpr RhsExpr 
#  does HakuExpr because of Hon, not very nice. Could be we need a separate bind expr for this.
role BindExpr[  $rhs-expr,  $expr]  does HakuExpr {
    has $.rhsExpr = $rhs-expr;
    has $.lhsExpr = $expr;
} 

# data HakuExpr = LetExpr | IfExpr | ListExpr | AtomicExpr | LambdaExpr | FunctionApplyExpr | LambdaApplyExpr | ParensExpr | BinOpExpr
role HakuExpr {}

# data BinOpExpr = mkBinOpExpr BinOp HakuExpr HakuExpr
role BinOpExpr[BinOp $op, HakuExpr $lhs-expr, HakuExpr $rhs-expr] does HakuExpr {
    has BinOp $.op=$op;
    has HakuExpr @.args = $lhs-expr, $rhs-expr;
}

# data LetExpr = mkLetExpr [BindExpr] ResultExpr
role LetExpr[BindExpr @bindings,HakuExpr $result] does HakuExpr  {
    has @.bind-exprs = @bindings;
    has $.result-expr = $result;
} 

# data IfExpr = mkIfExpr CondExpr ThenExpr ElseExpr
role IfExpr[HakuExpr $cond,HakuExpr $true-expr, HakuExpr $false-expr] does HakuExpr  {
    has HakuExpr $.cond=$cond;
    has HakuExpr $.true-expr=$true-expr;
    has HakuExpr $.false-expr=$false-expr;
}
role ListExpr[ @exprs] does HakuExpr {
    has  @.elts = @exprs;
}
role AtomicExpr does HakuExpr {} 
# data LambdaExpr = mkLambdaExpr [Variable] HakuExpr
role LambdaExpr[Variable @lambda-args,HakuExpr $expr] {
    has @.lambda-args = @lambda-args;
    has $.expr = $expr;
} 

role FunctionApplyExpr[HakuExpr @args-exprs, Identifier $function-name, Bool $partial] does HakuExpr {
    has HakuExpr @.args-exprs=@args-exprs; 
    has Identifier $.function-name=$function-name;
    has Bool $.partial = $partial;
}
role LambdaApplyExpr[HakuExpr @args-exprs, LambdaExpr $lambda-expr, Bool $partial] does HakuExpr {
    has HakuExpr @.args-exprs=@args-exprs;
    has LambdaExpr $.lambda-expr=$lambda-expr;
    has Bool $.partial = $partial;
}
role ParensExpr[HakuExpr $parens-expr] does HakuExpr {
    has $.parens-expr=$parens-expr;
}

# data AtomicExpr = Number | Identifier | String
role AtomicExpr[\_] does HakuExpr {
    has $._ = _;
}
role Number[ Num \num_] does AtomicExpr {
    has Num $.num = num_;
}
role String[Str @chars] does AtomicExpr {
    has Str @.chars = @chars;
}
role Null does AtomicExpr {}
role Identifier[Str $id] does AtomicExpr {
    has Str $.id = $id;
}

# data Function = mkFunction [FunctionArg] FunctionBody
role Function[Variable @args, HakuExpr $body] {
    has Variable @.function-args = @args;
    has HakuExpr $.function-body = $body;
}

# data Hon = mkHon [HakuExpr]
role Hon[ @main,  @comments] {
    has  @.exprs = @main;
    has @.comments = @comments;
}

role HakuProgram[@functions,$hon,@comments] {
    has  @.funcs = @functions;
    has $.hon = $hon;
    has @.comments = @comments;

}
