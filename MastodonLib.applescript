use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use scripting additions

-- Mastodon App Configuration - https://mastodon.example/settings/applications (replace with your instance's domain)
property APIDOMAIN : "https://mastodon.example" -- your Mastodon instance's URL
property APICLIENT_KEY : "client key" -- your Mastodon App's client key
property APICLIENT_SECRET : "client secret" -- your Mastodon App's client secret
property APIACCESS_TOKEN : missing value -- your Mastodon App's access token OR missing value (get new access token for each use)

-- classes, constants, and enums used
property NSJSONSerialization : a reference to current application's NSJSONSerialization
property NSData : a reference to current application's NSData
property NSString : a reference to current application's NSString
property NSURL : a reference to current application's NSURL
property NSURLRequestReloadIgnoringLocalCacheData : a reference to current application's NSURLRequestReloadIgnoringLocalCacheData
property NSMutableURLRequest : a reference to current application's NSMutableURLRequest
property NSURLConnection : a reference to current application's NSURLConnection
property NSURLComponents : a reference to current application's NSURLComponents
property NSURLQueryItem : a reference to current application's NSURLQueryItem
property NSUTF8StringEncoding : a reference to current application's NSUTF8StringEncoding

-- state
property accessToken : missing value

-- testing...
--getHomeTimeline()
--getHashtagTimeline("lego")
--postStatus("Test post from AppleScript", missing value, "private") -- use "public" to make the post visible
--
--set maxStatusID to missing value
--repeat
--	set statusItems to getHomeTimeline(maxStatusID, missing value, missing value, missing value)
--	set statusItemsCount to count of statusItems
--	if statusItemsCount = 0 then
--		exit repeat
--	else
--		set maxStatusID to ((last item of statusItems)'s objectForKey:"id") as text
--
--		-- do something with the statusItems array of status entries		
--	end if
--end repeat

on getAccessToken()
	--	If we have an accesss token for the Mastodon App, use that
	if APIACCESS_TOKEN is not missing value then
		return APIACCESS_TOKEN
	end if
	--	Otherwiae, request a new access token
	if accessToken is missing value then
		--	Get OAuth2 access token
		--
		--	See https://docs.joinmastodon.org/client/token/#flow
		
		local theRequest, theResult, theJSONData, theJSON -- so SD can see them
		
		--	Construct a URL containing all the query parameters needed to create an access token
		set clientIdParam to NSURLQueryItem's queryItemWithName:"client_id" value:APICLIENT_KEY
		set clientSecretParam to NSURLQueryItem's queryItemWithName:"client_secret" value:APICLIENT_SECRET
		set redirectURIParam to NSURLQueryItem's queryItemWithName:"redirect_uri" value:"urn:ietf:wg:oauth:2.0:oob"
		set grantTypeParam to NSURLQueryItem's queryItemWithName:"grant_type" value:"client_credentials"
		
		set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & "/oauth/token")
		urlComponents's setQueryItems:{clientIdParam, clientSecretParam, redirectURIParam, grantTypeParam}
		
		--	Send the create post request to the Discourse site
		set theRequest to NSMutableURLRequest's requestWithURL:(urlComponents's |URL|) ¬
			cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
		theRequest's setHTTPMethod:"POST"
		set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
			returningResponse:(reference) |error|:(missing value)
		set theJSONData to item 1 of theResult
		set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
		set accessToken to (theJSON's objectForKey:"access_token") as text
	end if
	
	return accessToken
end getAccessToken


on getHomeTimeline(maxID, minID, sinceID, limit)
	-- See https://docs.joinmastodon.org/methods/timelines/#home
	local theJSON, params -- so SD can see them
	
	set params to {}
	if maxID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"max_id" value:maxID
	if minID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"min_id" value:minID
	if sinceID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"since_id" value:sinceID
	if limit is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"limit" value:limit
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & "/api/v1/timelines/home")
	urlComponents's setQueryItems:params
	
	--	Send the get catagories request to the Discourse site
	set theRequest to NSMutableURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	
	theRequest's setValue:("Bearer " & getAccessToken()) forHTTPHeaderField:"Authorization"
	theRequest's setValue:"application/json;charset=utf-8" forHTTPHeaderField:"Content-Type"
	
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	return theJSON -- list of status (up to 20 by default)
end getHomeTimeline


on getHashtagTimeline(hashtag, maxID, minID, sinceID, limit)
	-- See https://docs.joinmastodon.org/methods/timelines/#tag
	local theJSON -- so SD can see them
	
	set params to {}
	if maxID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"max_id" value:maxID
	if minID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"min_id" value:minID
	if sinceID is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"since_id" value:sinceID
	if limit is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"limit" value:limit
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & "/api/v1/timelines/home")
	urlComponents's setQueryItems:params
	
	--	Send the get catagories request to the Discourse site
	set theRequest to NSMutableURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	
	theRequest's setValue:("Bearer " & getAccessToken()) forHTTPHeaderField:"Authorization"
	theRequest's setValue:"application/json;charset=utf-8" forHTTPHeaderField:"Content-Type"
	
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	return theJSON -- list of status (up to 20 by default)
end getHashtagTimeline


on postStatus(status, contentWarning, visibility)
	-- See https://docs.joinmastodon.org/methods/statuses/#create
	local theRequest, theResult, theJSONData, theJSON -- so SD can see them
	
	if visibility is missing value then set visibility to "public"
	
	--	Construct a URL containing all the query parameters needed to create a Dicourse post
	set params to {}
	set end of params to NSURLQueryItem's queryItemWithName:"status" value:status
	set end of params to NSURLQueryItem's queryItemWithName:"visibility" value:visibility
	if contentWarning is not missing value then set end of params to NSURLQueryItem's queryItemWithName:"spoiler_text" value:contentWarning
	
	set urlComponents to NSURLComponents's componentsWithString:(APIDOMAIN & "/api/v1/statuses")
	urlComponents's setQueryItems:params
	
	--	Send the create post request to the Discourse site
	set theRequest to NSMutableURLRequest's requestWithURL:(urlComponents's |URL|) ¬
		cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10
	theRequest's setHTTPMethod:"POST"
	theRequest's setValue:("Bearer " & getAccessToken()) forHTTPHeaderField:"Authorization"
	theRequest's setValue:"application/json;charset=utf-8" forHTTPHeaderField:"Content-Type"
	set theResult to NSURLConnection's sendSynchronousRequest:theRequest ¬
		returningResponse:(reference) |error|:(missing value)
	set theJSONData to item 1 of theResult
	set theJSON to NSJSONSerialization's JSONObjectWithData:theJSONData options:0 |error|:(missing value)
	
	return theJSON -- dictionary of newly created post
end postStatus
