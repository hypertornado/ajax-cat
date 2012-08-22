class TranslationTable

  constructor: (@translation, data) ->
    @data = JSON.parse(data)
    console.log @data

  get_table: =>
    ret = $("<table>"
      class: 'translation-table'
    )
    ret.append(@get_header())
    for row in @data.table
      ret.append(@get_row(row))
    return ret

  get_header: =>
    ret = $("<tr>")
    i = 0
    for word in @data.source
      src = $("<th>"
        class: 'ac-source'
        html: word
        "data-position": i
        click: (event) =>
          position = parseInt($(event.currentTarget).data('position'))
          if @position_marked(position)
            @unmark_position(position)
          else
            @mark_position(position)
          $(window).trigger('loadSuggestions')
      )
      ret.append(src)
      i += 1
    return ret

  get_row: (row) =>
    ret = $("<tr>")
    i = 0
    for word in row
      len = parseInt(word.w)
      if !word.str
        ret.append("<td colspan='#{len}' class='ac-empty'></td>")
      else
        cell = $("<td colspan='#{len}' class='ac-word'></td>")
        content = $("<div>"
          'data-position-from': i
          'data-position-to': (i + len - 1)
          html: word.str
          click: (event) =>
            i = parseInt($(event.currentTarget).data('position-from'))
            while i <= parseInt($(event.currentTarget).data('position-to'))
              @mark_position(i)
              i += 1
            @translation.add_words($(event.currentTarget).text())
            $(window).trigger('loadSuggestions')
        )
        cell.append(content)
        ret.append(cell)
      i += len
    return ret

  position_marked: (position) =>
    return true if $("th.ac-source").slice(position, (position + 1)).hasClass('ac-selected')
    return false

  #use edit distance to mark written words
  mark_words: (word) =>
    word = Utils.trim word
    best_result = 10000
    best_element = null
    maximal_acceptable_distance = 1
    maximal_acceptable_distance = 0 if word.length < 5
    maximal_acceptable_distance = 2 if word.length > 10
    for el in $(".ac-word div")
      element_text = Utils.trim($(el).text())
      result = Utils.edit_distance(word, element_text)
      if result < best_result
        best_result = result
        best_element = $(el)
    if best_element != null and best_result <= maximal_acceptable_distance
      @mark_interval(best_element.data('position-from'), best_element.data('position-to'))

  #when more words, there should be fix on server side giving most likely continuation
  mark_words_OLD: (words) =>
    console.log "MARKING WORDS: #{words}"
    words = "#{words} "
    for el in $(".ac-word div")
      el_text = Utils.trim $(el).text()
      el_text = "#{el_text} "
      if ((words.indexOf(el_text) == 0) and (words.length >= el_text.length))
        #console.log "#{words}, #{el_text}, #{words.length} , #{el_text.length}"
        @mark_interval($(el).data('position-from'), $(el).data('position-to'))
        $(window).trigger('loadSuggestions')
        words = words.substr(el_text.length)
        words = Utils.trim(words)
        words = "#{words} "
        return unless words.length > 0

  mark_interval: (from, to) =>
    i = from
    while i <= to
      @mark_position(i)
      i += 1

  mark_position: (position) =>
    $("th.ac-source").slice(position, (position + 1)).addClass('ac-selected')

  unmark_position: (position) =>
    $("th.ac-source").slice(position, (position + 1)).removeClass('ac-selected')

  covered_vector: =>
    ret = ""
    for el in $("th.ac-source")
      if $(el).hasClass('ac-selected')
        ret += "1"
      else
        ret += "0"
    return ret
