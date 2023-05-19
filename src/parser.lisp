(defpackage arakune
  (:use :cl :arakune.utils)
  (:export :parse-block
           :parse-settings))

(in-package :arakune)

(defun parse-block (file start &optional (end ""))
  (let ((commands nil)
        (finded nil))
    (with-open-file (stream file)
      (loop for line = (read-line stream nil)
            while line
            when (and finded (equal line end))
              return commands
            when finded              
              do (push line commands)
            when (equal line start)
              do (setf finded t)))
    (reverse commands)))


(defun parse-settings (file)
  (let ((settings nil))
    (with-open-file (stream file)
      (loop with regexp=nil
            for line = (read-line stream nil)
            while line
            do (setf regexp (nth-value 1 (cl-ppcre:scan-to-strings "(.*)=(.*)" line)))
            do (push (cons (intern (elt regexp 0))
                           (elt regexp 1))
                     settings)))
    settings))

