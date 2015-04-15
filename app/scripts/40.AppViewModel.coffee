class AppViewModel
	suggestionCount: 5
	constructor: ->
		@winner = ko.observable null
		@movies = ko.observableArray []
		@suggestions = ko.observableArray []
		@suggestions.extend({ rateLimit: 50 });
		@remainingSuggestions = ko.computed =>
			@suggestions().filter (suggestion) ->
				!suggestion.eliminated()

		@remainingSuggestions.subscribe (value) =>
			if value.length == 1
				@setWinner value[0]

		# Load from storage
		if not @importFromLocalStorage()
			@movies = ko.observableArray [
				new Movie 'Austin Powers II'
				new Movie 'Austin Powers III'
				new Movie 'Back to the Future'
				new Movie 'The Castle'
				new Movie 'The Devil Wears Prada'
				new Movie 'Die Welle'
				new Movie 'Dr Strangelove'
				new Movie 'Easy A'
				new Movie 'Fight Club'
				new Movie 'Galaxy Quest'
				new Movie 'Ghostbusters'
				new Movie 'Godzilla'
				new Movie 'Groundhog Day'
				new Movie 'Home'
				new Movie 'LEGO Movie'
				new Movie 'Life is Beautiful'
				new Movie 'Looper'
				new Movie 'Magicians'
				new Movie 'Mean Girls'
				new Movie 'Moon'
				new Movie 'Mulan'
				new Movie 'Primer'
				new Movie 'Rush Hour'
				new Movie 'Strictly Ballroom'
				new Movie 'This is Spinal Tap'
				new Movie 'Tripod vs the Dragon'
				new Movie 'Who Framed Roger Rabbit'
				new Movie 'Wreck-It Ralph'
				new Movie 'Young Frankenstein'
			]

		# Initial Save
		@saveToLocalStorage()

		# Save on changes
		@movies.subscribe =>
			@saveToLocalStorage()

		# Sidebar
		@sidebarCollapsed = ko.observable !!@movies().length

		return

	setWinner: (suggestion) ->
		@winner suggestion
		suggestion.movie.watched true

	toggleSlidebar: ->
		@sidebarCollapsed !@sidebarCollapsed()

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


	saveToLocalStorage: ->
		localStorage['movies'] = ko.toJSON @movies

	importFromLocalStorage: ->
		try
			movies = JSON.parse localStorage['movies']
			movies.sort (a, b) ->
				if a.name < b.name
					return -1
				if a.name > b.name
					return 1
				return 0
			for movie in movies
				@movies.push new Movie movie.name, movie.watched
			return true
		catch e
			return false

window.root = new AppViewModel()

ko.applyBindings window.root