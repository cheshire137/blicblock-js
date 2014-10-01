class BlockRow
  constructor: (index) ->
    @blocks = []
    @index = index

  append: (block) ->
    @blocks.push block

(exports ? this).BlockRow = BlockRow
