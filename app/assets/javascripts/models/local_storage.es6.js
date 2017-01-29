class LocalStorage {
  static isAvailable() {
    try {
      const storage = window.localStorage
      const x = '__storage_test__'
      storage.setItem(x, x)
      storage.removeItem(x)
      return true
    } catch(e) {
      return false
    }
  }

  static set(key, value) {
    window.localStorage.setItem(key, JSON.stringify(value))
  }

  static get(key) {
    const value = window.localStorage.getItem(key)
    if (typeof value === 'string') {
      return JSON.parse(value)
    }
    return value
  }

  static delete(key) {
    window.localStorage.removeItem(key)
  }
}
