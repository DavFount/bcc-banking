<script setup>
import { RouterLink } from 'vue-router';
</script>

<template>
  <nav class="sidebar">
    <RouterLink to="home" class="text-red-800 hover:text-gray-400">Home</RouterLink>
  </nav>
</template>

<style scoped>
.sidebar {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 10vw;
  background-color: #111;
}
</style>
