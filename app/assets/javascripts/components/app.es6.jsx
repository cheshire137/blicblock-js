class App extends React.Component {
  constructor() {
    super()
    this.state = { view: 'board' }
  }

  render () {
    switch (this.state.view) {
      default: return <BoardContainer />
    }
  }
}
