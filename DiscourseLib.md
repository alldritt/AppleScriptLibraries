
# DiscourseLib

DiscourseLib Lib is a library that allows you to access [Discourse](https://www.discourse.org) servers from AppleScript.  You can post new topics, get the details of existing posts, query tags and categories.

## Installation

Enter the following command in the `Terminal` application to install the latest version of DiscourseLib Lib on your machine:

~~~~
curl https://raw.githubusercontent.com/alldritt/AppleScriptLibraries/master/DiscourseLib.applescript | osacompile -o ~/Library/Script\ Libraries/DiscourseLib.scpt
~~~~

## Usage

### Configuration

1.	Install DiscourseLib as described above

2. Load DiscourseLib and configure it with your domain, access key and user name:

	~~~~
	use AppleScript version "2.4" -- Yosemite (10.10) or later
	use discourseLib : script "DiscourseLib" version "1.0"
	
	--	Discourse properties
	set discourseLib's APIDOMAIN to "https://forum.domain.com"
	set discourseLib's APIKEY to "your discourse API key"
	set discourseLib's APIUSER to "your discourse username"
	~~~~

### Post New Topic

~~~
--	Let the user pick a category into which the topic will go
set categoryChoice to choose from list discourseLib's getDiscourseCatagories() ¬
	with prompt "Forum Category" OK button name "Post" without multiple selections allowed and empty selection allowed
if categoryChoice = false then -- user cancelled?
	return
end if
set topicCategory to item 1 of categoryChoice
	
--	Post the topic to the Discouse forum
discourseLib's postToDiscourse(topicTitle, topicCategory, [], topicMarkdown)
~~~

### Read A Post

~~~
set myPost to discourseLib's getDiscoursePost(1234) -- replace 1234 with your post's ID
~~~

### Get Available Tags

~~~
set myTags to discourseLib's getDiscourseTags()
~~~

## Other uses

This library provides a base for developing other REST API clients for AppleScript.  The basic principals are generally transferable.
