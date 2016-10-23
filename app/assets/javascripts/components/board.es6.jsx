class Board extends React.Component {
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
        <GameMessage />
      </div>
    )
  }
}

