;;;;
;;;; feiertage.lisp - Main holiday calculation functions
;;;;

(in-package #:cl-feiertage)

;;;;
;;;; Date formatting configuration
;;;;

(defvar *default-time-format* "~2,'0D.~2,'0D.~4,'0D"
  "Default format for printing feiertag dates. Uses format-string with month, day, year.")

(defun set-default-time-format (format)
  "Set the default format string for printing feiertag dates.
   The format string should be a Common Lisp format string that accepts
   three arguments: day, month, year."
  (setf *default-time-format* format))

;;;;
;;;; Feiertag structure
;;;;

(defstruct (feiertag (:conc-name feiertag-))
  "A Feiertag represents a holiday with a date and a name.
   It can be associated with zero or more regions."
  (date (local-time:now) :type local-time:timestamp)
  (name "" :type string)
  (regions nil :type list))

(defun copy-feiertag (feiertag &key (date (feiertag-date feiertag))
                          (name (feiertag-name feiertag))
                          (regions (feiertag-regions feiertag)))
  "Create a copy of a Feiertag with optional overrides."
  (make-feiertag :date date :name name :regions regions))

(defmethod print-object ((obj feiertag) stream)
  "Print a Feiertag object in a human-readable format."
  (print-unreadable-object (obj stream :type t :identity t)
    (let ((date (feiertag-date obj))
          (name (feiertag-name obj)))
      (format stream *default-time-format*
              (local-time:timestamp-day date)
              (local-time:timestamp-month date)
              (local-time:timestamp-year date))
      (format stream " ~A" name))))

;;;;
;;;; Region structure
;;;;

(defstruct (region (:conc-name region-))
  "A Region represents a federal state of Germany or Austria (Bundesland).
   It contains the name, short name, and a list of public holidays valid in that region."
  (name "" :type string)
  (shortname "" :type string)
  (feiertage nil :type list))

(defun copy-region (region &key (name (region-name region))
                       (shortname (region-shortname region))
                       (feiertage (region-feiertage region)))
  "Create a copy of a Region with optional overrides."
  (make-region :name name :shortname shortname :feiertage feiertage))

(defmethod print-object ((obj region) stream)
  "Print a Region object with its holidays."
  (print-unreadable-object (obj stream :type t :identity t)
    (format stream "~A (~A)" (region-name obj) (region-shortname obj))
    (when (region-feiertage obj)
      (format stream "~%  ")
      (loop :for f :in (region-feiertage obj)
            :do (format stream "~A~%  " f)))))

;;;;
;;;; Easter calculation using Gauss's algorithm
;;;; Based on: https://de.wikipedia.org/wiki/Gau%C3%9Fsche_Osterformel
;;;;

(defun oster-datum (year)
  "Calculate the date of Easter Sunday using Gauss's algorithm.
   Returns a list of (day month year).
   
   The algorithm:
   1. K = year / 100 (säkularzahl)
   2. M = 15 + (3*K + 3)/4 - (8*K + 13)/25 (säkulare Mondschaltung)
   3. S = 2 - (3*K + 3)/4 (säkulare Sonnenschaltung)
   4. A = year mod 19 (Mondparameter)
   5. D = (19*A + M) mod 30 (Keim für den ersten Vollmond im Frühling)
   6. R = (D + A/11) / 29 (kalendarische Korrekturgröße)
   7. OG = 21 + D - R (Ostergrenze)
   8. SZ = 7 - (year + year/4 + S) mod 7 (erster Sonntag im März)
   9. OE = 7 - (OG - SZ) mod 7 (Osterentfernung)
   10. OS = OG + OE (Ostersonntag als Märzdatum, 32. März = 1. April)
   
   Returns: (day month year) where month is 3 (March) or 4 (April)"
  (let* ((k (floor year 100))
         (m (+ 15 (floor (+ (* 3 k) 3) 4) (- (floor (+ (* 8 k) 13) 25))))
         (s (- 2 (floor (+ (* 3 k) 3) 4)))
         (a (mod year 19))
         (d (mod (+ (* 19 a) m) 30))
         (r (floor (+ d (floor a 11)) 29))
         (og (+ 21 d (- r)))
         (sz (- 7 (mod (+ year (floor year 4) s) 7)))
         (oe (- 7 (mod (- og sz) 7)))
         (os (+ og oe))
         (day (mod os 31))
         (month (+ 3 (floor os 31))))
    (when (<= day 0)
      (setf day (+ day 31)
            month (- month 1)))
    (list day month year)))

(defun make-date (day month year)
  "Create a local-time timestamp from day, month, year."
  (local-time:encode-timestamp 0 0 0 0 day month year))

;;;;
;;;; Fixed date holidays
;;;;

(defun neujahr (year)
  "New Year's Day - January 1st.
  
  Neujahr is New Year, a fixed date."
  (make-feiertag :date (make-date 1 1 year) :name "Neujahr"))

(defun epiphanias (year)
  "Epiphany - January 6th.
  
  Epiphanias is Epiphany, a fixed date."
  (make-feiertag :date (make-date 6 1 year) :name "Epiphanias"))

(defun heilige-drei-könige (year)
  "Epiphany - January 6th.
  
  HeiligeDreiKönige is another name for Epiphany, a fixed date."
  (let ((e (epiphanias year)))
    (copy-feiertag e :name "Heilige drei Könige")))

(defun valentinstag (year)
  "Valentine's Day - February 14th.
  
  Valentinstag is Valentine's Day, a fixed date."
  (make-feiertag :date (make-date 14 2 year) :name "Valentinstag"))

(defun internationaler-tag-des-gedenkens-an-die-opfer-des-holocaust (year)
  "International Holocaust Remembrance Day - January 27th.
  
  InternationalerTagDesGedenkensAnDieOpferDesHolocaust is International Holocaust Remembrance Day, a fixed date."
  (make-feiertag :date (make-date 27 1 year) :name "Internationaler Tag des Gedenkens an die Opfer des Holocaust"))

(defun josefitag (year)
  "St. Joseph's Day - March 19th.
  
  Josefitag is St Joseph's Day, a fixed date."
  (make-feiertag :date (make-date 19 3 year) :name "Josefitag"))

(defun internationaler-frauentag (year)
  "International Women's Day - March 8th.
  
  InternationalerFrauentag is International Women's Day, a fixed date."
  (make-feiertag :date (make-date 8 3 year) :name "Internationaler Frauentag"))

(defun tag-der-arbeit (year)
  "Labour Day - May 1st.
  
  TagDerArbeit is Labour Day, a fixed date."
  (make-feiertag :date (make-date 1 5 year) :name "Tag der Arbeit"))

(defun staatsfeiertag (year)
  "May 1st in Austria - Labour Day.
  
  Staatsfeiertag is May 1st in Austria, a fixed date."
  (let ((e (tag-der-arbeit year)))
    (copy-feiertag e :name "Staatsfeiertag")))

(defun florianitag (year)
  "St. Florian's Day - May 4th.
  
  Florianitag is St Florian's Day, a fixed date."
  (make-feiertag :date (make-date 4 5 year) :name "Florianitag"))

(defun tag-der-befreiung (year)
  "Victory in Europe Day - May 8th.
  
  TagDerBefreiung is Victory in Europe Day, a fixed date."
  (make-feiertag :date (make-date 8 5 year) :name "Tag der Befreiung"))

(defun mariä-himmelfahrt (year)
  "Assumption Day - August 15th.
  
  MariäHimmelfahrt is Assumption Day, a fixed date."
  (make-feiertag :date (make-date 15 8 year) :name "Mariä Himmelfahrt"))

(defun rupertitag (year)
  "St. Rupert's Day - September 24th.
  
  Rupertitag is St Rupert's Day, a fixed date."
  (make-feiertag :date (make-date 24 9 year) :name "Rupertitag"))

(defun tag-der-deutschen-einheit (year)
  "German Unity Day - October 3rd.
  
  TagDerDeutschenEinheit is German Unity Day, a fixed date."
  (make-feiertag :date (make-date 3 10 year) :name "Tag der deutschen Einheit"))

(defun tag-der-volksabstimmung (year)
  "Referendum Day in Carinthia - October 10th.
  
  TagDerVolksabstimmung is Referendum Day in Carinthia, a fixed date."
  (make-feiertag :date (make-date 10 10 year) :name "Tag der Volksabstimmung"))

(defun nationalfeiertag (year)
  "Austrian National Day - October 26th.
  
  Nationalfeiertag is the Austrian national day, a fixed date."
  (make-feiertag :date (make-date 26 10 year) :name "Nationalfeiertag"))

(defun reformationstag (year)
  "Reformation Day - October 31st.
  
  Reformationstag is Reformation Day, a fixed date."
  (make-feiertag :date (make-date 31 10 year) :name "Reformationstag"))

(defun allerheiligen (year)
  "All Saints' Day - November 1st.
  
  Allerheiligen is All Saints' Day or Allhallows, a fixed date."
  (make-feiertag :date (make-date 1 11 year) :name "Allerheiligen"))

(defun martinstag (year)
  "Martinmas - November 11th.
  
  Martinstag or Skt. Martin is Martinmas, a fixed date."
  (make-feiertag :date (make-date 11 11 year) :name "Martinstag"))

(defun leopolditag (year)
  "St. Leopold's Day - November 15th.
  
  Leopolditag is St Leopold's Day, a fixed date."
  (make-feiertag :date (make-date 15 11 year) :name "Leopolditag"))

(defun weltkindertag (year)
  "World Children's Day - September 20th.
  
  Weltkindertag is World Children's Day, a fixed date."
  (make-feiertag :date (make-date 20 9 year) :name "Weltkindertag"))

(defun weihnachten (year)
  "Christmas Day - December 25th.
  
  Weihnachten is Christmas, a fixed date."
  (make-feiertag :date (make-date 25 12 year) :name "Weihnachten"))

(defun christtag (year)
  "Christmas Day in Austria.
  
  Christtag is Christmas in Austria."
  (let ((e (weihnachten year)))
    (copy-feiertag e :name "Christtag")))

(defun zweiter-weihnachtsfeiertag (year)
  "Second Christmas Day - December 26th.
  
  ZweiterWeihnachtsfeiertag is day after Christmas, a fixed date."
  (make-feiertag :date (make-date 26 12 year) :name "Zweiter Weihnachtsfeiertag"))

(defun stefanitag (year)
  "St. Stephen's Day - December 26th in Austria.
  
  Stefanitag is December 26th in Austria."
  (let ((e (zweiter-weihnachtsfeiertag year)))
    (copy-feiertag e :name "Stefanitag")))

(defun mariä-unbefleckte-empfängnis (year)
  "Immaculate Conception - December 8th.
  
  MariäUnbefleckteEmpfängnis is Day of Immaculate Conception, a fixed date."
  (make-feiertag :date (make-date 8 12 year) :name "Mariä unbefleckte Empfängnis"))

(defun mariä-empfängnis (year)
  "Immaculate Conception - December 8th.
  
  MariäEmpfängnis has a shorter name for MariäUnbefleckteEmpfängnis in Austria."
  (let ((e (mariä-unbefleckte-empfängnis year)))
    (copy-feiertag e :name "Mariä Empfängnis")))

(defun nikolaus (year)
  "St. Nicholas' Day - December 6th.
  
  Nikolaus is St Nicholas' Day, a fixed date."
  (make-feiertag :date (make-date 6 12 year) :name "Nikolaus"))

(defun heiligabend (year)
  "Christmas Eve - December 24th.
  
  Heiligabend is Christmas Eve, the last day before Christmas."
  (make-feiertag :date (make-date 24 12 year) :name "Heiligabend"))

(defun silvester (year)
  "New Year's Eve - December 31st.
  
  Silvester is New Year's Eve, a fixed date."
  (make-feiertag :date (make-date 31 12 year) :name "Silvester"))

;;;;
;;;; Easter-based movable holidays
;;;;

(defun ostern (year)
  "Easter Sunday.
  
  Ostern is Easter. Calculated by an extended Gauss algorithm.
  
  See: https://de.wikipedia.org/wiki/Gau%C3%9Fsche_Osterformel"
  (destructuring-bind (day month y) (oster-datum year)
    (make-feiertag :date (make-date day month y) :name "Ostern")))

(defun karfreitag (year)
  "Good Friday - the last Friday before Easter.
  
  Karfreitag is Good Friday, the last Friday before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 2 :day)
                   :name "Karfreitag")))

