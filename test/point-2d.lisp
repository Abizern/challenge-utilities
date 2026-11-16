;;;; Tests for the point-2d utilities

(defpackage :challenge-utilities/test/point-2d
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/point-2d)

(def-suite point-2d :in :challenge-utilities)
(in-suite point-2d)

(test point-has-x-and-y-parts
  (let ((pt (make-point-2d 2 3)))
    (is (= 2 (realpart pt)))
    (is (= 3 (imagpart pt)))))

(test manhattan-distance-to-origin
  (is (= 4 (manhattan-2d (make-point-2d 2 2))))
  (is (= 5 (manhattan-2d (make-point-2d -2 3))))
  (is (= 6 (manhattan-2d (make-point-2d -3 -3))))
  (is (= 3 (manhattan-2d (make-point-2d 0 3)))))

(test manhattan-distance-between-points
  (is (= 2 (manhattan-2d (make-point-2d 2 2) (make-point-2d 3 3))))
  (is (= 2 (manhattan-2d (make-point-2d -2 -2) (make-point-2d -3 -3))))
  (is (= 6 (manhattan-2d (make-point-2d 3 0) (make-point-2d 0 3)))))

(test point-equality-fn
  (is (point-2d= (make-point-2d 1 1) (make-point-2d 1 1)))
  (is-false (point-2d= (make-point-2d 1 1) (make-point-2d 1 0)))
  (is (point-2d= (make-point-2d 1 1) (make-point-2d 1 1) (make-point-2d 1 1)))
  (is-false (point-2d= (make-point-2d 1 1) (make-point-2d 1 1) (make-point-2d 0 1)))
  (is (point-2d= (make-point-2d 1 2))))

(test point-inequality-fn
  (is-false (point-2d/= (make-point-2d 1 1) (make-point-2d 1 1)))
  (is (point-2d/= (make-point-2d -1 1) (make-point-2d 1 -1)))
  (is (point-2d/= (make-point-2d -1 -1) (make-point-2d -1 -1) (make-point-2d -2 0)))
  (is-false (point-2d/= (make-point-2d -2 3))))

(test move-point-2d-xy
  (is (point-2d= #C(1 1) (move-point-2d-xy (make-point-2d 1 0) 0 1))))

(test move-point-2d
  (is (point-2d= (make-point-2d 1 2) (move-point-2d (make-point-2d 1 1) :n)))
  (is (point-2d= (make-point-2d 1 0) (move-point-2d (make-point-2d 1 1) :s)))
  (is (point-2d= (make-point-2d 2 1) (move-point-2d (make-point-2d 1 1) :e)))
  (is (point-2d= (make-point-2d 0 1) (move-point-2d (make-point-2d 1 1) :w))))

(test move-point-2d-step
  (is (point-2d= (make-point-2d 3 4) (move-point-2d-step (make-point-2d 1 1) #C(2 3))))
  (is (point-2d= (make-point-2d -1 2) (move-point-2d-step (make-point-2d 1 1) #C(-2 1))))
  (is (point-2d= (make-point-2d 1 1) (move-point-2d-step (make-point-2d 1 1) 0)))
  (let* ((from (make-point-2d 1 1))
         (to (make-point-2d 5 -3))
         (step (step-gradient-2d from to)))
    (is (point-2d= to (loop repeat 4
                            for pt = (move-point-2d-step from step)
                              then (move-point-2d-step pt step)
                            finally (return pt))))))

(test step-gradient-2d
  (is (equalp #C(1 1) (step-gradient-2d (make-point-2d 0 0) (make-point-2d 2 2))))
  (is (equalp #C(7 1) (step-gradient-2d (make-point-2d 1 1) (make-point-2d 8 2))))
  (is (equalp #C(-2 3) (step-gradient-2d (make-point-2d -1 -1) (make-point-2d -3 2))))
  (is (equalp #C(1 -1) (step-gradient-2d (make-point-2d 1 1) (make-point-2d 5 -3))))
  (is (equalp #C(0 1) (step-gradient-2d (make-point-2d 0 0) (make-point-2d 0 6))))
  (is (equalp 0 (step-gradient-2d (make-point-2d 2 3) (make-point-2d 2 3)))))
