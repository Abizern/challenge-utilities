;;;; Tests for the SQLite utility.

(defpackage :challenge-utilities/test/sqlite
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/sqlite)

(def-suite sqlite :in :challenge-utilities)
(in-suite sqlite)

(defmacro with-test-db ((db) &body body)
  "Run BODY with DB bound to an in-memory database holding a small table."
  `(sqlite:with-open-database (,db ":memory:")
     (sqlite:execute-non-query ,db "CREATE TABLE things (id INTEGER, name TEXT)")
     (sqlite:execute-non-query ,db "INSERT INTO things VALUES (1, 'one'), (2, 'two')")
     ,@body))

(test query-returns-rows-as-lists
  (with-test-db (db)
    (is (equal '((1 "one") (2 "two"))
               (query db (sxql:select (:id :name)
                           (sxql:from :things)
                           (sxql:order-by :id)))))))

(test query-binds-parameters
  (with-test-db (db)
    (is (equal '(("two"))
               (query db (sxql:select :name
                           (sxql:from :things)
                           (sxql:where (:= :id 2))))))))

(test query-returns-nil-for-statements-without-rows
  (with-test-db (db)
    (is (null (query db (sxql:insert-into :things (:id :name) (list 3 "three")))))
    (is (equal '((3))
               (query db (sxql:select ((:count :*)) (sxql:from :things)))))))
