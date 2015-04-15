ko.bindingHandlers.movieInput = {
	init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
		# Basic text input stuff
		ko.bindingHandlers.textInput.init.apply this, arguments

		# Add & remove movies
		movie = viewModel
		element.addEventListener 'keydown', (e) ->
			if e.which == 8  # BACKSPACE
				if movie.name().length == 0 and root.movies().length != 1
					i = Math.max 0, (root.movies.indexOf movie) - 1
					root.movies.remove movie
					setTimeout ->
						root.movies()[i].focus()

			if e.which == 13  # ENTER
				root.movies.push new Movie '', false, true

			if e.which == 38  # UP
				i = Math.max 0, (root.movies.indexOf movie) - 1
				setTimeout ->
					root.movies()[i].focus()

			if e.which == 40  # DOWN
				i = Math.min root.movies().length - 1, (root.movies.indexOf movie) + 1
				root.movies()[i].focus()

		# Focus
		if movie.focused()
			element.focus()

		movie.focused.subscribe (value) ->
			if value
				element.focus()
}