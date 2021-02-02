# MarkdownLib

MarkdownLib is a library which converts `rich text` within a `Text Suite` compatible application (e.g. `TextEdit`, [OmniOutliner](https://www.omnigroup.com/omnioutliner) and others) into Markdown.  This is a fairly rudimentary conversion to Markdown, but it serves my needs.

## Installation

Enter the following command in the `Terminal` application to install the latest version of MarkdownLib on your machine:

~~~~
curl https://raw.githubusercontent.com/alldritt/AppleScriptLibraries/master/MarkdownLib.applescript | osacompile -o ~/Library/Script\ Libraries/MarkdownLib.scpt
~~~~

## Usage

MarkdownLib provides a single public handler: `richTextToMarkdown(rich text object reference)`.

~~~~
use AppleScript version "2.4" -- Yosemite (10.10) or later
use MarkdownLib : script "MarkdownLib" version "1.0"
use scripting additions

tell application "TextEdit"
	MarkdownLib's richTextToMarkdown(a reference to document 1)
end tell
~~~~

See also [this post](http://forum.latenightsw.com/t/export-omnioutliner-document-to-markdown/1049) and [this post](http://forum.latenightsw.com/t/markdownlib-on-github/1013) on the Script Debugger support forum.
