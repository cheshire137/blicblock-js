class Board extends React.Component {
  render () {
    return (
      <div className="board">
        {this.props.blocks.map(block => {
          const classes = ['animate', 'block', block.color,
                           `pos-${block.x}${block.y}`]
          if (block.highlight) {
            classes.push('glow')
          }
          return <div className={classes.join(' ')}></div>
        })}
      </div>
    )
  }
}

Board.propTypes = {
  blocks: React.PropTypes.array.isRequired,
}
