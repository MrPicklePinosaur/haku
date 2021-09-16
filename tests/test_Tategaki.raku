use v6;
use Tategaki;

sub USAGE() {
    print Q:c:to/EOH/; 
    Usage: {$*PROGRAM-NAME} 
		<Japanese text, written horizontally, utf-8 text file>
		[--spacer-cols = 0]
		[--spacer-rows = 0 ]
		[--spacer = THIN_SPACE (default), NARROW_NOBREAK_SPACE, SPACE, VERTICAL_LINE, NONE]

	- The `spacer` adds a space character between the columns for better readability. 
	  By default this is the unicode THIN SPACE character.
 
 EOH
}

# enum Spacer (NONE => '', THIN_SPACE=>' ', NARROW_NOBREAK_SPACE=>' ', SPACE=>' ', VERTICAL_LINE=>'|') ;

unit sub MAIN(
  Str $file ,
  Int :$spacer-cols = 0,
  Int :$spacer-rows = 0,
  Spacer :$spacer = THIN_SPACE,
  Bool :$verbose = False
);  

$Tategaki::spacer-cols=$spacer-cols;

my $code_str = tategakiWriter($file);

say $code_str;