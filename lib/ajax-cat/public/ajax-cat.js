var AjaxCatList, AjaxCatTranslation, Suggestions, TranslationTable, Utils,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

AjaxCatList = (function() {

  function AjaxCatList() {
    this.create_new_translation = __bind(this.create_new_translation, this);
    this.delete_document = __bind(this.delete_document, this);
    this.show_translations = __bind(this.show_translations, this);
    this.new_translation = __bind(this.new_translation, this);
    var _this = this;
    $('#new-translation-modal').hide();
    $('#new-translation').on('click', this.new_translation);
    $('#create-new-translation').on('click', this.create_new_translation);
    this.show_translations();
    $(".example").click(function(event) {
      var text;
      text = $(event.currentTarget).data("text");
      $('#new-translation-text').val(text);
      return false;
    });
  }

  AjaxCatList.prototype.new_translation = function() {
    $('#new-translation-name').val('Name');
    $('#new-translation-text').val('');
    $('#new-translation-modal').modal('show');
    return $('#new-translation-text').focus();
  };

  AjaxCatList.prototype.show_translations = function() {
    var doc, i, ids, _i, _len,
      _this = this;
    $("#translation-list").html('');
    if (!localStorage['ac-data']) return;
    ids = JSON.parse(localStorage['ac-data']);
    for (_i = 0, _len = ids.length; _i < _len; _i++) {
      i = ids[_i];
      doc = JSON.parse(localStorage[i]);
      $("#translation-list").append("<tr><td width='100%'><a href='/translation.html#" + doc.id + "'>" + doc.name + "</a></td><td><button data-id='" + doc.id + "' class='btn btn-danger btn-mini delete-button'>delete</button></td></tr>");
    }
    return $(".delete-button").click(function(event) {
      var id;
      id = $(event.currentTarget).data("id");
      if (confirm("Delete this translation?")) {
        _this.delete_document(id);
        return _this.show_translations();
      }
    });
  };

  AjaxCatList.prototype.delete_document = function(id) {
    var i, ids, new_ids, _i, _len;
    if (!localStorage['ac-data']) return;
    ids = JSON.parse(localStorage['ac-data']);
    new_ids = [];
    for (_i = 0, _len = ids.length; _i < _len; _i++) {
      i = ids[_i];
      if (i !== id) new_ids.push(i);
    }
    localStorage.removeItem(id);
    return localStorage.setItem('ac-data', JSON.stringify(new_ids));
  };

  AjaxCatList.prototype.create_new_translation = function() {
    var doc, docs, text;
    text = $('#new-translation-text').val();
    if (localStorage['ac-data']) {
      docs = JSON.parse(localStorage['ac-data']);
    } else {
      docs = [];
    }
    doc = {};
    doc.id = Utils.random_string();
    doc['name'] = $('#new-translation-name').val();
    doc['pair'] = $('#new-translation-pair').val();
    doc.source = Utils.split_source(text);
    doc.target = new Array(doc.source.length);
    docs.push(doc.id);
    localStorage.setItem('ac-data', JSON.stringify(docs));
    localStorage.setItem(doc.id, JSON.stringify(doc));
    $('#new-translation-modal').modal('hide');
    return this.show_translations();
  };

  return AjaxCatList;

})();

