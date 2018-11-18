<template>
  <draggable v-model="lists" :options="{group: 'lists'}" @end="listMoved" class="row dragArea">
<!--     defining group ensures the scope of what can be dragged. for example, lists can't be dragged to cards because cards are not in the group -->
    <div class='col-3' v-for="list in lists">
      <h4>{{list.name}}</h4>

      <div v-for="(card, index) in list.cards" class="card card-body mb-3">
        {{card.name}}
      </div>

      <textarea v-model="newCards[list.id]" class='form-control'></textarea>
      <button v-on:click="saveCard(list.id)" class='btn btn-primary btn-sm'>Save</button>
    </div>
  </draggable>
</template>

<script>

import draggable from 'vuedraggable'
export default {
  props: ["original_lists"], // props needs to be separate from data
  data: function () {
    return {
      newCards: {},
      lists: this.original_lists,
      componentMessage: "Lists from vue component"
    }
  },
  components: { draggable },
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
    },
    saveCard: function (list_id){
      let data = new FormData
      data.append("card[list_id]", list_id)
      data.append("card[name]", this.newCards[list_id])

      Rails.ajax({
        url: '/cards',
        type: 'POST',
        data: data,
        dataType: 'json',
        success: (data) => {
          let index = this.lists.findIndex(item => item.id == list_id)
          this.lists[index].cards.push(data)
          this.newCards[list_id] = '' // clear the data for this card
        }
      })
    }
  }
}
</script>

<style scoped>
  .dragArea {
    min-height: 20px; /* to be able to see the draggable area*/
  }
</style>
