(defun cube_root()
  (let ((num 0)
        (precision))
    (progn
      (multiple-value-bind (a b) (read_input)
        (setf num a)
        (setf precision b))
      (compute num precision))))

(defun read_input()
  (progn
    (format t "Please enter a number: ")
    (let ((num_in (read)))
      (if (numberp num_in)
          (progn
            (format t "Please enter precision:")
            (let ((precision_in (read)))
              (if (floatp precision_in)
                  (values num_in precision_in)
                  (read_input))))
          (read_input)))))

(defun compute (num precision)
  (catch 'abort
    (let ((oldxn 0))
      (labels ((rec (xn)
                 (if (< (abs (- xn oldxn)) precision)
                     (throw 'abort 'done)
                     (progn
                       (setf oldxn xn)
                       (format t "~5,10f~%" oldxn)
                       (rec (- xn (/ (- (* xn xn xn) num)
                                     (* (* xn xn) 3))))))))
        (rec 1)))))
(defun cube_root()
  (let ((num 0)
        (precision))
    (progn
      (multiple-value-bind (a b) (read_input)
        (setf num a)
        (setf precision b))
      (compute num precision))))

(defun read_input()
  (progn
    (format t "Please enter a number: ")
    (let ((num_in (read)))
      (if (numberp num_in)
          (progn
            (format t "Please enter precision:")
            (let ((precision_in (read)))
              (if (floatp precision_in)
                  (values num_in precision_in)
                  (read_input))))
          (read_input)))))

(defun compute (num precision)
  (catch 'abort
    (let ((oldxn 0))
      (labels ((rec (xn)
                 (if (< (abs (- xn oldxn)) precision)
                     (throw 'abort 'done)
                     (progn
                       (setf oldxn xn)
                       (format t "~5,10f~%" oldxn)
                       (rec (- xn (/ (- (* xn xn xn) num)
                                     (* (* xn xn) 3))))))))
        (rec 50)))))
