use v6;

sub show(\x) is export {
    say(x);
    return x.gist;
}

sub fopen(\fn, $mode?) is export {
    
    if $mode {
    if $mode == 1 {
        open :r, fn;
    } 
    elsif $mode == 2 {
        open :w, fn;
    }
    }
    else {
        open :rw, fn;
    }
}
sub read($fh?) is export {
    if $fh { 
        $fh.get;
    } 
    1;
}

sub write($str?,$fh?) is export {
    if $fh { 
        $fh.put($str);
    } 
    2;
}

sub head( \lst) is export {
    given lst {
        when Str { 
            lst.substr(0,1)
        }
        default {
            lst.head;
        }
    }
}

sub tail(\lst) is export {
    given lst {
        when Str { lst.substr(1)}
        default {
            List.new(|lst.tail(lst.elems-1));
        }
    }
}

sub length(\lst) is export {
    given lst {
        when Str {
            lst.chars
        }
        default {
            lst.elems
        }
    }
}

sub concat(\l1, \l2) is export { 
    given l1 {
        when Str {
            l1 ~ l2
        }
        default {            
            |l1,|l2 
        }
    }        
}
# TODO: make work on strings
sub foldl (List \lst, \acc, &f) is export  {
    my $res = acc;
    for  lst -> \elt {
        $res = f($res,elt);
    }
    $res;
}  
# TODO: map needs a wrapper to make it work on strings
sub map (\lst, &f) is export  {
    lst.map(&f);
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