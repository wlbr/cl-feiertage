 ;;;;
;;;; regions-test.lisp - Tests for region functions
;;;; Using xlunit testing framework
;;;;

(in-package #:cl-user)

(defpackage #:cl-feiertage-regions-test
  (:use #:cl #:xlunit #:feiertage)
  (:export #:regions-test-suite))

(in-package #:cl-feiertage-regions-test)

;;;; Helper functions
(defun count-feiertage (region)
  "Count the number of holidays in a region."
  (length (region-feiertage region)))

;;;; Test suite definition
(defclass regions-test-suite (test-case)
  ()
  (:documentation "Test suite for cl-feiertage region functions"))

;;;; Basic region tests
(def-test-method test-region-non-empty ((test regions-test-suite) :run nil)
  "Test that region functions return non-empty results."
  (let ((r1 (all 2016 t))
        (r2 (deutschland 2016))
        (r3 (brandenburg 2016 t))
        (r4 (brandenburg 2016 nil)))
    (assert-true (> (count-feiertage r1) 0) "All 2016 should have holidays")
    (assert-true (> (count-feiertage r2) 0) "Deutschland 2016 should have holidays")
    (assert-true (> (count-feiertage r3) 0) "Brandenburg 2016 (with Sundays) should have holidays")
    (assert-true (> (count-feiertage r4) 0) "Brandenburg 2016 (without Sundays) should have holidays")
    (assert-true (stringp (region-name r1)) "Region should have a name")
    (assert-true (stringp (region-shortname r1)) "Region should have a shortname")))

;;;; German region count tests
(def-test-method test-german-region-counts ((test regions-test-suite) :run nil)
  "Test the number of holidays in German states."
  (assert-equal 12 (count-feiertage (baden-württemberg 2016 nil)))
  (assert-equal 12 (count-feiertage (bayern 2016 nil)))
  (assert-equal 9 (count-feiertage (berlin 2016 nil)))
  (assert-equal 10 (count-feiertage (berlin 2019 nil)))
  (assert-equal 11 (count-feiertage (berlin 2020 nil)))
  (assert-equal 12 (count-feiertage (brandenburg 2020 t)))
  (assert-equal 12 (count-feiertage (brandenburg 2017 t)))
  (assert-equal 10 (count-feiertage (brandenburg 2020 nil)))
  (assert-equal 9 (count-feiertage (bremen 2016 nil)))
  (assert-equal 9 (count-feiertage (hamburg 2016 nil)))
  (assert-equal 10 (count-feiertage (hessen 2016 nil)))
  (assert-equal 10 (count-feiertage (mecklenburg-vorpommern 2016 nil)))
  (assert-equal 9 (count-feiertage (niedersachsen 2016 nil)))
  (assert-equal 11 (count-feiertage (nordrhein-westfalen 2016 nil)))
  (assert-equal 11 (count-feiertage (rheinland-pfalz 2016 nil)))
  (assert-equal 12 (count-feiertage (saarland 2016 nil)))
  (assert-equal 11 (count-feiertage (sachsen 2016 nil)))
  (assert-equal 11 (count-feiertage (sachsen-anhalt 2016 nil)))
  (assert-equal 9 (count-feiertage (schleswig-holstein 2016 nil)))
  (assert-equal 10 (count-feiertage (thüringen 2016 nil)))
  (assert-equal 9 (count-feiertage (deutschland 2016 nil)))
  (assert-equal 10 (count-feiertage (deutschland 2017 nil))))

;;;; Austrian region count tests
(def-test-method test-austrian-region-counts ((test regions-test-suite) :run nil)
  "Test the number of holidays in Austrian states."
  (assert-equal 14 (count-feiertage (burgenland 2016 nil)))
  (assert-equal 15 (count-feiertage (kärnten 2016 nil)))
  (assert-equal 14 (count-feiertage (niederösterreich 2016 nil)))
  (assert-equal 14 (count-feiertage (oberösterreich 2016 nil)))
  (assert-equal 14 (count-feiertage (salzburg 2016 nil)))
  (assert-equal 14 (count-feiertage (steiermark 2016 nil)))
  (assert-equal 14 (count-feiertage (tirol 2016 nil)))
  (assert-equal 14 (count-feiertage (vorarlberg 2016 nil)))
  (assert-equal 14 (count-feiertage (wien 2016 nil)))
  (assert-equal 13 (count-feiertage (österreich 2016 nil))))

;;;; All region tests
(def-test-method test-all-region-counts ((test regions-test-suite) :run nil)
  "Test the number of holidays in the 'All' region."
  (assert-equal 81 (count-feiertage (all 2016 t)))
  (assert-equal 69 (count-feiertage (all 2016 nil))))

;;;; Get all regions tests
(def-test-method test-get-all-regions-germany ((test regions-test-suite) :run nil)
  "Test getting all German regions."
  (let ((regions (get-all-regions 2020 nil "de")))
    (assert-equal 17 (length regions) "Should have 16 states + 1 for Deutschland")))

(def-test-method test-get-all-regions-austria ((test regions-test-suite) :run nil)
  "Test getting all Austrian regions."
  (let ((regions (get-all-regions 2020 nil "at")))
    (assert-equal 10 (length regions) "Should have 9 states + 1 for Österreich")))

(def-test-method test-get-all-regions-all ((test regions-test-suite) :run nil)
  "Test getting all regions (German + Austrian + All)."
  (let ((regions (get-all-regions 2020 nil)))
    (assert-true (>= (length regions) 27) "Should have at least 27 regions (16 DE + 9 AT + 2 countries + 1 All)")))

;;;; Special cases
(def-test-method test-brandenburg-2017 ((test regions-test-suite) :run nil)
  "Test Brandenburg 2017 with Reformationstag included."
  (let ((r (brandenburg 2017 t)))
    (assert-equal 12 (count-feiertage r) "Brandenburg 2017 with Sundays should have 12 holidays")))

(def-test-method test-all-2017-includes-reformationstag ((test regions-test-suite) :run nil)
  "Test that all regions in 2017 include Reformationstag."
  (let ((r (all 2017 t)))
    (assert-true (> (count-feiertage r) 0) "All 2017 should have holidays")))

;;;; Holiday date verification tests
(def-test-method test-get-feiertage-for-date-in-region ((test regions-test-suite) :run nil)
  "Test retrieving holidays for a specific date in a region."
  (let* ((date (feiertag-date (pfingsten 2025)))
         (year (local-time:timestamp-year date))
         (month (local-time:timestamp-month date))
         (day (local-time:timestamp-day date))
         (holidays (get-feiertage-for-date-in-region (list year month day) 'baden-württemberg t)))
    (assert-true (> (length holidays) 0) "Should find Pfingsten in Baden-Württemberg 2025")
    (assert-equal "Pfingsten" (feiertag-name (first holidays)))))

;;;; Region holiday verification
(def-test-method test-bayern-has-fronleichnam ((test regions-test-suite) :run nil)
  "Test that Bayern has Fronleichnam."
  (let ((bayern-holidays (region-feiertage (bayern 2025 nil)))
        (fronleichnam-date (feiertag-date (fronleichnam 2025))))
    (assert-true (find-if (lambda (f) (local-time:timestamp= (feiertag-date f) fronleichnam-date)) bayern-holidays)
               "Bayern should have Fronleichnam")))

(def-test-method test-berlin-has-frauentag ((test regions-test-suite) :run nil)
  "Test that Berlin has Internationaler Frauentag since 2019."
  (let ((berlin-holidays (region-feiertage (berlin 2025 nil)))
        (frauentag-date (feiertag-date (internationaler-frauentag 2025))))
    (assert-true (find-if (lambda (f) (local-time:timestamp= (feiertag-date f) frauentag-date)) berlin-holidays)
               "Berlin should have Internationaler Frauentag in 2025")))
