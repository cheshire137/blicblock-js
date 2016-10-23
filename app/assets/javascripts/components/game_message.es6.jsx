class GameMessage extends React.Component {
  gameOver() {
    const { currentScore, existingHighScore } = this.props
    return (
      <div className="game-message game-over">
        <h2 className="simlish">game over</h2>
        <div className="final-score-message">
          Final score: <span className="value">{currentScore}</span>
        </div>
        <form className="submit-score-form form-inline">
          <input
            type="text"
            placeholder="Your initials"
            maxLength="3"
            className="form-control"
            autoFocus="autofocus"
          />
          <button type="submit" className="btn btn-info">
            Submit Score
          </button>
        </form>
        <div className="test-mode-message">
          Test mode, score is not saved.
        </div>
        <div className="new-high-score-message">
          New personal high score!
        </div>
        <div className="existing-high-score-message">
          Your high score:
          <span className="value">{existingHighScore.value}</span>
          <time className="date">{existingHighScore.date}</time>
        </div>
        <button type="button" className="new-game-button btn btn-primary">
          New Game
        </button>
      </div>
    )
  }

  paused() {
    return (
      <div className="game-message paused">
        <h2 className="simlish">paused</h2>
        <div className="test-mode-message">
          Test mode, score will not be saved.
        </div>
        <button type="button" className="resume-game-button btn btn-primary">
          Resume Game
        </button>
      </div>
    )
  }

  render () {
    const { inProgress, gameOver } = this.props
    if (inProgress) {
      return null
    }
    if (gameOver) {
      return this.gameOver()
    }
    return this.paused()
  }
}


GameMessage.propTypes = {
  inProgress: React.PropTypes.bool.isRequired,
  gameOver: React.PropTypes.bool.isRequired,
  currentScore: React.PropTypes.number.isRequired,
  existingHighScore: React.PropTypes.object,
}
