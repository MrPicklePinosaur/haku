use v6;
use Test;
use Haku;
use HakuActions;
use HakuReader;
use Raku;
# iroha
# maps
# mugendai
# pwc131-t1
# recursion_let
# recursive_length_calc
# yuki

my @src_files = <
adjectives
foldl
haku-raku
iroha
maps
mugendai
pwc131-t1
recursion_let
recursive_length_calc
yuki
zoi_chinamini
>; 
# To iterate over the contents of the current directory: 
for @src_files  -> $src_file {
         
say $src_file;
run 'haku', "examples/$src_file.haku";
# my $program_str = hakuReader("examples/$src_file.haku");

# my $hon_parse = Haku.parse($program_str, :actions(HakuActions));
# my $hon_raku_code =  ppHakuProgram($hon_parse.made,$src_file);
# say $hon_raku_code;     
# my $fh = "$src_file.rakumod".IO.open: :w;
# $fh.put: $hon_raku_code;
# $fh.close;
# require ::($src_file);# <&hon>;
# my &mmk = ::($src_file ~ "::EXPORT::DEFAULT::&hon");
# my $res = mmk();
# say "RES: <$res>";
# # ok ($res eq '557188'), "OK!";
# }
}
