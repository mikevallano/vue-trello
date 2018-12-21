<template>
  <div class='list'>
    <h4>{{list.name}}</h4>

    <draggable v-model="list.cards" :options="{group: 'cards', animation: 1000}" @change="cardMoved" class="dragArea" >
      <div v-for="(card, index) in list.cards" class="card card-body bg-light border-secondary mb-3">
        {{card.name}}
      </div>
    </draggable>

    <textarea v-model="newCardName" class='form-control' placeholder="Add new card to this list"></textarea>
    <button v-on:click="saveCard" class='btn btn-dark btn-sm mt-1 save-card-btn'>Save</button>
  </div>
</template>


<script>

  import draggable from 'vuedraggable'

  export default {
    components: { draggable },
    props: {
      list: {type: Object}
    },
    data: function() {
      return {
        newCardName: '',
      }
    },
    methods: {
      saveCard: function (){
        let data = new FormData
        data.append("card[list_id]", this.list.id)
        data.append("card[name]", this.newCardName)

        Rails.ajax({
          url: '/cards',
          type: 'POST',
          data: data,
          dataType: 'json',
          success: (data) => {
            let index = window.store.lists.findIndex(item => item.id == this.list.id)
            window.store.lists[index].cards.push(data)
            this.newCardName = '' // clear the data for this card
          }
        })
      },
      cardMoved: function (event) {
        let evt = event.added || event.moved
        if (evt === undefined) {return}

        let element = evt.element

        let list_index = window.store.lists.findIndex((list) => {
          return list.cards.find(function(card) {
            return card.id === element.id
          })
        })

        let data = new FormData
        data.append("card[list_id]", window.store.lists[list_index].id)
        data.append("card[position]", evt.newIndex + 1)

        Rails.ajax({
          url: `/cards/${element.id}/move`,
          type: 'PATCH',
          data: data,
          format: 'json'
        })
      },
    }
  }
</script>


<style scoped>
</style>
