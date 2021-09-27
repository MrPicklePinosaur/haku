use v6;
# 1 +2 -3 *4 /5 +6 *7 *8 -9 -10 /11 *12 +13 +14 *15 -16
my @args = 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;
my @ops = '+','-','*','/','+','*','*','-','-','/','*','+','+','*','-','-';

my $first-arg = @args[0];
my $first = True;
my $l2-args=Nil;#=();
my @l1-args=();
my $prev-l1-arg=Nil;
my $l1-idx=0;
for  0 .. @args.elems-2 -> $arg-idx {
    my $op = @ops[$arg-idx];
    my $arg = @args[$arg-idx+1];
    
    if $op eq ('/'|'*') {
        say "l2 $op $arg  ";
        if $first {
            # push @l2-args,$first-arg;   
            $l2-args =     [$first-arg,$arg,$op];
        } else {
            if $l2-args {
            $l2-args =     [$l2-args,$arg,$op];
            } else {
                $l2-args =     [$prev-l1-arg,$arg,$op];
            }
        }
        
        # push @l2-args,$arg;        
         say $l2-args.raku;
    } else { # must be + or -
    say "l1 $op $arg  ";
        if $first {
            push @l1-args,$first-arg;
        }   
        if $l2-args {
            push @l1-args, $l2-args;#[@l2-args];
        } #else {
            if @ops[$arg-idx+1] and @ops[$arg-idx+1] eq ('+'|'-') {
            push @l1-args,$arg;
            }
        #}
        ++$l1-idx;
        # say 'l1: ',@l1-args;
        # @l2-args=();
        $l2-args=Nil;
        $prev-l1-arg=$arg;
    }
    $first=False;    
}

my @l1-ops = @ops.grep({$_ eq ('+'|'-')});
say @l1-args.raku;
say @l1-args.elems;
say @l1-ops.raku;
my $l1-expr = @l1-args[0];
for  1 .. @l1-args.elems-2 -> $arg-idx {
    my $op = @l1-ops[$arg-idx-1];
    my $arg = @l1-args[$arg-idx];
$l1-expr = [$l1-expr,$arg, $op]
}
say $l1-expr.raku;
