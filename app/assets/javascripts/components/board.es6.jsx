class Board extends React.Component {
  blockClass(block) {
    const classes = ['animate', 'block', block.color,
                     `pos-${block.x}${block.y}`]
    if (block.highlight) {
      classes.push('glow')
    }
    return classes.join(' ')
  }

  render () {
    return (
      <div className="board">
        {this.props.blocks.map(block => {
          return <div className={this.blockClass(block)}></div>
        })}
      </div>
    )
  }
}

Board.propTypes = {
  blocks: React.PropTypes.array.isRequired,
}
