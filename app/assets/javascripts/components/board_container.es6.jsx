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
      upcoming: [],
      tickLength: 1200, // ms
    }
  }

  componentDidMount() {
    const gameInterval = setInterval(() => this.gameLoop(),
                                     this.state.tickLength)
    this.setState({ gameInterval })
  }

  componentWillUnmount() {
    clearInterval(this.state.gameInterval)
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

  dropBlocks() {
    const cols = 5
    const rows = 7
    const lastRowX = rows - 1
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
      console.log('dehighlighting blocks')
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

  dropQueuedBlockIfNoActive() {

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

  render () {
    const { currentScore, level, inProgress, gameOver, submittedScore,
            testMode, blocks } = this.state
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
        />
      </div>
    )
  }
}
