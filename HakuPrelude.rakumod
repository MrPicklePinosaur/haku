use v6;

sub head(List \lst) is export {
    lst.head;
}

sub tail(List \lst --> List) is export {
    List.new(|lst.tail(lst.elems-1));
}

sub concat(List \l1, List \l2 --> List) is export { |l1,|l2 }

sub foldl (&f, \acc, List \lst) is export  {
    my $res = acc;
    for  lst -> \elt {
        $res = f($res,elt);
    }
    $res;
}  

sub insert (\m,\k,\v) is export {
    m{k}=v;
    return m;    
}

sub has (\m,\k) is export {
    m{k}:exists 
}

sub lookup (\m,\k) is export {
    m{k}
}

sub delete (\m,\k) is export {
    m{k}:delete 
}