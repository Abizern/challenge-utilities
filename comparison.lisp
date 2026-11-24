;;;; Utility functions for dealing with comparisons

(uiop:define-package :challenge-utilities/comparison
  (:use :cl)
  (:export
   #:compare
   #:nif
   #:nif-compare))

(in-package :challenge-utilities/comparison)

;;; Public interface

(defgeneric compare (a b)
  (:documentation "Three way comparison returning -1, 0 or 1."))

(defmethod compare ((a real) (b real))
  (cond ((< a b) -1)
        ((> a b) 1)
        (t 0)))

(defmethod compare ((a string) (b string))
  (cond ((string< a b) -1)
        ((string> a b) 1)
        (t 0)))

(defmethod compare ((a character) (b character))
  (cond ((char< a b) -1)
        ((char> a b) 1)
        (t 0)))

(defmacro nif (expr pos zero neg)
  "Evaluate EXPR once, then evaluate and return POS if it is positive, ZERO if
it is zero, or NEG if it is negative. Only the chosen form is evaluated."
  (let ((g (gensym "RESULT-")))
    `(let ((,g ,expr))
       (cond ((plusp ,g) ,pos)
             ((zerop ,g) ,zero)
             (t ,neg)))))

(defmacro nif-compare (a b pos zero neg)
  "Compare A and B with COMPARE, then evaluate and return POS if A is greater,
ZERO if they are equal, or NEG if A is less. Only the chosen form is evaluated."
  `(nif (compare ,a ,b) ,pos ,zero ,neg))
