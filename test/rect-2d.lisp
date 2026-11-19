;;;; Tests for the rect-2d utilities

(defpackage :challenge-utilities/test/rect-2d
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/rect-2d)

(def-suite rect-2d :in :challenge-utilities)
(in-suite rect-2d)

(test make-rect-ordered-points
  (let* ((a (make-point-2d 1 2))
         (b (make-point-2d 5 6))
         (r (make-rect-from-points a b)))
    (is (= 1 (r2-x1 r)))
    (is (= 5 (r2-x2 r)))
    (is (= 2 (r2-y1 r)))
    (is (= 6 (r2-y2 r)))))

(test make-rect-unordered-points
  (let* ((a (make-point-2d 5 6))
         (b (make-point-2d 1 2))
         (r (make-rect-from-points a b)))
    (is (= 1 (r2-x1 r)))
    (is (= 5 (r2-x2 r)))
    (is (= 2 (r2-y1 r)))
    (is (= 6 (r2-y2 r)))))

(test make-rect-non-complex-points
  (let* ((a (make-point-2d 1 0))
         (b (make-point-2d 5 0))
         (r (make-rect-from-points a b)))
    (is (= 1 (r2-x1 r)))
    (is (= 5 (r2-x2 r)))
    (is (= 0 (r2-y1 r)))
    (is (= 0 (r2-y2 r)))))

(test make-rect-negative-points
  (let* ((a (make-point-2d -5 6))
         (b (make-point-2d 1 -2))
         (r (make-rect-from-points a b)))
    (is (= -5 (r2-x1 r)))
    (is (= 1 (r2-x2 r)))
    (is (= -2 (r2-y1 r)))
    (is (= 6 (r2-y2 r)))))

(test make-rect-same-point
  (let* ((a (make-point-2d 3 4))
         (r (make-rect-from-points a a)))
    (is (= 3 (r2-x1 r)))
    (is (= 3 (r2-x2 r)))
    (is (= 4 (r2-y1 r)))
    (is (= 4 (r2-y2 r)))))

(test make-rect-other-diagonal
  (let* ((a (make-point-2d 1 6))
         (b (make-point-2d 5 2))
         (r (make-rect-from-points a b)))
    (is (= 1 (r2-x1 r)))
    (is (= 5 (r2-x2 r)))
    (is (= 2 (r2-y1 r)))
    (is (= 6 (r2-y2 r)))))

(test rect-area-square
  (is (= 25 (rect-area (make-rect-from-points (make-point-2d 1 2)
                                              (make-point-2d 5 6))))))

(test rect-area-non-square
  (is (= 24 (rect-area (make-rect-from-points (make-point-2d 1 2)
                                              (make-point-2d 4 7))))))

(test rect-area-negative-points
  (is (= 63 (rect-area (make-rect-from-points (make-point-2d -5 6)
                                              (make-point-2d 1 -2))))))

(test rect-area-line
  (is (= 5 (rect-area (make-rect-from-points (make-point-2d 1 0)
                                             (make-point-2d 5 0))))))

(test rect-area-same-point
  (is (= 1 (rect-area (make-rect-from-points (make-point-2d 3 4)
                                             (make-point-2d 3 4))))))
