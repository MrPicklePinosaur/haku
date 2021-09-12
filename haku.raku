use v6;
use Haku;
use HakuActions;
use HakuReader;
# use Tategaki;
use Raku;

# TODO: flags, see Tategaki runner
unit sub MAIN(
          Str $src_file
        );

if (not $src_file.defined) {
         die "Please provide an input file\n";
}

my $program_str = hakuReader($src_file);

my $hon_parse = Haku.parse($program_str, :actions(HakuActions));
my $hon_raku_code =  ppHakuProgram($hon_parse.made);
# Write the parsed program to a module and require it
my $fh = 'Hon.rakumod'.IO.open: :w;
$fh.put: $hon_raku_code;
$fh.close;

require Hon;

#Hon::hon();

