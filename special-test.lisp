 ;;;;
;;;; special-test.lisp - Tests for special.lisp functions
;;;; Using xlunit testing framework
;;;;

(in-package #:cl-user)
(print "special-test.lisp loaded")

(defpackage #:cl-feiertage-special-test
  (:use #:cl #:xlunit #:feiertage)
  (:export #:special-test-suite))

(in-package #:cl-feiertage-special-test)

;;;; Helper function for formatting dates
(defun format-date (feiertag)
  "Format a feiertag date as DD.MM.YYYY string."
  (format nil "~2,'0D.~2,'0D.~4,'0D"
          (local-time:timestamp-day (feiertag-date feiertag))
          (local-time:timestamp-month (feiertag-date feiertag))
          (local-time:timestamp-year (feiertag-date feiertag))))

;;;; Test suite definition
(defclass special-test-suite (test-case)
  ()
  (:documentation "Test suite for cl-feiertage special.lisp functions"))

;;;; Fixed date special holidays tests
(def-test-method test-weltknuddeltag ((test special-test-suite) :run nil)
  "Test World Hug Day - January 21st."
  (assert-equal "21.01.2025" (format-date (weltknuddeltag 2025))))

(def-test-method test-star-wars-day ((test special-test-suite) :run nil)
  "Test Star Wars Day - May 4th."
  (assert-equal "04.05.2025" (format-date (star-wars-day 2025))))

(def-test-method test-handtuchtag ((test special-test-suite) :run nil)
  "Test Towel Day - May 25th."
  (assert-equal "25.05.2025" (format-date (handtuchtag 2025))))

(def-test-method test-towel-day ((test special-test-suite) :run nil)
  "Test Towel Day (English name) - May 25th."
  (assert-equal "25.05.2025" (format-date (towel-day 2025))))

(def-test-method test-weltumwelttag ((test special-test-suite) :run nil)
  "Test World Environment Day - June 5th."
  (assert-equal "05.06.2025" (format-date (weltumwelttag 2025))))

(def-test-method test-weltspieltag ((test special-test-suite) :run nil)
  "Test International Day of Play - June 11th."
  (assert-equal "11.06.2025" (format-date (weltspieltag 2025))))

(def-test-method test-weltblutspendetag ((test special-test-suite) :run nil)
  "Test World Blood Donor Day - June 14th."
  (assert-equal "14.06.2025" (format-date (weltblutspendetag 2025))))

(def-test-method test-fête-de-la-musique ((test special-test-suite) :run nil)
  "Test World Music Day - June 21st."
  (assert-equal "21.06.2025" (format-date (fête-de-la-musique 2025))))

(def-test-method test-internationaler-tag-gegen-drogenmissbrauch ((test special-test-suite) :run nil)
  "Test International Day Against Drug Abuse - June 26th."
  (assert-equal "26.06.2025" (format-date (internationaler-tag-gegen-drogenmissbrauch 2025))))

(def-test-method test-hobbit-day ((test special-test-suite) :run nil)
  "Test Hobbit Day - September 22nd."
  (assert-equal "22.09.2025" (format-date (hobbit-day 2025))))

(def-test-method test-internationaler-männertag ((test special-test-suite) :run nil)
  "Test International Men's Day - November 19th."
  (assert-equal "19.11.2025" (format-date (internationaler-männertag 2025))))

(def-test-method test-karnevalsbeginn ((test special-test-suite) :run nil)
  "Test beginning of carnival - November 11th."
  (assert-equal "11.11.2025" (format-date (karnevalsbeginn 2025))))

(def-test-method test-tag-des-meeres ((test special-test-suite) :run nil)
  "Test World Oceans Day - June 8th."
  (assert-equal "08.06.2025" (format-date (tag-des-meeres 2025))))

(def-test-method test-weltflüchtlingstag ((test special-test-suite) :run nil)
  "Test World Refugee Day - June 20th."
  (assert-equal "20.06.2025" (format-date (weltflüchtlingstag 2025))))

(def-test-method test-antikriegstag ((test special-test-suite) :run nil)
  "Test Anti-War Day - September 1st."
  (assert-equal "01.09.2025" (format-date (antikriegstag 2025))))

(def-test-method test-internationaler-tag-der-pressefreiheit ((test special-test-suite) :run nil)
  "Test World Press Freedom Day - May 3rd."
  (assert-equal "03.05.2025" (format-date (internationaler-tag-der-pressefreiheit 2025))))

(def-test-method test-tag-der-erde ((test special-test-suite) :run nil)
  "Test Earth Day - April 22nd."
  (assert-equal "22.04.2025" (format-date (tag-der-erde 2025))))

(def-test-method test-walpurgisnacht ((test special-test-suite) :run nil)
  "Test Walpurgis Night - April 30th."
  (assert-equal "30.04.2025" (format-date (walpurgisnacht 2025))))

(def-test-method test-halloween ((test special-test-suite) :run nil)
  "Test Halloween - October 31st."
  (assert-equal "31.10.2025" (format-date (halloween 2025))))

(def-test-method test-allerseelen ((test special-test-suite) :run nil)
  "Test All Souls' Day - November 2nd."
  (assert-equal "02.11.2025" (format-date (allerseelen 2025))))

(def-test-method test-weltmännertag ((test special-test-suite) :run nil)
  "Test Men's World Day - November 3rd."
  (assert-equal "03.11.2025" (format-date (weltmännertag 2025))))

(def-test-method test-internationaler-kindertag ((test special-test-suite) :run nil)
  "Test International Children's Day - June 1st."
  (assert-equal "01.06.2025" (format-date (internationaler-kindertag 2025))))

;;;; Movable special dates tests
(def-test-method test-system-administrator-appreciation-day ((test special-test-suite) :run nil)
  "Test System Administrator Appreciation Day - last Friday in July."
  (assert-equal "25.07.2025" (format-date (system-administrator-appreciation-day 2025)))
  (assert-equal "31.07.2020" (format-date (system-administrator-appreciation-day 2020)))
  (assert-equal "26.07.2019" (format-date (system-administrator-appreciation-day 2019))))

(def-test-method test-thanksgiving ((test special-test-suite) :run nil)
  "Test US Thanksgiving - fourth Thursday of November."
  (assert-equal "27.11.2025" (format-date (thanksgiving 2025)))
  (assert-equal "28.11.2019" (format-date (thanksgiving 2019)))
  (assert-equal "22.11.2018" (format-date (thanksgiving 2018))))

(def-test-method test-blackfriday ((test special-test-suite) :run nil)
  "Test Black Friday - the Friday after Thanksgiving."
  (assert-equal "28.11.2025" (format-date (blackfriday 2025)))
  (assert-equal "29.11.2019" (format-date (blackfriday 2019)))
  (assert-equal "23.11.2018" (format-date (blackfriday 2018))))

;;;; Advent tests from special.lisp
(def-test-method test-erster-advent-special ((test special-test-suite) :run nil)
  "Test first Sunday in Advent from special.lisp."
  (assert-equal "30.11.2025" (format-date (erster-advent 2025)))
  (assert-equal "27.11.2016" (format-date (erster-advent 2016))))

(def-test-method test-zweiter-advent-special ((test special-test-suite) :run nil)
  "Test second Sunday in Advent from special.lisp."
  (assert-equal "07.12.2025" (format-date (zweiter-advent 2025)))
  (assert-equal "04.12.2016" (format-date (zweiter-advent 2016))))

(def-test-method test-dritter-advent-special ((test special-test-suite) :run nil)
  "Test third Sunday in Advent from special.lisp."
  (assert-equal "14.12.2025" (format-date (dritter-advent 2025)))
  (assert-equal "11.12.2016" (format-date (dritter-advent 2016))))

(def-test-method test-vierter-advent-special ((test special-test-suite) :run nil)
  "Test fourth Sunday in Advent from special.lisp."
  (assert-equal "21.12.2025" (format-date (vierter-advent 2025)))
  (assert-equal "18.12.2016" (format-date (vierter-advent 2016))))

(def-test-method test-volkstrauertag ((test special-test-suite) :run nil)
  "Test Remembrance Sunday - second Sunday before the first Sunday in Advent."
  (assert-equal "16.11.2025" (format-date (volkstrauertag 2025)))
  (assert-equal "13.11.2016" (format-date (volkstrauertag 2016))))

(def-test-method test-totensontag ((test special-test-suite) :run nil)
  "Test Sunday in commemoration of the dead - last Sunday before fourth Sunday in Advent."
  (assert-equal "23.11.2025" (format-date (totensontag 2025)))
  (assert-equal "20.11.2016" (format-date (totensontag 2016))))

;;;; Daylight saving time tests (also in special.lisp)
(def-test-method test-beginn-sommerzeit-special ((test special-test-suite) :run nil)
  "Test start of daylight saving time from special.lisp."
  (assert-equal "30.03.2025" (format-date (beginn-sommerzeit 2025)))
  (assert-equal "29.03.2015" (format-date (beginn-sommerzeit 2015))))

(def-test-method test-beginn-winterzeit-special ((test special-test-suite) :run nil)
  "Test end of daylight saving time from special.lisp."
  (assert-equal "26.10.2025" (format-date (beginn-winterzeit 2025)))
  (assert-equal "25.10.2015" (format-date (beginn-winterzeit 2015))))

;;;; Harvest festival test (also in special.lisp)
(def-test-method test-erntedankfest-special ((test special-test-suite) :run nil)
  "Test Harvest Festival from special.lisp."
  (assert-equal "05.10.2025" (format-date (erntedankfest 2025)))
  (assert-equal "04.10.2015" (format-date (erntedankfest 2015))))
