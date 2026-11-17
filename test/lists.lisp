;;;; Tests for Lists utilities.

(defpackage :challenge-utilities/test/lists
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/lists)

(def-suite lists :in :challenge-utilities)
(in-suite lists)

;; transpose tests

(test transpose-a-null-list
  (is (null (transpose nil))))

(test transpose-a-single-list
  (is (equal '((1) (2) (3)) (transpose '((1 2 3))))))

(test transpose-a-square-list
  (is (equal '((1 3) (2 4)) (transpose '((1 2) (3 4))))))

(test transpose-a-rectangular-list
  (is (equal '((1 4) (2 5) (3 6)) (transpose '((1 2 3) (4 5 6))))))

;; flip tests

(test flip-a-null-list
  (is (null (flip nil))))

(test flip-a-square-list
  (is (equal '((2 1) (4 3)) (flip '((1 2) (3 4))))))

(test flip-a-rectangular-list
  (is (equal '((3 2 1) (6 5 4)) (flip '((1 2 3) (4 5 6))))))

(test flip-twice-is-unchanged
  (let ((lists '((1 2 3) (4 5 6))))
    (is (equal lists (flip (flip lists))))))

;; rotate-right tests

(test rotate-right-a-null-list
  (is (null (rotate-right nil))))

(test rotate-right-a-square-list
  (is (equal '((3 1) (4 2)) (rotate-right '((1 2) (3 4))))))

(test rotate-right-a-rectangular-list
  (is (equal '((4 1) (5 2) (6 3)) (rotate-right '((1 2 3) (4 5 6))))))

(test rotate-right-four-times-is-unchanged
  (let ((lists '((1 2 3) (4 5 6) (7 8 9))))
    (is (equal lists (rotate-right (rotate-right (rotate-right (rotate-right lists))))))))

;; grid-symmetries tests

(test grid-symmetries-of-a-null-list
  (is (null (grid-symmetries nil))))

(test grid-symmetries-of-a-square-list
  (is (equal '(((1 2) (3 4)) ((3 1) (4 2)) ((4 3) (2 1)) ((2 4) (1 3))
               ((2 1) (4 3)) ((4 2) (3 1)) ((3 4) (1 2)) ((1 3) (2 4)))
             (grid-symmetries '((1 2) (3 4))))))

(test grid-symmetries-of-an-asymmetric-list-are-all-different
  (let ((symmetries (grid-symmetries '((1 2 3) (4 5 6) (7 8 9)))))
    (is (= 8 (length symmetries)))
    (is (= 8 (length (remove-duplicates symmetries :test #'equal))))))

(test grid-symmetries-of-a-symmetric-list-keeps-duplicates
  (let ((symmetries (grid-symmetries '((1 1) (1 1)))))
    (is (= 8 (length symmetries)))
    (is (= 1 (length (remove-duplicates symmetries :test #'equal))))))

;; digits tests

(test empty-string-to-digits
  (is (null (digits ""))))

(test string-to-digits
  (is (equal '(1 2 3) (digits "123"))))

(test string-without-digits
  (is (equal '(nil nil nil) (digits "abc"))))

(test string-with-some-digits-to-digits
  (is (equal '(1 nil 2) (digits "1a2"))))

;; ncycle tests

(test ncycle-empty-list
  (is (null (ncycle nil))))

(test ncycle-continues-to-return-values
  (is (equal '(1 2 3 1 2 3)
             (loop for i below 6
                   for x in (ncycle (list 1 2 3))
                   collect x))))

(test ncycle-is-destructive
  (let* ((list (list 1 2 3))
         (cycle (ncycle list)))
    (is-true (eq list cycle))
    (is-true (eq cycle (nthcdr 3 cycle)))))

(test ncycle-unit-list
  (let ((c (ncycle (list 1))))
    (is-true (eq c (cdr c)))))

(test last1
  (is (equal 3 (last1 (list 1 2 3))))
  (is (equal 'a (last1 (list 'a))))
  (is (null (last1 nil))))
