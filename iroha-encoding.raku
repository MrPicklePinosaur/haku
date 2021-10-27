use v6;
use lib ('lib');
use Romaji;


sub USAGE() {
    print Q:c:to/EOH/;
    Usage: iroha-encoding <hiragana string>
    Encodes hiragana characters by position in the iroha poem.
    Diacritics are ignored, small kana are treated as large and ん is treated as む.
 EOH
}
#         [--tategaki, -t] : do not run the program but print it vertically.
#         [--miseru, -m] : just print the Raku source code, don't execute.
#         [--yomudake, -y] : just print the Haku source after reading, as a single line. Don't execute.
#         [--parse-only, -p] : for debugging, parse and print out the parse tree.
#         [--subparse, -s] : for debugging, use subparse instead of parse.
#         [--rule, -r] :  for debugging, use a specific grammar rule.
#         [--verbose, -v] : for debugging, verbose output.
#         [--expression, -e] : provide an expression string instead of a file name 

unit sub MAIN(
          Str $kana_str
        #   Bool :t($tategaki) = False,   
        #   Bool :m($miseru) = False,
        #   Bool :y($yomudake) = False,
        #   Bool :p($parse-only) = False,
        #   Bool :v($verbose) = False,
        #   Bool :s($subparse) = False,
        #   Str :r($rule), 
        #   Str :e($expression) 
        );  

my @codes = map &irohaEncoding, $kana_str.comb;
say @codes;