class App extends React.Component {
  constructor() {
    super()
    this.state = { view: 'board' }
  }

  render () {
    switch (this.state.view) {
      case 'board': return <Board />
    }
    return <h1>404 Not Found</h1>
  }
}
