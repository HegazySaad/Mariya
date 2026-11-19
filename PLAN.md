# Plan: wordcount CLI (trial plan for Claudex Loop)

Small, self-contained task used to test the cross-model plan review. Not a real product.

## Goal

A Python 3 command-line tool `wordcount.py` that counts words, lines and characters in a text file or stdin, with correct handling of Arabic text.

## Scope

- In: one script `wordcount.py` and one test file `test_wordcount.py` in the repo root.
- Out: packaging, config files, third-party dependencies, GUI.

## Requirements

1. `python3 wordcount.py FILE` prints three numbers on one line: `lines words chars`, separated by single spaces.
2. With no argument, or with `-` as the argument, the tool reads stdin.
3. A word is a maximal run of non-whitespace characters. Arabic and English words count the same way.
4. `chars` counts Unicode code points, not bytes.
5. Input is decoded as UTF-8. Invalid bytes are replaced, never raise.
6. Missing file: print `wordcount: FILE: No such file` to stderr and exit with code 2.
7. Empty input prints `0 0 0` and exits with code 0.
8. Standard library only. Python 3.10 or newer.

## Design notes

- One function `count(text: str) -> tuple[int, int, int]` holds the logic. The CLI layer only handles arguments and I/O.
- Lines are counted as the number of newline characters, plus one if the text does not end with a newline and is not empty.

## Acceptance criteria

| # | Input | Expected output |
|---|-------|-----------------|
| A1 | `hello world\n` | `1 2 12` |
| A2 | `مرحبا بالعالم\n` | `1 2 14` |
| A3 | `a b\nc` (no trailing newline) | `2 3 5` |
| A4 | empty input | `0 0 0` |
| A5 | nonexistent file | exit code 2, message on stderr |
| A6 | stdin via `-` | same result as the file with the same content |

## Proof command

```
python3 -m unittest test_wordcount -v
```

All tests must pass, and each acceptance row A1 to A6 must map to at least one test.

## Open questions for the reviewer

- Is the line-count rule in the design notes consistent with the `wc -l` convention, and does it matter here?
- Does requirement 3 conflict with requirement 4 for Arabic text that includes combining marks?
