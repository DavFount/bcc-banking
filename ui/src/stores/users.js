import { ref, computed } from 'vue';
import { defineStore } from 'pinia';

export const useUsersStore = defineStore('users', {
  state: () => ({
    users: [
      {
        id: 1,
        name: 'SavSin',
      },
      {
        id: 2,
        name: 'Apo',
      },
      {
        id: 3,
        name: 'Byte',
      },
      {
        id: 4,
        name: 'Jake',
      },
      {
        id: 5,
        name: 'Jannings',
      },
    ],
  }),
  getters: {
    searchUsers: (state) => {
      return (name) => state.users.filter((user) => user.name.includes(name));
    },
    getBankID: (state) => {
      return state.bankId;
    },
  },
  actions: {
    storeUsers(users) {
      this.users = users;
    },
    setBankId(bankId) {
      this.bankId = bankId;
    },
  },
});
