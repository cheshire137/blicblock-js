class GameMessage extends React.Component {
  gameOver() {
    return (
      <div className="game-message game-over">
        <h2 className="simlish">game over</h2>
        <div className="final-score-message">
          Final score: <span className="value"></span>
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
          <span className="value"></span>
          <time className="date"></time>
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
        <button type="button" className="noPreventDefault resume-game-button btn btn-primary">
          Resume Game
        </button>
      </div>
    )
  }

  render () {
    return <div />
  }
}

