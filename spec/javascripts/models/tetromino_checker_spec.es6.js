describe('TetrominoChecker', () => {
  it('starts with no tetromino blocks', () => {
    const checker = new TetrominoChecker([], 0)
    expect(checker.tetromino).toEqual([])
  })

  it('returns false when no blocks are given', () => {
    const checker = new TetrominoChecker([], 0)
    expect(checker.check()).toEqual(false)
  })

  it('filters out blocks of a different color', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 0, y: 1, color: 'magenta' })
    const b3 = new Block({ x: 0, y: 2, color: 'white' })
    const b4 = new Block({ x: 0, y: 3, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.blocks.length).toEqual(1)
    expect(checker.blocks[0].id).toEqual(b4.id)
  })

  // 1***
  it('returns true when straight horizontal tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 0, y: 1, color: 'blue' })
    const b3 = new Block({ x: 0, y: 2, color: 'blue' })
    const b4 = new Block({ x: 0, y: 3, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  // 1
  // *
  // *
  // *
  it('returns true when straight vertical tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 2, y: 0, color: 'blue' })
    const b4 = new Block({ x: 3, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  // 1*
  // **
  it('returns true when square tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 0, y: 1, color: 'blue' })
    const b3 = new Block({ x: 1, y: 0, color: 'blue' })
    const b4 = new Block({ x: 1, y: 1, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  //  1       1*
  //  *  1    *   **1
  // **  ***  *     *
  // A   B    C   D
  it('returns true when left L A tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 1, color: 'blue' })
    const b2 = new Block({ x: 1, y: 1, color: 'blue' })
    const b3 = new Block({ x: 2, y: 0, color: 'blue' })
    const b4 = new Block({ x: 2, y: 1, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when left L B tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 1, y: 2, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when left L C tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 0, y: 1, color: 'blue' })
    const b3 = new Block({ x: 1, y: 0, color: 'blue' })
    const b4 = new Block({ x: 2, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when left L D tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 2, color: 'blue' })
    const b2 = new Block({ x: 1, y: 2, color: 'blue' })
    const b3 = new Block({ x: 0, y: 1, color: 'blue' })
    const b4 = new Block({ x: 0, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  // 1        *1
  // *     1   *  1**
  // **  ***   *  *
  // A   B     C  D
  it('returns true when right L A tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 2, y: 0, color: 'blue' })
    const b4 = new Block({ x: 2, y: 1, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when right L B tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 2, color: 'blue' })
    const b2 = new Block({ x: 1, y: 2, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 1, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when right L C tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 1, color: 'blue' })
    const b2 = new Block({ x: 0, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 2, y: 1, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when right L D tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 0, y: 1, color: 'blue' })
    const b4 = new Block({ x: 0, y: 2, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  //           1    1
  // *1    1*  **  **
  //  **  **    *  *
  //  A   B    C   D
  it('returns true when Z A tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 1, color: 'blue' })
    const b2 = new Block({ x: 0, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 0, color: 'blue' })
    const b4 = new Block({ x: 1, y: 2, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when Z B tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 1, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 0, y: 2, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when Z C tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 0, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 2, y: 1, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  it('returns true when Z D tetromino exists', () => {
    const b1 = new Block({ x: 0, y: 1, color: 'blue' })
    const b2 = new Block({ x: 1, y: 0, color: 'blue' })
    const b3 = new Block({ x: 1, y: 1, color: 'blue' })
    const b4 = new Block({ x: 2, y: 0, color: 'blue' })
    const blocks = [b1, b2, b3, b4]
    const checker = new TetrominoChecker(blocks, 0)
    expect(checker.check()).toEqual(true)
  })

  // 1    1
  // **  **   1   *1*
  // *    *  ***   *
  // A    B   C    D
  it('returns true when T A tetromino exists')
  it('returns true when T B tetromino exists')
  it('returns true when T C tetromino exists')
  it('returns true when T D tetromino exists')
})
