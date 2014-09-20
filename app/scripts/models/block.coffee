class Block
  constructor: (attribs) ->
    @color = attribs.color
    @x = attribs.x
    @y = attribs.y
    @locked = false
    @active = true

(exports ? this).Block = Block
