(uiop:define-package :challenge-utilities/all
  (:nicknames :challenge-utilities :c-utils)
  (:use :cl)
  (:use-reexport :challenge-utilities/comparison)
  (:use-reexport :challenge-utilities/count-letters)
  (:use-reexport :challenge-utilities/grid)
  (:use-reexport :challenge-utilities/lists)
  (:use-reexport :challenge-utilities/matrix)
  (:use-reexport :challenge-utilities/md5)
  (:use-reexport :challenge-utilities/numbers)
  (:use-reexport :challenge-utilities/point-2d)
  (:use-reexport :challenge-utilities/queue)
  (:use-reexport :challenge-utilities/rect-2d)
  (:use-reexport :challenge-utilities/screen)
  (:use-reexport :challenge-utilities/sqlite)
  ;; Commonly used libraries. Importing nothing from them still makes them
  ;; dependencies, so loading this system loads them too.
  (:import-from :cl-ppcre)
  (:import-from :alexandria))
