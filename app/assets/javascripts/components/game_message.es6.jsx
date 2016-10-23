class GameMessage extends React.Component {
  existingHighScore() {
    const { newHighScore, existingHighScore } = this.props
    if (newHighScore.value) {
      return null
    }
    return (
      <div className="existing-high-score-message">
        Your high score:
        <span className="value">{existingHighScore.value}</span>
        <time className="date">{existingHighScore.date}</time>
      </div>
    )
  }

  newHighScore() {
    const { newHighScore } = this.props
    if (!newHighScore.value) {
      return
    }
    return (
      <div className="new-high-score-message">
        New personal high score!
      </div>
    )
  }

  testMode() {
    const { testMode } = this.props
    if (!testMode) {
      return null
    }
    return (
      <div className="test-mode-message">
        Test mode, score is not saved.
      </div>
    )
  }

  submitScoreForm() {
    const { currentScore, testMode, submittedScore } = this.props
    if (currentScore <= 0 || testMode || submittedScore) {
      return null
    }
    return (
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
    )
  }

  gameOver() {
    const { currentScore } = this.props
    return (
      <div className="game-message game-over">
        <h2 className="simlish">game over</h2>
        <div className="final-score-message">
          Final score: <span className="value">{currentScore}</span>
        </div>
        {this.submitScoreForm()}
        {this.testMode()}
        {this.newHighScore()}
        {this.existingHighScore()}
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
        {this.testMode()}
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
  testMode: React.PropTypes.bool.isRequired,
  submittedScore: React.PropTypes.bool.isRequired,
  currentScore: React.PropTypes.number.isRequired,
  existingHighScore: React.PropTypes.object,
  newHighScore: React.PropTypes.object,
}
