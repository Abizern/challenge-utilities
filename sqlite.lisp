;;;; Helpers for running SxQL statements against an SQLite database

(uiop:define-package :challenge-utilities/sqlite
  (:use :cl)
  (:import-from :sqlite #:execute-to-list)
  (:import-from :sxql #:yield)
  (:export #:query))

(in-package :challenge-utilities/sqlite)

;;; Public interface

(defun query (db statement)
  "Run the SxQL STATEMENT against DB and return its rows as lists."
  (multiple-value-bind (sql params) (yield statement)
    (apply #'execute-to-list db sql params)))
