(defun cube_root()
  (let ((num 0)
        (precision 0))
    (progn
      (multiple-value-bind (a b) (read_input)
        (setf num a)
        (setf precision b))
      (if (>= (abs num) 1)
          (let* ((low 0)
                 (high num)
                 (oldmid num)
                 (mid (/ (+ low high) 2)))
            (compute (list num precision low high oldmid mid)))
          (if (> num 0)
              (let* ((low num)
                     (high 1)
                     (oldmid num)
                     (mid (/ (+ low high) 2)))
                (compute (list num precision low high oldmid mid)))
              (let* ((low num)
                     (high -1)
                     (oldmid num)
                     (mid (/ (+ low high) 2)))
                (compute (list num precision low high oldmid mid))))))))

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

(defun compute (lst)
  (do ((num (nth 0 lst))
       (precision (nth 1 lst))
       (low (nth 2 lst))
       (high (nth 3 lst))
       (oldmid (nth 4 lst))
       (mid (nth 5 lst))
       (midcube))
      (nil)
    (if (> (abs (- oldmid mid)) precision)
        (progn
          (setf midcube (* mid mid mid))
          (if (> num 0)
              (if (> midcube num)
                  (setf high mid)
                  (setf low mid))
              (if (> midcube num)
                  (setf low mid)
                  (setf high mid)))
          (setf oldmid mid)
          (setf mid (/ (+ low high) 2))
          (format t "~5,10f~%" mid))
        (return 'done))))
