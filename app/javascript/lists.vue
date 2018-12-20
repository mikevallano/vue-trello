<template>
  <draggable v-model="lists" :options="{group: 'lists', animation: 1000}" @end="listMoved" class="board dragArea">
<!--     defining group ensures the scope of what can be dragged. for example, lists can't be dragged to cards because cards are not in the group -->
    <div class='list' v-for="list in lists">
      <h4>{{list.name}}</h4>

      <draggable v-model="list.cards" :options="{group: 'cards', animation: 1000}" @change="cardMoved" class="dragArea" >
        <div v-for="(card, index) in list.cards" class="card card-body bg-light border-secondary mb-3">
          {{card.name}}
        </div>
      </draggable>

      <textarea v-model="newCards[list.id]" class='form-control' placeholder="Add new card to this list"></textarea>
      <button v-on:click="saveCard(list.id)" class='btn btn-dark btn-sm mt-1 save-card-btn'>Save</button>
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
    cardMoved: function (event) {
      let evt = event.added || event.moved
      if (evt === undefined) {return}

      let element = evt.element

      let list_index = this.lists.findIndex((list) => {
        return list.cards.find(function(card) {
          return card.id === element.id
        })
      })

      let data = new FormData
      data.append("card[list_id]", this.lists[list_index].id)
      data.append("card[position]", evt.newIndex + 1)

      Rails.ajax({
        url: `/cards/${element.id}/move`,
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

</style>
