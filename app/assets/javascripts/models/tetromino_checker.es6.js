class TetrominoChecker {
  constructor(blocks, index) {
    this.index = index
    this.block1 = blocks[this.index]
    this.blocks = blocks.filter(b => {
      return b.color === this.block1.color && b.id !== this.block1.id
    })
    this.tetromino = []
  }

  // Returns true if the block at the given index is part of a tetromino. Sets
  // this.tetromino to an array containing the blocks that make up the
  // tetromino.
  check() {
    if (this.blocks.length < 1) {
      return false
    }
    this.blocks.forEach(block => {
      const xDiff = Math.abs(block.x - this.block1.x)
      const yDiff = Math.abs(block.y - this.block1.y)
      if (block.x === this.block1.x && yDiff <= 3) {
        this.tetromino.push(block)
      } else if (block.y === this.block1.y && xDiff <= 3) {
        this.tetromino.push(block)
      } else if (xDiff <= 2 && yDiff <= 1 || xDiff <= 1 && yDiff <= 2) {
        this.tetromino.push(block)
      }
    })
    if (this.tetromino.length === 3) {
      this.tetromino.push(this.block1)
      return true
    }
    return false
  }
}
