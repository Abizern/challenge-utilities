;;;; Utilities for dealing with matrices, which are represented as a 2D array.

(uiop:define-package :challenge-utilities/matrix
  (:use :cl)
  (:export #:rref))

(in-package :challenge-utilities/matrix)

(defun rref (matrix)
  "Transforms MATRIX, an augmented matrix whose last column is the right-hand
side, into Reduced Row Echelon Form in-place.
Returns a list of pivot column indices."
  (let* ((rows (array-dimension matrix 0))
         (cols (1- (array-dimension matrix 1)))
         (pivot-row 0)
         (pivots '()))
    (loop for col from 0 below cols
          while (< pivot-row rows)
          for found = (loop for r from pivot-row below rows
                            when (not (zerop (aref matrix r col)))
                              return r)
          when found
            ;; Swap pivot row into place
            do (unless (= found pivot-row)
                 (loop for c from col to cols
                       do (rotatef (aref matrix pivot-row c)
                                   (aref matrix found c))))
               ;; Normalize pivot row so pivot becomes 1
               (let ((div (aref matrix pivot-row col)))
                 (loop for c from col to cols
                       do (setf (aref matrix pivot-row c)
                                (/ (aref matrix pivot-row c) div))))
               ;; Eliminate this column in all other rows
               (loop for r from 0 below rows
                     when (and (/= r pivot-row)
                               (not (zerop (aref matrix r col))))
                       do (let ((factor (aref matrix r col)))
                            (loop for c from col to cols
                                  do (decf (aref matrix r c)
                                           (* factor (aref matrix pivot-row c))))))
               (push col pivots)
               (incf pivot-row))
    (nreverse pivots)))
