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
          const key = `${block.id}-${block.x}-${block.y}-${block.sliding}-` +
              `${block.plummetting}-${block.highlight}-${block.active}-` +
              `${block.color}-${block.locked}`
          return <div className={this.blockClass(block)} key={key}></div>
        })}
      </div>
    )
  }
}

Board.propTypes = {
  blocks: React.PropTypes.array.isRequired,
}
