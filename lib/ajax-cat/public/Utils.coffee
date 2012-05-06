class Utils

  @random_string: ->
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz"
    ret = ""
    for i in [0..16]
      rnum = Math.floor(Math.random() * chars.length)
      ret += chars.substring(rnum,rnum+1)
    return ret

  @tokenize: (input) =>
    input = input.toLowerCase()
    input = input.replace(/\,/g, " , ")
    input = input.replace(/\./g, " . ")
    input = input.replace(/\n/g, "")
    input = input.replace(/\ \ /g, " ")
    return input

  @split_source: (text) ->
    delimiters = [".","!","?"]
    line = ""
    spliting = false
    firstSplit = false
    input = new Array()
    white = 0
    last = ' '
    for c in text
      #c = text[i]
      if (spliting == true)
          if (c != ' ' && c != '\n' && c != '\t')
            if (white > 0 || last == '\n')
              input[input.length] = line
              line = ""
            spliting = false
          else
            ++white
      line += c
      if (c == '.' || c == '!' || c == '?' || c == '\n')
        spliting = true
        white = 0
      last = c
    input[input.length] = line
    return input

  @trim: (text) =>
    return text.replace(/^\s+|\s+$/g, "")
