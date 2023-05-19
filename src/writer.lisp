(in-package :cl-user)
(defpackage :arakune.writer
  (:use :cl)
  (:import-from :arakune.utils
                :mkdir
                :merge-with-dir
                :mklist)
  (:import-from :arakune.templates
                :current-time
                :basic)
  (:export :logger-setup
           :create-template
           :current-time
           :write-log
           :write-line-to
           :write-hashtable-to
           :write-hashvalues-to
           :write-list-to))

(in-package :arakune.writer)

(defvar *dir* nil)
(defvar *log-templates* nil)

(defun add-template (log template file)
  (push (list log template file) *log-templates*))

(defun template-path (log)
  (nth 2 (assoc log *log-templates*)))

(defun template-string (template)
  (nth 1 (assoc template *log-templates*)))

(defun logger-setup (dir &key template)
  (declare (type simple-string dir))
  (setf *dir* (mkdir dir))
  (when template
    (create-template (basic))))

(defun create-template (&rest templates)
  (if (consp (car templates))
      (parse-template (car templates))
      (parse-template templates)))

(defun parse-template (templates)
  (let ((template-path (merge-with-dir (car templates) *dir*)))
    (loop for template in (cdr templates) do
      (progn 
        (add-template (car template) (cadr template) template-path)))))

(defun create-message (template args)
  (let ((message (template-string template)))
    (if args
        (format nil (concatenate 'string "~{" message "~}") args)
        message)))

(defun write-log (template &rest args)
  (let ((pathname (template-path template))
        (message (create-message template args)))
    (write-line-to pathname (format nil "~&[~a] ~a" (current-time) message))))

(defun write-line-to (file line)
  (with-open-file (stream file :direction :output :if-exists :append :if-does-not-exist :create)
    (write-line line stream)))

(defun write-hashtable-to (file table &optional (format-string "~&~a: ~a"))
  (declare (optimize (speed 3) (safety 2)))
  (with-open-file (output file :direction :output :if-exists if-exists :if-does-not-exist :create)
    (maphash #'(lambda (key value) (write-line (format nil format-string key value) output)) hashtable)))

(defun write-hashvalues-to (file table &optional (format-string "~&~a"))
  (declare (optimize (speed 3) (safety 2)))
  (with-open-file (output file :direction :output :if-exists if-exists :if-does-not-exist :create)
    (maphash #'(lambda (key value) (declare (ignorable key))
                 (write-line (format nil format-string value) output))
             table)))

(defun write-list-to (file list &optional (format-string "~&~a"))
  (declare (optimize (speed 3) (safety 2)))
  (with-open-file (output file :direction :output :if-exists if-exists :if-does-not-exist :create)
    (loop for item in list do
      (write-line (format nil format-string item) output))))
    
