<template>
  <div class="kt-123">
    {{ msg }}
    <slot></slot>
  </div>
</template>
<script>
export default {
  data() {
    return {
      msg: 'KT TEST'
    }
  }
}
</script>
<style type="scss">
</style>