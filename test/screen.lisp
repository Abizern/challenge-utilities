;;;; Tests for the screen utilities.

(defpackage :challenge-utilities/test/screen
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/screen)

(def-suite screen :in :challenge-utilities)
(in-suite screen)

(defun draw (screen)
  "Return the picture of SCREEN as a string."
  (format nil "~a" screen))

(test new-screen-is-off
  (let ((screen (make-screen 2 3)))
    (is (= 0 (count-pixels screen)))
    (is (string= "
...
..." (draw screen)))))

(test set-and-read-a-pixel
  (let ((screen (make-screen 2 3)))
    (is (= 1 (setf (pixel screen 1 2) 1)))
    (is (= 1 (pixel screen 1 2)))
    (is (= 0 (pixel screen 0 0)))))

(test pixels-are-bits
  (signals type-error
    (setf (pixel (make-screen 2 3) 0 0) t)))

(test rows-come-before-columns
  (let ((screen (make-screen 2 3)))
    (setf (pixel screen 1 2) 1)
    (is (string= "
...
..#" (draw screen)))))

(test turn-on-lights-the-top-left
  (let ((screen (make-screen 3 7)))
    (turn-on screen 2 3)
    (is (= 6 (count-pixels screen)))
    (is (string= "
###....
###....
......." (draw screen)))))

(test turn-on-nothing
  (let ((screen (make-screen 3 7)))
    (turn-on screen 0 0)
    (is (= 0 (count-pixels screen)))))

(test count-pixels-counts-every-pixel
  (let ((screen (make-screen 6 50)))
    (turn-on screen 6 50)
    (is (= 300 (count-pixels screen)))))

(defun screen-from-rows (&rest rows)
  "Return a screen whose pixels are ROWS, a list of strings of # and .
characters."
  (let ((screen (make-screen (length rows) (length (first rows)))))
    (loop for line in rows
          for row from 0
          do (loop for char across line
                   for col from 0
                   do (setf (pixel screen row col) (if (char= char #\#) 1 0))))
    screen))

(test get-row-returns-the-row
  (let ((screen (screen-from-rows "#.#." "..##")))
    (is (equal #*1010 (get-row screen 0)))
    (is (equal #*0011 (get-row screen 1)))))

(test get-col-returns-the-column
  (let ((screen (screen-from-rows "#.#." "..##")))
    (is (equal #*10 (get-col screen 0)))
    (is (equal #*11 (get-col screen 2)))))

(test get-row-and-get-col-return-copies
  (let ((screen (screen-from-rows "#.#." "..##")))
    (setf (sbit (get-row screen 0) 1) 1)
    (setf (sbit (get-col screen 1) 0) 1)
    (is (= 0 (pixel screen 0 1)))))

(test set-row-overwrites-only-that-row
  (let ((screen (screen-from-rows "#.#." "..##")))
    (is (eq screen (set-row screen 0 #*0110)))
    (is (string= "
.##.
..##" (draw screen)))))

(test set-col-overwrites-only-that-column
  (let ((screen (screen-from-rows "#.#." "..##")))
    (is (eq screen (set-col screen 3 #*10)))
    (is (string= "
#.##
..#." (draw screen)))))

(test get-then-set-leaves-the-screen-unchanged
  (let ((screen (screen-from-rows "#.#." "..##")))
    (set-row screen 1 (get-row screen 1))
    (set-col screen 0 (get-col screen 0))
    (is (string= "
#.#.
..##" (draw screen)))))
