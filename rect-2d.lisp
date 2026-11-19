;;;; A rectangle in 2D space on an infinite grid and actions that can be performed on it.

(uiop:define-package :challenge-utilities/rect-2d
  (:use :cl)
  (:export #:r2-x1
           #:r2-x2
           #:r2-y1
           #:r2-y2
           #:rect-area
           #:rect-corners
           #:make-rect-from-points))

(in-package :challenge-utilities/rect-2d)

(defstruct (rect-2d (:conc-name r2-))
  (x1 0 :type fixnum)
  (x2 0 :type fixnum)
  (y1 0 :type fixnum)
  (y2 0 :type fixnum))

(declaim (ftype (function (number number) rect-2d) make-rect-from-points))
(defun make-rect-from-points (a b)
  "Return the rectangle with the points A and B as opposite corners.
The corners can be given in either order: the bounds are stored with
X1 <= X2 and Y1 <= Y2."
  (make-rect-2d :x1 (min (realpart a) (realpart b))
                :x2 (max (realpart a) (realpart b))
                :y1 (min (imagpart a) (imagpart b))
                :y2 (max (imagpart a) (imagpart b))))

(declaim (ftype (function (rect-2d) list) rect-corners))
(defun rect-corners (r)
  "Return a list of the ordered boundaries of R
(X1 X2 Y1 Y2)."
  (list (r2-x1 r) (r2-x2 r) (r2-y1 r) (r2-y2 r)))

(declaim (ftype (function (rect-2d) fixnum) rect-area))
(defun rect-area (r)
  "Return the number of cells covered by the rectangle R, counting
the cells on its edges, so a rectangle whose corners are the same
point has an area of 1."
  (* (1+ (- (r2-x2 r) (r2-x1 r)))
     (1+ (- (r2-y2 r) (r2-y1 r)))))