AjaxCatTranslation = (function() {

  AjaxCatTranslation.prototype.cur_position = false;

  AjaxCatTranslation.prototype.pair = "en-cs";

  AjaxCatTranslation.prototype.host = "localhost";

  function AjaxCatTranslation() {
    this.add_words = __bind(this.add_words, this);
    this.change_position = __bind(this.change_position, this);
    this.load_translation_table = __bind(this.load_translation_table, this);
    this.save_target = __bind(this.save_target, this);
    this.show_preview = __bind(this.show_preview, this);
    this.bind_events = __bind(this.bind_events, this);
    this.resize = __bind(this.resize, this);
    var data, hash, i, s, t, _i, _j, _len, _len2, _ref, _ref2,
      _this = this;
    this.host = window.location.hostname;
    this.suggestions = new Suggestions(this);
    $('#translation-preview-modal').hide();
    $('#myTab').tab('show');
    hash = window.location.hash.substr(1);
    data = localStorage.getItem(hash);
    if (!data) {
      alert("No such document.");
      return;
    }
    this.doc = JSON.parse(data);
    this.pair = this.doc.pair;
    $('h1').html("" + this.doc.name + " <small>" + this.pair + "</small>");
    $("title").html("" + this.doc.name + " - AJAX-CAT");
    i = 0;
    _ref = this.doc.source;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      s = _ref[_i];
      $("#source-top").append("<span class='ac-element ac-source' data-position='" + i + "'>" + s + "</span>");
      $("#source-bottom").append("<span class='ac-element ac-source' data-position='" + i + "'>" + s + "</span>");
      i += 1;
    }
    i = 0;
    _ref2 = this.doc.target;
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      t = _ref2[_j];
      if (!t) t = "";
      $("#target-top").append("<span class='ac-element ac-target' data-position='" + i + "'>" + t + "</span>");
      $("#target-bottom").append("<span class='ac-element ac-target' data-position='" + i + "'>" + t + "</span>");
      i += 1;
    }
    $('.ac-element').click(function(event) {
      var position;
      position = $(event.target).data('position');
      return _this.change_position(position);
    });
    this.length = $("#source-top").children().length;
    this.change_position(0);
    this.bind_events();
    this.resize();
  }

  AjaxCatTranslation.prototype.resize = function() {
    var width;
    width = $(window).width();
    return $("#translation-table-container").width(width - 60);
  };

  AjaxCatTranslation.prototype.bind_events = function() {
    var _this = this;
    $("#target-sentence").on('keydown', function(event) {
      var ar, text, word;
      switch (event.which) {
        case 13:
          return _this.suggestions.take_suggestion();
        case 32:
          text = $("#target-sentence").val();
          text = Utils.trim(text);
          if (text.length > 0) {
            ar = text.split(/[ ]+/);
            word = ar[ar.length - 1];
            return _this.table.mark_words(word);
          }
          break;
        case 33:
          if (_this.cur_position > 0) {
            _this.change_position(_this.cur_position - 1);
          }
          return false;
        case 34:
          if ((_this.cur_position + 1) < _this.length) {
            _this.change_position(_this.cur_position + 1);
          }
          return false;
        case 38:
          return _this.suggestions.up();
        case 40:
          return _this.suggestions.down();
        default:
          return $(window).trigger('loadSuggestions');
      }
    });
    $("#preview").click(function() {
      _this.save_target();
      _this.show_preview();
      return false;
    });
    return $("#save").click(function() {
      _this.save_target();
      return alert("Translation was saved into your browser.");
    });
  };

  AjaxCatTranslation.prototype.show_preview = function() {
    $("#source").text(this.doc.source.join(''));
    $("#target").text(this.doc.target.join(''));
    return $('#translation-preview-modal').modal('show');
  };

  AjaxCatTranslation.prototype.save_target = function() {
    var el, tar, _i, _len, _ref;
    $("#target-top .ac-target[data-position=" + this.cur_position + "]").text($("#target-sentence").val());
    $("#target-bottom .ac-target[data-position=" + this.cur_position + "]").text($("#target-sentence").val());
    tar = [];
    _ref = $("#target-top .ac-target");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      tar.push($(el).text());
    }
    this.doc.target = tar;
    return localStorage.setItem(this.doc.id, JSON.stringify(this.doc));
  };

  AjaxCatTranslation.prototype.load_translation_table = function(sentence) {
    var _this = this;
    sentence = Utils.tokenize(sentence);
    if (sentence.match(/^[\ \t]*$/)) {
      $("#translation-table-container").html("");
      this.suggestions.clear();
      return;
    }
    $("#translation-table-container").text("");
    return $.ajax("http://" + this.host + ":8888/table", {
      data: {
        pair: this.pair,
        q: sentence
      },
      success: function(data) {
        _this.table = new TranslationTable(_this, data);
        $("#translation-table-container").html(_this.table.get_table());
        return $(window).trigger('loadSuggestions');
      },
      error: function() {}
    });
  };

  AjaxCatTranslation.prototype.change_position = function(position) {
    if (this.cur_position !== false) this.save_target();
    $("#source-top").children().slice(0, position).show();
    $("#source-top").children().slice(position, this.length).hide();
    $("#source-bottom").children().slice(0, position + 1).hide();
    $("#source-bottom").children().slice(position + 1, this.length).show();
    $("#target-top").children().slice(0, position).show();
    $("#target-top").children().slice(position, this.length).hide();
    $("#target-bottom").children().slice(0, position + 1).hide();
    $("#target-bottom").children().slice(position + 1, this.length).show();
    $("#source-sentence").text($("#source-top .ac-source[data-position=" + position + "]").text());
    $("#target-sentence").val($("#target-top .ac-target[data-position=" + position + "]").text());
    this.cur_position = position;
    $("#target-sentence").focus();
    return this.load_translation_table($("#source-top .ac-source[data-position=" + position + "]").text());
  };

  AjaxCatTranslation.prototype.add_words = function(words, change_covered) {
    var text;
    if (change_covered == null) change_covered = false;
    text = $("#target-sentence").val();
    text = Utils.trim(text);
    words = Utils.trim(words);
    text = Utils.trim(text);
    text += " " + words + " ";
    $("#target-sentence").val(text);
    return $("#target-sentence").click();
  };

  return AjaxCatTranslation;

})();

