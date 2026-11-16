;;;; Utilities for working with numbers.

(uiop:define-package :challenge-utilities/numbers
  (:use :cl)
  (:export #:composite-p))

(in-package :challenge-utilities/numbers)

;; Public interface

(defun composite-p (n)
  "Return T if N is a composite number: a whole number greater than 1 with a
divisor other than 1 and itself. 0, 1 and the primes are not composite."
  (and (> n 1)
       (loop for i from 2 to (isqrt n)
             thereis (zerop (mod n i)))))
