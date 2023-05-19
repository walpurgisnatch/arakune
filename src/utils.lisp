(defpackage arakune.utils
  (:use :cl)
  (:import-from :cl-ppcre
                :scan-to-strings)
  (:export :substp
           :regex-groups
           :split-by-two
           :count-indent))

(in-package :arakune.utils)

(defun component-present-p (value)
  (and value (not (eql value :unspecific))))

(defun directory-pathname-p  (p)
  (and
   (not (component-present-p (pathname-name p)))
   (not (component-present-p (pathname-type p)))
   p))

(defun pathname-as-directory (name)
  (let ((pathname (pathname name)))
    (when (wild-pathname-p pathname)
      (error "Can't reliably convert wild pathnames."))
    (if (not (directory-pathname-p name))
        (make-pathname
         :directory (append (or (pathname-directory pathname) (list :relative))
                            (list (file-namestring pathname)))
         :name      nil
         :type      nil
         :defaults pathname)
        pathname)))

(defun mkdir (dir &optional parent)
  (namestring (ensure-directories-exist
               (if parent
                   (merge-with-dir dir parent)
                   (pathname-as-directory dir)))))

(defun merge-with-dir (child parent)
  (merge-pathnames child (pathname-as-directory parent)))

(defun mklist (x)
  (if (listp x)
      x
      (list x)))


(defun substp (regex string)
  (scan-to-strings regex string))

(defun regexp-groups (regex string)
  (nth-value 1 (scan-to-strings regex string)))

(defun split-by-two (line splitter)
  (let* ((regex (format nil "(.*)~a(.*)" splitter))
         (groups (regexp-groups regex line)))
    (when groups
      (cons (elt groups 0) (elt groups 1)))))

(defun indent-split (line)
  (regexp-groups "^( *)(.*)" line))

(defun indent (line)
  (elt (indent-split line) 0))

(defun remove-indent (line)
  (elt (indent-split line) 1))

(defun count-indent (line &optional (indent 1))
  (let* ((result (indent line))
         (count (/ (length result) indent)))
    (if (> count 0)
        count
        nil)))
