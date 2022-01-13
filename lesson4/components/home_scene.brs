function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.videoplayer = m.top.findNode("videoplayer")

	m.category_screen.observeField("category_selected","onCategorySelected")	
	m.content_screen.observeField("content_selected", "onContentSelected")
	m.details_screen.observeField("play_button_pressed", "onPlayButtonPressed")

	m.category_screen.setFocus(true)
end function

sub onPlayButtonPressed(obj)
	m.details_screen.visible = false
	m.videoplayer.visible = true
	m.videoplayer.setFocus(true)
end sub

sub onContentSelected(obj)
    selected_index = obj.getData()
    ? "content selected_index :"; selected_index
    item = m.content_screen.findNode("content_grid").content.getChild(selected_index)
    m.details_screen.content = item
    m.content_screen.visible = false
    m.details_screen.visible = true
end sub

sub onCategorySelected(obj)
    ? "onCategorySelected field: ";obj.getField()
    ? "onCategorySelected data: ";obj.getData()
    list = m.category_screen.findNode("category_list")
    ? "onCategorySelected checkedItem: ";list.checkedItem
    ? "onCategorySelected selected ContentNode: ";list.content.getChild(obj.getData())
    item = list.content.getChild(obj.getData())
    loadFeed(item.feed_url)
end sub

sub loadFeed(url)
  m.feed_task = createObject("roSGNode", "load_feed_task")
  m.feed_task.observeField("response", "onFeedResponse")
  m.feed_task.url = url
  m.feed_task.control = "RUN"
end sub



sub onFeedResponse(obj)
	? "onFeedResponse: "; obj.getData()
	response = obj.getData()
	data = parseJSON(response)
	? "data parsedJSON: "; data
	if data <> Invalid and data.items <> invalid
        m.category_screen.visible = false
        m.content_screen.visible = true
		m.content_screen.feed_data = data
	else
		? "FEED RESPONSE IS EMPTY!"
	end if
end sub


function onKeyEvent(key, press) as Boolean
	? "[home_scene] onKeyEvent", key, press
	if key = "back" and press
		if m.content_screen.visible
			m.content_screen.visible=false
			m.category_screen.visible=true
			m.category_screen.setFocus(true)
			return true		
		else if m.details_screen.visible
			m.details_screen.visible=false
			m.content_screen.visible=true
			m.content_screen.setFocus(true)
			return true
		else if m.videoplayer.visible
			m.videoplayer.visible=false
			m.details_screen.visible=true
			m.details_screen.setFocus(true)
			return true
	
		end if

	end if
 return false
end function
