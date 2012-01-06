HTMLPP - HTML pre-processing utilities
======

The Utilities
-------------

* htmlpp - command-line script for adding scripts to a page and 
	expanding variables in URLs
* htmldecor - command-line script for merging two html pages, 
	one with content and the other with page-decor
* decor2xsl - command-line script for creating an xslt-stylesheet
	from a HTML decor page
* HTMLDecor.js - elegantly merges an external decor page 
	into the (presumeably fairly raw) content page
	

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

### HTMLDecor.js

To see this in action visit http://meekostuff.net/blog which is dog-fooding this script. 

Create a HTML document (page.html) with some page specific content:

	<!DOCTYPE html>
	<html>
	<head>
		<!-- create a link to the decor page -->
		<link rel="meeko-decor" type="text/html" href="decor.html" />
		<!-- and source the HTMLDecor script -->
		<script src="/path/to/HTMLDecor.js"></script>
		<style>
		.page { border: 2px solid green; }
		</style>
	</head>
	<body>
		<div>
		This irrelevant content will be removed from the page
		</div>
		
		<div id="page-main">
		#page-main
			<div class="page">
			This content is styled by the page stylesheet
			</div>
			<div class="decor">
			This content is styled by the decor stylesheet
			</div>	
		</div>
		
		<div>
		This irrelevant content will be removed from the page
		</div>
	</body>
	</html>
	
Create the decor document (decor.html):

	<!DOCTYPE html>
	<html>
	<head>
		<style>
		.decor { border: 2px solid blue; }
		</style>
	</head>
	<body>
		<div id="header">
		#header in decor
		</div>
		
		<div id="main">
			#main in decor
			<div id="page-main">
			#page-main in decor: This will be replaced by #page-main in the page
			</div>
		</div>
		
		<div id="footer">
		#footer in decor
		</div>
	</body>
	</html>

When page.html is loaded into the browser HTMLDecor.js will merge decor.html into it, resulting in a DOM tree like this:

	<!DOCTYPE html>
	<html>
	<head>
		<style>
		.decor { border: 2px solid blue; }
		</style>
		<!-- create a link to the decor page -->
		<link rel="meeko-decor" type="text/decor+html" href="decor.html" />
		<!-- and source the HTMLDecor script -->
		<script src="/path/to/HTMLDecor.js"></script>
		<style>
		.page { border: 2px solid green; }
		</style>
	</head>
	<body>
		<div id="header">
		#header in decor
		</div>
		
		<div id="main">
			#main in decor
			<div id="page-main">
			#page-main
				<div class="page">
				This content is styled by the page stylesheet
				</div>
				<div class="decor">
				This content is styled by the decor stylesheet
				</div>	
			</div>
		</div>
		
		<div id="footer">
		#footer in decor
		</div>
	</body>
	</html>


Installation
------------

For now it is easiest to copy from the installation available at http://devel.meekostuff.net/HTMLPP/0.9-devel/


License
-------

The long-term license is still undecided.
For now it is available under Create-Commons Attribution, No-Derivitives.
