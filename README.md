# AppleScript Libraries
Here is a collection of AppleScript libraries which I use regularly which others may find useful.  This code also forms the basis for a series of blog posts on [markalldritt.com](http://markalldritt.com).

## MarksLib

MarksLib is a collection of handlers for everyday operations that I find myself using in almost every script I write.  There are tools for reading and writing text files, string substitution, converting between strings and arrays and more.


### Installation

Enter the following command in the `Terminal` application to install the latest version of MarksLib on your machine:

~~~~
curl https://raw.githubusercontent.com/alldritt/AppleScriptLibraries/master/MarksLib.applescript | osacompile -o ~/Library/Script\ Libraries/MarksLib.scpt
~~~~

### Usage

MarksLib provides the following handlers:

#### readFromFile

The `readFromFile(theFile)` handler reads the contents of a text file.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g.) (`readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

#### writeToFile

The `writeToFile(theFile, theData)` handler writes the contents of a variable to a text file.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g.) (`readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

The `theData` parameter should be a string.

#### replaceText

The `replaceText(theString, fString, rString)` handler replaces all occurrences of `fString` in `theString` with `rString.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's replaceText("the quick brown fox jumped over the lazy dog", "the", "xxx")
-->"xxx quick brown fox jumped over xxx lazy dog"
~~~~

#### trim

The `trim(theString)` handler trims leading and trailing whitespace from a string.  The functional also works on arrays of strings, returning an array of trimmed strings.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's trim("  hello world  " & return)
-->"hello world"
MarksLib's trim({" abc ", "1234   ", "   "})
-->{"abc", "1234", ""}
~~~~

#### split

The `split(theString, theSeparator)` handler splits a string into an array of strings.  

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's split("1, 2, 3, 4", ",")
-->{"1", " 2", " 3", " 4"}
MarksLib's trim(MarksLib's split("1, 2, 3, 4", ","))
-->{"1", "2", "3", "4"}
~~~~

#### join

The `|join|(theString, theSeparator)` handler joins an array of strings together into a single string.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's join({"hello", "world"}, " ")-->{"hello world"}MarksLib's join(MarksLib's trim(MarksLib's split("1, 2, 3, 4", ",")), "-")-->{"1-2-3-4"} ~~~~

#### formatForJSON

The `formatForJSON(theValue)` handler formats a string so that it is suitable for use as a value in a JSON structure.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's formatForJSON("My name is \"Mark\"")-->"My name is \"Mark\""~~~~

#### formatForCSV

The `formatCSVString(theValue)` handler formats a string so that is suitable for use as a value in a CSV file.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarksLib : script "MarksLib" version "1.0"MarksLib's formatCSVString("Nothing special")-->"Nothing special"MarksLib's formatCSVString("My name is \"Mark\"")-->"My name is ""Mark"""~~~~


## MarkdownLib

MarkdownLib is a library which converts `rich text` within a `Text Suite` compatible application (e.g. `TextEdit`, [OmniOutliner](https://www.omnigroup.com/omnioutliner) and others) into Markdown.  This is a fairly rudimentary conversion to Markdown, but it serves me needs.

### Installation

Enter the following command in the `Terminal` application to install the latest version of MarkdownLib on your machine:

~~~~
curl https://raw.githubusercontent.com/alldritt/AppleScriptLibraries/master/MarkdownLib.applescript | osacompile -o ~/Library/Script\ Libraries/MarkdownLib.scpt
~~~~

### Usage

MarkdownLib provides a single public handler: `richTextToMarkdown(rich text object reference)`.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or lateruse MarkdownLib : script "MarkdownLib" version "1.0"use scripting additionstell application "TextEdit"	MarkdownLib's richTextToMarkdown(a reference to document 1)end tell~~~~
## The Future
I hope to add additional libraries to this repository as time goes on.  If you want to improve on my work, Pull Requests are always welcome.

