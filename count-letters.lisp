;;;; A utility for dealing with counting lower case letters a-z.

(uiop:define-package :challenge-utilities/count-letters
  (:use :cl)
  (:import-from :alexandria #:extremum)
  (:export #:count-letters
           #:counts-alist
           #:least-frequent-char
           #:most-frequent-char))

(in-package :challenge-utilities/count-letters)

(defconstant +offset+ (char-code #\a))

(defstruct (count-letters (:constructor %make-count-letters (counts)))
  counts)

(defun count-letters (sequence)
  "Return a COUNT-LETTERS struct counting the letters a-z in SEQUENCE.
SEQUENCE is a string or a list of characters. Other characters, including
upper case letters, are ignored."
  (let ((counts (make-array 26 :initial-element 0)))
    (loop for c being the elements of sequence
          for code = (char-code c)
          when (char<= #\a c #\z)
            do (incf (aref counts (- code +offset+))))
    (%make-count-letters counts)))

(defun counts-alist (letters)
  "Return an alist of (CHAR . COUNT) for each letter counted in LETTERS.
The list is in alphabetical order and omits letters with a count of zero.
It is freshly made, so destructive operations can be safely made to it."
  (loop for count across (count-letters-counts letters)
        for i from 0
        when (plusp count)
          collect (cons (code-char (+ +offset+ i)) count)))

(defun least-frequent-char (letters)
  "Return the least frequent letter counted in LETTERS, and its count.
Letters with a count of zero are not considered. Ties go to the letter that
is last alphabetically. Returns NIL and NIL if no letters were counted."
  (let ((pair (extremum (counts-alist letters) #'< :key #'cdr)))
    (values (car pair) (cdr pair))))

(defun most-frequent-char (letters)
  "Return the most frequent letter counted in LETTERS, and its count.
Ties go to the letter that is last alphabetically. Returns NIL and NIL if no
letters were counted."
  (let ((pair (extremum (counts-alist letters) #'> :key #'cdr)))
    (values (car pair) (cdr pair))))
