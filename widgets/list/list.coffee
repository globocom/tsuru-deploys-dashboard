class Dashing.List extends Dashing.Widget
  onData: (data) ->
  	console.log data.items
  	@set 'items', data.items[0..15]
  ready: ->
    if @get('unordered')
      $(@node).find('ol').remove()
    else
      $(@node).find('ul').remove()
