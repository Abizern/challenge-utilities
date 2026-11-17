# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Shared Common Lisp utilities for the user's programming-challenge solutions: Advent of Code (`~/Developer/AoC/Lisp/aoc-cl`, system `aoc`) and Everybody Codes (`~/Developer/EveryBodyCodes/Lisp/everybody.codes`, system `ec`). Each contest loads this library instead of keeping its own copy. The user is learning Common Lisp by solving puzzles: the utilities are theirs to grow, so don't pre-emptively build out utilities or macros unless asked.

Only code that isn't tied to one contest belongs here. Contest-specific code stays in the contest's repository, e.g. reading puzzle input (each contest names its input files differently), AoC's `solve-day` (it prints two parts, while EC quests have three, each with its own input), and the Intcode and Assembunny interpreters.

## Layout

An ASDF `:package-inferred-system` named `challenge-utilities` (`challenge-utilities.asd`). Each file defines exactly one package whose name matches its path relative to the repo root:

- `NAME.lisp` → package `challenge-utilities/NAME`: one package per group of utilities:
  - `grid.lisp`: `make-grid` (a 2D array indexed row then column, so cells are read and set with `aref`), `make-grid-xy` (the same, sized and initialised by X and Y, with the cell at X, Y being `(aref grid y x)`), `lines-to-grid` (a row for each string in a sequence and a column for each character, optionally converting each character with a function), `grid-rows`, `grid-cols`, `neighbours` (the in-bounds `(row . col)` cells up, down, left and right, optionally with the diagonals), `cell-neighbours` (the same for a `(row . col)` cell), `cell-value` (the value at a `(row . col)` cell; `setf`-able), `cells-matching` (the `(row . col)` cells whose value satisfies a predicate, in row order), `print-grid` (draws each cell with a function returning a character)
  - `lists.lisp`: `transpose`, `flip` (reverses each row), `rotate-right` (a quarter turn clockwise), `grid-symmetries` (the four rotations and four flipped rotations of a list of rows), `digits` (a list of the digits in a string, with NIL for any other character), `digits-to-number` (the number whose decimal digits are a list of digits; signals a `type-error` on anything that isn't a number), `ncycle` (makes a list circular in place), `last1` (the last element of a list, rather than its last cons)
  - `point-2d.lisp`: `make-point-2d` (a point on an unbounded 2D grid as a complex number, X the real part and Y the imaginary part; a point with Y = 0 is a plain number), `point-2d=`, `point-2d/=`, `manhattan-2d` (the Manhattan distance between two points, or from the origin), `move-point-2d` (one step in a direction `:n`, `:s`, `:e` or `:w`, with `:n` adding 1 to Y), `move-point-2d-xy` (moves by X and Y), `step-gradient-2d` (the smallest whole-number step from one point towards another, as a complex number; 0 for the same point), `move-point-2d-step` (adds a step to a point)
  - `queue.lisp`: `make-queue` (a FIFO queue as a cons of the list's head and its last cell), `enqueue` (adds an item at the back and returns the queue), `dequeue` (removes and returns the front item, or NIL when empty), `queue-empty-p`
  - `numbers.lisp`: `composite-p` (T for a whole number greater than 1 that has a divisor other than 1 and itself)
  - `count-letters.lisp`: `count-letters` (a struct of a–z counts), `counts-alist`, `most-frequent-char`, `least-frequent-char`
  - `md5.lisp`: `find-md5-prefix`, `md5-hex` (the hex hash of a key followed by a number), `stretched-md5-hex` (the same, re-hashed a number of rounds)
  - `screen.lisp`: `make-screen` (a struct of 0/1 pixels, indexed row then column), `pixel` (`setf`-able), `turn-on`, `get-row`, `set-row`, `get-col`, `set-col`, `count-pixels`; prints as a picture
  - `sqlite.lisp`: `query` (runs an SxQL statement against an SQLite database and returns its rows as lists)
- `all.lisp` → package `challenge-utilities/all`, nicknamed `challenge-utilities` and `c-utils`: re-exports every utilities package via `:use-reexport`. The system `challenge-utilities` depends on it, so a contest's `(:use-reexport :challenge-utilities)` loads and re-exports everything. When adding a utilities package, add it to the `:use-reexport` list and to the list above. Exported names must be unique across all utilities packages, or the re-export fails with a name conflict. `all` also `:import-from`s commonly used libraries (`cl-ppcre`, `alexandria`) so loading the library loads them.
- Don't name a utilities file `all` or `test`: those names are taken.

`c-utils` is for the REPL only. In a `defpackage` clause, ASDF turns the package name into a system name to find the dependency, and there is no `c-utils` system, so write `:challenge-utilities` or `:challenge-utilities/NAME`.

Dependencies are inferred from `defpackage`: `(:use ...)` and `(:import-from ...)` clauses name the packages and systems a file depends on. An empty `(:import-from :cl-ppcre)` still declares the dependency. Don't use `:local-nicknames` in `defpackage`: the ASDF bundled with this SBCL (3.3.1) can't parse it in a package-inferred system, and loading fails with a `CASE-FAILURE`.

Conventions:
- Don't add top-level `(declaim (optimize ...))`: in a system it proclaims globally for the whole image. Use a local `(declare (optimize ...))` instead.
- Use `uiop` for file I/O.

## Tests

FiveAM, in a separate `test/` tree so loading the library doesn't depend on it. `challenge-utilities/test` is defined explicitly in `challenge-utilities.asd` (so it can carry the `:perform`). The root suite `:challenge-utilities` is in `test/suite.lisp`. Run everything with `(asdf:test-system "challenge-utilities")`. Both contests depend on this library, so run the tests after every change.

To add tests for a utilities package, e.g. `lists.lisp`:
- Create `test/lists.lisp` with package `challenge-utilities/test/lists`: `(:use :cl :fiveam :challenge-utilities)` and `(:import-from :challenge-utilities/test/suite)`. Then `(def-suite lists :in :challenge-utilities)` and `(in-suite lists)`. Using `:challenge-utilities` rather than the individual package also checks that the functions are re-exported.
- Add `"challenge-utilities/test/lists"` to the `:depends-on` of `challenge-utilities/test` in `challenge-utilities.asd`.
- Tests mustn't depend on puzzle inputs, which aren't in any repository. Worked examples from puzzle descriptions make good test cases.

## Workflow

There's no build or lint tooling (tests are above). Development is interactive:

- SBCL with Quicklisp (`~/.quicklisp`). The repo is in `~/Developer/Lisp/`, which `~/.sbclrc` adds to `ql:*local-project-directories*`, so there's no symlink.
- The repo is public on GitHub at https://github.com/Abizern/challenge-utilities. Renaming or removing an export breaks any contest code that uses it, so check both contests when doing either.
- After the exports change, quickload the contest system (`aoc` or `ec`) in the running image, not `challenge-utilities`. Quickloading the library updates its own exports, but a contest's re-export package isn't re-evaluated, so a new export still looks undefined in the day packages. Quickloading the contest rebuilds the library and then the contest packages that depend on it. If the new name was typed in a contest package before reloading, that package already has its own symbol with the name, so `unintern` it there or restart Lisp.
