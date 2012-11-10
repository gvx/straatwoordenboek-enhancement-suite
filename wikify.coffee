localStorage.wikify_cache ?= '{}'

cache = JSON.parse localStorage.wikify_cache

makeUri = (word) ->
	return "/letter/" + word.substr(0, 1).toUpperCase() + "/" + word

isWord = (word) ->
	return false unless word.match "[a-zA-Z]+"

	word = word.toLowerCase()
	if word not of cache
		client = new XMLHttpRequest()
		client.open "GET", (makeUri word), false
		client.send()
		cache[word] = client.responseText.indexOf('<h3') > -1
	return cache[word]

makeLink = (word) ->
	if isWord word
		"""<a href="#{makeUri word}">#{word}</a>"""
	else
		word

wikify = () ->
	content = document.getElementById 'content'
	text = content.innerHTML
	body = text.split /\<\/h3\>|<!--\<\/form\>/
	for repl in body[1..] by 2
		newrepl = repl.replace /[a-zA-Z]+/g, makeLink
		text = text.replace repl, newrepl
	content.innerHTML = text

wikify()
localStorage.wikify_cache = JSON.stringify cache
