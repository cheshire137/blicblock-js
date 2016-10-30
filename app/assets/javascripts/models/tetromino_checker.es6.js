class TetrominoChecker {
  constructor(blocks, index) {
    this.index = index
    this.block1 = blocks[this.index]
    this.blocks = blocks.filter(b => b.color === this.block1.color)
    this.tetromino = []
  }

  // Returns true if the block at the given index is part of a tetromino. Sets
  // this.tetromino to an array containing the blocks that make up the
  // tetromino.
  check() {
    if (this.blocks.length < 1) {
      return false
    }
  }
}
