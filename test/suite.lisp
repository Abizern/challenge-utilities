;;;; Root test suite. Each test package defines its own suite inside this one.

(defpackage :challenge-utilities/test/suite
  (:use :cl :fiveam))

(in-package :challenge-utilities/test/suite)

(def-suite :challenge-utilities :description "All challenge-utilities tests")
