class AjaxCatList

  constructor: ->
    $('#new-translation-modal').hide()
    $('#new-translation').on('click',@new_translation)
    $('#create-new-translation').on('click',@create_new_translation)
    @show_translations()
    $(".example").click(
      (event) =>
        text = $(event.currentTarget).data("text")
        $('#new-translation-text').val(text)
        return false
    )

  new_translation: =>
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
          @delete_document(id)
          @show_translations()
    )

  delete_document: (id) =>
    return unless localStorage['ac-data']
    ids = JSON.parse(localStorage['ac-data'])
    new_ids = []
    for i in ids
      new_ids.push(i) unless i == id
    localStorage.removeItem(id)
    localStorage.setItem('ac-data', JSON.stringify(new_ids))


  create_new_translation: =>
    text = $('#new-translation-text').val()
    if localStorage['ac-data']
      docs = JSON.parse(localStorage['ac-data'])
    else
      docs = []
    doc = {}
    doc.id = Utils.random_string()
    doc['name'] = $('#new-translation-name').val()
    doc['pair'] = $('#new-translation-pair').val()
    doc.source = Utils.split_source(text)
    doc.target = new Array(doc.source.length)
    docs.push(doc.id)
    localStorage.setItem('ac-data', JSON.stringify(docs))
    localStorage.setItem(doc.id, JSON.stringify(doc))
    $('#new-translation-modal').modal('hide')
    @show_translations()