Suggestions = (function() {

  function Suggestions(translation, limit) {
    var i, sug,
      _this = this;
    this.translation = translation;
    if (limit == null) limit = 5;
    this.down = __bind(this.down, this);
    this.up = __bind(this.up, this);
    this.set_position = __bind(this.set_position, this);
    this.get_position = __bind(this.get_position, this);
    this.positions = __bind(this.positions, this);
    this.process_suggestions = __bind(this.process_suggestions, this);
    this.take_suggestion = __bind(this.take_suggestion, this);
    this.load_suggestions = __bind(this.load_suggestions, this);
    this.clear = __bind(this.clear, this);
    i = 0;
    while (i < limit) {
      sug = $("<div>", {
        "class": 'ac-suggestion',
        'data-suggestion-position': i,
        click: function() {
          return _this.take_suggestion();
        },
        mouseover: function(event) {
          var target;
          target = $(event.currentTarget);
          if (target.hasClass('suggestion-enabled')) {
            return _this.set_position(target.data('suggestion-position'));
          }
        }
      });
      $("#suggestions-container").append(sug);
      i += 1;
    }
    $(window).bind('loadSuggestions', function() {
      _this.load_suggestions();
      return $("#target-sentence").focus();
    });
  }

  Suggestions.prototype.clear = function() {
    $(".ac-suggestion").text("");
    $(".ac-suggestion").removeClass('suggestion-enabled');
    return $(".ac-suggestion").removeClass('suggestion-active');
  };

  Suggestions.prototype.load_suggestions = function() {
    var covered, sentence, translated,
      _this = this;
    this.clear();
    sentence = $("#source-sentence").text();
    sentence = Utils.tokenize(sentence);
    translated = Utils.tokenize($("#source-target").text());
    covered = this.translation.table.covered_vector();
    return $.ajax("http://" + this.translation.host + ":8888/suggestion", {
      data: {
        pair: this.translation.pair,
        q: Utils.tokenize(sentence),
        covered: covered,
        translated: translated
      },
      success: function(data) {
        data = JSON.parse(data);
        return _this.process_suggestions(data);
      },
      error: function() {}
    });
  };

  Suggestions.prototype.take_suggestion = function() {
    var text;
    if (this.get_position() === false) return;
    text = $(".suggestion-active span").text();
    this.translation.add_words(text);
    return this.translation.table.mark_words(text);
  };

  Suggestions.prototype.process_suggestions = function(data) {
    var el, i, suggestion, translation, _i, _len, _ref, _results;
    i = 0;
    _ref = data.suggestions;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      suggestion = _ref[_i];
      translation = $("#target-sentence").val();
      el = $(".ac-suggestion").slice(i, i + 1);
      el.html("" + translation + " <span>" + suggestion + "</span>");
      el.addClass('suggestion-enabled');
      _results.push(i += 1);
    }
    return _results;
  };

  Suggestions.prototype.positions = function() {
    return $(".suggestion-enabled").length;
  };

  Suggestions.prototype.get_position = function() {
    var el;
    el = $(".suggestion-active");
    if (!el.length) return false;
    return el.data('suggestion-position');
  };

  Suggestions.prototype.set_position = function(position) {
    $(".suggestion-active").removeClass('suggestion-active');
    return $(".suggestion-enabled[data-suggestion-position=" + position + "]").addClass('suggestion-active');
  };

  Suggestions.prototype.up = function() {
    var position;
    position = this.get_position();
    if (position === false) return;
    return this.set_position(position - 1);
  };

  Suggestions.prototype.down = function() {
    var position;
    position = this.get_position();
    if (position === false) {
      this.set_position(0);
      return;
    }
    if ((position + 1) < this.positions()) return this.set_position(position + 1);
  };

  return Suggestions;

})();

