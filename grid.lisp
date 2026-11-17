;;;; A grid of cells: a 2D array indexed by row then column.

(uiop:define-package :challenge-utilities/grid
  (:use :cl)
  (:export #:make-grid
           #:make-grid-xy
           #:lines-to-grid
           #:grid-rows
           #:grid-cols
           #:copy-grid
           #:neighbours
           #:cell-neighbours
           #:cell-value
           #:cells-matching
           #:print-grid))

(in-package :challenge-utilities/grid)

(defun make-grid (rows cols &key initial-element initial-function)
  "Return a grid of ROWS by COLS cells: a 2D array indexed by row then column,
so (AREF GRID ROW COL) reads a cell and SETF of it writes one. Each cell is
INITIAL-ELEMENT or, if INITIAL-FUNCTION is given, the result of calling it
with the cell's row and column."
  (let ((grid (make-array (list rows cols) :initial-element initial-element)))
    (when initial-function
      (dotimes (row rows)
        (dotimes (col cols)
          (setf (aref grid row col) (funcall initial-function row col)))))
    grid))

(defun make-grid-xy (width height &key initial-element initial-function)
  "Return a grid of WIDTH columns by HEIGHT rows, for puzzles that give
positions as X (the column) and Y (the row), so the cell at X, Y is
(AREF GRID Y X). INITIAL-FUNCTION, if given, is called with each cell's X and
Y."
  (make-grid height width
             :initial-element initial-element
             :initial-function (and initial-function
                                    (lambda (row col)
                                      (funcall initial-function col row)))))

(defun lines-to-grid (lines &optional (cell-function #'identity))
  "Return a grid with a row for each string in the sequence LINES and a column
for each of its characters. CELL-FUNCTION is called with each character and
returns the cell's value; the default keeps the characters. The lines must all
be the same length."
  (let ((lines (coerce lines 'vector)))
    (make-grid (length lines)
               (if (plusp (length lines)) (length (aref lines 0)) 0)
               :initial-function (lambda (row col)
                                   (funcall cell-function
                                            (char (aref lines row) col))))))

(defun grid-rows (grid)
  "Return the number of rows of GRID."
  (array-dimension grid 0))

(defun grid-cols (grid)
  "Return the number of columns of GRID."
  (array-dimension grid 1))

(defun copy-grid (grid)
  "Return a new grid the same size as GRID with the same value in each cell,
so setting a cell in one doesn't change the other. The values themselves
aren't copied: a cell holding a list or a structure shares it with GRID."
  (make-grid (grid-rows grid) (grid-cols grid)
             :initial-function (lambda (row col) (aref grid row col))))

(defparameter *orthogonal* '((-1 . 0) (1 . 0) (0 . -1) (0 . 1))
  "Row and column offsets of the cells up, down, left and right of a cell.")

(defparameter *diagonal* '((-1 . -1) (-1 . 1) (1 . -1) (1 . 1))
  "Row and column offsets of the cells diagonally next to a cell.")

(defun neighbours (grid row col &key diagonals)
  "Return the cells next to ROW and COL that are inside GRID, as a list of
(ROW . COL) conses: up, down, left and right, then the four diagonal cells as
well if DIAGONALS is true."
  (loop for (dr . dc) in (if diagonals
                             (append *orthogonal* *diagonal*)
                             *orthogonal*)
        for r = (+ row dr)
        for c = (+ col dc)
        when (array-in-bounds-p grid r c)
          collect (cons r c)))

(defun cell-neighbours (grid cell &key diagonals)
  "Return the neighbours of CELL, a (ROW . COL) cons such as CELLS-MATCHING
returns, in the same way as NEIGHBOURS."
  (neighbours grid (car cell) (cdr cell) :diagonals diagonals))

(defun cell-value (grid cell)
  "Return the value in GRID at CELL, a (ROW . COL) cons. SETF of it writes the
value."
  (aref grid (car cell) (cdr cell)))

(defun (setf cell-value) (value grid cell)
  (setf (aref grid (car cell) (cdr cell)) value))

(defun cells-matching (grid predicate)
  "Return a list of the (ROW . COL) conses of the cells in GRID whose value satisfies
PREDICATE."
  (loop for row below (grid-rows grid)
        nconc (loop for col below (grid-cols grid)
                    when (funcall predicate (aref grid row col))
                      collect (cons row col))))

(defun print-grid (grid &optional (cell-char #'identity)
                          (stream *standard-output*))
  "Draw GRID on STREAM, one row per line. CELL-CHAR is called with the value of
each cell and returns the character to draw; the default draws a grid of
characters as it is."
  (dotimes (row (grid-rows grid))
    (dotimes (col (grid-cols grid))
      (write-char (funcall cell-char (aref grid row col)) stream))
    (terpri stream)))
