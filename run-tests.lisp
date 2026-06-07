(load "feiertage.asd")
(asdf:load-system :feiertage)
(asdf:load-system :xlunit)
(asdf:load-system :cl-feiertage-tests)

(format t "~%Running feiertage tests...~%")
(xlunit:textui-test-run (make-instance 'feiertage-test:feiertage-test-suite))

(format t "~%Running regions tests...~%")
(xlunit:textui-test-run (make-instance 'feiertage-regions-test:regions-test-suite))

(format t "~%Running special tests...~%")
(xlunit:textui-test-run (make-instance 'feiertage-special-test:special-test-suite))

(format t "~%All tests completed.~%"
)
