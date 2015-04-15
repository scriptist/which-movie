window.Suggestion = class Suggestion
	constructor: (@movie, eliminated = false) ->
		@eliminated    = ko.observable eliminated

	toggle: ->
		@eliminated !@eliminated()