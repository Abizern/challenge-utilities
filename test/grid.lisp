;;;; Tests for the grid utilities.

(defpackage :challenge-utilities/test/grid
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/grid)

(def-suite grid :in :challenge-utilities)
(in-suite grid)

(defun draw (grid &optional (cell-char #'identity))
  "Return the picture of GRID that PRINT-GRID draws, as a string."
  (with-output-to-string (stream)
    (print-grid grid cell-char stream)))

(test make-grid-has-rows-then-columns
  (let ((grid (make-grid 2 3 :initial-element #\.)))
    (is (= 2 (grid-rows grid)))
    (is (= 3 (grid-cols grid)))
    (is (char= #\. (aref grid 1 2)))))

(test make-grid-calls-the-initial-function-with-row-and-column
  (let ((grid (make-grid 2 3 :initial-function #'cons)))
    (is (equal '(1 . 2) (aref grid 1 2)))))

(test make-grid-xy-has-width-columns-and-height-rows
  (let ((grid (make-grid-xy 3 2 :initial-element 0)))
    (is (= 2 (grid-rows grid)))
    (is (= 3 (grid-cols grid)))))

(test make-grid-xy-calls-the-initial-function-with-x-and-y
  (let ((grid (make-grid-xy 3 2 :initial-function #'cons)))
    (is (equal '(2 . 1) (aref grid 1 2)))))

(test neighbours-are-up-down-left-right
  (let ((grid (make-grid 3 3)))
    (is (equal '((0 . 1) (2 . 1) (1 . 0) (1 . 2))
               (neighbours grid 1 1)))))

(test neighbours-in-a-corner
  (let ((grid (make-grid 3 3)))
    (is (equal '((1 . 0) (0 . 1)) (neighbours grid 0 0)))))

(test neighbours-on-an-edge
  (let ((grid (make-grid 3 3)))
    (is (equal '((1 . 1) (0 . 0) (0 . 2)) (neighbours grid 0 1)))))

(test neighbours-with-diagonals
  (let ((grid (make-grid 3 3)))
    (is (= 8 (length (neighbours grid 1 1 :diagonals t))))
    (is (equal '((1 . 0) (0 . 1) (1 . 1))
               (neighbours grid 0 0 :diagonals t)))))

(test cells-matching-available-values
  (let ((grid (make-grid 3 3 :initial-function (lambda (r c)
                                                 (+ r c)))))
    (is (equal '((0 . 0) (0 . 2) (1 . 1) (2 . 0) (2 . 2))
               (cells-matching grid #'evenp)))))

(test cells-matching-no-values
  (let ((grid (make-grid 3 3 :initial-element 1)))
    (is (null (cells-matching grid #'evenp)))))

(test print-grid-draws-characters-as-they-are
  (let ((grid (make-grid 2 3 :initial-element #\.)))
    (setf (aref grid 1 2) #\#)
    (is (string= "...
..#
" (draw grid)))))

(test print-grid-uses-the-cell-function
  (let ((grid (make-grid 2 2 :initial-function #'+)))
    (is (string= ".#
#.
" (draw grid (lambda (n) (if (oddp n) #\# #\.)))))))

(test lines-to-grid-keeps-the-characters
  (let ((grid (lines-to-grid '("#.." "..#"))))
    (is (= 2 (grid-rows grid)))
    (is (= 3 (grid-cols grid)))
    (is (char= #\# (aref grid 0 0)))
    (is (char= #\# (aref grid 1 2)))))

(test lines-to-grid-from-a-vector
  (is (equalp #2A((#\a #\b) (#\c #\d))
              (lines-to-grid #("ab" "cd")))))

(test lines-to-grid-uses-the-cell-function
  (is (equalp #2A((1 2) (3 4))
              (lines-to-grid '("12" "34") #'digit-char-p))))

(test lines-to-grid-of-no-lines
  (let ((grid (lines-to-grid nil)))
    (is (= 0 (grid-rows grid)))
    (is (= 0 (grid-cols grid)))))

(test cell-neighbours-takes-a-cons
  (let ((grid (make-grid 3 3)))
    (is (equal (neighbours grid 0 1) (cell-neighbours grid '(0 . 1))))
    (is (equal (neighbours grid 1 1 :diagonals t)
               (cell-neighbours grid '(1 . 1) :diagonals t)))))

(test cell-neighbours-of-cells-matching
  (let ((grid (lines-to-grid '("..." ".#." "..."))))
    (is (= 8 (length (cell-neighbours grid
                                      (first (cells-matching grid (lambda (c) (char= c #\#))))
                                      :diagonals t))))))

(test cell-value-reads-a-cell
  (let ((grid (lines-to-grid '("ab" "cd"))))
    (is (char= #\b (cell-value grid '(0 . 1))))
    (is (char= #\c (cell-value grid '(1 . 0))))))

(test cell-value-is-setf-able
  (let ((grid (make-grid 2 2 :initial-element 0)))
    (setf (cell-value grid '(1 . 0)) 5)
    (is (= 5 (aref grid 1 0)))
    (is (= 5 (cell-value grid '(1 . 0))))))

(test copy-grid-has-the-same-cells
  (let ((grid (lines-to-grid '("ab" "cd" "ef"))))
    (is (equalp grid (copy-grid grid)))))

(test copy-grid-is-a-separate-grid
  (let* ((grid (make-grid 2 2 :initial-element 0))
         (copy (copy-grid grid)))
    (setf (aref copy 0 0) 1)
    (is (= 0 (aref grid 0 0)))))
