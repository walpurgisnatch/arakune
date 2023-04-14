(defsystem "fileparser"
  :version "0.1.0"
  :author "Walpurgisnatch"
  :license "MIT"
  :depends-on ("cl-ppcre")
  :components ((:module "src"
                :components
                ((:file "fileparser"))))
  :description "Text file parser")
