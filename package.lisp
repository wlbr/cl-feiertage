;;;;
;;;; package.lisp - Package definition for cl-feiertage
;;;;

(defpackage #:cl-feiertage
  (:use #:cl)
  (:nicknames #:feiertage)
  (:export
   ;; Date formatting
   #:*default-time-format*
   #:set-default-time-format
   #:format-feiertag
   
   ;; Holiday structure and classes
   #:feiertag
   #:feiertag-date
   #:feiertag-name
   #:feiertag-regions
   #:make-feiertag
   #:copy-feiertag
   
   ;; Region structure and classes
   #:region
   #:region-name
   #:region-shortname
   #:region-feiertage
   #:make-region
   #:copy-region
   
   ;; Holiday calculation functions
   ;; Fixed date holidays
   #:neujahr
   #:epiphanias
   #:heilige-drei-könige
   #:valentinstag
   #:internationaler-tag-des-gedenkens-an-die-opfer-des-holocaust
   #:josefitag
   #:internationaler-frauentag
   #:tag-der-arbeit
   #:staatsfeiertag
   #:florianitag
   #:tag-der-befreiung
   #:mariä-himmelfahrt
   #:rupertitag
   #:tag-der-deutschen-einheit
   #:tag-der-volksabstimmung
   #:nationalfeiertag
   #:reformationstag
   #:allerheiligen
   #:martinstag
   #:leopolditag
   #:weltkindertag
   #:weihnachten
   #:christtag
   #:zweiter-weihnachtsfeiertag
   #:stefanitag
   #:mariä-empfängnis
   #:mariä-unbefleckte-empfängnis
   #:nikolaus
   #:heiligabend
   #:silvester
   
   ;; Movable holidays (Easter-based)
   #:ostern
   #:karfreitag
   #:ostermontag
   #:christi-himmelfahrt
   #:vatertag
   #:pfingsten
   #:pfingstmontag
   #:fronleichnam
   #:dreifaltigkeitssonntag
   
   ;; Carnival holidays
   #:weiberfastnacht
   #:karnevalssonntag
   #:rosenmontag
   #:fastnacht
   #:aschermittwoch
   #:palmsonntag
   #:gründonnerstag
   
   ;; Special holidays
   #:weltknuddeltag
   #:star-wars-day
   #:handtuchtag
   #:towel-day
   #:weltumwelttag
   #:weltspieltag
   #:weltblutspendetag
   #:fête-de-la-musique
   #:internationaler-tag-gegen-drogenmissbrauch
   #:system-administrator-appreciation-day
   #:hobbit-day
   #:internationaler-männertag
   #:karnevalsbeginn
   #:thanksgiving
   #:blackfriday
   #:tag-des-meeres
   #:weltflüchtlingstag
   #:antikriegstag
   #:halloween
   #:beginn-sommerzeit
   #:beginn-winterzeit
   #:allerseelen
   #:weltmännertag
   #:erntedankfest
   #:volkstrauertag
   #:totensonntag
   #:erster-advent
   #:zweiter-advent
   #:dritter-advent
   #:vierter-advent
   
   ;; Region functions
   #:baden-württemberg
   #:bayern
   #:berlin
   #:brandenburg
   #:bremen
   #:hamburg
   #:hessen
   #:mecklenburg-vorpommern
   #:niedersachsen
   #:nordrhein-westfalen
   #:rheinland-pfalz
   #:saarland
   #:sachsen
   #:sachsen-anhalt
   #:schleswig-holstein
   #:thüringen
   #:deutschland
   #:burgenland
   #:kärnten
   #:niederösterreich
   #:oberösterreich
   #:salzburg
   #:steiermark
   #:tirol
   #:vorarlberg
   #:wien
   #:österreich
   #:all
   
   ;; Utility functions
   #:date=
   #:get-feiertage-for-date-in-region
   #:get-feiertage-for-date
   #:get-all-regions
   
   ;; Sorting
   #:sort-feiertage-by-date
   ))

(in-package #:cl-feiertage)
