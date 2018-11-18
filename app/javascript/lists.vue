<template>
  <div> <!-- you can only return one item, so wrapping in a div (fragment not supported) -->
    <p>{{ componentMessage }}</p>
    <div class="row">
      <div class='col-3' v-for="list in lists">
        <h4>{{list.name}}</h4>

        <div v-for="(card, index) in list.cards" class="card card-body mb-3">
          {{card.name}}
        </div>

        <textarea v-model="newCards[list.id]" class='form-control'></textarea>
        <button v-on:click="saveCard(list.id)" class='btn btn-primary btn-sm'>Save</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"], // props needs to be separate from data
  data: function () {
    return {
      newCards: {},
      lists: this.original_lists,
      componentMessage: "Lists from vue component"
    }
  },
  methods: {
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
