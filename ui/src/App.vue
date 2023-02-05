<script>
import { serviceProviders } from './service_providers'
import { showToast } from 'vant'

const NO_META_THE_COMPANY_KEY = '_bankimoon.meta';
const ACCOUNT_KEY = '_bankimoon.accounts';

export default {
  data() {
    return {
      query: '',
      appTitle: "Bankimoon",
      activeTabName: "ALL",
      isEditingAccount: false,
      availableServiceProviders: serviceProviders,
      newAccount: {
        org: '',
        name: '',
        accountNumber: '',
        mine: false,
        fav: false,
      },
      accounts: []
    }
  },

  mounted() {
    let existingAccounts = localStorage.getItem(ACCOUNT_KEY);
    if (existingAccounts) {
      let arr = JSON.parse(existingAccounts)
      this.accounts.push(...arr)
    }
  },

  computed: {
    searchResults() {
      if (this.query) {
        return this.accounts.filter(acc => {
          let nameLwr = acc.name.toLowerCase(),
            accLwr = acc.accountNumber.toLowerCase(),
            q = this.query.toLowerCase();

          return (nameLwr.indexOf(q) != -1 || accLwr.indexOf(q) != -1)
        })
      }
      return this.accounts;
    },

    myAccounts() {
      return this.accounts.filter(acc => acc.mine)
    }
  },

  methods: {
    resetNewAccount() {
      this.newAccount = {
        org: '',
        name: '',
        accountNumber: '',
        mine: false,
        fav: false,
      }
    },

    saveOrEditAccount() {
      if (this.newAccount.accountNumber.length < 1) {
        return;
      }
      let accountData = Object.assign({}, this.newAccount)
      // TODO: handle answer options for multiple choice
      this.accounts.push(accountData)
      this.resetNewAccount()
      this.isEditingAccount = false;
      this.saveAccountsToLocalStorage()
    },
    saveAccountsToLocalStorage() {
      let data = {
        lastSaveAt: new Date(),
        numAccounts: this.accounts.length
      }
      localStorage.setItem(NO_META_THE_COMPANY_KEY, JSON.stringify(data));
      localStorage.setItem(ACCOUNT_KEY, JSON.stringify(this.accounts))
    },
    
    deleteSelectedAccount(account) {
      this.accounts.shift()
      this.saveAccountsToLocalStorage()
    },

    copyAccountToClipboard(account) {
      navigator.clipboard.writeText(decodeURI(account.accountNumber))
      showToast(`Copied ${account.accountNumber}`)
    },


    clearAll() {
      this.accounts = [];
      localStorage.clear()
      showToast(`It's all gone. Everything's gone.`)
    },

    onSwipeLeft(e) {
      if (e.position == 'right') {
        this.copyAccountToClipboard(account)
      }
    }
  }
}
</script>

<template>
  <van-nav-bar :title="appTitle" />

  <van-search v-model="query" placeholder="Search" />
  <van-tabs v-model:active="activeTabName">
    <van-tab title="ALL" name="allAccounts">

      <van-cell-group>
        <van-swipe-cell v-for="account in searchResults"
          v-on:close="onSwipeLeft"
          >
          <template #left>
            <van-button square type="primary" text="Copy" @click="copyAccountToClipboard(account)"/>
          </template>
          <van-cell :border="false" :key="account.accountNumber" :title="account.name"
            @dblclick="copyAccountToClipboard(account)">
            <p>{{ account.accountNumber }}</p>
            <span>{{ account.org }}</span>
          </van-cell>
          <template #right>
            <van-button square type="danger" text="Delete" @click="deleteSelectedAccount(account)"/>
          </template>
        </van-swipe-cell>
      </van-cell-group>
      <van-cell-group>
        <van-button type="primary" size="large" @click="isEditingAccount = !this.isEditingAccount">Add
          Account</van-button>
      </van-cell-group>
    </van-tab>
    <van-tab title="MINE" name="myAccounts">
      <van-list>
        <van-cell v-for="account in myAccounts" :key="account.accountNumber" :title="account.name">
          <p>{{ account.accountNumber }}</p>
          <span>{{ account.org }}</span>
        </van-cell>
      </van-list>
    </van-tab>
    <van-tab title="Settings" name="settings">
      <van-space>
        <van-button square type="danger" text="Clear All Accounts" @click="clearAll()"/>
      </van-space>

    </van-tab>
    <!-- <van-tab title="FAVOURITES" name="favAccounts">
    </van-tab>
    <van-tab title="FAMILY" name="familyAccounts">
    </van-tab> -->
  </van-tabs>

  <van-popup v-model:show="isEditingAccount" closeable position="bottom" :style="{ height: '70%' }">
    <van-cell title="Add Account"></van-cell>

    <van-field v-model="newAccount.name" name="accountName" label="Name"
      placeholder="Type or Paste the account name here"
      :rules="[{ required: true, message: 'Account Name is required' }]" />

    <van-field v-model="newAccount.accountNumber" name="accountNumber" label="Account Number"
      placeholder="Type or Paste the account number here"
      :rules="[{ required: true, message: 'Account Number is required' }]" />

    <van-space direction="vertical">
      <van-checkbox v-model="newAccount.mine" shape="square">Mine</van-checkbox>
      <van-checkbox v-model="newAccount.fav" shape="square">Add to Favourites</van-checkbox>
    </van-space>

    <van-field name="radio" label="Type">
      <template #input>
        <van-radio-group v-model="newAccount.org" direction="horizontal">
          <van-radio v-for="sp in availableServiceProviders" :name="sp.alias">{{ sp.name }} ({{ sp.alias }})</van-radio>
        </van-radio-group>
      </template>
    </van-field>

    <van-button type="primary" round block @click="saveOrEditAccount">Save</van-button>
  </van-popup>
</template>

<style scoped>

</style>
