;;;;
;;;; special.lisp - Special dates and additional holidays
;;;;

(in-package #:cl-feiertage)

;;;;
;;;; Special dates with fixed dates
;;;;

(defun weltknuddeltag (year)
  "World Hug Day or National Hugging Day - January 21st.
  
  Weltknuddeltag is World Hug Day or National Hugging Day, a fixed date."
  (make-feiertag :date (make-date 21 1 year) :name "Weltknuddeltag"))

(defun star-wars-day (year)
  "Star Wars Day - May 4th.
  
  StarWarsDay is a fixed date."
  (make-feiertag :date (make-date 4 5 year) :name "Star Wars Day"))

(defun handtuchtag (year)
  "Towel Day - May 25th.
  
  Handtuchtag is Towel Day, May 25. It is celebrated as a tribute to the author Douglas Adams by his fans."
  (make-feiertag :date (make-date 25 5 year) :name "Handtuchtag"))

(defun towel-day (year)
  "Towel Day - May 25th.
  
  TowelDay is May 25. It is celebrated as a tribute to the author Douglas Adams by his fans."
  (let ((e (handtuchtag year)))
    (copy-feiertag e :name "Towel Day")))

(defun weltumwelttag (year)
  "World Environment Day - June 5th.
  
  Weltumwelttag is World Environment Day, a fixed date."
  (make-feiertag :date (make-date 5 6 year) :name "Weltumwelttag"))

(defun weltspieltag (year)
  "International Day of Play - June 11th.
  
  Weltspieltag is International Day of Play, a fixed date."
  (make-feiertag :date (make-date 11 6 year) :name "Weltspieltag"))

(defun weltblutspendetag (year)
  "World Blood Donor Day - June 14th.
  
  Weltblutspendetag is World Blood Donor Day, a fixed date."
  (make-feiertag :date (make-date 14 6 year) :name "Weltblutspendetag"))

(defun fête-de-la-musique (year)
  "World Music Day - June 21st.
  
  FêteDeLaMusique is World Music Day, a fixed date."
  (make-feiertag :date (make-date 21 6 year) :name "Fête de la Musique"))

(defun internationaler-tag-gegen-drogenmissbrauch (year)
  "International Day Against Drug Abuse and Illicit Trafficking - June 26th.
  
  InternationalerTagGegenDrogenmissbrauch is International Day Against Drug Abuse and Illicit Trafficking, a fixed date."
  (make-feiertag :date (make-date 26 6 year) :name "Internationaler Tag gegen Drogenmissbrauch"))

(defun system-administrator-appreciation-day (year)
  "System Administrator Appreciation Day - last Friday in July.
  
  SystemAdministratorAppreciationDay is the last Friday in July."
  (let* ((date (make-date 31 7 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to subtract to get to Friday
         ;; 5 = Friday in local-time (Monday=0, ..., Sunday=6)
         (offset (mod (- 5 dow) 7)))
    (make-feiertag :date (local-time:timestamp- date offset :day)
                   :name "System Administrator Appreciation Day")))

(defun hobbit-day (year)
  "Hobbit Day - September 22nd.
  
  Hobbit Day is a fixed date."
  (make-feiertag :date (make-date 22 9 year) :name "Hobbit Day"))

(defun internationaler-männertag (year)
  "International Men's Day - November 19th.
  
  InternationalerMännertag is International Day Men's Day, a fixed date."
  (make-feiertag :date (make-date 19 11 year) :name "Internationaler Männertag"))

(defun karnevalsbeginn (year)
  "Beginning of carnival - November 11th at 11:11:11.
  
  Karnevalsbeginn is the beginning of carnival, a fixed date."
  (make-feiertag :date (local-time:encode-timestamp 11 11 11 11 11 11 year)
                 :name "Karnevalsbeginn"))

(defun tag-des-meeres (year)
  "World Oceans Day - June 8th.
  
  TagDesMeeres is World Oceans Day, a fixed date."
  (make-feiertag :date (make-date 8 6 year) :name "Tag des Meeres"))

(defun weltflüchtlingstag (year)
  "World Refugee Day - June 20th.
  
  Weltflüchtlingstag is World Refugee Day, a fixed date."
  (make-feiertag :date (make-date 20 6 year) :name "Weltflüchtlingstag"))

(defun antikriegstag (year)
  "Anti-War Day - September 1st.
  
  Antikriegstag is Anti-War Day, a fixed date."
  (make-feiertag :date (make-date 1 9 year) :name "Antikriegstag"))

(defun internationaler-tag-der-pressefreiheit (year)
  "World Press Freedom Day - May 3rd.
  
  InternationalerTagDerPressefreiheit is World Press Freedom Day, a fixed date."
  (make-feiertag :date (make-date 3 5 year) :name "Internationaler Tag der Pressefreiheit"))

(defun tag-der-erde (year)
  "Earth Day - April 22nd.
  
  TagDerErde is Earth Day, a fixed date."
  (make-feiertag :date (make-date 22 4 year) :name "Tag der Erde"))

(defun walpurgisnacht (year)
  "Walpuris Night - April 30th.
  
  Walpurgisnacht is Walpurgis Night, a fixed date."
  (make-feiertag :date (make-date 30 4 year) :name "Walpurgisnacht"))

(defun halloween (year)
  "Halloween - October 31st.
  
  Halloween is a fixed date."
  (make-feiertag :date (make-date 31 10 year) :name "Halloween"))

(defun allerseelen (year)
  "All Souls' Day - November 2nd.
  
  Allerseelen is All Souls' Day, the day after All Saints' Day."
  (make-feiertag :date (make-date 2 11 year) :name "Allerseelen"))

(defun weltmännertag (year)
  "Men's World Day - November 3rd.
  
  Weltmännertag is Men's World Day."
  (make-feiertag :date (make-date 3 11 year) :name "Weltmännertag"))

;;;;
;;;; Movable special dates (not Easter-based)
;;;;

(defun thanksgiving (year)
  "Thanksgiving in the US - fourth Thursday of November.
  
  Thanksgiving in the US, the fourth Thursday of November."
  (let* ((date (make-date 1 11 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to add to get to Thursday (4 in local-time)
         (offset (mod (- 4 dow) 7))
         (first-thursday (+ 1 offset))
         (fourth-thursday (+ first-thursday 21)))
    (make-feiertag :date (make-date fourth-thursday 11 year)
                   :name "Thanksgiving (US)")))

(defun blackfriday (year)
  "Black Friday - the Friday after Thanksgiving.
  
  Blackfriday is the Friday after Thanksgiving."
  (let ((thanksgiving-date (feiertag-date (thanksgiving year))))
    (make-feiertag :date (local-time:timestamp+ thanksgiving-date 1 :day)
                   :name "Blackfriday")))

;;;;
;;;; Daylight saving time transitions
;;;;

(defun beginn-sommerzeit (year)
  "Start of daylight saving time - last Sunday of March.
  
  BeginnSommerzeit is the start of daylight saving time. Last Sunday of March."
  (let* ((date (make-date 31 3 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to subtract to get to Sunday (6 in local-time)
         (offset (mod (- 6 dow) 7)))
    (make-feiertag :date (local-time:timestamp- date offset :day)
                   :name "Beginn Sommerzeit")))

(defun beginn-winterzeit (year)
  "End of daylight saving time - last Sunday of October.
  
  BeginnWinterzeit is the end of daylight saving time. Last Sunday of October."
  (let* ((date (make-date 31 10 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to subtract to get to Sunday (6 in local-time)
         (offset (mod (- 6 dow) 7)))
    (make-feiertag :date (local-time:timestamp- date offset :day)
                   :name "Beginn Winterzeit")))

;;;;
;;;; German-specific movable dates
;;;;

(defun erntedankfest (year)
  "Harvest Festival - first Sunday of October.
  
  Erntedankfest is Thanksgiving or Harvest Festival, the first Sunday of October.
  The german Erntedankfest is not the same than the US Thanksgiving."
  (let* ((date (make-date 1 10 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to add to get to Sunday (6 in local-time)
         (offset (mod (- 6 dow) 7)))
    (make-feiertag :date (local-time:timestamp+ date offset :day)
                   :name "Erntedankfest")))

(defun vierter-advent (year)
  "Fourth Sunday in Advent - last Sunday before Christmas.
  
  VierterAdvent is the fourth Sunday in Advent."
  (let* ((date (make-date 24 12 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to subtract to get to Sunday (6 in local-time)
         (offset (mod (- 6 dow) 7)))
    (make-feiertag :date (local-time:timestamp- date offset :day)
                   :name "Vierter Advent")))

(defun erster-advent (year)
  "First Sunday in Advent.
  
  ErsterAdvent is the first Sunday in Advent."
  (let ((fourth-advent (feiertag-date (vierter-advent year))))
    (make-feiertag :date (local-time:timestamp- fourth-advent 21 :day)
                   :name "Erster Advent")))

(defun zweiter-advent (year)
  "Second Sunday in Advent.
  
  ZweiterAdvent is the second Sunday in Advent."
  (let ((fourth-advent (feiertag-date (vierter-advent year))))
    (make-feiertag :date (local-time:timestamp- fourth-advent 14 :day)
                   :name "Zweiter Advent")))

(defun dritter-advent (year)
  "Third Sunday in Advent.
  
  DritterAdvent is the third Sunday in Advent."
  (let ((fourth-advent (feiertag-date (vierter-advent year))))
    (make-feiertag :date (local-time:timestamp- fourth-advent 7 :day)
                   :name "Dritter Advent")))

(defun volkstrauertag (year)
  "Remembrance Sunday - second Sunday before the first Sunday in Advent.
  
  Volkstrauertag is Remembrance Sunday, the second sunday before the first Sunday in Advent."
  (let ((first-advent (feiertag-date (erster-advent year))))
    (make-feiertag :date (local-time:timestamp- first-advent 14 :day)
                   :name "Volkstrauertag")))

(defun totensontag (year)
  "Sunday in commemoration of the dead - last Sunday before the fourth Sunday in Advent.
  
  Totensontag is Sunday in commemoration of the dead, the last Sunday before the fourth Sunday in Advent."
  (let ((fourth-advent (feiertag-date (vierter-advent year))))
    (make-feiertag :date (local-time:timestamp- fourth-advent 28 :day)
                   :name "Totensontag")))

;;;;
;;;; Additional special dates
;;;;

(defun internationaler-kindertag (year)
  "International Children's Day - June 1st.
  
  InternationalerKindertag is special to Germany and Austria and
  is not the same as Weltkindertag (World Children's Day), a fixed date."
  (make-feiertag :date (make-date 1 6 year) :name "Internationaler Kindertag"))





;; Note: Some functions like Weiberfastnacht, Karnevalssonntag, Rosenmontag, etc.
;; are defined in feiertage.lisp as they are Easter-based.
