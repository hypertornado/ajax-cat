class AjaxCatList

  constructor: ->
    $('#new-translation-modal').hide()
    $('#new-experiment-modal').hide()
    $('#new-translation').on('click',@new_translation)
    $('#create-new-translation').on('click',@create_new_translation)
    @show_translations()
    $(".example").click(
      (event) =>
        text = $(event.currentTarget).data("text")
        $('#new-translation-text').val(text)
        return false
    )
    $("#new-experiment-translation").click(
      =>
        @new_experiment_translation()
    )
    $("#create-new-experiment").click(
      =>
        @create_experiment_translation()
    )

  create_experiment_translation: =>
    email = $("#new-experiment-email").val()
    pair = $("#new-experiment-pair").val()
    filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    unless filter.test(email)
      alert "Write your email, please."
      return
    $.ajax "/admin/get_experiment"
      data:
        email: email
        pair: pair
      success: (data) =>
        data = JSON.parse(data)
        id = @add_translation(data.sentence, "EXPERIMENT ##{data.task_id}, #{data.email}", data.pair, data.task_id, data.email)
        window.location = "/translation.html##{id}"
      error: =>
        alert "Could not find experiment for you."

  new_experiment_translation: =>
    $("#new-experiment-pair").html("")
    $.ajax "/api/info"
      success: (data) =>
        data = JSON.parse(data)
        for p in data.pairs
          $("#new-experiment-pair").append("<option value='#{p}'>#{p}</option>")
        $('#new-experiment-modal').modal('show')

  new_translation: =>
    $("#new-translation-pair").html("")
    $.ajax "/api/info"
      success: (data) =>
        data = JSON.parse(data)
        for p in data.pairs
          $("#new-translation-pair").append("<option value='#{p}'>#{p}</option>")
        $('#new-translation-name').val('Name')
        $('#new-translation-text').val('')
        $('#new-translation-modal').modal('show')
        $('#new-translation-text').focus()

  show_translations: =>
    $("#translation-list").html('')
    return unless localStorage['ac-data']
    ids = JSON.parse(localStorage['ac-data'])
    for i in ids
      doc = JSON.parse(localStorage[i])
      $("#translation-list").append("<tr><td width='100%'><a href='/translation.html##{doc.id}'>#{doc.name}</a></td><td><button data-id='#{doc.id}' class='btn btn-danger btn-mini delete-button'>delete</button></td></tr>")
    $(".delete-button").click(
      (event) =>
        id = $(event.currentTarget).data("id")
        if confirm("Delete this translation?")
          AjaxCatList.delete_document(id)
          @show_translations()
    )

  @delete_document: (id) =>
    return unless localStorage['ac-data']
    ids = JSON.parse(localStorage['ac-data'])
    new_ids = []
    for i in ids
      new_ids.push(i) unless i == id
    localStorage.removeItem(id)
    localStorage.setItem('ac-data', JSON.stringify(new_ids))


  create_new_translation: =>
    text = $('#new-translation-text').val()    
    name = $('#new-translation-name').val()
    pair = $('#new-translation-pair').val()
    @add_translation(text, name, pair)
    $('#new-translation-modal').modal('hide')
    @show_translations()

  add_translation: (text, name, pair, task_id = false, email = false) =>
    if localStorage['ac-data']
      docs = JSON.parse(localStorage['ac-data'])
    else
      docs = []
    doc = {}
    doc.id = Utils.random_string()
    doc.name = name
    doc.pair = pair
    doc.email = email
    doc.task_id = task_id
    doc.source = Utils.split_source(text)
    doc.target = new Array(doc.source.length)
    docs.push(doc.id)
    localStorage.setItem('ac-data', JSON.stringify(docs))
    localStorage.setItem(doc.id, JSON.stringify(doc))
    return doc.id