(defun ostermontag (year)
  "Easter Monday - the Monday after Easter.
  
  Ostermontag is Easter Monday, the Monday after Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 1 :day)
                   :name "Ostermontag")))

(defun christi-himmelfahrt (year)
  "Ascension Day - 39 days after Easter, therefore always a Thursday.
  
  ChristiHimmelfahrt is Ascension Day, 39 days after Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 39 :day)
                   :name "Christi Himmelfahrt")))

(defun vatertag (year)
  "Father's Day - same day as Ascension Day.
  
  Vatertag is Father's Day, same day as Ascension Day, 39 days after Easter."
  (let ((e (christi-himmelfahrt year)))
    (copy-feiertag e :name "Vatertag")))

(defun pfingsten (year)
  "Pentecost - 49 days after Easter.
  
  Pfingsten is Pentecost, 49 days after Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 49 :day)
                   :name "Pfingsten")))

(defun pfingstmontag (year)
  "Whit Monday - the Monday after Pentecost.
  
  Pfingstmontag is Whit Monday, the monday after Pentecost."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 50 :day)
                   :name "Pfingstmontag")))

(defun fronleichnam (year)
  "Corpus Christi - 60 days after Easter, therefore always a Thursday.
  
  Fronleichnam is Corpus Christi, 60 days after Eastern."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 60 :day)
                   :name "Fronleichnam")))

