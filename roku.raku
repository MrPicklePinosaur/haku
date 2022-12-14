use v6;
# use lib ('.');
use Roku;
use RokuActions;
use HakuReader;
# use Tategaki;
use Raku;

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
          Str :r($rule) 
        );  
$Raku::toRomaji=False;
if ($verbose) { 
    $Raku::V=True;
    $RokuActions::V=True;
}

if (not $src_file.defined) {
         die "Please provide an input file\n";
}

# if $tategaki {
#     say tategakiWriter($src_file);
#     exit;
# }

my $program_str = rokuReader($src_file);

if $yomudake { 
    say $program_str;
    exit;
}

if $parse-only { 
    $reportErrors = False;
    if $subparse {
        if $rule {
            # die "$program_str,:rule($rule)";
            say Roku.subparse($program_str,:rule($rule));
        } else {
            say Roku.subparse($program_str);
        }
    } else {
        if $rule {
            # die "$program_str,:rule($rule)";
        say Roku.parse($program_str,:rule($rule));
        } else {
        say Roku.parse($program_str);
        }
    }
    exit;
} else {

    my $hon_parse = Roku.parse($program_str, :actions(RokuActions));
    my $hon_raku_code =  ppHakuProgram($hon_parse.made);
    if $miseru {
        say $hon_raku_code;
    } else {
        # Write the parsed program to a module 
        # my $fh = 'Hon.rakumod'.IO.open: :w;
        # $fh.put: $hon_raku_code;
        # $fh.close;
        # Liz suggests
        'Hon.rakumod'.IO.spurt($hon_raku_code);
        
        # Require the module. This will execute the program
        require Hon;
    }
}


sub rokuReader($file) {
    my $input_file = IO::Path.new( $file ) ;
my $horiz_str = $input_file.IO.slurp;
if $horiz_str ~~ /'Hon' ['ma']? ' toha' <.ws>?/ {
    return $horiz_str.lines.grep({ not /^ '#' / }).join("\n");
} else {
    return Nil;
}

}