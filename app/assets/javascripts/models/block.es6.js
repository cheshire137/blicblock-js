class Block {
  constructor(attrs) {
    attrs = attrs || {}
    if (typeof attrs.color === 'string') {
      this.color = attrs.color
    } else {
      const colors = ['magenta', 'orange', 'yellow', 'green', 'blue', 'white']
      this.color = colors[Math.floor(Math.random() * colors.length)]
    }
    this.x = attrs.x
    this.y = attrs.y
    if (typeof attrs.locked === 'undefined') {
      this.locked = false
    } else {
      this.locked = attrs.locked
    }
    if (typeof attrs.active === 'undefined') {
      this.active = true
    } else {
      this.active = attrs.active
    }
    this.sliding = attrs.sliding || false
    this.plummetting = attrs.plummetting || false
    this.highlight = attrs.highlight || false
    this.id = attrs.id || this.generateID()
  }

  generateID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0
      const v = c === 'x' ? r : (r & 0x3 | 0x8)
      return v.toString(16)
    })
  }

  attrs() {
    return { color: this.color, x: this.x, y: this.y, locked: this.locked,
             active: this.active, sliding: this.sliding,
             plummetting: this.plummetting, highlight: this.highlight,
             id: this.id }
  }
}
