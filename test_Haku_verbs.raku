use v6;
use Haku;
use HakuActions;
# use Scheme;
use Raku;

say Haku.parse("見せてくれて下さい",:rule('verb'));
say Haku.parse("見せる",:rule('verb'));
say Haku.parse("見せませんか",:rule('verb'));
say Haku.parse("触れる",:rule('verb'));
say Haku.parse("捨てる",:rule('verb'));
say Haku.parse("捨てて",:rule('verb'));
say Haku.parse("忘れかけて",:rule('verb'));
say Haku.parse("合わせる",:rule('verb'));
say Haku.parse("探索する",:rule('verb'));
say Haku.parse("正引きする",:rule('verb'));