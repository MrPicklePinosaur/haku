# Haku TODOs

- Better error messages
- Adjectives as distinct parts of nouns, probably only -i and -na, plus maybe -kute, -de
- Treatment of の which should bind tighter than と, specifically for Noun-based function application
- System call
- Bring the Scheme emitter in sync with the Raku emitter

# Haku TODOs DONE

- Support から and に and maybe まで wherever と is OK (rationale: for map operations)
- Every expression should optionally be preceded by a comment
- Errors should work on programs with newlines, we should say "on line $line-no"
- Correct string handling: treat strings as lists, with at least head/tail/length/concat
- Errors for missing delimiters
- miseru returns a stringified version of whatever it prints
- I should support mo instead of ha/ga
- Adjectival verbs as function application
- Variables should probably be renamed because we'd like kanji-based variables as well as katakana => no need, just support nouns on the LHS
- cons on the RHS => was already supported
- File I/O
