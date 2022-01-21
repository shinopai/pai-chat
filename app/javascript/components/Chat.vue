<template>
<div class="w-screen">
    <div class="grid grid-cols-3 min-w-full border rounded" style="min-height: 80vh;">
            <Main />
        </div>
    </div>
</template>

<script>
import Main from './parts/Main.vue'

export default {
  components: {
    Main
  },
  setup() {

  },
}
</script>
