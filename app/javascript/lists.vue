<template>
  <draggable v-model="lists" :options="{group: 'lists', animation: 1000}" @end="listMoved" class="board dragArea">
<!--     defining group ensures the scope of what can be dragged. for example, lists can't be dragged to cards because cards are not in the group -->
  <list v-for="(list, index) in lists" :list="list"></list>
  </draggable>
</template>

<script>

import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  props: ["original_lists"], // props needs to be separate from data
  data: function () {
    return {
      newCards: {},
      lists: this.original_lists,
      componentMessage: "Lists from vue component"
    }
  },
  components: { draggable, list },
  methods: {
    listMoved: function (event) {
      let data = new FormData
      data.append('list[position]', event.newIndex + 1) //correlates with the database id

      Rails.ajax({
        url: `/lists/${this.lists[event.newIndex].id}/move`,
        type: 'PATCH',
        data: data,
        format: 'json'

      })
    }
  }
}
</script>

<style scoped>

</style>
