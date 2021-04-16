use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions

--	Public Discourse Configuration
property APIDOMAIN : missing value -- "https://forum.domain.com"
property APIKEY : missing value -- "your Discourse API key"
property APIUSER : missing value -- "your Discourse username"

--	Discourse properties
property APIPOSTS_ENDPOINT : "/posts.json"
property APIPOST_ENDPOINT : "/posts/{id}.json"
property APICATAGORIES_ENDPOINT : "/categories.json"
property APITAGGROUPS_ENDPOINT : "/tag_groups.json"
property APITAGS_ENDPOINT : "/tags.json"

-- classes, constants, and enums used
property NSJSONSerialization : a reference to current application's NSJSONSerialization
property NSData : a reference to current application's NSData
property NSString : a reference to current application's NSString
property NSArray : a reference to current application's NSArray
property NSURL : a reference to current application's NSURL
property NSURLRequest : a reference to current application's NSURLRequest
property NSURLRequestReloadIgnoringLocalCacheData : a reference to current application's NSURLRequestReloadIgnoringLocalCacheData
property NSMutableURLRequest : a reference to current application's NSMutableURLRequest
property NSURLConnection : a reference to current application's NSURLConnection
property NSURLComponents : a reference to current application's NSURLComponents
property NSURLQueryItem : a reference to current application's NSURLQueryItem


on getDiscourseTags()
	local theJSON, theNames -- so SD can see them
	
	--	Construct a URL containing all the query parameters needed to create a Dicourse post
	set apiKeyParam to NSURLQueryItem's queryItemWithName:"api_key" value:APIKEY
	set userParam to NSURLQueryItem's queryItemWithName:"api_username" value:APIUSER
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & APITAGS_ENDPOINT)
	urlComponents's setQueryItems:{apiKeyParam, userParam}
	
	--	Send the get tags request to the Discourse site
	set theRequest to NSURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	set theNames to (theJSON's valueForKeyPath:"tags.text") as list
	return theNames
end getDiscourseTags

on getDiscourseCatagories()
	local theJSON, theNames -- so SD can see them
	
	--	Construct a URL containing all the query parameters needed to create a Dicourse post
	set apiKeyParam to NSURLQueryItem's queryItemWithName:"api_key" value:APIKEY
	set userParam to NSURLQueryItem's queryItemWithName:"api_username" value:APIUSER
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & APICATAGORIES_ENDPOINT)
	urlComponents's setQueryItems:{apiKeyParam, userParam}
	
	--	Send the get catagories request to the Discourse site
	set theRequest to NSURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	set theNames to (theJSON's valueForKeyPath:"category_list.categories.name") as list
	return theNames
end getDiscourseCatagories

on getDiscoursePost(postID)
	local theJSON, endpoint
	
	set endpoint to (NSString's stringWithString:APIPOST_ENDPOINT)'s ¬
		stringByReplacingOccurrencesOfString:"{id}" withString:(postID as text)
	
	--	Construct a URL containing all the query parameters needed to create a Dicourse post
	set apiKeyParam to NSURLQueryItem's queryItemWithName:"api_key" value:APIKEY
	set userParam to NSURLQueryItem's queryItemWithName:"api_username" value:APIUSER
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & endpoint)
	urlComponents's setQueryItems:{apiKeyParam, userParam}
	
	--	Send the get post request to the Discourse site
	set theRequest to NSURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	return theJSON
end getDiscoursePost

on postToDiscourse(postTitle, postCategory, postTags, postMarkdown)
	local theRequest, theResult, theJSONData, theJSON -- so SD can see them
	
	--	AppleScript strings often have CR line endings while Discourse expects LF line endings.  Convert all 
	--	CRs to LFs.
	set postMarkdown to (NSString's stringWithString:postMarkdown)'s ¬
		stringByReplacingOccurrencesOfString:return withString:linefeed
	if postTags = missing value tjem then
		postTags = (NSArray's array)
	else if postTags is not array then
		set postTags to (NSArray's arrayWithObjects:[postTags])
	else
		set postTags to (NSArray's arrayWithObjects:postTags)
	end if
	
	--	Construct a URL containing all the query parameters needed to create a Dicourse post
	set apiKeyParam to NSURLQueryItem's queryItemWithName:"api_key" value:APIKEY
	set userParam to NSURLQueryItem's queryItemWithName:"api_username" value:APIUSER
	set titleParam to NSURLQueryItem's queryItemWithName:"title" value:postTitle
	set categoryParam to NSURLQueryItem's queryItemWithName:"category" value:postCategory
	set tagsParam to NSURLQueryItem's queryItemWithName:"tags" value:postTags
	set rawParam to NSURLQueryItem's queryItemWithName:"raw" value:postMarkdown
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & APIPOSTS_ENDPOINT)
	urlComponents's setQueryItems:{apiKeyParam, userParam, titleParam, categoryParam, tagsParam, rawParam}
	
	--	Send the create post request to the Discourse site
	set theRequest to NSMutableURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	theRequest's setHTTPMethod:"POST"
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	return theJSON
end postToDiscourse
