[![Melpa Status](http://melpa.org/packages/sqlformat-badge.svg)](http://melpa.org/#/sqlformat)
[![Melpa Stable Status](http://stable.melpa.org/packages/sqlformat-badge.svg)](http://stable.melpa.org/#/sqlformat)
[![Build Status](https://github.com/purcell/sqlformat/workflows/CI/badge.svg)](https://github.com/purcell/sqlformat/actions)
<a href="https://www.patreon.com/sanityinc"><img alt="Support me" src="https://img.shields.io/badge/Support%20Me-%F0%9F%92%97-ff69b4.svg"></a>

sqlformat.el
============

This Emacs library provides commands and a minor mode for easily reformatting
SQL using external programs such as [sqlformat][sqlformat], [sqlfluff][sqlfluff] or [pg_format][pgformatter].

Installation
=============

If you choose not to use one of the convenient
packages in [MELPA][melpa], you'll need to
add the directory containing `sqlformat.el` to your `load-path`, and
then `(require 'sqlformat)`.

Usage
=====

Customise the `sqlformat-command` variable as desired. For example, to
use [pgformatter][pgformatter] (i.e., the `pg_format` command) with
two-character indent and no statement grouping,

``` el
(setq sqlformat-command 'pgformatter)
(setq sqlformat-args '("-s2" "-g"))
```

Then call `sqlformat`, `sqlformat-buffer` or `sqlformat-region` as convenient.

Enable `sqlformat-on-save-mode` in SQL buffers like this:

```el
(add-hook 'sql-mode-hook 'sqlformat-on-save-mode)
```

or locally to your project with a form in your .dir-locals.el like
this:

```el
((sql-mode
   (mode . sqlformat-on-save)))
```

You might like to bind `sqlformat` or `sqlformat-buffer` to a key,
e.g. with:

```el
(define-key sql-mode-map (kbd "C-c C-f") 'sqlformat)
```

Install the [sqlparse][sqlformat] (Python) package to get "sqlformat", or
[pgformatter][pgformatter] to get "pg_format"

[melpa]: http://melpa.org
[sqlformat]: https://sqlformat.org/
[pgformatter]: https://github.com/darold/pgFormatter
[sqlfluff]: https://www.sqlfluff.com

<hr>

[💝 Support this project and my other Open Source work](https://www.patreon.com/sanityinc)

[💼 LinkedIn profile](https://uk.linkedin.com/in/stevepurcell)

[✍ sanityinc.com](http://www.sanityinc.com/)

[🐦 @sanityinc](https://twitter.com/sanityinc)
