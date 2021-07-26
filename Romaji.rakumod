use v6;
my %katakana is Map = < ア A
ィ _I
イ I
ゥ _U
ウ U
ェ _E
エ E
ォ _O
オ O
カ KA
ガ GA
キ KI
ギ GI
ク KU
グ GU
ケ KE
ゲ GE
コ KO
ゴ GO
サ SA
ザ ZA
シ SHI
ジ JI
ス SU
ズ ZU
セ SE
ゼ ZE
ソ SO
ゾ ZO
タ TA
ダ DA
チ CHI
ヂ JI
ッ _TU
ツ TSU
ヅ DZU
テ TE
デ DE
ト TO
ド DO
ナ NA
ニ NI
ヌ NU
ネ NE
ノ NO
ハ HA
バ BA
パ PA
ヒ HI
ビ BI
ピ PI
フ HU
ブ BU
プ PU
ヘ HE
ベ BE
ペ PE
ホ HO
ボ BO
ポ PO
マ MA
ミ MI
ム MU
メ ME
モ MO
ャ _YA
ヤ YA
ュ _YU
ユ YU
ョ _YO
ヨ YO
ラ RA
リ RI
ル RU
レ RE
ロ RO
ヮ _WA
ワ WA
ヰ WI
ヱ WE
ヲ WO
ン N
ヴ VU
ヵ _KA
ヶ _KE
ヷ VA
ヸ VI
ヹ VE
ヺ VO 
>;

my %hiragana is Map = <
あ A
ぃ _I
い I
ぅ _U
う U
ぇ _E
え E
ぉ _O
お O
か KA
が GA
き KI
ぎ GI
く KU
ぐ GU
け KE
げ GE
こ KO
ご GO
さ SA
ざ ZA
し SI
じ ZI
す SU
ず ZU
せ SE
ぜ ZE
そ SO
ぞ ZO
た TA
だ DA
ち TI
ぢ DI
っ _TU
つ TU
づ DU
て TE
で DE
と TO
ど DO
な NA
に NI
ぬ NU
ね NE
の NO
は HA
ば BA
ぱ PA
ひ HI
び BI
ぴ PI
ふ HU
ぶ BU
ぷ PU
へ HE
べ BE
ぺ PE
ほ HO
ぼ BO
ぽ PO
ま MA
み MI
む MU
め ME
も MO
ゃ _YA
や YA
ゅ _YU
ゆ YU
ょ _YO
よ YO
ら RA
り RI
る RU
れ RE
ろ RO
ゎ _WA
わ WA
ゐ WI
ゑ WE
を WO
ん N
ゔ VU
ゕ _KA
ゖ _KE
>;

my %combined_chars is Map = <
KI_YA KYA
KI_YU KYU
KI_YO KYO
GI_YA GYA
GI_YU GYU
GI_YO GYO
SI_YA SYA
SI_YU SYU
SI_YO SYO
ZI_YA ZYA
ZI_YU ZYU
ZI_YO ZYO
TI_YA TYA
TI_YU TYU
TI_YO TYO
DI_YA DYA
DI_YU DYU
DI_YO DYO
NI_YA NYA
NI_YU NYU
NI_YO NYO
HI_YA HYA
HI_YU HYU
HI_YO HYO
BI_YA BYA
BI_YU BYU
BI_YO BYO
PI_YA PYA
PI_YU PYU
PI_YO PYO
MI_YA MYA
MI_YU MYU
MI_YO MYO
RI_YA RYA
RI_YU RYU
RI_YO RYO
WI_YA WYA
WI_YU WYU
WI_YO WYO
VI_YA VYA
VI_YU VYU
VI_YO VYO
U_I WI
U_E WE
U_O WO
U_A WA
VU_I VI
VU_E VE
VU_O VO
VU_A VA
>;


my @i_row = <
KI
GI
SI
ZI
TI
DI
NI
HI
BI
PI
MI
RI
WI
VI
>;




my @y_col = <YA YU YO>;

#for @i_row -> $i {
#for @y_col -> $y {
#my $char_seq = $i~'_'~$y;
#my $comb_char = $i.chop~$y;
#say "$char_seq $comb_char";
#}
#}

sub katakanaToRomaji(Str $kstr --> Str) is export {

    my @ks = $kstr.comb;
    my @rs = @ks.map({%katakana{$_}});
    my $r_str = @rs.join('');
    while $r_str ~~/_/ {
        for %combined_chars.keys -> $c {
            my $cc = %combined_chars{$c};
            $r_str ~~ s/$c/$cc/;  
        }
    }
    return $r_str.lc;
}

sub hiraganaToRomaji (Str $kstr --> Str) is export  {

    my @ks = $kstr.comb;
    my @rs = @ks.map({%hiragana{$_}});
    my $r_str = @rs.join('');
    while $r_str ~~/_/ {
        for %combined_chars.keys -> $c {
            my $cc = %combined_chars{$c};
            $r_str ~~ s/$c/$cc/;  
        }
    }
    return $r_str.lc;
}


#say katakanaToRomaji('ウィムデス');
#say hiraganaToRomaji('どうもありがとうございました');

