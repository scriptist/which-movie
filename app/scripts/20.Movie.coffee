window.Movie = class Movie
	constructor: (name = '', watched = false, focused = false) ->
		@name    = ko.observable name
		@watched = ko.observable watched
		@focused = ko.observable focused
		@focused.extend {notify: 'always'}

		@name.subscribe ->
			root.saveToLocalStorage()
		@watched.subscribe ->
			root.saveToLocalStorage()

	toggle: ->
		@watched !@watched()

	focus: ->
		@focused true