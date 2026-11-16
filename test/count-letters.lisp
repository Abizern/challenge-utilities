;;;; Tests for the letter counting utilities.

(defpackage :challenge-utilities/test/count-letters
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/count-letters)

(def-suite letters :in :challenge-utilities)
(in-suite letters)

(test count-letters-accepts-a-string-or-a-list
  (is (equal (counts-alist (count-letters "abca"))
             (counts-alist (count-letters '(#\a #\b #\c #\a))))))

(test counts-alist-is-alphabetical-and-omits-zeros
  (is (equal '((#\a . 2) (#\b . 1) (#\c . 1))
             (counts-alist (count-letters "caba"))))
  (is (equal '((#\a . 2) (#\c . 1) (#\z . 1))
             (counts-alist (count-letters "zaca")))))

(test counts-alist-ignores-other-characters
  (is (equal '((#\a . 2) (#\b . 1))
             (counts-alist (count-letters "a-b A1 a!")))))

(test counts-alist-of-nothing-is-empty
  (is (null (counts-alist (count-letters ""))))
  (is (null (counts-alist (count-letters "---")))))

(test counts-alist-is-fresh
  (let ((letters (count-letters "abca")))
    (sort (counts-alist letters) #'> :key #'cdr)
    (is (equal '((#\a . 2) (#\b . 1) (#\c . 1))
               (counts-alist letters)))))

(test most-frequent-char-returns-char-and-count
  (is (eql #\b (most-frequent-char (count-letters "abbc"))))
  (is (equal '(#\b 2) (multiple-value-list (most-frequent-char (count-letters "abbc"))))))

(test least-frequent-char-returns-char-and-count
  (is (eql #\a (least-frequent-char (count-letters "abbcc"))))
  (is (equal '(#\a 1) (multiple-value-list (least-frequent-char (count-letters "abbcc"))))))

(test least-frequent-char-ignores-missing-letters
  (is (eql #\z (least-frequent-char (count-letters "zzz")))))

;; Ties currently go to the letter that is last alphabetically.
(test frequent-char-ties
  (is (eql #\b (most-frequent-char (count-letters "aabbc"))))
  (is (eql #\c (least-frequent-char (count-letters "aabbcc")))))

(test frequent-char-of-nothing
  (is (equal '(nil nil) (multiple-value-list (most-frequent-char (count-letters "")))))
  (is (equal '(nil nil) (multiple-value-list (least-frequent-char (count-letters "---"))))))
