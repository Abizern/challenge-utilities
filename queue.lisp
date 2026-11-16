;;;; A simple FIFO queue

(uiop:define-package :challenge-utilities/queue
  (:use :cl)
  (:export #:dequeue
           #:enqueue
           #:make-queue
           #:queue-empty-p))

(in-package :challenge-utilities/queue)

;;; Public interface

(defun make-queue ()
  "Create a new, empty queue."
  (cons nil nil))

(defun queue-empty-p (queue)
  "Return T if QUEUE is empty."
  (null (car queue)))

(defun enqueue (item queue)
  "Add ITEM to the queue."
  (let ((new-cell (list item)))
    (if (queue-empty-p queue)
        (setf (car queue) new-cell
              (cdr queue) new-cell)
        (setf (cdr (cdr queue)) new-cell
              (cdr queue) new-cell))
    queue))

(defun dequeue (queue)
  "Remove and return the front item of the queue or NIL
if the queue is empty."
  (unless (queue-empty-p queue)
    (let ((item (car (car queue))))
      (setf (car queue) (cdr (car queue)))
      (when (queue-empty-p queue)
        (setf (cdr queue) nil))
      item)))
