const COLS = 5
const ROWS = 7
const MIDDLE_COL_IDX = (COLS - 1) / 2
const INITIAL_TICK_LENGTH = 1200
const HAVE_LOCAL_STORAGE = LocalStorage.isAvailable()

class BoardContainer extends React.Component {
  constructor() {
    super()
    this.state = {
      inProgress: true,
      gameOver: false,
      currentScore: 0,
      level: 1,
      submittedScore: false,
      testMode: false,
      blocks: [],
      upcoming: [new Block(), new Block()],
      tickLength: INITIAL_TICK_LENGTH, // ms
      checking: false,
      plummettingBlock: false,
      slidingBlock: false,
    }
    this.onKeyUp = this.onKeyUp.bind(this)
  }

  componentDidMount() {
    document.addEventListener('keyup', this.onKeyUp)
    this.startGameInterval()
  }

  componentWillUnmount() {
    this.cancelGameInterval()
    document.removeEventListener('keyup', this.onKeyUp)
  }

  onKeyUp(event) {
    if (event.which === 32) { // Space
      this.togglePause()
    } else if (event.which === 37) { // Left arrow
      this.moveLeft()
    } else if (event.which === 39) { // Right arrow
      this.moveRight()
    } else if (event.which === 40) { // Down arrow
      this.moveDown()
    }
  }

  getUpdatedBlocks(idx, block) {
    const { blocks } = this.state
    return blocks.slice(0, idx).concat([block]).concat(blocks.slice(idx + 1))
  }

  stopSliding(id) {
    const block = this.getBlockByID(id)
    const index = this.getBlockIndex(block)
    const attrs = block.attrs()
    attrs.sliding = false
    const newBlock = new Block(attrs)
    const blocks = this.getUpdatedBlocks(index, newBlock)
    this.setState({ blocks, slidingBlock: false })
  }

  getBlockIndex(block) {
    const ids = this.state.blocks.map(b => b.id)
    return ids.indexOf(block.id)
  }

  moveLeft() {
    if (!this.state.inProgress) {
      return
    }
    const block = this.getActiveBlock()
    if (!block || block.plummetting || block.sliding || block.y === 0) {
      return
    }
    console.log(block.id, 'move left')
    const index = this.getBlockIndex(block)
    const attrs = block.attrs()
    let slidingBlock = false
    attrs.sliding = true
    const blockToLeft = this.getClosestBlockToLeft(attrs.x, attrs.y)
    if (blockToLeft && blockToLeft.y === attrs.y - 1) {
      attrs.sliding = false
    } else {
      attrs.y--
      setTimeout(() => this.stopSliding(block.id), 100)
      slidingBlock = true
    }
    const newBlock = new Block(attrs)
    const blocks = this.getUpdatedBlocks(index, newBlock)
    this.setState({ blocks, slidingBlock })
  }

  moveRight() {
    if (!this.state.inProgress) {
      return
    }
    const block = this.getActiveBlock()
    if (!block || block.plummetting || block.sliding || block.y === COLS - 1) {
      return
    }
    console.log(block.id, 'move right')
    const index = this.getBlockIndex(block)
    const attrs = block.attrs()
    let slidingBlock = false
    attrs.sliding = true
    const blockToRight = this.getClosestBlockToRight(attrs.x, attrs.y)
    if (blockToRight && blockToRight.y === attrs.y + 1) {
      attrs.sliding = false
    } else {
      attrs.y++
      setTimeout(() => this.stopSliding(block.id), 100)
      slidingBlock = true
    }
    const newBlock = new Block(attrs)
    const blocks = this.getUpdatedBlocks(index, newBlock)
    this.setState({ blocks, slidingBlock })
  }

  moveDown() {
    if (!this.state.inProgress) {
      return
    }
    const block = this.getActiveBlock()
    if (!block || block.plummetting || block.sliding || block.x == ROWS - 1) {
      return
    }
    console.log(block.id, 'move down')
    const blockBelow = this.getClosestBlockBelow(block.x, block.y)
    const newX = blockBelow ? blockBelow.x - 1 : ROWS - 1
    this.plummetBlock(block, newX).then(() => {
      console.log('finished plummetting block', block.id)
      this.cancelGameInterval()
      this.dropQueuedBlockIfNoActive()
      this.startGameInterval()
    })
  }

