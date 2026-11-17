;;;; Utilities for operating on lists.

(uiop:define-package :challenge-utilities/lists
  (:use :cl)
  (:export #:digits
           #:flip
           #:grid-symmetries
           #:last1
           #:ncycle
           #:rotate-right
           #:transpose))

(in-package :challenge-utilities/lists)

;; Public interface

(defun transpose (lists)
  "Return the transpose of LISTS, a list of rows, as a list of columns.
For example, ((1 2 3) (4 5 6)) gives ((1 4) (2 5) (3 6)). Rows of different
lengths are truncated to the shortest. Returns NIL when LISTS is empty."
  (when lists
    (apply #'mapcar #'list lists)))

(defun flip (lists)
  "Return the result of flipping LISTS around the vertical axis.
For example, ((1 2) (3 4)) gives ((2 1) (4 3)). Most useful when
rows are of the same lengths. Returns NIL when LISTS is empty."
  (when lists
    (mapcar #'reverse lists)))

(defun rotate-right (lists)
  "Return LISTS, a list of rows, rotated a quarter turn clockwise.
For example, ((1 2) (3 4)) gives ((3 1) (4 2)), and the rows of
((1 2 3) (4 5 6)) become the columns of ((4 1) (5 2) (6 3)). Returns NIL
when LISTS is empty."
  (when lists
    (flip (transpose lists))))

(defun grid-symmetries (lists)
  "Return a list of the eight symmetries of LISTS, a list of rows: its four
rotations, starting with LISTS itself, then the four rotations of its flip.
A grid that is already symmetric gives some of the same grids more than once.
Returns NIL when LISTS is empty."
  (when lists
    (loop for grid in (list lists (flip lists))
          nconc (loop repeat 4
                      for rotated = grid then (rotate-right rotated)
                      collect rotated))))

(defun digits (string)
  "Return a list of the digits in STRING.
Characters that are not digits are transformed into NIL."
  (map 'list #'digit-char-p string))

(defun ncycle (list)
  "Make LIST circular by pointing its last cons back to its first, and return
it. LIST is modified."
  (when list
    (setf (cdr (last list)) list)
    list))

(declaim (inline last1))
(defun last1 (lst)
  "Return the last element in LST. Unlike the built-in
LAST function which returns a cons, this just returns the object."
  (car (last lst)))
