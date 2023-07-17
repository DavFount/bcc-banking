import { defineStore } from 'pinia';

export const useSessionStore = defineStore('session', {
  state: () => ({
    bankId: null,
    bankName: null,
    charId: null,
  }),
  getters: {
    getBankName: (state) => {
      return state.bankName;
    },
    getBankId: (state) => {
      return state.bankId;
    },
    getCharId: (state) => {
      return state.charId;
    },
  },
  actions: {
    setBankName(bankName) {
      this.bankName = bankName;
    },
    setBankId(bankId) {
      this.bankId = bankId;
    },
    setCharId(charId) {
      this.charId = charId;
    },
  },
});
