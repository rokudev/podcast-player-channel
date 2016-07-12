Function RSSParse()
       working = GetPodCastInfo(m.feed) 'Was not working as an AA and contentNode wasn't working for URI
       m.glb.Addfield("PodcastTitle", "string", true)
       m.glb.Addfield("uri", "string", true)
       m.glb.Addfield("summary", "string", true)
       m.glb.Addfield("author", "string", true)
       m.glb.PodcastTitle = working["Title"].getText()
       m.glb.uri = working["itunes:image"].getAttributes()["href"]
       if working.DoesExist("tunes:summary")
            m.glb.summary = working["itunes:summary"].getText()
       end if
       m.glb.author = working["itunes:author"].getText()
       
       m.ChildContent = GetEpisodes(m.feed)
       
               
       m.TopContent = createObject("roSGNode", "ContentNode")
       for each item in m.ChildContent
            row = createObject("roSGNode", "ContentNode")
            row.title = item["title"].getText()
            row.ContentType = "audio"
            row.streamFormat = "mp3"
            row.Length = item["itunes:duration"].getText().ToInt()
            if row.Length = 0
                x = item["itunes:duration"].getText().split(":")
                row.Length = x[0].toInt()*360 + x[1].toInt() *60 + x[2].toInt()
            end if
            if item.DoesExist("itunes:summary")
                row.Description = item["itunes:summary"].getText()
            end if    
            row.URL = item["enclosure"].getAttributes()["url"]
            if item.DoesExist("itunes:explicit")
                if  item["itunes:explicit"].getText() = "yes"
                    row.Rating = "R"
                end if
            end if    
            m.TopContent.appendChild(row)
       end for
end Function

Function GetPodCastInfo(PodcastUrl as String) as object'Used to get main info.. Podcast Title, Podcast Artwork, Summary, etc...
    url = createObject("roUrlTransfer")
    url.setUrl(PodcastUrl)
    urlString = url.GetToString()
    
    XML = checkXML(urlString)
    XML = XML.GetChildElements()
    XMLArray = XML.GetChildElements()
    
    result = {}
    
    for each item in XMLArray
        result[item.getName()] = item
    end for
    return result
End Function


Function GetEpisodes(PodcastUrl as String) as object 'Used for episodes, separated for now until Global issue is fixed
    url = createObject("roUrlTransfer")
    url.setUrl(PodcastUrl)
    urlString = url.GetToString()
    
    XML = checkXML(urlString)
    XML = XML.GetChildElements()
    XMLArray = XML.GetChildElements()
    
    episodelist = []
    for each item in XMLArray
        if item.getName() = "item"
        episodes = {}
        episodesArray = item.getChildElements()
        for each episode in episodesArray
            episodes[episode.getName()] = episode
        end for
        episodelist.Unshift(episodes)
        end if
    end for
    return episodelist
End Function


Function checkXML(str as String) as dynamic 'Checks to make sure that feed is working
    if str = invalid return invalid
    xml = createObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function