(defun dreifaltigkeitssonntag (year)
  "Trinity Sunday - the Sunday after Pentecost.
  
  Dreifaltigkeitssonntag is Trinity Sunday, the Sunday after Pentecost."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp+ (feiertag-date o) 56 :day)
                   :name "Dreifaltigkeitssonntag")))

;;;;
;;;; Carnival holidays (Easter-based)
;;;;

(defun weiberfastnacht (year)
  "Weiberfastnacht - 52 days before Easter.
  
  Weiberfastnacht is a part of carnival, 52 days before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 52 :day)
                   :name "Weiberfastnacht")))

(defun karnevalssonntag (year)
  "Carnival Sunday - 49 days before Easter.
  
  Karnevalssonntag is the sunday of carnival, 49 days before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 49 :day)
                   :name "Karnevalssonntag")))

(defun rosenmontag (year)
  "Rose Monday - 48 days before Easter.
  
  Rosenmontag is the monday of carnival, 48 days before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 48 :day)
                   :name "Rosenmontag")))

(defun fastnacht (year)
  "Shrove Tuesday - 47 days before Easter.
  
  Fastnacht is shrovetide, the Tuesday of carnival, 47 days before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 47 :day)
                   :name "Fastnacht")))

(defun aschermittwoch (year)
  "Ash Wednesday - 46 days before Easter.
  
  Aschermittwoch is Ash Wednesday, 46 days before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 46 :day)
                   :name "Aschermittwoch")))

