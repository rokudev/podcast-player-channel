sub main()
       screen = createObject("roSGScreen")
       port = createObject("roMessagePort")
       screen.setMessagePort(port)
       
       LoadConfig()
       
       m.glb = screen.getGlobalNode()
       m.glb.addField("FF", "int", true)
       m.glb.FF = 0
       m.glb.addField("Rewind", "int", true)
       m.glb.Rewind = 0
      
       m.glb.addField("SummaryColor", "string", true)
       m.glb.SummaryColor = m.SummaryColor
       m.glb.addField("ListColor", "string", true)
       m.glb.ListColor = m.ListColor
       
       RSSParse()
       scene = screen.CreateScene("PodcastScene")
       screen.Show()
       
       scene.listContent = m.TopContent
         
       while true
        msg = wait(0,port)
        if (msg <> invalid)
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.isScreenClosed() then return
            end if
        end if
       end while
End sub


