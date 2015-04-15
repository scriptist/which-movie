window.Suggestion = class Suggestion
	constructor: (@movie, eliminated = false) ->
		@eliminated    = ko.observable eliminated

	eliminate: ->
		@eliminated true