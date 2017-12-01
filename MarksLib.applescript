--
--	Created by: Mark Alldritt
--	Created on: 2016-06-19
--
--	Copyright (c) 2016 Late Night Software Ltd.
--	All Rights Reserved
--

use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions


property pstrCharToTrim : {tab, linefeed, return, space, character id 160, character id 5760, character id 8192, character id 8193, character id 8194, character id 8195, character id 8196, character id 8197, character id 8198, character id 8199, character id 8200, character id 8201, character id 8202, character id 8239, character id 8287, character id 12288}


on containerOf(theObject)
	return «class from» of (theObject as record)
end

on replaceText(theString, fString, rString)
	if class of theString is list then
		local resultList
		
		set resultList to {}
		repeat with anItem in theString
			set end of resultList to replaceText(contents of anItem, fString, rString)
		end repeat
		return resultList
	else
		(*
		local saveTID, stringList, newString
		
		set saveTID to AppleScript's text item delimiters
		set AppleScript's text item delimiters to fString
		set stringList to every text item of theString
		set AppleScript's text item delimiters to rString
		set newString to stringList as string
		set AppleScript's text item delimiters to saveTID
		return newString
		*)
		return ((current application's NSString's stringWithString:theString)'s ¬
			stringByReplacingOccurrencesOfString:fString withString:rString) as text
	end if
end replaceText

on throwError(errMsg)
	error errMsg number 1000
end throwError

on trim(theString)
	--	Trim whitespace from the beginning and end of string(s).  theString may be a single string or a list of strings.
	if class of theString is list then
		local resultList
		
		set resultList to {}
		repeat with anItem in theString
			set end of resultList to trim(contents of anItem)
		end repeat
		return resultList
	else if class of theString is string or class of theString is text then
		local lLoc, rLoc
		
		set lLoc to 1
		set rLoc to count of theString
		
		--- From left to right, get location of first non-whitespace character
		repeat until lLoc = (rLoc + 1) or character lLoc of theString is not in pstrCharToTrim
			set lLoc to lLoc + 1
		end repeat
		
		-- From right to left, get location of first non-whitespace character
		repeat until rLoc = 0 or character rLoc of theString is not in pstrCharToTrim
			set rLoc to rLoc - 1
		end repeat
		
		if lLoc > rLoc then
			return ""
		else
			return text lLoc thru rLoc of theString
		end if
	else
		return theString
	end if
end trim

on split(theString, theSeparator)
	local saveTID, theResult
	
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to theSeparator
	set theResult to text items of theString
	set AppleScript's text item delimiters to saveTID
	return theResult
end split

on |join|(theString, theSeparator)
	local saveTID, theResult
	
	set saveTID to AppleScript's text item delimiters
	set AppleScript's text item delimiters to theSeparator
	set theResult to theString as text
	set AppleScript's text item delimiters to saveTID
	return theResult
end |join|

on formatForJSON(theValue)
	--	Format a string as a valid JSON value
	if (class of theValue is boolean) then
		if (theValue) then
			return true
		else
			return false
		end if
	else
		set theValue to theValue as string
		return "\"" & replaceText(replaceText(theValue, "\\", "\\\\"), "\"", "\\\"") & "\""
	end if
end formatForJSON

on formatCSVString(theValue)
	--	Format a string as a valid CSV value
	if theValue is missing value then
		return ""
	else
		set theValue to theValue as string
		return "\"" & replaceText(theValue, "\"", "\"\"") & "\""
	end if
end formatCSVString

on makeFileReference(theFile)
	--	Convert a string path into a file reference
	--
	--	Parameters:
	--
	--	theFile - when a string, can be a full HFS path, a full Posix Path (beginning with /), a HOME-relative Posix path (beginning with ~/)
	--			- when an alias, returned as is
	--			- when a file referene, returned as is
	--
	if class of theFile is string and character 1 of theFile is "/" then
		set theFile to POSIX file theFile
	else if class of theFile is string and character 1 of theFile is "~" then
		set theFile to POSIX file ((POSIX path of (path to home folder)) & text 2 thru -1 of theFile)
	else if class of theFile is string then
		try
			set theFile to alias theFile
		end try
	end if
	
	return theFile
end makeFileReference

on writeToFile(theFile, theData)
	--	Write theData to theFile (file ref or string path)
	try
		local fileReference, fileSpec
		
		set theFile to makeFileReference(theFile)
		set fileReference to open for access theFile with write permission
		set eof fileReference to 0
		write theData to fileReference as «class utf8»
		close access fileReference
		return theFile
	on error errMessage number errNum
		try
			close access file theFile
		end try
		error errMessage number errNum
	end try
	
end writeToFile

on readFromFile(theFile)
	return readFromFileAs(theFile, text)
end readFromFile

on readFromFileAs(theFile, theClass)
	--	Read the contents of theFile (file ref or string path)
	try
		local fileReference, fileSpec
		
		set theFile to makeFileReference(theFile)
		set fileReference to open for access theFile
		set theData to read fileReference as theClass
		close access fileReference
		return theData
	on error
		try
			close access file theFile
		end try
		return missing value
	end try
end readFromFileAs
