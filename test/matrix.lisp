;;;; Tests for the matrix utilities

(defpackage :challenge-utilities/test/matrix
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/matrix)

(def-suite matrix :in :challenge-utilities)
(in-suite matrix)

(defun matrix (rows)
  "A 2D array with a row for each list in ROWS."
  (make-array (list (length rows) (length (first rows)))
              :initial-contents rows))

(test rref-unique-solution
  (let ((m (matrix '((2 1 -1 8) (-3 -1 2 -11) (-2 1 2 -3)))))
    (is (equal '(0 1 2) (rref m)))
    (is (equalp (matrix '((1 0 0 2) (0 1 0 3) (0 0 1 -1))) m))))

(test rref-swaps-zero-pivot
  (let ((m (matrix '((0 1 2) (1 0 3)))))
    (is (equal '(0 1) (rref m)))
    (is (equalp (matrix '((1 0 3) (0 1 2))) m))))

(test rref-dependent-rows
  (let ((m (matrix '((0 0 1 3) (1 2 0 4) (2 4 1 11)))))
    (is (equal '(0 2) (rref m)))
    (is (equalp (matrix '((1 2 0 4) (0 0 1 3) (0 0 0 0))) m))))

(test rref-inconsistent-system
  ;; x + y = 1 and x + y = 2 leave a row of 0 0 | 1
  (let ((m (matrix '((1 1 1) (1 1 2)))))
    (is (equal '(0) (rref m)))
    (is (equalp (matrix '((1 1 1) (0 0 1))) m))))

(test rref-exact-rationals
  (let ((m (matrix '((3 1)))))
    (rref m)
    (is (eql 1/3 (aref m 0 1)))))
