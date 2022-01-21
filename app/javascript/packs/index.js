import {
  createApp
} from "vue";
import dayjs from 'dayjs';
import relativeTime from "dayjs/plugin/relativeTime"
import 'dayjs/locale/ja'
import {
  library
} from '@fortawesome/fontawesome-svg-core'
import {
  faHeart
} from '@fortawesome/free-solid-svg-icons'
import {
  FontAwesomeIcon
} from '@fortawesome/vue-fontawesome'

library.add(faHeart)

import Chat from '../components/Chat.vue'

dayjs.locale('ja')
dayjs.extend(relativeTime)

const app = createApp(Chat)
app.component('fa', FontAwesomeIcon)
app.provide('dayjs', dayjs)
app.mount('#pai-chat')
