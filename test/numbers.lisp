;;;; Tests for Numbers utilities.

(defpackage :challenge-utilities/test/numbers
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/numbers)

(def-suite numbers :in :challenge-utilities)
(in-suite numbers)

;; composite-p tests

(test zero-and-one-are-not-composite
  (is-false (composite-p 0))
  (is-false (composite-p 1)))

(test two-is-not-composite
  (is-false (composite-p 2)))

(test primes-are-not-composite
  (is-false (composite-p 7))
  (is-false (composite-p 97)))

(test composites-are-composite
  (is-true (composite-p 4))
  (is-true (composite-p 100)))

(test square-of-a-prime-is-composite
  (is-true (composite-p 49)))
