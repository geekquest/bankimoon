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
      isAddingAccount: false,
      isFirstTimeUser: false,
      availableServiceProviders: serviceProviders,
      newAccount: {
        _idx: null,
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
    } else {
      this.isFirstTimeUser = true;
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

    showAccountForm() {
      return this.isEditingAccount || this.isAddingAccount;
    },

    myAccounts() {
      return this.accounts.filter(acc => acc.mine)
    },

    favAccounts() {
      return this.accounts.filter(acc => acc.fav)
    }
  },

  methods: {
    resetNewAccount() {
      this.newAccount = {
        _idx: null,
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
      
      if (this.isEditingAccount) {
        this.resetNewAccount()
      } else if (this.isAddingAccount) {
        let accountData = Object.assign({}, this.newAccount)
        this.accounts.push(accountData)
        this.resetNewAccount()
      }

      this.hideAccountForm()
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

    deleteSelectedAccount(idx, account) {
      this.accounts.splice(idx, 1)
      this.saveAccountsToLocalStorage()
    },

    addNewAccount() {
      this.isAddingAccount = true
    },

    hideAccountForm() {
      this.isAddingAccount = false;
      this.isEditingAccount = false
    },

    editSelectedAccount(idx, account) {
      this.newAccount = this.accounts[idx]
      this.newAccount._idx = idx;
      this.isEditingAccount = true
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
  <small style="color: #ffadf1; font-size: 0.65em;">Tap the account number to copy or swipe right and click "Copy"</small>
  <van-tabs v-model:active="activeTabName">
    <van-tab title="ALL" name="allAccounts">
      <van-empty description="No accounts created yet" v-if="this.accounts.length < 1"/>
      <van-cell-group v-else>
        <van-swipe-cell v-for="(account, idx) in searchResults" v-on:close="onSwipeLeft"
          @dblclick="copyAccountToClipboard(account)">
          <template #left>
            <van-button square type="primary" text="Copy" @click="copyAccountToClipboard(account)" />
          </template>
          <van-cell :border="false" :key="account.accountNumber" :title="account.name">
            <div>
              <van-tag plain type="primary" @click="copyAccountToClipboard(account)">{{
                account.accountNumber
              }}</van-tag>
            </div>
            <span>{{ account.org }}</span>
          </van-cell>
          <template #right>
            <van-button square type="primary" text="Edit" @click="editSelectedAccount(idx, account)" />
            <van-button square type="danger" text="Delete" @click="deleteSelectedAccount(idx, account)" />
          </template>
        </van-swipe-cell>
      </van-cell-group>
      <van-cell-group>
        <van-button type="primary" size="large" @click="addNewAccount()">Add
          Account</van-button>
      </van-cell-group>
    </van-tab>
    <van-tab title="MINE" name="myAccounts">
      <van-cell-group>
        <van-swipe-cell v-for="(account, idx) in myAccounts" v-on:close="onSwipeLeft"
          @dblclick="copyAccountToClipboard(account)">
          <template #left>
            <van-button square type="primary" text="Copy" @click="copyAccountToClipboard(account)" />
          </template>
          <van-cell :border="false" :key="account.accountNumber" :title="account.name">
            <div>
              <van-tag plain type="primary" @click="copyAccountToClipboard(account)">{{
                account.accountNumber
              }}</van-tag>
            </div>
            <span>{{ account.org }}</span>
          </van-cell>
          <template #right>
            <van-button square type="primary" text="Edit" @click="editSelectedAccount(idx, account)" />
            <van-button square type="danger" text="Delete" @click="deleteSelectedAccount(idx, account)" />
          </template>
        </van-swipe-cell>
      </van-cell-group>
    </van-tab>
    <van-tab title="Favourites" name="favAccounts">
      <van-cell-group>
        <van-swipe-cell v-for="(account, idx) in favAccounts" v-on:close="onSwipeLeft"
          @dblclick="copyAccountToClipboard(account)">
          <template #left>
            <van-button square type="primary" text="Copy" @click="copyAccountToClipboard(account)" />
          </template>
          <van-cell :border="false" :key="account.accountNumber" :title="account.name">
            <div>
              <van-tag plain type="primary" @click="copyAccountToClipboard(account)">{{
                account.accountNumber
              }}</van-tag>
            </div>
            <span>{{ account.org }}</span>
          </van-cell>
          <template #right>
            <van-button square type="primary" text="Edit" @click="editSelectedAccount(idx, account)" />
            <van-button square type="danger" text="Delete" @click="deleteSelectedAccount(idx, account)" />
          </template>
        </van-swipe-cell>
      </van-cell-group>
    </van-tab>
    <van-tab title="Settings" name="settings">
      <van-space>
        <van-button square type="danger" text="Clear All Accounts" @click="clearAll()" />
      </van-space>

    </van-tab>
    <!-- <van-tab title="FAVOURITES" name="favAccounts">
    </van-tab>
    <van-tab title="FAMILY" name="familyAccounts">
    </van-tab> -->
  </van-tabs>

  <van-popup v-model:show="showAccountForm" closeable position="bottom" :style="{ height: '70%' }">
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

  <van-popup v-model:show="isFirstTimeUser" closeable position="center">
    <section class="intro">
      <h4>👋 Hi, welcome to Bankimoon.</h4>
      <p>Simple, secure app for keeping and remembering <em>Account Numbers</em> for Banks 💰, MASM 🏥, ESCOM 💡 etc.</p>
      <p>
        Stop ⛔ keeping Account Numbers as Phone Numbers 📞. Save Accounts quickly 📥 and Copy instantly with a Double tap ☝️☝️
      </p>

      <p>Click the button below to create your first account</p>
      <van-button type="primary" round block @click="(evt) => { this.isFirstTimeUser = false; this.isEditingAccount = true }">📓 Add My First Account</van-button>
    </section>
  </van-popup>
</template>

<style scoped>
.intro {
  padding: 0.35em 0.5em;
}
</style>
