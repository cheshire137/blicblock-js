class Block
  constructor: (attribs) ->
    @color = attribs.color
    @x = attribs.x
    @y = attribs.y
    if typeof attribs.locked == 'undefined'
      @locked = false
    else
      @locked = attribs.locked
    if typeof attribs.active == 'undefined'
      @active = true
    else
      @active = attribs.active
    @sliding = false
    @plummetting = false
    @highlight = false
    @id = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c == 'x' then r else (r&0x3|0x8)
      v.toString(16)

(exports ? this).Block = Block
