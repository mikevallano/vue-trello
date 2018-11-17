import Vue from 'vue/dist/vue.esm'
import Lists from '../lists.vue'

document.addEventListener('DOMContentLoaded', () => { //if using turbolinks, you have to do on turbolinks load
  let element = document.getElementById('boards');
  const listsVue = new Vue({
    el: element,
    data: {
      lists: JSON.parse(element.dataset.lists),
      testmessage: 'holamundo',
    },
    template: "<Lists :original_lists='lists' />", //passes original_lists as a prop to the Lists vue object
    components: {Lists}
  })
})
