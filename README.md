# cl-feiertage

cl-feiertage is a Common Lisp library for calculating German and Austrian bank holidays. It includes the calculation of the date of Easter and, more importantly, offers ways to retrieve public holidays for a state of Germany or Austria (=Bundesland).

The library is probably useful only for people realizing use cases with special requirements inside of Austria or Germany, such as shift schedules or capacity calculation.

## Usage

There are two types of functions:

  * `(feiertage:<feiertag> year)` and
  * `(feiertage:<region> year)`

`<feiertag>` returns a `feiertag` struct. It carries the date of the holiday in the requested year plus the name of the holiday. `<feiertag>` may be any of the following:

|||
|----|-----|
`neujahr` | `epiphanias`
`heilige-drei-könige` | `weltknuddeltag`
`internationaler-tag-des-gedenkens-an-die-opfer-des-holocaust` | `weiberfastnacht`
`valentinstag` | `karnevalssonntag`
`rosenmontag` | `fastnacht`
`aschermittwoch` | `internationaler-frauentag`
`josefitag` | `palmsonntag`
`beginn-sommerzeit` | `gründonnerstag`
`karfreitag` | `ostern`
`ostermontag` | `tag-der-erde`
`walpurgisnacht` | `staatsfeiertag`
`tag-der-arbeit` | `internationaler-tag-der-pressefreiheit`
`star-wars-day` | `florianitag`
`tag-der-befreiung` | `muttertag`
`vatertag` | `christi-himmelfahrt`
`pfingsten` | `handtuchtag`
`pfingstmontag` | `towel-day`
`dreifaltigkeitssonntag` | `internationaler-kindertag`
`fronleichnam` | `weltumwelttag`
`tag-des-meeres` | `weltspieltag`
`weltblutspendetag` | `weltflüchtlingstag`
`fête-de-la-musique` | `internationaler-tag-gegen-drogenmissbrauch`
`system-administrator-appreciation-day` | `mariä-himmelfahrt`
`antikriegstag` | `weltkindertag`
`hobbit-day` | `rupertitag`
`tag-der-deutschen-einheit` | `erntedankfest`
`tag-der-volksabstimmung` | `beginn-winterzeit`
`nationalfeiertag` | `halloween`
`reformationstag` | `allerheiligen`
`allerseelen` | `weltmännertag`
`martinstag` | `karnevalsbeginn`
`volkstrauertag` | `leopolditag`
`buß-und-bettag` | `internationaler-männertag`
`totensonntag` | `thanksgiving`
`blackfriday` | `erster-advent`
`nikolaus` | `zweiter-advent`
`mariä-empfängnis` | `mariä-unbefleckte-empfängnis`
`dritter-advent` | `vierter-advent`
`heiligabend` | `christtag`
`weihnachten` | `stefanitag`
`zweiter-weihnachtsfeiertag` | `silvester`

`<region>` returns a `region` struct. It offers a list of public holidays valid in the specified state as well as the name and the shortname of the state as attributes.
`<region>` may be any of:

||||
----|-----|----
`baden-württemberg` | `bayern` | `berlin`
`brandenburg` | `bremen` | `hamburg`
`hessen` | `mecklenburg-vorpommern` | `niedersachsen`
`nordrhein-westfalen` | `rheinland-pfalz` | `saarland`
`sachsen` | `sachsen-anhalt` | `schleswig-holstein`
`thüringen` | `deutschland` | `burgenland`
`kärnten` | `niederösterreich` | `oberösterreich`
`salzburg` | `steiermark` | `tirol`
`vorarlberg` | `wien` | `österreich`
`all` | &nbsp; | &nbsp;

The region functions return the public holidays ("gesetzliche Feiertage"). The function `all` returns all defined "special dates", such as Penance Day (Buß- und Bettag) or the begin/end of daylight saving time.

The regional functions for Austrian Bundesländer include saints' days which are state-level holidays, meaning schools etc. are generally closed but workers don't get the day off by default. If you don't want to include these days in your planning, it's okay to reference `österreich` instead, as legal holidays are (more or less) synchronised across all Austrian states (Bundesländer).

## Examples

```lisp
(feiertage:ostern 2016)
--> #S(FEIERTAG :DATE 27.03.2016 :NAME "Ostern")

(feiertage:buß-und-bettag 2016)
--> #S(FEIERTAG :DATE 16.11.2016 :NAME "Buß- und Bettag")

(feiertage:brandenburg 2016)
--> Brandenburg (BB)
    01.01.2016 Neujahr
    25.03.2016 Karfreitag
    27.03.2016 Ostern
    28.03.2016 Ostermontag
    01.05.2016 Tag der Arbeit
    05.05.2016 Christi Himmelfahrt
    15.05.2016 Pfingsten
    16.05.2016 Pfingstmontag
    03.10.2016 Tag der deutschen Einheit
    31.10.2016 Reformationstag
    25.12.2016 Weihnachten
    26.12.2016 Zweiter Weihnachtsfeiertag
```

## Installation

The most simple and recommended way to install cl-feiertage is by using
[Quicklisp](http://www.quicklisp.org). If you have Quicklisp installed, a simple

```lisp
(ql:quickload :feiertage)
```

will download the package and load it. You only need to do this once per machine. Later a

```lisp
(require :feiertage)
```

will be enough.

Alternatively you may get the code with:

```sh
git clone git://github.com/wlbr/cl-feiertage.git
```

Either you add this to your ASDF repository, then you will only need to do a `(require :feiertage)` in your source.

Or, you may put the source in a subdirectory of your project and add the file `feiertage.asd` with its full path to your own ASDF definition.

Or, you may put the source in a subdirectory of your project and load the file `feiertage.asd` directly. After that a `(asdf:load-system "feiertage")` should be sufficient.

## Dependencies

* [alexandria](https://common-lisp.net/project/alexandria/)
* [local-time](https://common-lisp.net/project/local-time/)

xlunit for the unit tests only (the tests are not included in the asdf system definition).

## Testing

Tested with SBCL and CCL. Should run in any standard Common Lisp environment.

A set of unit tests is included. To run them:

```lisp
(asdf:test-system :feiertage)
```

## License

MIT License. See included LICENSE file.

## Reporting problems

If you run into any trouble or find bugs, please report them via [the Github issue tracker](http://github.com/wlbr/cl-feiertage/issues).
