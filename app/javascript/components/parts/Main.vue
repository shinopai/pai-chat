<template>
<div class="col-span-1 bg-white border-r border-gray-300">
                <ul class="overflow-auto" style="height: 500px;">
                    <h2 class="ml-2 mb-2 text-gray-600 text-lg my-2">Chats</h2>
                    <li v-for="message in allMessages" :key="message">
                        <a class="hover:bg-gray-100 border-b border-gray-300 px-3 py-2 cursor-pointer flex items-center text-sm focus:outline-none focus:border-gray-300 transition duration-150 ease-in-out">
                            <img class="h-10 w-10 rounded-full object-cover"
                            :src="'/uploads/user/profile_image/' + message.user_id + '/' + message.profile_image"
                            :alt="message.name" />
                            <div class="w-full pb-2">
                                <div class="flex justify-between">
                                    <span class="block ml-2 font-semibold text-base text-gray-600 ">{{ message.name }}</span>
                                    <span class="block ml-2 text-sm text-gray-600">{{ dayjs(message.created_at).fromNow() }}</span>
                                </div>
                                <span class="block ml-2 text-sm text-gray-600">{{ message.body }}</span>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>

  <div class="col-span-2 bg-white">
                <div class="w-full">
                    <div id="chat" class="w-full overflow-y-auto p-10 relative" style="height: 700px;" ref="toolbarChat">
                        <ul>
                            <li class="clearfix2">
                              <template v-if="allMessages.length > 0">
                                <div v-for="message in allMessages.reverse()" :key="message" class="w-full flex" :class="{ 'justify-end': message.user_id == userId, 'justify-start': message.user_id != userId }">
                                    <div v-if="allLikedMessages.includes(message.id)" class="rounded px-5 py-2 my-2 text-gray-700 relative cursor-pointer" :class="{ 'bg-blue-100': message.user_id == userId, 'bg-gray-100': message.user_id != userId }" style="max-width: 300px;" @dblclick="removeLike(userId, message.id)">
                                      <template v-if="allLikedMessages.includes(message.id)">
                                    <fa icon="heart" class="text-red-500"></fa>
                                      </template>
                                      <span class="block text-sm">{{ message.name }}</span>
                                        <span class="block">{{ message.body }}</span>
                                        <span class="block text-xs text-right">{{ dayjs(message.created_at).fromNow() }}</span>
                                    </div>
                                    <div v-else class="rounded px-5 py-2 my-2 text-gray-700 relative cursor-pointer" :class="{ 'bg-blue-100': message.user_id == userId, 'bg-gray-100': message.user_id != userId }" style="max-width: 300px;" @dblclick="addLike(userId, message.id)">
                                      <template v-if="allLikedMessages.includes(message.id)">
                                    <fa icon="heart" class="text-red-500"></fa>
                                      </template>
                                      <span class="block text-sm">{{ message.name }}</span>
                                        <span class="block">{{ message.body }}</span>
                                        <span class="block text-xs text-right">{{ dayjs(message.created_at).fromNow() }}</span>
                                    </div>
                                </div>
                              </template>
                              <template v-else>
                              <p class="text-center">メッセージはまだありません</p>
                              </template>
                            </li>
                        </ul>
                    </div>

                    <div class="w-full py-3 px-3 flex items-center justify-between border-t border-gray-300">
                        <input type="text" v-model="newMessage" placeholder="メッセージを入力してください"
                            class="py-2 mx-3 pl-5 block w-full rounded-full bg-gray-100 outline-none focus:text-gray-700">

                        <button class="outline-none focus:outline-none" type="button" @click="sendNewMessage(userId)">
                            <svg class="text-gray-400 h-7 w-7 origin-center transform rotate-90 hover:text-indigo-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                                <path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z" />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
</template>

<script>
import { ref, toRefs, onMounted, inject, watch } from 'vue'
import Axios from 'axios'

Axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  setup() {
    const newMessage = ref('')
    const userId = ref()
    const allMessages = ref([])
    const dayjs = inject('dayjs')
    let roomId = ref(location.href.substr(28, 1))
    let allLikedMessages = ref([])

    // get current user id
    const getUserId = async () => {
      await Axios.get('/api/v1/rooms/' + roomId.value + '/get_user_id')
                 .then( response => {
                   userId.value = response.data
                   getAllLikedMessages(userId.value)
                   getAllMessages(roomId.value)
                 })
                 .catch( error => {
                   console.log(error.response.data)
                 })
    }

    // get all messages
    const getAllMessages = async (roomId) => {
      await Axios.get('/api/v1/rooms/' + roomId + '/get_all_messages')
                 .then( response => {
                   console.log(response.data)
                   allMessages.value = response.data
                 })
                 .catch( error => {
                   console.log(error.response.data)
                 })
    }

    // send new message
    const sendNewMessage = async (userId) => {
      let res = location.href.substr(28, 1)
      await Axios.post('/api/v1/rooms/' + res + '/users/' + userId + '/messages', {
        body: newMessage.value,
        room_id: Number(res),
        user_id: userId
      })
      .then( response => {
        newMessage.value = ''
        getUserId()
      })
      .catch( error => {
        console.log(error.response.data)
      })
    }

    // add like
    const addLike = async (userId, messageId) => {
      await Axios.post('/api/v1/users/' + userId + '/messages/' + messageId + '/likes', {
        user_id: userId,
        message_id: messageId
      })
      .then( response => {
        console.log(response.data)
        getUserId()
      })
      .catch( error => {
        console.log(error.response.data)
      })
    }

    // remove like
    const removeLike = async (userId, messageId) => {
      await Axios.delete('/api/v1/users/' + userId + '/messages/' + messageId + '/likes/remove_like', {
        user_id: userId,
        message_id: messageId
      })
      .then( response => {
        getUserId()
      })
      .catch( error => {
        console.log(error.response.data)
      })
    }

    // get all messages that current user liked
    const getAllLikedMessages = async (userId) => {
      await Axios.get('/api/v1/users/' + userId + '/liked_messages')
          .then( response => {
            console.log(response.data)
            allLikedMessages.value = response.data
          })
          .catch( error => {
            console.log(error.response.data)
          })
    }

    onMounted(() => {
      getUserId()
    })

    return {
      newMessage, allMessages, sendNewMessage, dayjs, userId, addLike, removeLike, allLikedMessages
    }
  },
}
</script>