(defun palmsonntag (year)
  "Palm Sunday - the last Sunday before Easter.
  
  Palmsonntag is Palm Sunday, the last Sunday before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 7 :day)
                   :name "Palmsonntag")))

(defun gründonnerstag (year)
  "Holy Thursday - the last Thursday before Easter.
  
  Gründonnerstag is Holy Thursday or Maundy Thursday, the last Thursday before Easter."
  (let ((o (ostern year)))
    (copy-feiertag o
                   :date (local-time:timestamp- (feiertag-date o) 3 :day)
                   :name "Gründonnerstag")))

(defun muttertag (year)
  "Mother's Day - second Sunday in May.
  
  Muttertag is Mother's Day oder Mothering Sunday, the second Sunday in May."
  (let* ((date (make-date 1 5 year))
         (dow (local-time:timestamp-day-of-week date))
         ;; Calculate days to add to get to Sunday (6 in local-time)
         (offset (mod (- 6 dow) 7)))
    (make-feiertag :date (local-time:timestamp+ date (+ offset 7) :day)
                   :name "Muttertag")))

;;;;
;;;; Sorting utilities
;;;;

(defun sort-feiertage-by-date (feiertage)
  "Sort a list of Feiertag objects by date.
  
  Returns a new sorted list."
  (sort (copy-list feiertage) #'(lambda (a b) (local-time:timestamp< (feiertag-date a) (feiertag-date b)))))