  getBlockByID(id) {
    return this.state.blocks.filter(b => b.id === id)[0]
  }

  plummetBlock(originalBlock, x) {
    return new Promise(resolve => {
      if (originalBlock.x === x) {
        resolve()
      } else {
        let interval = undefined
        dropSingleBlock = (id) => {
          const block = this.getBlockByID(id)
          const index = this.getBlockIndex(block)
          const attrs = block.attrs()
          attrs.plummetting = true

          if (attrs.x < x) {
            attrs.x++
            const newBlock = new Block(attrs)
            const blocks = this.getUpdatedBlocks(index, newBlock)
            this.setState({ blocks, plummettingBlock: true })
          } else if (attrs.x === x) {
            clearInterval(interval)
            attrs.locked = true
            attrs.active = false
            attrs.plummetting = false
            const newBlock = new Block(attrs)
            this.onBlockLand(newBlock)
            const blocks = this.getUpdatedBlocks(index, newBlock)
            this.setState({ blocks, plummettingBlock: false }, () => resolve())
          }
        }
        dropSingleBlock(originalBlock.id)
        interval = setInterval(() => dropSingleBlock(originalBlock.id), 25)
      }
    })
  }

  onBlockLand(block) {
    const attrs = block.attrs()
    attrs.highlight = true
    const index = this.getBlockIndex(block)
    const newBlock = new Block(attrs)
    const blocks = this.getUpdatedBlocks(index, newBlock)
    this.setState({ blocks }, () => this.checkForTetrominos())
  }

  togglePause() {
    if (this.state.inProgress) {
      this.pauseGame()
    } else {
      this.resumeGame()
    }
  }

  gameLoop() {
    if (!this.state.inProgress) {
      return
    }
    if (this.state.plummettingBlock || this.state.slidingBlock) {
      return
    }
    this.dropBlocks()
    this.dropQueuedBlockIfNoActive()
  }

  getClosestBlockBelow(x, y) {
    const blocksBelow = this.state.blocks.filter(b => b.x > x && b.y === y)
    blocksBelow.sort((a, b) => {
      if (a.x < b.x) {
        return -1
      }
      return a.x > b.x ? 1 : 0
    })
    return blocksBelow[0]
  }

  getClosestBlockToRight(x, y) {
    const blocksToRight = this.state.blocks.filter(b => b.x === x && b.y > y)
    blocksToRight.sort((a, b) => {
      if (a.y < b.y) {
        return -1
      }
      return a.y > b.y ? 1 : 0
    })
    return blocksToRight[0]
  }

  getClosestBlockToLeft(x, y) {
    const blocksToLeft = this.state.blocks.filter(b => b.x === x && b.y < y)
    blocksToLeft.sort((a, b) => {
      if (a.y < b.y) {
        return -1
      }
      return a.y > b.y ? 1 : 0
    })
  }

  dropBlocks() {
    const lastRowX = ROWS - 1
    const blocks = this.state.blocks.map(block => {
      if (block.sliding) {
        return block
      }
      const attrs = block.attrs()
      if (attrs.active || !attrs.locked) {
        if (attrs.x === lastRowX) {
          attrs.locked = true
          attrs.active = false
          attrs.highlight = true
        }
        if (this.isBlockDirectlyBelow(attrs.x, attrs.y)) {
          attrs.locked = true
          attrs.active = false
        }
      }
      if (!attrs.locked) {
        attrs.x++
      }
      return new Block(attrs)
    })
    this.setState({ blocks }, () => this.onBlocksDropped())
  }

  isBlockDirectlyBelow(x, y) {
    const matching = this.state.blocks.filter(block => {
      return block.x === x + 1 && block.y === y
    })
    return matching.length > 0
  }

  onBlocksDropped() {
    this.deHighlightBlocks()
    this.checkForTetrominos()
  }

  checkForTetrominos() {

  }

  deHighlightBlocks() {
    setTimeout(() => {
      const blocks = this.state.blocks.map(block => {
        if (block.highlight) {
          const attrs = block.attrs()
          attrs.highlight = false
          return new Block(attrs)
        }
        return block
      })
      this.setState({ blocks })
    }, this.state.tickLength * 0.21)
  }

  getActiveBlock() {
    return this.state.blocks.filter(block => block.active)[0]
  }

