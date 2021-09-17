use v6;
use Haku;
use HakuActions;
use HakuReader;
use Tategaki;
use Raku;

sub USAGE() {
    print Q:c:to/EOH/;
    Usage: haku <Haku program, written horizontally or vertically, utf-8 text file>
        [--tategaki, -t] : do not run the program but print it vertically.
        [--miseru, -m] : just print the Raku source code, don't execute.
        [--yomudake, -y] : just print the Haku source after reading, as a single line. Don't execute.
        [--parse-only, -p] : for debugging, parse and print out the parse tree.
        [--subparse, -s] : for debugging, use subparse instead of parse.
        [--verbose, -v] : for debugging, verbose output.        
 EOH
}

unit sub MAIN(
          Str $src_file,
          Bool :t($tategaki) = False,   
          Bool :m($miseru) = False,
          Bool :y($yomudake) = False,
          Bool :p($parse-only) = False,
          Bool :v($verbose) = False,
          Bool :s($subparse) = False,
        );  

if ($verbose) { 
    
    $Raku::V=True;
}

if (not $src_file.defined) {
         die "Please provide an input file\n";
}
if $tategaki {
    say tategakiWriter($src_file);
    exit;
}

my $program_str = hakuReader($src_file);

if $yomudake { 
    say $program_str;
    exit;
}

if $parse-only { 
    $reportErrors = False;
    if $subparse {
        say Haku.subparse($program_str);
    } else {
        say Haku.parse($program_str);
    }
    exit;
} else {

    my $hon_parse = Haku.parse($program_str, :actions(HakuActions));
    my $hon_raku_code =  ppHakuProgram($hon_parse.made);
    if $miseru {
        say $hon_raku_code;
    } else {
        # Write the parsed program to a module 
        my $fh = 'Hon.rakumod'.IO.open: :w;
        $fh.put: $hon_raku_code;
        $fh.close;
        # Require the module. This will execute the program

        require Hon;
    }
}


