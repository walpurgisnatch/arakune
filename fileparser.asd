(defsystem "fileparser"
  :version "0.1.0"
  :author "Walpurgisnatch"
  :license "MIT"
  :depends-on ("cl-ppcre")
  :components ((:module "src"
                :components
                ((:file "utils")
                 (:file "writer" :depends-on ("utils"))
                 (:file "parser" :depends-on ("parser"))
                 (:file "fileparser" :depends-on ("writer"))))
  :description "Text file parser")
