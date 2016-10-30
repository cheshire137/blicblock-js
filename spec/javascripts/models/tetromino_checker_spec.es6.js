describe('TetrominoChecker', () => {
  it('starts with no tetromino blocks', () => {
    const checker = new TetrominoChecker([], 0)
    expect(checker.tetromino).toEqual([])
  })

  it('returns false when no blocks are given', () => {
    const checker = new TetrominoChecker([], 0)
    expect(checker.check()).toEqual(false)
  })

  it('returns true when straight horizontal tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 0, y: 1, color: 'blue' })
    const b3 = new Block({ x: 0, y: 2, color: 'blue' })
    const b4 = new Block({ x: 0, y: 3, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when straight vertical tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 2, y: 0, color: 'blue' })
    const b4 = new Block({ x: 3, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })
})
