<script setup>
import { watch } from 'vue';
import { useRoute } from 'vue-router';
import { storeToRefs } from 'pinia';
import { useAccountStore } from '@/stores/accounts';

const route = useRoute();
const accountStore = useAccountStore();

const { getAccountById } = storeToRefs(accountStore);

let account = getAccountById.value(Number(route.params.id));
watch(
  () => route.params,
  (current, previous) => {
    console.log(`Previous Account ID: ${previous.id} Current Account ID: ${current.id}`);
    account = getAccountById.value(Number(route.params.id));
  }
);
</script>

<template>
  <div class="text-gray-100">{{ account }}</div>
</template>

<style scoped></style>
