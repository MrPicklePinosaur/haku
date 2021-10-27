use v6;

sub show(\x) is export {
    say(x);
    return x.gist;
}

sub fopen(\fn, $mode?) is export {
    if $mode {
    if $mode.gist eq '&read' {
        open :r, fn or note( "Could not open file "~ fn ~ " for reading.") and exit 1;
    } 
    elsif $mode.gist eq '&write' {
        open :w, fn or note( "Could not open file "~ fn ~ " for writing.")  and exit 1;
    }
    }
    else {
        open :rw, fn or note( "Could not open file "~ fn ~ "in r/w mode." ) and  exit 1;
    }
}
sub read(  $fh, Sub $mode? ) is export {
    if $fh ~~ IO::Handle { 
        if $mode {
            if $mode.gist eq 'one' {
                $fh.get;
            }
            elsif $mode.gist eq 'all' {
                $fh.lines; 
            }
        } else {
            $fh.get;
        }
    } else { # Assuming failure    
        note 'Failed to open file for reading' && exit 1;
    }
    1;
}

sub enter(Sub $mode?) is export {
        if $mode {
            if $mode.gist eq 'one' {
                $*IN.get
            }
            elsif $mode.gist eq 'all' {
                $*IN.lines; 
            }
        } else {
            $*IN.get;
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

sub filter (\lst,&f) is export {
    lst.grep(&f); 
}


sub insert (\m,\k,\v) is export {
    m{k}=v;
    return m;    
}

# We use this for map as well as list
sub has (\m,\k) is export {
    given m {
        when Map {
            m{k}:exists 
        } 
        default {
           my \s = set m;
           s{k} 
        }
    }
}

sub lookup (\m,\k) is export {
    m{k}
}

sub delete (\m,\k) is export {
    m{k}:delete 
}
