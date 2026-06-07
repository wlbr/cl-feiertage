;;;;
;;;; regions.lisp - Region definitions for German and Austrian states
;;;;

(in-package #:feiertage)

;;;;
;;;; Helper functions for creating region holiday lists
;;;;

(defun create-common-feiertags-list (year)
  "Create a list of common holiday functions for all regions.
  
  Returns a list of functions that take a year and return a Feiertag."
  (declare (ignore year))
  (list #'neujahr #'ostermontag #'christi-himmelfahrt #'pfingstmontag))

(defun create-uniq-austrian-feiertags-list ()
  "Create a list of unique Austrian holiday functions.
  
  Returns a list of functions that take a year and return a Feiertag."
  (list #'heilige-drei-könige #'staatsfeiertag
        #'fronleichnam #'mariä-himmelfahrt #'nationalfeiertag
        #'allerheiligen #'mariä-empfängnis #'christtag #'stefanitag))

(defun create-uniq-german-feiertags-list (year)
  "Create a list of unique German holiday functions.
  
  Returns a list of functions that take a year and return a Feiertag.
  In 2017, Reformationstag was a one-time holiday in all states of Germany."
  (let ((feiern (list #'karfreitag #'tag-der-arbeit
                     #'tag-der-deutschen-einheit #'weihnachten
                     #'zweiter-weihnachtsfeiertag)))
    (when (= year 2017)
      (push #'reformationstag feiern))
    feiern))

(defun feiertags-function-list-to-feiertag-list (ffun-list year)
  "Convert a list of holiday functions to a list of Feiertag objects.
  
  Args:
    ffun-list: List of functions that take a year and return a Feiertag
    year: The year to calculate holidays for
  
  Returns:
    A list of Feiertag objects."
  (loop :for f :in ffun-list
        :collect (funcall f year)))

(defun create-feiertags-list (year country &optional ffun-list)
  "Create a list of Feiertag objects for a region.
  
  Args:
    year: The year to calculate holidays for
    country: \"DE\" for Germany or \"AT\" for Austria
    ffun-list: Optional list of additional holiday functions specific to the region
  
  Returns:
    A sorted list of Feiertag objects."
  (let* ((feiern (create-common-feiertags-list year))
         (nfeiern (if (string= country "AT")
                      (create-uniq-austrian-feiertags-list)
                      (create-uniq-german-feiertags-list year)))
         (all-feiern (append feiern nfeiern)))
    ;; Add region-specific holidays
    (when ffun-list
      (dolist (f ffun-list all-feiern)
        (let ((holiday (funcall f year)))
          ;; Skip Reformationstag in 2017 if it's already in the German list
          (when (and (= year 2017)
                     (local-time:timestamp= (feiertag-date holiday)
                                          (feiertag-date (reformationstag year))))
            (return))
          (push f all-feiern))))
    ;; Convert to Feiertag objects and sort
    (sort-feiertage-by-date (feiertags-function-list-to-feiertag-list all-feiern year))))

(defun add-region-to-feiertag-regions (feiertag region)
  "Add a region to the regions list of a Feiertag if not already present."
  (unless (member region (feiertag-regions feiertag) :test #'equal :key #'region-shortname)
    (push region (feiertag-regions feiertag))))

;;;;
;;;; German states (Bundesländer)
;;;;

(defun baden-württemberg (year &optional include-sundays)
  "Baden-Württemberg state holidays.
  
  Returns a Region object holding all public holidays in the state Baden-Württemberg."
  (declare (ignore include-sundays))
  (let* ((ffun-list (list #'epiphanias #'fronleichnam #'allerheiligen))
         (region (make-region :name "Baden-Württemberg"
                              :shortname "BW"
                              :feiertage (create-feiertags-list year "DE" ffun-list))))
    ;; Add region to each feiertag's regions list
    (dolist (f (region-feiertage region))
      (add-region-to-feiertag-regions f region))
    region))

(defun bayern (year &optional include-sundays)
  "Bavaria state holidays.
  
  Returns a Region object holding all public holidays in the state Bayern."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'epiphanias #'fronleichnam #'allerheiligen)))
    (make-region :name "Bayern"
                 :shortname "BY"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun berlin (year &optional include-sundays)
  "Berlin state holidays.
  
  Returns a Region object holding all public holidays in the state Berlin.
  
  Since 2019, Internationaler Frauentag (March 8) is a holiday.
  In 2020 and 2025, Tag der Befreiung (May 8) is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (when (>= year 2019)
      (push #'internationaler-frauentag ffun-list))
    (when (or (= year 2020) (= year 2025))
      (push #'tag-der-befreiung ffun-list))
    (make-region :name "Berlin"
                 :shortname "BE"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun brandenburg (year &optional include-sundays)
  "Brandenburg state holidays.
  
  Returns a Region object holding all public holidays in the state Brandenburg.
  
  Brandenburg has special handling for holidays that fall on Sundays.
  If include-sundays is NIL, Ostern, Pfingsten, and Reformationstag on Sundays are excluded."
  (let ((ffun-list nil))
    (cond
      ((and include-sundays (not (eq include-sundays :explicitly-nil)))
       ;; Include Ostern, Pfingsten, Reformationstag even on Sundays
       (setf ffun-list (list #'ostern #'pfingsten #'reformationstag)))
      (t
       ;; Exclude holidays on Sundays
       (setf ffun-list (list #'reformationstag))))
    (make-region :name "Brandenburg"
                 :shortname "BB"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun bremen (year &optional include-sundays)
  "Bremen state holidays.
  
  Returns a Region object holding all public holidays in the state Bremen.
  
  Since 2018, Reformationstag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (when (>= year 2018)
      (push #'reformationstag ffun-list))
    (make-region :name "Bremen"
                 :shortname "HB"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun hamburg (year &optional include-sundays)
  "Hamburg state holidays.
  
  Returns a Region object holding all public holidays in the state Hamburg.
  
  Since 2018, Reformationstag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (when (>= year 2018)
      (push #'reformationstag ffun-list))
    (make-region :name "Hamburg"
                 :shortname "HH"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun hessen (year &optional include-sundays)
  "Hesse state holidays.
  
  Returns a Region object holding all public holidays in the state Hessen."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'fronleichnam)))
    (make-region :name "Hessen"
                 :shortname "HE"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun mecklenburg-vorpommern (year &optional include-sundays)
  "Mecklenburg-Vorpommern state holidays.
  
  Returns a Region object holding all public holidays in the state Mecklenburg-Vorpommern.
  
  Since 2018, Reformationstag is a holiday.
  Since 2023, Internationaler Frauentag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'reformationstag)))
    (when (>= year 2023)
      (push #'internationaler-frauentag ffun-list))
    (make-region :name "Mecklenburg-Vorpommern"
                 :shortname "MV"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun niedersachsen (year &optional include-sundays)
  "Lower Saxony state holidays.
  
  Returns a Region object holding all public holidays in the state Niedersachsen.
  
  Since 2018, Reformationstag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (when (>= year 2018)
      (push #'reformationstag ffun-list))
    (make-region :name "Niedersachsen"
                 :shortname "NI"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun nordrhein-westfalen (year &optional include-sundays)
  "North Rhine-Westphalia state holidays.
  
  Returns a Region object holding all public holidays in the state Nordrhein-Westfalen."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'fronleichnam #'allerheiligen)))
    (make-region :name "Nordrhein-Westfalen"
                 :shortname "NW"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun rheinland-pfalz (year &optional include-sundays)
  "Rhineland-Palatinate state holidays.
  
  Returns a Region object holding all public holidays in the state Rheinland-Pfalz."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'fronleichnam #'allerheiligen)))
    (make-region :name "Rheinland-Pfalz"
                 :shortname "RP"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun saarland (year &optional include-sundays)
  "Saarland state holidays.
  
  Returns a Region object holding all public holidays in the state Saarland."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'fronleichnam #'mariä-himmelfahrt #'allerheiligen)))
    (make-region :name "Saarland"
                 :shortname "SL"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun sachsen (year &optional include-sundays)
  "Saxony state holidays.
  
  Returns a Region object holding all public holidays in the state Sachsen.
  
  Reformationstag and Buß- und Bettag are holidays."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'reformationstag #'buß-und-bettag)))
    (make-region :name "Sachsen"
                 :shortname "SN"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun sachsen-anhalt (year &optional include-sundays)
  "Saxony-Anhalt state holidays.
  
  Returns a Region object holding all public holidays in the state Sachsen-Anhalt.
  
  Epiphanias and Reformationstag are holidays."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'epiphanias #'reformationstag)))
    (make-region :name "Sachsen-Anhalt"
                 :shortname "ST"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun schleswig-holstein (year &optional include-sundays)
  "Schleswig-Holstein state holidays.
  
  Returns a Region object holding all public holidays in the state Schleswig-Holstein.
  
  Since 2018, Reformationstag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (when (>= year 2018)
      (push #'reformationstag ffun-list))
    (make-region :name "Schleswig-Holstein"
                 :shortname "SH"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun thüringen (year &optional include-sundays)
  "Thuringia state holidays.
  
  Returns a Region object holding all public holidays in the state Thüringen.
  
  Reformationstag is a holiday.
  Since 2019, Weltkindertag is a holiday."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'reformationstag)))
    (when (>= year 2019)
      (push #'weltkindertag ffun-list))
    (make-region :name "Thüringen"
                 :shortname "TH"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

(defun deutschland (year &optional include-sundays)
  "All-Germany holidays (common across all states).
  
  Returns a Region object holding all public holidays that are common in Germany."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (make-region :name "Deutschland"
                 :shortname "DE"
                 :feiertage (create-feiertags-list year "DE" ffun-list))))

;;;;
;;;; Austrian states (Bundesländer)
;;;;

(defun burgenland (year &optional include-sundays)
  "Burgenland state holidays.
  
  Returns a Region object holding all public holidays in the state of Burgenland."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'martinstag)))
    (make-region :name "Burgenland"
                 :shortname "Bgld"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun kärnten (year &optional include-sundays)
  "Carinthia state holidays.
  
  Returns a Region object holding all public holidays in the state of Kärnten."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'josefitag #'tag-der-volksabstimmung)))
    (make-region :name "Kärnten"
                 :shortname "Ktn"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun niederösterreich (year &optional include-sundays)
  "Lower Austria state holidays.
  
  Returns a Region object holding all public holidays in the state of Niederösterreich."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'leopolditag)))
    (make-region :name "Niederösterreich"
                 :shortname "NÖ"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun oberösterreich (year &optional include-sundays)
  "Upper Austria state holidays.
  
  Returns a Region object holding all public holidays in the state of Oberösterreich."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'florianitag)))
    (make-region :name "Oberösterreich"
                 :shortname "OÖ"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun salzburg (year &optional include-sundays)
  "Salzburg state holidays.
  
  Returns a Region object holding all public holidays in the state of Salzburg."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'rupertitag)))
    (make-region :name "Salzburg"
                 :shortname "Sbg"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun steiermark (year &optional include-sundays)
  "Styria state holidays.
  
  Returns a Region object holding all public holidays in the state of Steiermark."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'josefitag)))
    (make-region :name "Steiermark"
                 :shortname "Stmk"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun tirol (year &optional include-sundays)
  "Tyrol state holidays.
  
  Returns a Region object holding all public holidays in the state of Tirol."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'josefitag)))
    (make-region :name "Tirol"
                 :shortname "T"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun vorarlberg (year &optional include-sundays)
  "Vorarlberg state holidays.
  
  Returns a Region object holding all public holidays in the state of Vorarlberg."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'josefitag)))
    (make-region :name "Vorarlberg"
                 :shortname "Vbg"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun wien (year &optional include-sundays)
  "Vienna state holidays.
  
  Returns a Region object holding all public holidays in the city and state of Vienna."
  (declare (ignore include-sundays))
  (let ((ffun-list (list #'leopolditag)))
    (make-region :name "Wien"
                 :shortname "W"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

(defun österreich (year &optional include-sundays)
  "All-Austria holidays (common across all states).
  
  Returns a Region object holding all public holidays that are common in Austria."
  (declare (ignore include-sundays))
  (let ((ffun-list nil))
    (make-region :name "Österreich"
                 :shortname "AT"
                 :feiertage (create-feiertags-list year "AT" ffun-list))))

;;;;
;;;; All holidays (including special dates)
;;;;

(defun all (year &optional include-sundays)
  "All known holidays and special dates.
  
  Returns a Region object holding all public holidays/feast days known to this program.
  Not all of them are public holidays (basically 'work free' days).
  
  If include-sundays is T, includes holidays that fall on Sundays."
  (let* ((feiern (list
                  ;; Special dates from special.go
                  #'epiphanias #'valentinstag
                  #'internationaler-tag-des-gedenkens-an-die-opfer-des-holocaust
                  #'josefitag #'weiberfastnacht #'rosenmontag #'fastnacht
                  #'aschermittwoch #'gründonnerstag #'internationaler-kindertag
                  #'tag-des-meeres #'weltflüchtlingstag #'beginn-sommerzeit
                  #'walpurgisnacht #'internationaler-tag-der-pressefreiheit
                  #'tag-der-erde #'fête-de-la-musique #'florianitag
                  #'tag-der-befreiung #'muttertag #'christi-himmelfahrt
                  #'pfingsten #'pfingstmontag #'dreifaltigkeitssonntag
                  #'fronleichnam #'mariä-himmelfahrt #'rupertitag
                  #'tag-der-volksabstimmung #'halloween #'beginn-winterzeit
                  #'allerseelen #'weltmännertag #'martinstag #'karnevalsbeginn
                  #'leopolditag #'weltumwelttag #'weltspieltag #'weltblutspendetag
                  #'internationaler-männertag #'star-wars-day
                  #'weltknuddeltag #'weltkindertag #'buß-und-bettag
                  #'thanksgiving #'blackfriday #'nikolaus
                  #'mariä-unbefleckte-empfängnis #'heiligabend
                  #'silvester #'antikriegstag
                  ))
         ;; Add Easter-based carnival holidays
         (feiern (append (list #'karnevalssonntag #'palmsonntag) feiern))
         
         ;; Add common feiertags
         (feiern (append (create-common-feiertags-list year) feiern))
         
         ;; Add Austrian-specific holidays
         (feiern (append (create-uniq-austrian-feiertags-list) feiern))
         
         ;; Add German-specific holidays
         (feiern (append (create-uniq-german-feiertags-list year) feiern))
         
         ;; Add Reformationstag (except in 2017 when it's already in German list)
         (feiern (if (= year 2017)
                     feiern
                     (cons #'reformationstag feiern)))
         
         ;; Add Internationaler Frauentag since 2019
         (feiern (if (>= year 2019)
                     (cons #'internationaler-frauentag feiern)
                     feiern))
         
         ;; Add Hobbit Day since 1978
         (feiern (if (>= year 1978)
                     (cons #'hobbit-day feiern)
                     feiern))
         
         ;; Add Sunday holidays if requested
         (feiern (if include-sundays
                     (append (list #'karnevalssonntag #'palmsonntag #'ostern
                                   #'pfingsten #'dreifaltigkeitssonntag
                                   #'erntedankfest #'volkstrauertag #'totensontag
                                   #'erster-advent #'zweiter-advent #'dritter-advent
                                   #'vierter-advent)
                             feiern)
                     feiern)))
    (make-region :name "Alle"
                 :shortname "All"
                 :feiertage (sort-feiertage-by-date
                             (feiertags-function-list-to-feiertag-list feiern year)))))

;;;;
;;;; Utility functions for getting all regions
;;;;

(defun region-function-list-to-region-list (rfun-list year &optional include-sundays)
  "Convert a list of region functions to a list of Region objects.
  
  Args:
    rfun-list: List of region functions
    year: The year to calculate holidays for
    include-sundays: Whether to include holidays on Sundays
  
  Returns:
    A list of Region objects."
  (loop :for r :in rfun-list
        :collect (funcall r year include-sundays)))

(defun get-all-regions (year include-sundays &optional country)
  "Get a list of all available regions.
  
  Args:
    year: The year to calculate holidays for
    include-sundays: Whether to include holidays on Sundays
    country: Optional filter - \"de\" for German states, \"at\" for Austrian states
  
  Returns:
    A list of Region objects.
  
  If country is not specified, returns all German states, all Austrian states,
  plus the \"All\" region."
  (let* ((german-regions (region-function-list-to-region-list
                          (list #'baden-württemberg #'bayern #'berlin
                                #'brandenburg #'bremen #'hamburg
                                #'hessen #'mecklenburg-vorpommern
                                #'niedersachsen #'nordrhein-westfalen
                                #'rheinland-pfalz #'saarland
                                #'sachsen #'sachsen-anhalt
                                #'schleswig-holstein #'thüringen
                                #'deutschland)
                          year include-sundays))
         (austrian-regions (region-function-list-to-region-list
                            (list #'burgenland #'kärnten #'niederösterreich
                                  #'oberösterreich #'salzburg
                                  #'steiermark #'tirol #'vorarlberg
                                  #'wien #'österreich)
                            year include-sundays))
         (all-regions (append german-regions austrian-regions (list (all year include-sundays)))))
    (cond
      ((string-equal country "de") german-regions)
      ((string-equal country "at") austrian-regions)
      (t all-regions))))

;;;;
;;;; Note: Buß-und-Bettag function needs to be defined
;;;;

(defun buß-und-bettag (year)
  "Penance Day - 11 days before the first Sunday in Advent.
  
  BußUndBettag is Penance Day, 11 days before the first Sunday in Advent."
  (let* ((date (make-date 22 11 year))
         (dow (local-time:timestamp-day-of-week date))
         (d (- 4 dow))
         (offset (if (>= d 0) d (+ d 7))))
    (make-feiertag :date (local-time:timestamp- date offset :day)
                   :name "Buß- und Bettag")))

;;;;
;;;; Utility functions for finding holidays by date
;;;;

(defun date= (date1 date2)
  "Compare two timestamps for equality by date (ignoring time)."
  (and (= (local-time:timestamp-year date1) (local-time:timestamp-year date2))
       (= (local-time:timestamp-month date1) (local-time:timestamp-month date2))
       (= (local-time:timestamp-day date1) (local-time:timestamp-day date2))))

(defun get-feiertage-for-date-in-region (date region-fn &optional (include-sundays nil))
  "Retrieve all bank holidays for a given date in the specified region.
  
  Args:
    date: A local-time timestamp or a list of (year month day)
    region-fn: A region function like 'brandenburg or 'bayern
    include-sundays: Whether to include holidays that fall on Sundays
  
  Returns:
    A list of Feiertag objects for the given date in the region.
  
  Example:
    (get-feiertage-for-date-in-region '(2025 6 8) 'brandenburg t)
    => (#<FEIERTAG 08.06.2025 Pfingsten {1005C11653}>)"
  (let* ((normalized-date (if (listp date)
                              (make-date (third date) (second date) (first date))
                              date))
         (region (funcall region-fn (local-time:timestamp-year normalized-date) include-sundays))
         (result nil))
    (dolist (f (region-feiertage region) result)
      (when (date= (feiertag-date f) normalized-date)
        (push f result)))))

(defun get-feiertage-for-date (date)
  "Retrieve all defined holidays for a given date (across all regions).
  
  Args:
    date: A local-time timestamp or a list of (year month day)
  
  Returns:
    A list of Feiertag objects for the given date.
  
  Example:
    (get-feiertage-for-date '(2025 6 8))
    => (#<FEIERTAG 08.06.2025 Tag des Meeres {1005C11653}>
        #<FEIERTAG 08.06.2025 Pfingsten {1005C11713}>)"
  (let* ((normalized-date (if (listp date)
                              (make-date (third date) (second date) (first date))
                              date))
         (all-holidays (all (local-time:timestamp-year normalized-date) t))
         (result nil))
    (dolist (f (region-feiertage all-holidays) result)
      (when (date= (feiertag-date f) normalized-date)
        (push f result)))))
