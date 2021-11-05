use v6;

=begin pod
This module contains the functionality to convert verbs into their dictionary form.
We use the verb stem and kanji following the stem to identify the type of verb and its form.
=end

my %dict-ending-for-te-form is Map = {
    'いて' =>　<く>,
    'って' =>　<う　つ　る>,
    'して' =>　<す>,
    'んで' =>　<む　ぬ　ぶ>,
    'いで' =>　<ぐ>
};

my %dict-ending-for-ta-form is Map = {
    'いた' =>　<く>,
    'った' =>　<う　つ　る>,
    'した' =>　<す>,
    'んだ' =>　<む　ぬ　ぶ>,
    'いだ' =>　<ぐ>
};

my %dict-ending-for-masu-form is Map = {
    'き' =>　<く>,
    'ち' =>　<つ>,
    'い' =>　<う>,
    'り' =>　<る>,
    'し' =>　<す>,
    'み' =>　<む>,
    'に' =>　<ぬ>,
    'び' =>　<ぶ>,
    'ぎ' =>　<ぐ>
};
# other forms are a, e and o
# a-form is nai, nakatta, passive, causative, negative imperative
my %dict-ending-for-a-form is Map = {
    'か' =>　<く>,
    'た' =>　<つ>,
    'わ' =>　<う>,
    'ら' =>　<る>,
    'さ' =>　<す>,
    'ま' =>　<む>,
    'な' =>　<ぬ>,
    'ば' =>　<ぶ>,
    'が' =>　<ぐ>
};
# e-form is conditional, potential, imperative
my %dict-ending-for-e-form is Map = {
    'け' =>　<く>,
    'て' =>　<つ>,
    'え' =>　<う>,
    'れ' =>　<る>,
    'せ' =>　<す>,
    'め' =>　<む>,
    'ね' =>　<ぬ>,
    'べ' =>　<ぶ>,
    'げ' =>　<ぐ>
};
# o-form is volitional
my %dict-ending-for-o-form is Map = {
    'こ' =>　<く>,
    'と' =>　<つ>,
    'お' =>　<う>,
    'ろ' =>　<る>,
    'そ' =>　<す>,
    'も' =>　<む>,
    'の' =>　<ぬ>,
    'ぼ' =>　<ぶ>,
    'ご' =>　<ぐ>
};