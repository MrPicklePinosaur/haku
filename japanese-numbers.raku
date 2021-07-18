use v6;

# There are two number systems: the traditional one and the transliteration of the arabic numbers, using zero

# To determine which system:
# contains zero or dot
# has more than two kanji but does not contain 10,100,1000,10000 etc
# or in other words only contains 0 .. 9
# So maybe I can do a comb and then test if a kanji is in %digits.  
# '四五点一ニ' ~~ / <[一ニ三四五六七八九壱弐参〇零]>+　['点'　<[一ニ三四五六七八九壱弐参〇零]>+　]?/

my %digits is Map = < 一  1 壱 1 ニ 2 弐 2 三 3 参 3 弎 3 四 4 五 5 六 6 七 7 八 8 九 9 零 0 〇 0>;
my %magnitudes is Map = < 十 10 拾 10 百 100 千 1000 >;
my @myriad_kanji = < 万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 >;
my %myriads is Map = @myriad_kanji.map( {state $i=0; $_ => 10**(++$i*4)});
my %precisions is Map = < 
    分 0.1 厘 0.01 毛 0.001 糸 0.0001 忽 0.00001 
    微 1e-6 繊 1e-7 沙 1e-8 塵 1e-9 埃 1e-10 渺 1e-11 漠 1e-12 
    >;

sub kanjiToNumbersMag(Str $kazu --> Num ) {
    my Str @kazu_kanji = $kazu.comb();
    my Num $acc = 0e0;
    my Int $m = 0;

    for 0..(@kazu_kanji.elems-1)  -> $k {    
        if %digits{@kazu_kanji[$k]}:exists {
            if $m > 0 {
                $acc=$acc+$m;
                $m=0;
            }
            $m = %digits{@kazu_kanji[$k]};
        } elsif %myriads{@kazu_kanji[$k]}:exists {
                $acc+=$m;
                $acc*=%myriads{@kazu_kanji[$k]};
                $m=0;
        } elsif %magnitudes{@kazu_kanji[$k]}:exists {
                if $m == 0 {$m = 1}
                $acc+=$m*%magnitudes{@kazu_kanji[$k]};        
                $m=0;
        } elsif %precisions{@kazu_kanji[$k]}:exists {
                if $m == 0 {$m = 1}
                $acc+=$m*%precisions{@kazu_kanji[$k]};
                $m=0;
        }
    }
    $acc+=$m ;

    return $acc;
}


# Positional, so based on the number of digits like in arabic numbers
sub kanjiToNumbersPosDec(Str $kazu --> Num ) {
    
    my ($mag_str,$prec_str) = $kazu.split('点'); 
    my ($num, $max_exp) = kanjiToNumbersPos($mag_str);

    if $prec_str {
        my ($prec, $max_exp) = kanjiToNumbersPos($prec_str); 
        $num+= $prec/(10**($max_exp+1));
    }
    return $num;
}

sub kanjiToNumbersPos(Str $mag  ) {
    my Str @mag_kanji = $mag.comb();
    my $max_exp = @mag_kanji.elems - 1;
    my Num $acc=0e0;
    my $idx=0;
    for @mag_kanji -> $k {        
        my Int $m = %digits{$k};
        $acc+= $m*(10**($max_exp-$idx));
        ++$idx;
    }
    return ($acc,$max_exp);
}

sub kanjiToNumbers(Str $kazu_str  ) {
    if $kazu_str ~~ /^ <[一ニ三四五六七八九壱弐参〇零]>+　['点'　<[一ニ三四五六七八九壱弐参〇零]>+　]? $/
    {        
        return kanjiToNumbersPosDec( $kazu_str ) ;
    } else {
        
        return kanjiToNumbersMag( $kazu_str ) ;
    }
}
my Str $gogo = '五十五万七千一百八十八弐分参厘五忽微';

say kanjiToNumbers($gogo);

my Str $test_dec = '一ニ〇三点四五六';

say kanjiToNumbers($test_dec);
