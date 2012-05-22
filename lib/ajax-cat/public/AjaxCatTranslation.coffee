class AjaxCatTranslation

  cur_position: false

  constructor: ->
    @now = Date.now()
    $('#new-experiment-modal').hide()
    $("#send-experiment").hide()
    @suggestions = new Suggestions(@)
    $('#translation-preview-modal').hide()
    $('#myTab').tab('show')
    @hash = window.location.hash.substr(1)
    data = localStorage.getItem(@hash)
    unless data
      alert "No such document."
      return
    @doc = JSON.parse(data)
    @prepare_test() if @doc.task_id
    @pair = @doc.pair
    $('h1').html("#{@doc.name} <small>#{@pair}</small>")
    $("title").html("#{@doc.name} - AJAX-CAT")
    i = 0
    for s in @doc.source
      $("#source-top").append("<span class='ac-element ac-source' data-position='#{i}'>#{s}</span>")
      $("#source-bottom").append("<span class='ac-element ac-source' data-position='#{i}'>#{s}</span>")
      i += 1
    i = 0
    for t in @doc.target
      t = "" unless t
      $("#target-top").append("<span class='ac-element ac-target' data-position='#{i}'>#{t}</span>")
      $("#target-bottom").append("<span class='ac-element ac-target' data-position='#{i}'>#{t}</span>")
      i += 1
    $('.ac-element').click(
      (event) =>
        position = $(event.target).data('position')
        @change_position(position)
    )
    @length = $("#source-top").children().length
    @change_position(0)
    @bind_events()
    @resize()

  time: =>
    sec = parseInt((Date.now() - @now) / 1000)
    t = "time from start: #{parseInt(sec / 60)}:#{sec % 60}"
    $("#time").html(t)
    setTimeout(@time, 10)

  prepare_test: =>
    AjaxCatList.delete_document(@hash)
    $("#save").hide()
    $("#send-experiment").show()
    $("#send-experiment").click(
      =>
        $("#send-experiment").hide()
        $.ajax "/admin/save_experiment"
          data:
            log: JSON.stringify(@doc)
          type: "post"
          success: =>
            alert "Experiment saved."
            window.location = "/"
          error: =>
            alert "Could not save experiment."
    )
    @doc.log = []
    @time()
    $("#log").append("<h2>Log</h2>")
    @log()

  log: (type = false, param = false) =>
    return unless @doc.task_id
    new_log = (
      time: Date.now()
      target: $("#target-sentence").val()
    )
    new_log.type = type if type
    new_log.param = param if param
    @doc.log.push(new_log)
    $("#log").append(JSON.stringify(new_log) + "<br>")


  resize: =>
    width = $(window).width()
    $("#translation-table-container").width(width - 60)

  bind_events: =>
    $("#target-sentence").on('keyup',
      =>
        @log()
    )
    $("#target-sentence").on('click',
      =>
        @log()
    )
    $("#target-sentence").on('keydown'
      (event) =>
        @log()
        switch event.which
          when 13 #enter
            @suggestions.take_suggestion()
          when 32 #space
            text = $("#target-sentence").val()
            text = Utils.trim text
            if text.length > 0
              ar = text.split(/[ ]+/)
              word = ar[(ar.length - 1)]
              @table.mark_words(word)
          when 33 #pgup
            @change_position(@cur_position - 1) if @cur_position > 0
            return false
          when 34 #pgdown
            @change_position(@cur_position + 1) if (@cur_position + 1) < @length
            return false
          when 38 #up
            @suggestions.up()
          when 40 #down
            @suggestions.down()
          else
            $(window).trigger('loadSuggestions')

    )

    $("#preview").click(
      =>
        @save_target()
        @show_preview()
        return false
    )

    $("#save").click(
      =>
        @save_target()
        alert "Translation was saved into your browser."
    )

  show_preview: =>
    $("#source").text(@doc.source.join(''))
    $("#target").text(@doc.target.join(''))
    $('#translation-preview-modal').modal('show')

  save_target: =>
    $("#target-top .ac-target[data-position=#{@cur_position}]").text($("#target-sentence").val())
    $("#target-bottom .ac-target[data-position=#{@cur_position}]").text($("#target-sentence").val())

    tar = []
    for el in $("#target-top .ac-target")
      tar.push($(el).text())
    @doc.target = tar
    localStorage.setItem(@doc.id, JSON.stringify(@doc))


  load_translation_table: (sentence) =>
    sentence = Utils.tokenize(sentence)
    if sentence.match(/^[\ \t]*$/)
      $("#translation-table-container").html("")
      @suggestions.clear()
      return
    $("#translation-table-container").text("")
    $.ajax "/api/table"
      data:
        pair: @pair
        q: sentence
      success: (data) =>
        @table = new TranslationTable(@, data)
        $("#translation-table-container").html(@table.get_table())
        $(window).trigger('loadSuggestions')
      error: =>
        #alert "failed to load translation table"

  change_position: (position) =>
    @save_target() if @cur_position != false
    $("#source-top").children().slice(0,position).show()
    $("#source-top").children().slice(position,@length).hide()
    $("#source-bottom").children().slice(0,position + 1).hide()
    $("#source-bottom").children().slice(position + 1,@length).show()

    $("#target-top").children().slice(0,position).show()
    $("#target-top").children().slice(position,@length).hide()
    $("#target-bottom").children().slice(0,position + 1).hide()
    $("#target-bottom").children().slice(position + 1,@length).show()

    $("#source-sentence").text($("#source-top .ac-source[data-position=#{position}]").text())
    $("#target-sentence").val($("#target-top .ac-target[data-position=#{position}]").text())
    @cur_position = position
    $("#target-sentence").focus()
    @load_translation_table($("#source-top .ac-source[data-position=#{position}]").text())

  add_words: (words, change_covered = false) =>
    text = $("#target-sentence").val()
    text = Utils.trim(text)
    words = Utils.trim(words)
    text = Utils.trim(text)
    text += " #{words} "
    $("#target-sentence").val(text)
    $("#target-sentence").click()
