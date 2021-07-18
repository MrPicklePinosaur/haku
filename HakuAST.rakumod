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
role BinOp[Str $op] {
    has $.op=$op;
}

role ConsExpr {}
role ConsVar[Str $var] does ConsExpr {
    has Str $.var = $var;
}
role ConsNil does ConsExpr {
}

role RhsExpr {}
role Variable[Str $var] does RhsExpr {
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
role BindExpr[ RhsExpr $rhs-expr, HakuExpr $expr]  does HakuExpr {
    has $.rhsExpr = $rhs-expr;
    has $.lhsExpr = $expr;
} 

# data HakuExpr = LetExpr | IfExpr | AtomicExpr | LambdaExpr | FunctionApplyExpr | LambdaApplyExpr | ParensExpr | BinOpExpr
role HakuExpr {}

# data BinOpExpr = mkBinOpExpr BinOp HakuExpr HakuExpr
role BinOpExpr[BinOp $op, HakuExpr $lhs-expr, HakuExpr $rhs-expr] does HakuExpr {
    has BinOp $.op=$op;
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

role AtomicExpr does HakuExpr {} 
# data LambdaExpr = mkLambdaExpr [Variable] HakuExpr
role LambdaExpr[Variable @lambda-args,HakuExpr $expr] {
    has @.lambda-args = @lambda-args;
    has $.expr = $expr;
} 

role FunctionApplyExpr[HakuExpr $args-expr, Identifier $function-name] does HakuExpr {
    has HakuExpr $.args-expr=$args-expr; 
    has Identifier $.function-name=$function-name;
}
role LambdaApplyExpr[HakuExpr $args-expr, LambdaExpr $lambda-name] does HakuExpr {
    has HakuExpr $.args-expr=$args-expr;
    has LambdaExpr $.lambda-name=$lambda-name;
}
role ParensExpr[HakuExpr $parens-expr] does HakuExpr {
    has $.parens-expr=$parens-expr;
}

# data AtomicExpr = Number | Identifier | String
role AtomicExpr does HakuExpr {}
role Number[Numeric $num] does AtomicExpr {
    has Numeric $.num = $num;
}
role String[Str $str] does AtomicExpr {
    has Str $.str = $str;
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
role Hon[HakuExpr @main] {
    has HakuExpr @.hon-exprs = @main;
}

