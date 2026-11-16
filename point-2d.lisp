;;;; A point in 2D space on an infinite grid and the actions that can be performed with it.

(uiop:define-package :challenge-utilities/point-2d
  (:use :cl)
  (:export #:manhattan-2d
           #:make-point-2d
           #:move-point-2d
           #:move-point-2d-step
           #:move-point-2d-xy
           #:point-2d=
           #:point-2d/=
           #:step-gradient-2d))

(in-package :challenge-utilities/point-2d)

;;; Public interface

(defun make-point-2d (x y)
  "Return a complex number representing a 2D point
as a complex number with the X as real part and Y
as the imaginary part"
  (complex x y))

(defun point-2d= (p1 &rest pts)
  "Return T if all the given points are the same."
  (every (lambda (p) (equalp p1 p)) pts))

(defun point-2d/= (p1 &rest pts)
  "Return T unless all the given points are the same."
  (not (apply #'point-2d= p1 pts)))

(defun manhattan-2d (p1 &optional (p2 0))
  "Return the Manhattan distance between P1 and P2.
By default, P2 is the origin."
  (+ (abs (- (realpart p1) (realpart p2)))
     (abs (- (imagpart p1) (imagpart p2)))))

(defun move-point-2d-xy (point x y)
  "Return a new point created by moving POINT
by the amounts given by X and Y."
  (make-point-2d (+ x (realpart point))
                 (+ y (imagpart point))))

(defun move-point-2d (point dir)
  "Return a new point created by moving POINT in the
direction of DIR which is one of :N :S :E :W"
  (ecase dir
    (:N (+ point #C(0 1)))
    (:S (+ point #C(0 -1)))
    (:E (+ point 1))
    (:W (- point 1))))

(defun move-point-2d-step (point step)
  "Return a new point created by moving POINT by
the amounts in the complex number STEP."
  (+ point step))

(defun step-gradient-2d (from-pt to-pt)
  "Return the smallest whole-number step from FROM-PT towards
TO-PT, for use with MOVE-POINT-2D-STEP. Returns a zero step if
they are the same point."
  (let* ((dx (- (realpart to-pt) (realpart from-pt)))
         (dy (- (imagpart to-pt) (imagpart from-pt)))
         (g (gcd dx dy)))
    (if (zerop g)
        0
        (complex (/ dx g) (/ dy g)))))
