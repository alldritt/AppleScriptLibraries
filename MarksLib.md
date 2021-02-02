# MarksLib

MarksLib is a collection of handlers for everyday operations that I find myself using in almost every script I write.  There are tools for reading and writing text files, string substitution, converting between strings and arrays and more.


## Installation

Enter the following command in the `Terminal` application to install the latest version of MarksLib on your machine:

~~~~
curl https://raw.githubusercontent.com/alldritt/AppleScriptLibraries/master/MarksLib.applescript | osacompile -o ~/Library/Script\ Libraries/MarksLib.scpt
~~~~

## Usage

MarksLib provides the following handlers:

### containerOf

The `containerOf(theReference)` handler returns the `container` of an object specifier.  For example, `containerOf(file 1 of folder 1 of application "Finder")` would return `file 1`'s container: `folder 1 of application "Finder"`.

### readFromFile

The `readFromFile(theFile)` handler reads the contents of a text file.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g. `readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

### writeToFile

The `writeToFile(theFile, theData)` handler writes the contents of a variable to a file encoded as UTF-8 text.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g. `readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

The `theData` parameter should be a string.

### writeDataToFile

The `writeDataToFile(theFile, theData)` handler writes the contents of a variable to a file as raw data.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g. `readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

The `theData` parameter can be any type of data.

### doesFileExist

The `doesFileExist(theFile)` handler tests to see if a file exists.  The `theFile` parameter can take many forms:

- full HFS path (e.g. `readFromFile("Macintosh HD:Users:Mark:Desktop:file.txt")`)
- full POSIX path (e.g. `readFromFile("/Users/Mark/Desktop/file.txt")`)
- relative POSIX path (e.g. `readFromFile("~/Desktop/file.txt")`)
- alias (e.g. `readFromFile(alias "Macintosh HD:Users:Mark:Desktop:file.txt")`)
- file reference (e.g. `readFromFile(file "Macintosh HD:Users:Mark:Desktop:file.txt")`)

### replaceText

The `replaceText(theString, fString, rString)` handler replaces all occurrences of `fString` in `theString` with `rString`.  If
`theString` is a list of strings then all occurrences of `fString` are replaced in each string in the list.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's replaceText("the quick brown fox jumped over the lazy dog", "the", "xxx")
-->"xxx quick brown fox jumped over xxx lazy dog"
~~~~

### trim

The `trim(theString)` handler trims leading and trailing whitespace from a string.  The functional also works on arrays of strings, returning an array of trimmed strings.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's trim("  hello world  " & return)
-->"hello world"
MarksLib's trim({" abc ", "1234   ", "   "})
-->{"abc", "1234", ""}
~~~~

### split

The `split(theString, theSeparator)` handler splits a string into an array of strings.  

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's split("1, 2, 3, 4", ",")
-->{"1", " 2", " 3", " 4"}
MarksLib's trim(MarksLib's split("1, 2, 3, 4", ","))
-->{"1", "2", "3", "4"}
~~~~

### join

The `|join|(theString, theSeparator)` handler joins an array of strings together into a single string.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's join({"hello", "world"}, " ")
-->{"hello world"}
MarksLib's join(MarksLib's trim(MarksLib's split("1, 2, 3, 4", ",")), "-")
-->{"1-2-3-4"} 
~~~~

### formatForJSON

The `formatForJSON(theValue)` handler formats a string so that it is suitable for use as a value in a JSON structure.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's formatForJSON("My name is \"Mark\"")
-->"My name is \"Mark\""
~~~~

### formatForCSV

The `formatCSVString(theValue)` handler formats a string so that is suitable for use as a value in a CSV file.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarksLib : script "MarksLib" version "1.0"

MarksLib's formatCSVString("Nothing special")
-->"Nothing special"
MarksLib's formatCSVString("My name is \"Mark\"")
-->"My name is ""Mark"""
~~~~

