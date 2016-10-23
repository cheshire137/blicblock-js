class Board extends React.Component {
  constructor() {
    super()
    this.state = {
      inProgress: true,
      gameOver: false,
      currentScore: 0,
      level: 1,
    }
  }

  render () {
    const { currentScore, level } = this.state
    return (
      <div className="board-container">
        <div className="score">{currentScore}</div>
        <div className="level">{level}</div>
        <div className="board">
        </div>
        <BlockPreview />
        <GameMessage
          inProgress={this.state.inProgress}
          gameOver={this.state.gameOver}
        />
      </div>
    )
  }
}

