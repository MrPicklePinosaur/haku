#!/usr/bin/env raku 
# for a summary, run prove --exec raku test-all-examples.raku
use v6;
use lib ('.');
use Test;

my @src_files = dir('examples', test => { ! /dbg/  && /\.haku/ }).sort ;

my %assertions is Map =
'adjectives', 'Nil',
'foldl', '((1 2 3 4 5) (7 8) (11) (13) (16 17))',
'haku-raku', '魄から楽まで',
'iroha', "7188\n557188",
'maps', '{}'~"\n"~'{四十二 => 42}',
'mugendai', '記憶に心を奪われて',
'pwc131-t1', '((1 2 3 4 5) (7 8) (11) (13) (16 17))',
'recursion_let', '42',
'recursive_length_calc', '42',
'yuki', '忘れられない あの冬の the new fallen snow',
'zoi_chinamini', '大丈夫' ~"\n"~ '42',
'dailymaths-25', '25',
'sum-of-list', '55'~"\n"~ '55',
'piem', '3.14159265358',
'haiku', 'ギラギラ太陽' ~"\n"~ '照らされたいよ'
;
plan @src_files.elems; 
# To iterate over the contents of the examples directory: 
for @src_files -> $src_path {
# for dir('examples', test => { ! /dbg/  && /\.haku/ }).sort -> $src_path {
    my $src_file =~ S/examples\/ (<[\w \-]>+) \.haku/$0/ with $src_path;
    say '* ' ~$src_file;
    my $ref = %assertions{$src_file} // Nil;
    my $proc = run 'haku', $src_path, :out;
    my $res = $proc.out.slurp.chomp;
    if $ref {
        is( $res, $ref,$ref);
    } else {
        skip( "No reference: " ~ $res); 
    }
}
