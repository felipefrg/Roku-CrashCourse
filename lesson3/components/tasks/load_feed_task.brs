sub init()
	m.top.functionname = "request"
	m.top.response = ""
end sub

function request()
	url = m.top.url
	? "Feed Task URL: "; url
	m.top.response = "test."
end function
