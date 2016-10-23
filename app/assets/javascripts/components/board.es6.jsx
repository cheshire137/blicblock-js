class Board extends React.Component {
  constructor() {
    super()
    this.state = { inProgress: true, gameOver: false }
  }

  render () {
    return (
      <div className="board-container">
        <div className="score">
        </div>
        <div className="level">
        </div>
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

