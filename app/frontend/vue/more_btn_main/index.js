const main = {
  data: {
    itemShow: false,
    itemId: '' 
  },
  methods: {
    expand(id) {
      // click to close more
      if (this.itemId === id) {
        this.itemId = ''
        this.itemShow = false
      // click to open more
      } else {
        this.itemId = id
        this.itemShow = true
      }
    }
  }
}
export default main