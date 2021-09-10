# Haku TODOs

- Variables should probably be renamed because we'd like kanji-based variables as well as katakana
- Adjectives as distinct parts of nouns, probably only -i and -na, plus maybe -kute, -de
- Adjectival verbs as function application
- Treatment of の which should bind tighter than と, specifically for Noun-based function application
- File I/O
- System call

# Haku TODOs DONE

- Support から and に and maybe まで wherever と is OK
- Every expression should optionally be preceded by a comment
- Errors should work on programs with newlines, we should say "on line $line_nr"
- Correct string handling: treat strings as lists, with at least head/tail/length/concat
- Errors for missing delimiters
