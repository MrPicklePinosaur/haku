#!/usr/bin/env raku

# Write Haku code vertically
# Options I'd like is to add a spacer row and a spacer col on the left
# Otherwise the number of columns is the number of lines and the number of rows is based on the longest line.

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

enum Spacer (NONE => '', THIN_SPACE=>' ', NARROW_NOBREAK_SPACE=>' ', SPACE=>' ', VERTICAL_LINE=>'|') ;

# unit sub MAIN(
#   Str $file ,
#   Int :$spacer-cols = 0,
#   Int :$spacer-rows = 0,
#   Spacer :$spacer = THIN_SPACE,
#   Bool :$verbose = False
# );  
my %h2v is Map = < 
「  ﹁  」  ﹂  『  ﹃	 』  ﹄ 
【  ︻  】  ︼  《  ︽  》  ︾   （  ︵  ） ︶ 
｛  ︷  ｝  ︸  〈  ︿  〉  ﹀ 
〖  ︗  〗  ︘  〔  ︹  〕  ︺   ［  ﹇  ］ ﹈ 
>;

# die %h2v.antipairs;

our $spacer-cols = 0;
our $spacer-rows = 0;
our $spacer = THIN_SPACE;
our $verbose = False;

sub tategakiWriter($file) is export {

	if (not $file.defined) {
	# USAGE();
		die "Please provide an input file\n";
		
	}
	my $input_file = IO::Path.new( $file ) ;
	my $V = $verbose;

	my $use_col_spacer = ($spacer.defined and !($spacer ~~ NONE));

	my $col_space_char = $spacer.value;

	# '' (nothing, the default)
	# thin space  U+2009   THIN SPACE (HTML &#8201; · &thinsp;). 
	# non-breaking space U+202F   NARROW NO-BREAK SPACE (HTML &#8239;) is a non-breaking space with a width similar to that of the thin space. 
	# Ordinary space
	# '|'

	my $col_spacer = $use_col_spacer ?? $col_space_char !! NONE.value;


	my $pad_ws= $V ?? '＿' !! '　'; 

	my @lines = $input_file.IO.lines;

	my $max_line_length = 0;
	for @lines -> $line {
		my $line_length =  $line.chars;
		$max_line_length = $line_length > $max_line_length ?? $line_length !! $max_line_length;
	};

	my @rows=();
	for 0 .. $max_line_length - 1 -> $idx {
		my @row_chars=();
		for @lines -> $line {
			my @chars = $line.comb();
			if @chars[$idx] {
				my $c=@chars[$idx];
				if %h2v{$c}:exists {
					$c = %h2v{$c};
				}
				@row_chars.push($c);
			} else {
				@row_chars.push($pad_ws);
			}
		}
		@rows.push(@row_chars);
	}

	# say @rows.raku;
	my @code_strs=();
	if $spacer-rows>0 {
		for 1 .. $spacer-rows {
			push @code_strs, '';
		}
	}
	for @rows -> @row {
	if $spacer-cols>0 {
		for 1 .. $spacer-cols {
			@row.push($pad_ws);
		}
	}

		@code_strs.push( join($col_spacer,@row.reverse));
	}
	my $code_str = @code_strs.join("\n");
	return $code_str;
}