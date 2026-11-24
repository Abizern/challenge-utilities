;;;; Tests for Comparison utilities.

(defpackage :challenge-utilities/test/comparison
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/comparison)

(def-suite comparison :in :challenge-utilities)
(in-suite comparison)

;; compare tests

(test compare-integers
  (is (= -1 (compare 1 2)))
  (is (= 0 (compare 2 2)))
  (is (= 1 (compare 3 2))))

(test compare-mixed-reals
  (is (= -1 (compare 1/2 1)))
  (is (= 0 (compare 1/2 0.5)))
  (is (= 1 (compare 2.5 2))))

(test compare-strings
  (is (= -1 (compare "apple" "banana")))
  (is (= 0 (compare "apple" "apple")))
  (is (= 1 (compare "banana" "apple"))))

(test compare-string-prefix-is-less
  (is (= -1 (compare "app" "apple")))
  (is (= 1 (compare "apple" "app"))))

(test compare-strings-is-case-sensitive
  (is (= -1 (compare "B" "a"))))

(test compare-characters
  (is (= -1 (compare #\a #\b)))
  (is (= 0 (compare #\a #\a)))
  (is (= 1 (compare #\b #\a))))

(test compare-mismatched-types-signals-an-error
  (signals error (compare 1 "1")))

;; nif tests

(test nif-picks-by-sign
  (is (eq :pos (nif 5 :pos :zero :neg)))
  (is (eq :zero (nif 0 :pos :zero :neg)))
  (is (eq :neg (nif -5 :pos :zero :neg))))

(test nif-evaluates-expr-once
  (let ((count 0))
    (nif (progn (incf count) 1) :pos :zero :neg)
    (is (= 1 count))))

(test nif-evaluates-only-the-chosen-form
  (let ((evaluated '()))
    (nif 0 (push :pos evaluated) (push :zero evaluated) (push :neg evaluated))
    (is (equal '(:zero) evaluated))))

;; nif-compare tests

(test nif-compare-picks-by-comparison
  (is (eq :greater (nif-compare 3 2 :greater :equal :less)))
  (is (eq :equal (nif-compare "a" "a" :greater :equal :less)))
  (is (eq :less (nif-compare #\a #\b :greater :equal :less))))

(test nif-compare-evaluates-each-value-once
  (let ((count 0))
    (nif-compare (incf count) (incf count) :greater :equal :less)
    (is (= 2 count))))
