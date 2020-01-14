const main = {
  data: {
    itemShow: false,
    itemId: '',
    closeBtn: true
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
    },
    close() {
      this.closeBtn = false
    }
  }
}
export default main