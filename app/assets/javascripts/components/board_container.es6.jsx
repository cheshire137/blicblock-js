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
