class AppViewModel
	suggestionCount: 5
	constructor: ->
		@movies = ko.observableArray()
		@suggestions = ko.observableArray()

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

	shuffleArray: (a) ->
		i = a.length
		while --i > 0
			j = ~~(Math.random() * (i + 1))
			t = a[j]
			a[j] = a[i]
			a[i] = t
		a

	generateSuggestions: ->
		unwatchedMovies = @movies().filter (movie) ->
			!movie.watched()

		if unwatchedMovies.length <= @suggestionCount
			return alert "The list should contain more than #{@suggestionCount} unwatched movies."

		shuffled = @shuffleArray unwatchedMovies
		chosen = shuffled.slice 0, @suggestionCount

		for movie in chosen
			@suggestions.push new Suggestion movie
		console.log @suggestions()


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