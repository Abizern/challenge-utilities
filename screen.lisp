;;;; A screen of pixels that are either on (1) or off (0).

(uiop:define-package :challenge-utilities/screen
  (:use :cl)
  (:export #:make-screen
           #:pixel
           #:turn-on
           #:get-row
           #:set-row
           #:get-col
           #:set-col
           #:count-pixels))

(in-package :challenge-utilities/screen)

(defstruct (screen (:constructor %make-screen (pixels)))
  pixels)

(defun make-screen (rows cols)
  "Return a SCREEN of ROWS by COLS pixels, all off."
  (%make-screen (make-array (list rows cols) :element-type 'bit :initial-element 0)))

(defun pixel (screen row col)
  "Return the pixel of SCREEN at ROW and COL: 1 if it is on, 0 if it is off.
Use SETF to change it."
  (sbit (screen-pixels screen) row col))

(defun (setf pixel) (value screen row col)
  "Set the pixel of SCREEN at ROW and COL to VALUE, which must be 1 or 0."
  (setf (sbit (screen-pixels screen) row col) value))

(defun turn-on (screen rows cols)
  "Turn on the pixels in the top-left ROWS by COLS rectangle of SCREEN."
  (loop for row from 0 below rows
        do (loop for col from 0 below cols
                 do (setf (pixel screen row col) 1))))

(defun get-row (screen row)
  "Return a fresh bit vector of the pixels in row ROW of SCREEN."
  (let* ((pixels (screen-pixels screen))
         (cols (array-dimension pixels 1))
         (row-vector (make-array cols :element-type 'bit)))
    (dotimes (c cols row-vector)
      (setf (sbit row-vector c) (sbit pixels row c)))))

(defun set-row (screen row new-vector)
  "Set the pixels in row ROW of SCREEN from NEW-VECTOR, a simple bit vector
at least as long as a row. Return SCREEN."
  (let* ((pixels (screen-pixels screen))
         (cols (array-dimension pixels 1)))
    (dotimes (c cols screen)
      (setf (sbit pixels row c) (sbit new-vector c)))))

(defun get-col (screen col)
  "Return a fresh bit vector of the pixels in column COL of SCREEN."
  (let* ((pixels (screen-pixels screen))
         (rows (array-dimension pixels 0))
         (col-vector (make-array rows :element-type 'bit)))
    (dotimes (r rows col-vector)
      (setf (sbit col-vector r) (sbit pixels r col)))))

(defun set-col (screen col new-vector)
  "Set the pixels in column COL of SCREEN from NEW-VECTOR, a simple bit
vector at least as long as a column. Return SCREEN."
  (let* ((pixels (screen-pixels screen))
         (rows (array-dimension pixels 0)))
    (dotimes (r rows screen)
      (setf (sbit pixels r col) (sbit new-vector r)))))

(defun count-pixels (screen)
  "Return the number of pixels of SCREEN that are on."
  (let ((pixels (screen-pixels screen)))
    (loop for i from 0 below (array-total-size pixels)
          sum (row-major-aref pixels i))))

(defmethod print-object ((screen screen) stream)
  "Draw SCREEN on STREAM, one row per line, with # for on and . for off.
Each row starts with a newline, so the picture starts on a fresh line."
  (loop for row from 0 below (array-dimension (screen-pixels screen) 0)
        do (terpri stream)
           (loop for col from 0 below (array-dimension (screen-pixels screen) 1)
                 do (write-char (if (= 1 (pixel screen row col)) #\# #\.) stream))))
