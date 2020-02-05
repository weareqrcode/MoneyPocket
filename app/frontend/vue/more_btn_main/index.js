const main = {
  data: {
    itemShow: false,
    itemId: '',
    modalFade: 'modal fade',
    show: 'show',
    modalShow: false,
    closeBtn: true,
  },
  methods: {
    expand(id) {
      // click to close more
      if (this.itemId === id) {
        this.itemId = ''
        this.itemShow = false
        this.modalShow = false
      // click to open more
      } else {
        this.itemId = id
        this.itemShow = true
        this.modalShow = true
      }
    },
    close() {
      this.closeBtn = false
    }
  }
}
export default main