<script setup>
import { ref, onMounted } from 'vue';
import { RouterView } from 'vue-router';
import api from './api';
import NavigationBar from '@/components/NavigationBar.vue';

const visible = ref(false);
const devmode = ref(true);

onMounted(() => {
  window.addEventListener('message', onMessage);
});

const onMessage = (event) => {
  switch (event.data.type) {
    case 'toggle':
      visible.value = event.data.visible;
      api
        .post('updatestate', {
          state: visible.value,
        })
        .catch((e) => {
          console.log(e.message);
        });
      break;
    default:
      break;
  }
};

const closeApp = () => {
  visible.value = false;
  api
    .post('updatestate', {
      state: visible.value,
    })
    .catch((e) => {
      console.log(e);
    });
};
</script>

<template>
  <div class="container" v-if="visible || devmode">
    <NavigationBar />
    <RouterView />
  </div>
</template>

<style scoped>
.container {
  background-color: rgb(32, 32, 32);

  /* background-image: url('./assets/images/bg.jpg');
  background-position: center;
  background-repeat: no-repeat;
  background-position: 0;
  background-size: 100%; */

  border-radius: 6px;
  height: 75vh;
  width: 75vw;

  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;

  margin: auto;
  overflow: hidden;
}

#close {
  position: absolute;
  right: 0;
  top: 0;
  margin-right: 0.75rem;
  margin-top: 0.3rem;
  font-size: 25px;
}
</style>
