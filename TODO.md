# Haku TODOs

- Variables should probably be renamed because we'd like kanji-based variables as well as katakana
- cons on the RHS
- Adjectives as distinct parts of nouns, probably only -i and -na, plus maybe -kute, -de
- Adjectival verbs as function application
- Treatment of の which should bind tighter than と, specifically for Noun-based function application
- File I/O
- System call
- I think I need 'nochi' so I can do prints on the RHS of a binding, like tjhe comma operator in Perl but in reverse. But then the function composition should maybe become 連結 renketsu
- I should support mo instead of ha/ga,maybe even demo

# Haku TODOs DONE

- Support から and に and maybe まで wherever と is OK
- Every expression should optionally be preceded by a comment
- Errors should work on programs with newlines, we should say "on line $line-no"
- Correct string handling: treat strings as lists, with at least head/tail/length/concat
- Errors for missing delimiters
- miseru returns a stringified version of whatever it prints
