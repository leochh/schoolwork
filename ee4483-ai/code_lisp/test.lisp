(defun super()
  (catch 'abort
    (sub)
    (format t "No Display")))

(defun sub ()
  (throw 'abort (subb)))

(defun subb ()
  (format t "Sub display"))
