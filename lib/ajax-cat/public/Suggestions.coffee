class Suggestions

  constructor: (@translation, limit = 5) ->
    i = 0
    while i < limit
      sug = $("<div>"
        class: 'ac-suggestion'
        'data-suggestion-position': i
        click: =>
          @take_suggestion()
        mouseover: (event) =>
          target = $(event.currentTarget)
          if target.hasClass('suggestion-enabled')
            @set_position(target.data('suggestion-position'))
      )
      $("#suggestions-container").append(sug)
      i += 1

    $(window).bind('loadSuggestions'
      =>
        @load_suggestions()
        $("#target-sentence").focus()
    )

  clear: =>
    @suggestion_request.abort() if @suggestion_request
    $(".ac-suggestion").text("")
    $(".ac-suggestion").removeClass('suggestion-enabled')
    $(".ac-suggestion").removeClass('suggestion-active')

  load_suggestions: =>
    @clear()
    return unless @translation.param_suggestion
    sentence = $("#source-sentence").text()
    sentence = Utils.tokenize(sentence)
    translated = Utils.tokenize($("#source-target").text())
    covered = @translation.table.covered_vector()
    @suggestion_request = $.ajax "/api/suggestion"
      data:
        pair: @translation.pair
        q: Utils.tokenize(sentence)
        covered: covered
        translated: translated
      success: (data) =>
        data = JSON.parse(data)
        @process_suggestions(data)
      error: =>
        #alert "failed to load suggestions"

  take_suggestion: =>
    return if (@get_position() == false)
    text = $(".suggestion-active span").text()
    
    from = $(".suggestion-active").data('from')
    to = $(".suggestion-active").data('to')
    @translation.add_words(text)
    #alert "#{from}-#{to}"
    @translation.table.mark_interval(from, to)
    #@translation.table.mark_words(text)


  process_suggestions: (data) =>
    i = 0
    for suggestion in data.suggestions
      translation = $("#target-sentence").val()
      el = $(".ac-suggestion").slice(i, (i + 1))
      el.html("#{translation} <span>#{suggestion.text}</span>")
      el.data('from', suggestion.from)
      el.data('to', suggestion.to)
      el.addClass('suggestion-enabled')
      i += 1

  positions: =>
    return $(".suggestion-enabled").length

  get_position: =>
    el = $(".suggestion-active")
    return false unless el.length
    return el.data('suggestion-position')

  set_position: (position) =>
    $(".suggestion-active").removeClass('suggestion-active')
    $(".suggestion-enabled[data-suggestion-position=#{position}]").addClass('suggestion-active')

  up: =>
    position = @get_position()
    return if position == false
    @set_position(position - 1)

  down: =>
    position = @get_position()
    if position == false
      @set_position(0)
      return
    if (position + 1) < @positions()
      @set_position(position + 1)