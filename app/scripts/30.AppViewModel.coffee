class AppViewModel
	constructor: ->
		@movies = ko.observableArray()

		# Load from storage
		if not @importFromLocalStorage()
			@movies = ko.observableArray [
				new Movie 'Jim'
				new Movie 'Cheese'
				new Movie 'Baked'
				new Movie 'Jumanji'
				new Movie 'Potato', true
				new Movie 'Cranberry', true
			]

		# Initial Save
		@saveToLocalStorage()

		# Save on changes
		@movies.subscribe =>
			@saveToLocalStorage()

		return

	saveToLocalStorage: ->
		localStorage['movies'] = ko.toJSON @movies

	importFromLocalStorage: ->
		try
			movies = JSON.parse localStorage['movies']
			for movie in movies
				@movies.push new Movie movie.name, movie.watched
			return true
		catch e
			return false

window.root = new AppViewModel()

ko.applyBindings window.root