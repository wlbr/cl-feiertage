;;;;
;;;; cl-feiertage.asd - ASDF system definition for cl-feiertage
;;;; Common Lisp library for calculating German and Austrian bank holidays
;;;;

(asdf:defsystem "feiertage"
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



(asdf:defsystem "feiertage/test"
  :description "Tests for cl-feiertage library"
  :author "Michael Wolber"
  :license "MIT"
  :version "1.0.0"
  :serial t
  :components ((:file "feiertage-test")
               (:file "regions-test")
               (:file "special-test"))
  :depends-on ("feiertage"
               #:xlunit)
  :perform (asdf:test-op (op c)
                   (format t "Running cl-feiertage tests...~%")
                   (let ((textui-test-run (find-symbol "TEXTUI-TEST-RUN" :xlunit))
                         (get-suite (find-symbol "GET-SUITE" :xlunit)))
                     (funcall textui-test-run
                              (funcall get-suite (find-symbol "FEIERTAGE-TEST-SUITE" :feiertage-test)))
                     (funcall textui-test-run
                              (funcall get-suite (find-symbol "REGIONS-TEST-SUITE" :cl-feiertage-regions-test)))
                     (funcall textui-test-run
                              (funcall get-suite (find-symbol "SPECIAL-TEST-SUITE" :cl-feiertage-special-test))))
                   (format t "~%All tests completed.~%")))
