 Function init ()
    m.PodcastArt = m.top.findNode("PodcastArt") 'Album Artwork
    m.Background = m.top.findNode("Background") 'Background Artwork
    m.AlbumPlay = m.top.findNode("AlbumPlay") 'Bottom Playbar Artwork
    
    m.Title = m.top.findNode("Title") 'Title Label
    m.Author = m.top.findNode("Author") 'Author/Artist Label
    
    m.Summary = m.top.findNode("Summary") ' Description/Summary Label under Album Artwork
    m.list = m.top.findNode("EpisodePicker") 'LabelList -- has wrapper class called "MyLabelList.xml
    m.list.color = m.global.ListColor
    m.current = m.top.findNode("PodcastPlaying")
    m.AlbumRect = m.top.findNode("AlbumRect")
    
    m.list.SetFocus(true)
    
    m.PodcastArt.uri = m.global.uri
    m.Background.uri = m.global.uri
    m.AlbumPlay.uri = m.global.uri
    
    m.Summary.text = m.global.summary
    m.Summary.color = m.global.SummaryColor
    m.Title.text = m.global.PodcastTitle
    m.Author.text = m.global.author
    
    m.TimerRect = m.top.findNode("TimeBarFront")
    m.TimerAnim = m.top.findNode("TimerAnim")
    m.TimerInterp = m.top.findNode("TimerInterp")
    m.AudioCurrent = m.top.findNode("AudioCurrent")
    m.AudioDuration = m.top.findNode("AudioDuration")
    m.AudioTime = 0
    
    m.Play = m.top.findNode("Play")
    m.FFAnim = m.top.findNode("FFAnim")
    m.RewindAnim = m.top.findNode("RewindAnim")
    
    m.Audio = createObject("roSGNode", "Audio")
    m.Audio.notificationInterval = 0.1
    m.AudioDuration.text = secondsToMinutes(0)
    m.AudioCurrent.text = secondsToMinutes(0)
    
    m.PlayTime = m.top.findNode("PlayTime")
    m.PlayTime.ObserveField("fire", "TimeUpdate")
    
    m.list.observeField("itemFocused", "setaudio")
    m.list.observeField("itemSelected", "playaudio")
    m.global.observeField("FF", "FF")
    m.global.observeField("Rewind", "Rewind")
end Function

sub FF()
    skip10Seconds(true)
end sub

sub Rewind()
    skip10Seconds(false)
end sub

sub setaudio()
    audiocontent = m.list.content.getChild(m.list.itemFocused)
    m.Summary.text = audiocontent.Description
    m.Audio.content = audiocontent
end sub

sub controlaudioplay()
    if (m.audio.state= "finished")
        m.audio.control = "stop"
        m.audio.control = "none"
    end if
end sub

sub TimeUpdate()
    m.AudioTime += 1
    m.AudioCurrent.text = secondsToMinutes(m.AudioTime)
    if m.AudioTime = m.check
        m.PlayTime.control = "stop"
    end if
end sub

sub playaudio()
    m.audiocontent = m.list.content.getChild(m.list.itemSelected)
    m.check = m.audiocontent.length
    print "this is"m.check
    m.audio.control = "stop"
    m.audio.control = "none"
    m.audio.control = "play"
    m.AlbumRect.opacity = "0.8"
    m.Play.text = "O"
    m.current.text = m.audiocontent.Title
    m.TimerAnim.duration = m.audiocontent.Length
    m.TimerInterp.keyValue = "[0,1470]"
    m.TimerAnim.control = "start"
    m.split = 1470.0/m.audiocontent.Length
    m.AudioDuration.text = secondsToMinutes(m.audiocontent.Length)
    m.PlayTime.control = "start"
    m.AudioTime = 0
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "replay"
            if (m.Audio.state = "playing")
                playaudio()
                
                return true
            end if
        else if key = "play"
            if (m.Audio.state = "playing")
                m.Audio.control = "pause"
                m.TimerAnim.control = "pause"
                m.PlayTime.control = "stop"
                m.Play.text = "N"
            else
                m.Audio.control = "resume"
                m.TimerAnim.control = "resume"
                m.PlayTime.control = "start"
                m.Play.text = "O"
            end if
                return true
        else if key = "right"
                skip10Seconds(true)
                return true
        else if key = "left"
                skip10Seconds(false)
                return true
        end if
    end if
end Function

sub skip10Seconds(forward as Boolean)
    if forward then
        if (m.check - 10) > m.AudioTime
            print m.check
            m.AudioTime += 10
            m.TimerInterp.KeyValue = [m.TimerRect.width + m.split*10, 1470]
            m.TimerAnim.duration = m.check - (m.AudioTime + 10)
            m.FFAnim.control = "start"
            m.Audio.seek = m.AudioTime
            m.TimerAnim.control = "start"
            print "1"
        else
            print m.AudioTime
            m.AudioTime = m.check
            m.AudioCurrent.text = secondsToMinutes(m.check)
            m.TimerAnim.control = "stop"
            m.TimerRect.width = 1470
            m.FFAnim.control = "start"
            m.PlayTime.control = "stop"
            m.Audio.seek = m.AudioTime
            print m.check
            print "2"
                
        end if
    else 
        if m.AudioTime > 10
            m.AudioTime -= 10
            m.TimerInterp.KeyValue = [m.TimerRect.width - m.split*10, 1470]
            m.TimerAnim.duration = m.check - (m.AudioTime - 10)
            m.RewindAnim.control = "start"
            m.PlayTime.control = "start"
            m.Audio.seek = m.AudioTime
            m.TimerAnim.control = "start"
            print "3"
        else
            m.AudioTime = 0
            m.TimerInterp.KeyValue = [0, 1470]
            m.TimerAnim.duration = m.check
            m.TimerAnim.control = "start"
            m.RewindAnim.control = "start"
            m.PlayTime.control = "start"
            m.Audio.seek = m.AudioTime
            print "4"
        end if
    end if
end sub

Function secondsToMinutes(seconds as integer) as String
    x = seconds\60
    y = seconds MOD 60
    if y < 10
        y = y.toStr()
        y = "0"+y
    else
        y = y.toStr()
    end if
    result = x.toStr()
    result = result +":"+ y
    return result
end Function