use v6;

grammar Spaces {
    token TOP {  <wss>+ }
    token wss { 
        ' ws '  | 'nows'
    }

}

my $p = Spaces.subparse('nows ws nows');
say $p;
