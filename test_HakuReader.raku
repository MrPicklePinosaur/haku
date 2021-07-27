use v6;
use HakuReader;

unit sub MAIN(
          Str $file
        );

if (not $file.defined) {
         die "Please provide an input file\n";
}
my $haku_code_str = hakuReader($file);

say $haku_code_str;
