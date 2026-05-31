;;;;
;;;; cl-feiertage.asd - ASDF system definition for cl-feiertage
;;;; Common Lisp library for calculating German and Austrian bank holidays
;;;;

(asdf:defsystem "cl-feiertage"
  :description "Common Lisp library for calculating German and Austrian bank holidays"
  :author "Michael Wolber"
  :license "MIT"
  :version "1.0.0"
  :serial t
  :components ((:file "package")
               (:file "feiertage")
               (:file "special")
               (:file "regions"))
  :depends-on (#:alexandria
               #:local-time))
