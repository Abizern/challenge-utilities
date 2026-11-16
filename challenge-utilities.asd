;;;; Utilities to help with programming challenges.

(defsystem "challenge-utilities"
  :description "Shared utilities for programming challenges."
  :author "Abizer Nasir <abizern@mac.com>"
  :version "0.1.0"
  :license "MIT"
  :class :package-inferred-system
  :depends-on ("challenge-utilities/all")
  :in-order-to ((test-op (test-op "challenge-utilities/test"))))

;;; Tests live under test/ and are run with (asdf:test-system "challenge-utilities").
(defsystem "challenge-utilities/test"
  :description "Tests for the challenge-utilities system"
  :class :package-inferred-system
  :depends-on ("challenge-utilities/test/suite"
               "challenge-utilities/test/count-letters"
               "challenge-utilities/test/grid"
               "challenge-utilities/test/lists"
               "challenge-utilities/test/md5"
               "challenge-utilities/test/numbers"
               "challenge-utilities/test/point-2d"
               "challenge-utilities/test/queue"
               "challenge-utilities/test/screen"
               "challenge-utilities/test/sqlite")
  :perform (test-op (o c) (uiop:symbol-call :fiveam :run! :challenge-utilities)))
