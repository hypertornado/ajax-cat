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

  @edit_distance: (source, target) ->
    a = []
    for i in [0..source.length]
      a[i] = new Array(target.length + 1)
      a[i][0] = i
    a[0] = [0..target.length]

    for i in [1..source.length]
      for j in [1..target.length]
        substitute_cost = a[i - 1][j - 1]
        substitute_cost += 1 if (source.charAt(i - 1) != target.charAt(j - 1))
        a[i][j] = Math.min(substitute_cost, a[i-1][j] + 1, a[i][j-1] + 1)
    return a[source.length][target.length]


