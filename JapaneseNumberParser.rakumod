use v6;

# There are two number systems: the traditional one and the transliteration of the arabic numbers, using zero

# To determine which system:
# contains a dot
# contains only 0 .. 9
#  / <[一ニ三四五六七八九壱弐参〇零]>+　['点'　<[一ニ三四五六七八九壱弐参〇零]>+　]?/

my %digits is Map = < 一 1 壱 1 二 2 弐 2 三 3 参 3 弎 3 四 4 五 5 六 6 七 7 八 8 九 9 零 0 〇 0
                       弌 1 壹 1 弍 2 貳 2 貮 2 弎 3 肆 4 伍 5 陸 6 漆 7 柒 7 捌 8 玖 9
                    >;
my %unique-digits is Map = < 一 1 二 2 三 3 四 4 五 5 六 6 七 7 八 8 九 9 〇 0 >;                    
my %magnitudes is Map = < 十 10 拾 10 百 100 千 1000 >;
my @myriad_kanji = < 万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 一 萬>;　# last 2 are a hack to have the 2 kanji for man
my %myriads is Map = @myriad_kanji.map( {state $i=0; $_ => 10**((++$i % 13) *4)});

my %precisions is Map = < 
    分 0.1 厘 0.01 毛 0.001 糸 0.0001 忽 0.00001 
    微 1e-6 繊 1e-7 沙 1e-8 塵 1e-9 埃 1e-10 渺 1e-11 漠 1e-12 
    >;

sub kanjiToNumbersMag(Str $kazu --> Num ) {
    my Str @kazu_kanji = $kazu.comb();
    my Num $acc = 0e0;
    my Int $m = 0;

    for 0..(@kazu_kanji.elems-1) -> $k {    
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



sub parseJapaneseNumbers(Str $kazu_str --> Num ) is export {
    if $kazu_str ~~ /^ <[一二三四五六七八九壱弐参弌壹弍貳貮弎肆伍陸漆柒捌玖〇零]>+　['点'　<[一二三四五六七八九壱弐参弌壹弍貳貮弎肆伍陸漆柒捌玖〇零]>+　]? $/
    {        
        return kanjiToNumbersPosDec( $kazu_str ) ;
    } else {
        return kanjiToNumbersMag( $kazu_str ) ;
    }
}

sub substituteKanjiToDigits(Str $kstr --> Str) is export {
    my @chars = $kstr.comb;
    my @rchars = @chars.map({
        if %digits{$_}:exists and not %unique-digits{$_}:exists {
            say "Error: In variable $kstr: in variable names, only 一 二 三 四 五 六 七 八 九 〇 are supported";
            exit;
        } else {
            %digits{$_} // $_           
        }
    });
    @rchars.join('');
}