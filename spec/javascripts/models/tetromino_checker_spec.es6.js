describe('TetrominoChecker', () => {
  it('starts with no tetromino blocks', () => {
    const checker = new TetrominoChecker([], 0)
    expect(checker.tetromino).toEqual([])
  })
})
