class Block {
  constructor(attrs) {
    this.color = attrs.color
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
    this.sliding = false
    this.plummetting = false
    this.highlight = false
    this.id = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0
      const v = c === 'x' ? r : (r & 0x3 | 0x8)
      return v.toString(16)
    })
  }
}
