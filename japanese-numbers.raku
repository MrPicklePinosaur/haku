use v6;

# There are two number systems: the traditional one and the transliteration of the arabic numbers, using zero


my %digits is Map = < 一  1 ニ 2 三 3 四 4 五 5 六 6 七 7 八 8 九 9 >;
my %magnitudes is Map = < 十 10 百 100 千 1000 >;
my @myriad_kanji = < 万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 >;
my %myriads is Map = @myriad_kanji.map( {state $i=0; $_ => 10**(++$i*4)});

sub kanjiToNumbers(Str $kazu --> Int ) {
    my Str @kazu_kanji = $kazu.comb();
    my Int $acc = 0;
    my Int $m = 0;

    for 0..(@kazu_kanji.elems-1)  -> $k {    
        if %digits{@kazu_kanji[$k]}:exists {
            $m = %digits{@kazu_kanji[$k]};
        } elsif %myriads{@kazu_kanji[$k]}:exists {
                $acc+=$m;
                $acc*=%myriads{@kazu_kanji[$k]};
        } elsif %magnitudes{@kazu_kanji[$k]}:exists {
                $acc+=$m*%magnitudes{@kazu_kanji[$k]};        
            $m=0;
        }
    }
    $acc+=$m;

    return $acc;
}

my Str $gogo = '五十五万七千一百八十八';

say kanjiToNumbers($gogo);