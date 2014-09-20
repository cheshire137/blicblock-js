class BlockRow
  constructor: ->
    @blocks = []

  append: (block) ->
    @blocks.push block

(exports ? this).BlockRow = BlockRow
