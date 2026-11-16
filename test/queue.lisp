;;;; Tests for the Queue utility.

(defpackage :challenge-utilities/test/queue
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/queue)

(def-suite queue :in :challenge-utilities)
(in-suite queue)

(test queue-creation
  (is (null (dequeue (make-queue)))))

;; enqueue tests

(test enqueue-onto-an-empty-queue
  (let ((q (make-queue)))
    (enqueue 1 q)
    (is (= 1 (dequeue q)))))

(test enqueue-keeps-items-in-order
  (let ((q (make-queue)))
    (enqueue 1 q)
    (enqueue 2 q)
    (enqueue 3 q)
    (is (= 1 (dequeue q)))
    (is (= 2 (dequeue q)))
    (is (= 3 (dequeue q)))
    (is (null (dequeue q)))))

(test enqueue-returns-the-queue
  (let ((q (make-queue)))
    (is (eq q (enqueue 1 q)))))

(test enqueue-after-emptying
  (let ((q (make-queue)))
    (enqueue 1 q)
    (dequeue q)
    (enqueue 2 q)
    (is (= 2 (dequeue q)))
    (is (null (dequeue q)))))

(test enqueue-while-dequeuing
  (let ((q (make-queue)))
    (enqueue 1 q)
    (enqueue 2 q)
    (dequeue q)
    (enqueue 3 q)
    (is (= 2 (dequeue q)))
    (is (= 3 (dequeue q)))))

(test queues-are-separate
  (let ((q1 (make-queue))
        (q2 (make-queue)))
    (enqueue 1 q1)
    (enqueue 2 q2)
    (is (= 1 (dequeue q1)))
    (is (null (dequeue q1)))
    (is (= 2 (dequeue q2)))))

(test check-non-empty-queue
  (let ((q (make-queue)))
    (enqueue 1 q)
    (is-false (queue-empty-p q))))

(test check-empty-queue
  (let ((q (make-queue)))
    (enqueue 1 q)
    (dequeue q)
    (is (queue-empty-p q))))
