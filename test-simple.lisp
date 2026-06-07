(in-package #:cl-user)

(eval-when (:load-toplevel :execute)
  (asdf:load-system :xlunit)
  (asdf:load-system :cl-feiertage))

(defpackage #:test-simple
  (:use #:cl #:xlunit #:cl-feiertage))

(in-package #:test-simple)

(defun format-date (feiertag)
  "Format a feiertag date as DD.MM.YYYY string."
  (format nil "~2,'0D.~2,'0D.~4,'0D"
          (local-time:timestamp-day (feiertag-date feiertag))
          (local-time:timestamp-month (feiertag-date feiertag))
          (local-time:timestamp-year (feiertag-date feiertag))))

(defclass simple-test (test-case) () )

(def-test-method test-1 ((test simple-test) :run nil)
  (assert-equal "05.04.2015" (format-date (ostern 2015))))

(def-test-method test-2 ((test simple-test) :run nil)
  (assert-equal "27.03.2016" (format-date (ostern 2016))))
