;;;; Utilities for MD5 hash puzzles, using ironclad.

(uiop:define-package :challenge-utilities/md5
  (:use :cl)
  (:import-from :ironclad)
  (:export #:find-md5-prefix
           #:md5-hex
           #:stretched-md5-hex))

(in-package :challenge-utilities/md5)

(defun leading-zeros-p (digest zeros)
  "Return true if the hex form of DIGEST (a byte vector) starts with ZEROS
zero digits. Each byte is two hex digits, so this checks the bytes directly
instead of building a hex string."
  (declare (type (simple-array (unsigned-byte 8) (16)) digest)
           (type fixnum zeros)
           (optimize (speed 3) (safety 0)))
  (multiple-value-bind (whole-bytes half-byte) (floor zeros 2)
    (and (loop for i below whole-bytes always (zerop (aref digest i)))
         (or (zerop half-byte)
             (< (aref digest whole-bytes) 16)))))

(declaim (inline write-int-to-bytes))
(defun write-int-to-bytes (n buffer)
  "Writes the decimal digits of integer N backwards into the end of BUFFER.
Returns the index where the digits start."
  (declare (type fixnum n)
           (type (simple-array (unsigned-byte 8) (*)) buffer)
           (optimize (speed 3) (safety 0)))
  (let ((idx (length buffer))
        (val n))
    (declare (type fixnum idx val))
    (loop
      (multiple-value-bind (q r) (truncate val 10)
        (decf idx)
        (setf (aref buffer idx) (+ 48 r))
        (setf val q)
        (when (zerop val)
          (return idx))))))

(defun write-hex (digest hex)
  "Write the lowercase hex digits of DIGEST (16 bytes) into HEX (32 bytes) as
ASCII codes, so HEX can be hashed again without building a string. Return HEX."
  (declare (type (simple-array (unsigned-byte 8) (16)) digest)
           (type (simple-array (unsigned-byte 8) (32)) hex)
           (optimize (speed 3) (safety 0)))
  (let ((digits (load-time-value
                 (map '(simple-array (unsigned-byte 8) (16)) #'char-code "0123456789abcdef")
                 t)))
    (declare (type (simple-array (unsigned-byte 8) (16)) digits))
    (dotimes (i 16 hex)
      (let ((byte (aref digest i)))
        (setf (aref hex (* 2 i)) (aref digits (ash byte -4))
              (aref hex (1+ (* 2 i))) (aref digits (logand byte 15)))))))

(defun key-with-number (key n)
  "Return the bytes of KEY followed by the decimal digits of N."
  (let* ((num-buffer (make-array 20 :element-type '(unsigned-byte 8)))
         (start-idx (write-int-to-bytes n num-buffer)))
    (concatenate '(simple-array (unsigned-byte 8) (*))
                 (ironclad:ascii-string-to-byte-array key)
                 (subseq num-buffer start-idx))))

;; Public interface

(defun find-md5-prefix (key zeros &key (start 0))
  "Return the lowest integer N >= START such that the MD5 hash of KEY followed
by N in decimal starts with ZEROS zero hex digits. The hash, as a lowercase
hex string, is returned as a second value.

Call again with :START (1+ N) to find the next match."
  (let* ((digester (ironclad:make-digest :md5))
         (key-bytes (ironclad:ascii-string-to-byte-array key))
         (key-len (length key-bytes))
         (digest-result (make-array 16 :element-type '(unsigned-byte 8)))
         (num-buffer (make-array 20 :element-type '(unsigned-byte 8))))
    (loop for n from start
          do (let* ((start-idx (write-int-to-bytes n num-buffer))
                    (num-len (- 20 start-idx))
                    ;; 1. Pre-allocate a temporary array combining key and suffix
                    (combined-buffer (make-array (+ key-len num-len) :element-type '(unsigned-byte 8))))

               ;; 2. Fill the workspace vector without allocation strings or parsing streams
               (replace combined-buffer key-bytes :end1 key-len)
               (replace combined-buffer num-buffer :start1 key-len :start2 start-idx)

               ;; 3. Reset the digester: digest-sequence adds to its existing state
               (reinitialize-instance digester)
               (ironclad:digest-sequence digester combined-buffer :digest digest-result)

               (when (leading-zeros-p digest-result zeros)
                 (return (values n (ironclad:byte-array-to-hex-string digest-result))))))))

(defun stretched-md5-hex (key n rounds)
  "Return the MD5 hash of KEY followed by N in decimal, as a lowercase hex
string, hashed ROUNDS more times: each round hashes the previous round's hex
string. With ROUNDS 0 this is the plain hash.

The rounds reuse the same buffers and only the final hash is made into a
string, so stretching doesn't allocate."
  (let ((digester (ironclad:make-digest :md5))
        (digest (make-array 16 :element-type '(unsigned-byte 8)))
        (hex (make-array 32 :element-type '(unsigned-byte 8))))
    (ironclad:digest-sequence digester (key-with-number key n) :digest digest)
    (write-hex digest hex)
    (loop repeat rounds
          do (reinitialize-instance digester)
             (ironclad:digest-sequence digester hex :digest digest)
             (write-hex digest hex))
    (map 'string #'code-char hex)))

(defun md5-hex (key n)
  "Return the MD5 hash of KEY followed by N in decimal, as a lowercase hex
string."
  (stretched-md5-hex key n 0))