TranslationTable = (function() {

  function TranslationTable(translation, data) {
    this.translation = translation;
    this.covered_vector = __bind(this.covered_vector, this);
    this.unmark_position = __bind(this.unmark_position, this);
    this.mark_position = __bind(this.mark_position, this);
    this.mark_interval = __bind(this.mark_interval, this);
    this.mark_words = __bind(this.mark_words, this);
    this.position_marked = __bind(this.position_marked, this);
    this.get_row = __bind(this.get_row, this);
    this.get_header = __bind(this.get_header, this);
    this.get_table = __bind(this.get_table, this);
    this.data = JSON.parse(data);
  }

  TranslationTable.prototype.get_table = function() {
    var ret, row, _i, _len, _ref;
    ret = $("<table>", {
      "class": 'translation-table'
    });
    ret.append(this.get_header());
    _ref = this.data.target;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      row = _ref[_i];
      ret.append(this.get_row(row));
    }
    return ret;
  };

  TranslationTable.prototype.get_header = function() {
    var i, ret, src, word, _i, _len, _ref,
      _this = this;
    ret = $("<tr>");
    i = 0;
    _ref = this.data.source;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      word = _ref[_i];
      src = $("<th>", {
        "class": 'ac-source',
        html: word,
        "data-position": i,
        click: function(event) {
          var position;
          position = parseInt($(event.currentTarget).data('position'));
          if (_this.position_marked(position)) {
            _this.unmark_position(position);
          } else {
            _this.mark_position(position);
          }
          return $(window).trigger('loadSuggestions');
        }
      });
      ret.append(src);
      i += 1;
    }
    return ret;
  };

  TranslationTable.prototype.get_row = function(row) {
    var cell, content, i, len, ret, word, _i, _len,
      _this = this;
    ret = $("<tr>");
    i = 0;
    for (_i = 0, _len = row.length; _i < _len; _i++) {
      word = row[_i];
      len = parseInt(word.s);
      if (word.empty) {
        ret.append("<td colspan='" + word.s + "' class='ac-empty'></td>");
      } else {
        cell = $("<td colspan='" + word.s + "' class='ac-word'></td>");
        content = $("<div>", {
          'data-position-from': i,
          'data-position-to': i + len - 1,
          html: word.t,
          click: function(event) {
            i = parseInt($(event.currentTarget).data('position-from'));
            while (i <= parseInt($(event.currentTarget).data('position-to'))) {
              _this.mark_position(i);
              i += 1;
            }
            _this.translation.add_words($(event.currentTarget).text());
            return $(window).trigger('loadSuggestions');
          }
        });
        cell.append(content);
        ret.append(cell);
      }
      i += len;
    }
    return ret;
  };

  TranslationTable.prototype.position_marked = function(position) {
    if ($("th.ac-source").slice(position, position + 1).hasClass('ac-selected')) {
      return true;
    }
    return false;
  };

  TranslationTable.prototype.mark_words = function(words) {
    var el, el_text, _i, _len, _ref;
    words = "" + words + " ";
    _ref = $(".ac-word div");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      el_text = Utils.trim($(el).text());
      el_text = "" + el_text + " ";
      if ((words.indexOf(el_text) === 0) && (words.length >= el_text.length)) {
        this.mark_interval($(el).data('position-from'), $(el).data('position-to'));
        $(window).trigger('loadSuggestions');
        words = words.substr(el_text.length);
        words = Utils.trim(words);
        words = "" + words + " ";
        if (!(words.length > 0)) return;
      }
    }
  };

  TranslationTable.prototype.mark_interval = function(from, to) {
    var i, _results;
    i = from;
    _results = [];
    while (i <= to) {
      this.mark_position(i);
      _results.push(i += 1);
    }
    return _results;
  };

  TranslationTable.prototype.mark_position = function(position) {
    return $("th.ac-source").slice(position, position + 1).addClass('ac-selected');
  };

  TranslationTable.prototype.unmark_position = function(position) {
    return $("th.ac-source").slice(position, position + 1).removeClass('ac-selected');
  };

  TranslationTable.prototype.covered_vector = function() {
    var el, ret, _i, _len, _ref;
    ret = "";
    _ref = $("th.ac-source");
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      el = _ref[_i];
      if ($(el).hasClass('ac-selected')) {
        ret += "1";
      } else {
        ret += "0";
      }
    }
    return ret;
  };

  return TranslationTable;

})();

