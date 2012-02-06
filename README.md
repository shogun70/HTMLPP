HTMLPP - HTML pre-processing utilities
======

__WARNING:__ You are probably looking for HTMLDecor.js which has been moved to the [HTMLDecor project](http://github.com/shogun70/HTMLDecor).

The remainder of this project isn't recommended for use yet, especially as the pre-requisites and installation process aren't documented. 

The Utilities
-------------

* htmlpp - command-line script for adding scripts to a page and 
	expanding variables in URLs
* htmldecor - command-line script for merging two html pages, 
	one with content and the other with page-decor
* decor2xsl - command-line script for creating an xslt-stylesheet
	from a HTML decor page

Usage
-----

### htmlpp

	htmlpp [--script before.js] [--post-script after.js] [--string-param name value] page.html > output.html

1. Inserts `before.js` before any scripts (in the head) of `page.html` and `after.js` after any scripts.
2. Performs variable expansion of passed parameters into any URI attributes (@href, @src).
   Uses Perl's [URI::Template module](http://search.cpan.org/dist/URI-Template/lib/URI/Template.pm)
   which implements [uri-templates](http://tools.ietf.org/html/draft-gregorio-uritemplate-03)
   
### htmldecor

	htmldecor [--wrap] --decor decor.html page.html > output.html

The equivalent of HTMLDecor.js but runs on the server-side.

If --wrap option is specified then the merging operation is slightly different for the content of `page.html`.
The entire content of the `<body>` tag is placed within the first descendant of the `<body>` of `decor.html`
which has `@role="main"`, replacing any content already there.

### decor2xsl

	decor2xsl decor.html > decor.xsl
	
Converts a decor page into an xslt stylesheet that can be referenced by xhtml pages. 

License
-------

The long-term license is still undecided.
For now it is available under Create-Commons Attribution, No-Derivitives.

