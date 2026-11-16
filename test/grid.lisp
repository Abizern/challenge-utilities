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