Utils = (function() {

  function Utils() {}

  Utils.random_string = function() {
    var chars, i, ret, rnum;
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
    ret = "";
    for (i = 0; i <= 16; i++) {
      rnum = Math.floor(Math.random() * chars.length);
      ret += chars.substring(rnum, rnum + 1);
    }
    return ret;
  };

  Utils.tokenize = function(input) {
    input = input.toLowerCase();
    input = input.replace(/\,/g, " , ");
    input = input.replace(/\./g, " . ");
    input = input.replace(/\n/g, "");
    input = input.replace(/\ \ /g, " ");
    return input;
  };

  Utils.split_source = function(text) {
    var c, delimiters, firstSplit, input, last, line, spliting, white, _i, _len;
    delimiters = [".", "!", "?"];
    line = "";
    spliting = false;
    firstSplit = false;
    input = new Array();
    white = 0;
    last = ' ';
    for (_i = 0, _len = text.length; _i < _len; _i++) {
      c = text[_i];
      if (spliting === true) {
        if (c !== ' ' && c !== '\n' && c !== '\t') {
          if (white > 0 || last === '\n') {
            input[input.length] = line;
            line = "";
          }
          spliting = false;
        } else {
          ++white;
        }
      }
      line += c;
      if (c === '.' || c === '!' || c === '?' || c === '\n') {
        spliting = true;
        white = 0;
      }
      last = c;
    }
    input[input.length] = line;
    return input;
  };

  Utils.trim = function(text) {
    return text.replace(/^\s+|\s+$/g, "");
  };

  return Utils;

}).call(this);
