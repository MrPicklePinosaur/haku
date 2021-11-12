use v6;
use lib ();
use lib ('.');
use Haku;
use HakuActions;
use HakuAST;
use HakuReader;
use Tategaki;
use Raku;

enum Kakikata <Romaji 1 Kanji 2 Kana 3>;
# TODO: for Kanji or Kana need to get the verbs in dict form§
# [--kakikata, -k] : generate code with Romaji, Kanji or Kana (default is Romaji).

sub USAGE() {
    print Q:c:to/EOH/;
    Usage: haku <Haku program, written horizontally or vertically, utf-8 text file>
        [--tategaki, -t] : do not run the program but print it vertically.
        [--miseru, -m] : just print the Raku source code, don't execute.
        [--yomudake, -y] : just print the Haku source after reading, as a single line. Don't execute.
        [--parse-only, -p] : for debugging, parse and print out the parse tree.
        [--subparse, -s] : for debugging, use subparse instead of parse.
        [--rule, -r] :  for debugging, use a specific grammar rule.
        [--verbose, -v] : for debugging, verbose output.
        [--expression, -e] : provide an expression string instead of a file name 
 EOH
}

unit sub MAIN(
          Str $src_file = 'NONE',
          Bool :t($tategaki) = False,   
          Bool :m($miseru) = False,
          Kakikata :k($kakikata) = Romaji,
          Bool :y($yomudake) = False,          
          Bool :p($parse-only) = False,
          Bool :v($verbose) = False,
          Bool :s($subparse) = False,
          Str :r($rule), 
          Str :e($expression) 
        );  

if ($verbose) { 
    $Raku::V=True;    
    $HakuActions::V=True;
}

if ($kakikata) {
    $Raku::KK = $kakikata.value;    
} else {
    $Raku::KK = 1;
}

my $use-expression = False;

if $src_file eq 'NONE'  {
    if not $expression.defined {
         die "Please provide an input file or expression\n";
    } else {
        $use-expression = True;
    }
}

if $tategaki {
    say tategakiWriter($src_file);
    exit;
}

my $program_str = $use-expression ?? $expression !! hakuReader($src_file);

if $yomudake { 
    say $program_str;
    exit;
}

if $parse-only or $subparse { 
    $reportErrors = False;
    if $subparse {
        if $rule {
            say Haku.subparse($program_str,:rule($rule));
        } else {
            say Haku.subparse($program_str);
        }
    } else {
        if $rule {
        say Haku.parse($program_str,:rule($rule));
        } else {
        say Haku.parse($program_str);
        }
    }
    exit;
} else {
    my $hon_parse = $rule 
        ?? Haku.parse($program_str, :actions(HakuActions),:rule($rule)) 
        !! Haku.parse($program_str, :actions(HakuActions));
    if $rule {
        given $hon_parse.made {
        when Verb {say $hon_parse.made.verb }
        default { say $hon_parse.made.raku ; }
        }
        exit;
    }
    my $hon_raku_code =  ppHakuProgram($hon_parse.made);
    if $miseru {
        say $hon_raku_code;
    } else {
        # Write the parsed program to a module 
        # my $fh = 'Hon.rakumod'.IO.open: :w;
        # $fh.put: $hon_raku_code;
        # $fh.close;
        # Liz suggests
        #'Hon.raku'.IO.spurt($hon_raku_code);
        
        # Require the module. This will execute the program
        #use lib ('runtime-lib');
        #require Hon;
        #run <raku -I. Hon.raku>;
        use  MONKEY-SEE-NO-EVAL;
        EVAL($hon_raku_code);
    }
}


