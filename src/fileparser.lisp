(defpackage fileparser
  (:use :cl)
  (:export :parse-commands
           :parse-settings
           :setting
           :*settings*))

(in-package :fileparser)

(defparameter *settings* nil)

(defun parse-commands (file name)
  (let ((commands nil)
        (finded nil))
    (with-open-file (stream file)
      (loop for line = (read-line stream nil)
            while line
            when (and finded (equal line ""))
              return commands
            when finded              
              do (push line commands)
            when (equal line name)
              do (setf finded t)))
    (reverse commands)))

(defun setting (name)
  (cdr (assoc name *settings*)))

(defun parse-settings (file)
  (with-open-file (stream file)
    (loop with regexp=nil
          for line = (read-line stream nil)
          while line
          do (setf regexp (nth-value 1 (cl-ppcre:scan-to-strings "(.*)=(.*)" line)))
          do (push (cons (intern (elt regexp 0))
                         (elt regexp 1))
                   *settings*))))