  dropQueuedBlockIfNoActive() {
    const activeBlock = this.getActiveBlock()
    if (activeBlock) {
      return
    }
    this.dropQueuedBlock()
  }

  dropQueuedBlock() {
    if (this.state.checking) {
      console.log('checking...')
      return
    }
    const middleColBlocks = this.state.blocks.filter(block => {
      return block.y === MIDDLE_COL_IDX
    })
    if (middleColBlocks.length >= ROWS) {
      this.gameOver()
      return
    }
    const x = 0
    const y = MIDDLE_COL_IDX
    const topMidBlock = this.state.blocks.filter(block => {
      return block.x === x && block.y === y
    })[0]
    if (topMidBlock) {
      return // Currently dropping or sliding at the top
    }
    const attrs = this.state.upcoming[0].attrs()
    attrs.x = x
    attrs.y = y
    const block = new Block(attrs)
    const upcoming = [this.state.upcoming[1], new Block()]
    this.setState({ upcoming, blocks: this.state.blocks.concat([block]) })
  }

  gameOver() {
    this.setState({ inProgress: false, gameOver: true })
    this.cancelGameInterval()
    this.saveHighScore()
  }

  startGameInterval() {
    if (typeof this.state.gameInterval !== 'undefined') {
      return
    }
    const gameInterval = setInterval(() => this.gameLoop(),
                                     this.state.tickLength)
    this.setState({ gameInterval })
  }

  cancelGameInterval() {
    clearInterval(this.state.gameInterval)
    this.setState({ gameInterval: undefined })
  }

  saveHighScore() {
    const { currentScore, testMode } = this.state
    if (testMode || !HAVE_LOCAL_STORAGE || currentScore <= 0) {
      return
    }
    const existingHighScore = this.getExistingHighScore()
    if (!existingHighScore.value || existingHighScore.value < currentScore) {
      const score = {
        value: currentScore,
        initials: existingHighScore.initials,
        date: new Date(),
      }
      LocalStorage.set('high_score', score)
    }
  }

  containerClass() {
    const classes = ['board-container']
    if (this.state.testMode) {
      classes.push('test-mode')
    }
    if (this.state.gameOver) {
      classes.push('game-over')
    }
    if (this.state.inProgress) {
      classes.push('in-progress')
    } else {
      classes.push('paused')
    }
    return classes.join(' ')
  }

  getExistingHighScore() {
    if (!HAVE_LOCAL_STORAGE) {
      return {}
    }
    return LocalStorage.get('high_score') || {}
  }

  getNewHighScore(existingHighScore) {
    const { currentScore } = this.state
    const newHighScore = {}
    if (existingHighScore.value && currentScore > existingHighScore.value) {
      newHighScore.value = currentScore
    }
    return newHighScore
  }

  startNewGame() {
    this.cancelGameInterval()
    const gameInterval = setInterval(() => this.gameLoop(),
                                     INITIAL_TICK_LENGTH)
    this.setState({
      gameInterval,
      inProgress: true,
      gameOver: false,
      currentScore: 0,
      level: 1,
      submittedScore: false,
      blocks: [],
      upcoming: [new Block(), new Block()],
      tickLength: INITIAL_TICK_LENGTH, // ms
      checking: false,
    })
  }

  resumeGame() {
    if (this.state.gameOver) {
      return
    }
    this.setState({ inProgress: true }, () => this.startGameInterval())
  }

  pauseGame() {
    if (this.state.plummettingBlock) {
      return
    }
    this.setState({ inProgress: false }, () => this.cancelGameInterval())
  }

  render () {
    const { currentScore, level, inProgress, gameOver, submittedScore,
            testMode, blocks } = this.state
    const existingHighScore = this.getExistingHighScore()
    const newHighScore = this.getNewHighScore(existingHighScore)
    return (
      <div className={this.containerClass()}>
        <div className="score">{currentScore}</div>
        <div className="level">{level}</div>
        <Board blocks={blocks} />
        <BlockPreview />
        <GameMessage
          inProgress={inProgress}
          gameOver={gameOver}
          currentScore={currentScore}
          submittedScore={submittedScore}
          testMode={testMode}
          newHighScore={newHighScore}
          existingHighScore={existingHighScore}
          startNewGame={() => this.startNewGame()}
          resumeGame={() => this.resumeGame()}
        />
      </div>
    )
  }
}
