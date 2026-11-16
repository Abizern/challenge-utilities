;;;; Tests for the MD5 utilities, using the worked examples from the puzzles.

(defpackage :challenge-utilities/test/md5
  (:use :cl :fiveam :challenge-utilities)
  (:import-from :challenge-utilities/test/suite))

(in-package :challenge-utilities/test/md5)

(def-suite md5 :in :challenge-utilities)
(in-suite md5)

;; 2015 day 4
(test find-md5-prefix-lowest-number
  (is (= 609043 (find-md5-prefix "abcdef" 5)))
  (is (= 1048970 (find-md5-prefix "pqrstuv" 5))))

(test find-md5-prefix-returns-hash
  (is (equal "000001dbbfa3a5c83a2d506429c7b00e"
             (nth-value 1 (find-md5-prefix "abcdef" 5)))))

;; 2016 day 5: each match gives the next one when searching from (1+ N)
(test find-md5-prefix-from-start
  (let ((first (find-md5-prefix "abc" 5)))
    (is (= 3231929 first))
    (is (= 5017308 (find-md5-prefix "abc" 5 :start (1+ first))))))

;; 2016 day 14
(test md5-hex-hashes-key-and-number
  (is (equal "0034e0923cc38887a57bd7b1d4f953df" (md5-hex "abc" 18))))

(test stretched-md5-hex-with-no-rounds-is-md5-hex
  (is (equal (md5-hex "abc" 18) (stretched-md5-hex "abc" 18 0))))

(test stretched-md5-hex-rehashes-the-hex-string
  (is (equal "577571be4de9dcce85a041ba0410f29f" (stretched-md5-hex "abc" 0 0)))
  (is (equal "eec80a0c92dc8a0777c619d9bb51e910" (stretched-md5-hex "abc" 0 1)))
  (is (equal "16062ce768787384c81fe17a7a60c7e3" (stretched-md5-hex "abc" 0 2))))

(test stretched-md5-hex-2016-rounds
  (is (equal "a107ff634856bb300138cac6568c0f24" (stretched-md5-hex "abc" 0 2016))))
