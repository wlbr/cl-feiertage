 ;;;;
;;;; feiertage-test.lisp - Tests for holiday calculation functions
;;;; Using xlunit testing framework
;;;;

(in-package #:cl-user)

(defpackage #:feiertage-test
  (:use #:cl #:xlunit #:feiertage)
  (:export #:feiertage-test-suite))

(in-package #:feiertage-test)

;;;; Helper function for formatting dates
(defun format-date (feiertag)
  "Format a feiertag date as DD.MM.YYYY string."
  (format nil "~2,'0D.~2,'0D.~4,'0D"
          (local-time:timestamp-day (feiertag-date feiertag))
          (local-time:timestamp-month (feiertag-date feiertag))
          (local-time:timestamp-year (feiertag-date feiertag))))

;;;; Test suite definition
(defclass feiertage-test-suite (test-case)
  ()
  (:documentation "Test suite for cl-feiertage holiday calculations"))

;;;; Easter calculation tests
(def-test-method test-ostern ((test feiertage-test-suite) :run nil)
  "Test Easter Sunday calculation for various years."
  (assert-equal "05.04.2015" (format-date (ostern 2015)))
  (assert-equal "27.03.2016" (format-date (ostern 2016)))
  (assert-equal "18.04.1954" (format-date (ostern 1954)))
  (assert-equal "19.04.1981" (format-date (ostern 1981))))

(def-test-method test-karfreitag ((test feiertage-test-suite) :run nil)
  "Test Good Friday calculation."
  (assert-equal "03.04.2015" (format-date (karfreitag 2015)))
  (assert-equal "25.03.2016" (format-date (karfreitag 2016))))

(def-test-method test-ostermontag ((test feiertage-test-suite) :run nil)
  "Test Easter Monday calculation."
  (assert-equal "06.04.2015" (format-date (ostermontag 2015)))
  (assert-equal "28.03.2016" (format-date (ostermontag 2016))))

(def-test-method test-christi-himmelfahrt ((test feiertage-test-suite) :run nil)
  "Test Ascension Day (39 days after Easter)."
  (assert-equal "14.05.2015" (format-date (christi-himmelfahrt 2015)))
  (assert-equal "05.05.2016" (format-date (christi-himmelfahrt 2016))))

(def-test-method test-pfingsten ((test feiertage-test-suite) :run nil)
  "Test Pentecost (49 days after Easter)."
  (assert-equal "24.05.2015" (format-date (pfingsten 2015)))
  (assert-equal "15.05.2016" (format-date (pfingsten 2016))))

(def-test-method test-pfingstmontag ((test feiertage-test-suite) :run nil)
  "Test Whit Monday (50 days after Easter)."
  (assert-equal "25.05.2015" (format-date (pfingstmontag 2015)))
  (assert-equal "16.05.2016" (format-date (pfingstmontag 2016))))

(def-test-method test-fronleichnam ((test feiertage-test-suite) :run nil)
  "Test Corpus Christi (60 days after Easter)."
  (assert-equal "04.06.2015" (format-date (fronleichnam 2015)))
  (assert-equal "26.05.2016" (format-date (fronleichnam 2016))))

(def-test-method test-dreifaltigkeitssonntag ((test feiertage-test-suite) :run nil)
  "Test Trinity Sunday (56 days after Easter)."
  (assert-equal "31.05.2015" (format-date (dreifaltigkeitssonntag 2015)))
  (assert-equal "22.05.2016" (format-date (dreifaltigkeitssonntag 2016))))

;;;; Daylight saving time tests
(def-test-method test-beginn-sommerzeit ((test feiertage-test-suite) :run nil)
  "Test start of daylight saving time (last Sunday in March)."
  (assert-equal "29.03.2015" (format-date (beginn-sommerzeit 2015)))
  (assert-equal "27.03.2016" (format-date (beginn-sommerzeit 2016))))

(def-test-method test-beginn-winterzeit ((test feiertage-test-suite) :run nil)
  "Test end of daylight saving time (last Sunday in October)."
  (assert-equal "25.10.2015" (format-date (beginn-winterzeit 2015)))
  (assert-equal "30.10.2016" (format-date (beginn-winterzeit 2016))))

;;;; Buß- und Bettag tests
(def-test-method test-buß-und-bettag ((test feiertage-test-suite) :run nil)
  "Test Penance Day calculation."
  (assert-equal "18.11.2015" (format-date (buß-und-bettag 2015)))
  (assert-equal "16.11.2016" (format-date (buß-und-bettag 2016))))

;;;; Advent tests
(def-test-method test-vierter-advent ((test feiertage-test-suite) :run nil)
  "Test fourth Sunday in Advent."
  (assert-equal "18.12.2016" (format-date (vierter-advent 2016)))
  (assert-equal "24.12.2006" (format-date (vierter-advent 2006))))

(def-test-method test-dritter-advent ((test feiertage-test-suite) :run nil)
  "Test third Sunday in Advent."
  (assert-equal "11.12.2016" (format-date (dritter-advent 2016))))

(def-test-method test-zweiter-advent ((test feiertage-test-suite) :run nil)
  "Test second Sunday in Advent."
  (assert-equal "04.12.2016" (format-date (zweiter-advent 2016))))

(def-test-method test-erster-advent ((test feiertage-test-suite) :run nil)
  "Test first Sunday in Advent."
  (assert-equal "27.11.2016" (format-date (erster-advent 2016))))

;;;; Thanksgiving tests
(def-test-method test-thanksgiving ((test feiertage-test-suite) :run nil)
  "Test US Thanksgiving (fourth Thursday in November)."
  (assert-equal "25.11.2010" (format-date (thanksgiving 2010)))
  (assert-equal "27.11.2014" (format-date (thanksgiving 2014)))
  (assert-equal "26.11.2015" (format-date (thanksgiving 2015)))
  (assert-equal "24.11.2016" (format-date (thanksgiving 2016))))

;;;; Forward-looking holidays tests
(def-test-method test-erntedankfest ((test feiertage-test-suite) :run nil)
  "Test Harvest Festival (first Sunday in October)."
  (assert-equal "04.10.2015" (format-date (erntedankfest 2015)))
  (assert-equal "02.10.2016" (format-date (erntedankfest 2016))))

(def-test-method test-muttertag ((test feiertage-test-suite) :run nil)
  "Test Mother's Day (second Sunday in May)."
  (assert-equal "10.05.2015" (format-date (muttertag 2015)))
  (assert-equal "08.05.2016" (format-date (muttertag 2016))))

;;;; Carnival holiday tests
(def-test-method test-carnival-holidays ((test feiertage-test-suite) :run nil)
  "Test carnival holidays relative to Easter."
  (assert-equal "12.02.2015" (format-date (weiberfastnacht 2015)))
  (assert-equal "04.02.2016" (format-date (weiberfastnacht 2016)))
  (assert-equal "15.02.2015" (format-date (karnevalssonntag 2015)))
  (assert-equal "07.02.2016" (format-date (karnevalssonntag 2016)))
  (assert-equal "16.02.2015" (format-date (rosenmontag 2015)))
  (assert-equal "08.02.2016" (format-date (rosenmontag 2016)))
  (assert-equal "17.02.2015" (format-date (fastnacht 2015)))
  (assert-equal "09.02.2016" (format-date (fastnacht 2016)))
  (assert-equal "18.02.2015" (format-date (aschermittwoch 2015)))
  (assert-equal "10.02.2016" (format-date (aschermittwoch 2016)))
  (assert-equal "29.03.2015" (format-date (palmsonntag 2015)))
  (assert-equal "20.03.2016" (format-date (palmsonntag 2016)))
  (assert-equal "02.04.2015" (format-date (gründonnerstag 2015)))
  (assert-equal "24.03.2016" (format-date (gründonnerstag 2016))))

;;;; Fixed date tests
(def-test-method test-fixed-dates ((test feiertage-test-suite) :run nil)
  "Test that fixed date holidays return the correct date."
  (assert-equal "01.01.2016" (format-date (neujahr 2016)))
  (assert-equal "06.01.2016" (format-date (epiphanias 2016)))
  (assert-equal "06.01.2016" (format-date (heilige-drei-könige 2016)))
  (assert-equal "14.02.2016" (format-date (valentinstag 2016)))
  (assert-equal "27.01.2016" (format-date (internationaler-tag-des-gedenkens-an-die-opfer-des-holocaust 2016)))
  (assert-equal "19.03.2016" (format-date (josefitag 2016)))
  (assert-equal "08.03.2016" (format-date (internationaler-frauentag 2016)))
  (assert-equal "01.05.2016" (format-date (tag-der-arbeit 2016)))
  (assert-equal "01.05.2016" (format-date (staatsfeiertag 2016)))
  (assert-equal "04.05.2016" (format-date (florianitag 2016)))
  (assert-equal "08.05.2016" (format-date (tag-der-befreiung 2016)))
  (assert-equal "15.08.2016" (format-date (mariä-himmelfahrt 2016)))
  (assert-equal "24.09.2016" (format-date (rupertitag 2016)))
  (assert-equal "03.10.2016" (format-date (tag-der-deutschen-einheit 2016)))
  (assert-equal "10.10.2016" (format-date (tag-der-volksabstimmung 2016)))
  (assert-equal "26.10.2016" (format-date (nationalfeiertag 2016)))
  (assert-equal "31.10.2016" (format-date (reformationstag 2016)))
  (assert-equal "01.11.2016" (format-date (allerheiligen 2016)))
  (assert-equal "11.11.2016" (format-date (martinstag 2016)))
  (assert-equal "15.11.2016" (format-date (leopolditag 2016)))
  (assert-equal "20.09.2016" (format-date (weltkindertag 2016)))
  (assert-equal "25.12.2016" (format-date (weihnachten 2016)))
  (assert-equal "25.12.2016" (format-date (christtag 2016)))
  (assert-equal "26.12.2016" (format-date (zweiter-weihnachtsfeiertag 2016)))
  (assert-equal "26.12.2016" (format-date (stefanitag 2016)))
  (assert-equal "08.12.2016" (format-date (mariä-unbefleckte-empfängnis 2016)))
  (assert-equal "08.12.2016" (format-date (mariä-empfängnis 2016)))
  (assert-equal "06.12.2016" (format-date (nikolaus 2016)))
  (assert-equal "24.12.2016" (format-date (heiligabend 2016)))
  (assert-equal "31.12.2016" (format-date (silvester 2016))))

