use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on isLink(linkText)
	--	This is a very crude test if a string is a link.
	
	ignoring case
		return linkText begins with "http:" or ¬
			linkText begins with "https:" or ¬
			linkText begins with "ftp:" or ¬
			linkText ends with ".com"
	end ignoring
end isLink

on isEmail(emailText)
	--	This is a very crude test if a string is an email address.
	
	ignoring case
		return emailText contains "@" and emailText ends with ".com"
	end ignoring
end isEmail

on isBoldFont(fontName)
	ignoring case
		return fontName contains "Bold"
	end ignoring
end isBoldFont

on isItalicFont(fontName)
	ignoring case
		return fontName contains "Italic"
	end ignoring
end isItalicFont

on richTextToMarkdown(cellRef)
	local markdownText, inBold, inItalic, rowText
	
	set markdownText to ""
	set inBold to false
	set inItalic to false
	set rowText to {} --  use an array because its a bit faster
	
	using terms from application "TextEdit"
		repeat with anAttribute in attribute runs of cellRef
			set {runText, runIsBold, runIsItalic} to ¬
				{contents of anAttribute, my isBoldFont(font of anAttribute), my isItalicFont(font of anAttribute)}
			
			--	close any existing attribute runs that have ended
			if inBold and not runIsBold then
				set end of rowText to "**"
				set inBold to false
			end if
			if inItalic and not runIsItalic then
				set end of rowText to "*"
				set inItalic to false
			end if
			
			--	open  new attribute runs
			if not inBold and runIsBold then
				set end of rowText to "**"
				set inBold to true
			end if
			if not inItalic and runIsItalic then
				set end of rowText to "*"
				set inItalic to true
			end if
			
			--	add the attribute run's text
			if my isEmail(runText) then
				set end of rowText to "[" & runText & "](mailto:" & runText & ")"
			else if my isLink(runText) then
				set end of rowText to "[" & runText & "](" & runText & ")"
			else
				set end of rowText to runText
			end if
		end repeat
		
		--	close any existing attribute runs
		if inBold then
			set end of rowText to "**"
			set inBold to false
		end if
		if inItalic then
			set end of rowText to "*"
			set inItalic to false
		end if
		
		--	convert the array of Markdown attribute runs into a single string
		set saveTID to AppleScript's text item delimiters
		set AppleScript's text item delimiters to {""}
		set markdownText to rowText as text
		set AppleScript's text item delimiters to saveTID
	end using terms from
	
	return markdownText
end richTextToMarkdown

