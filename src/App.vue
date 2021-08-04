<template>
  <div id="app">
    <b-container fluid>
      <b-row>
        <b-col>
          <dataset-browser></dataset-browser>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import DatasetBrowser from './components/DatasetBrowser.vue'

export default {
  name: 'App',
  components: {
    DatasetBrowser
  }
}
</script>

<style lang="scss">
@import "~@/assets/scss/vendors/bootstrap-vue/index";

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
