use v6;

grammar Test {
    token TOP { <quoted_string>+ }
    token quoted_string { '「' <non_quotes>* '」' }
    token non_quotes { < -[「」] > }
}

my $test = Test.parse("「テスト」");
say $test;

my $test1 = Test.parse("「テ「ス」ト」");
say $test1;

my $test2= Test.parse("「テキ」「ス」「トです」");
say $test2;

