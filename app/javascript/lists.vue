<template>
  <div> <!-- you can only return one item, so wrapping in a div (fragment not supported) -->
    <p>{{ componentMessage }}</p>
    <div class="row">
      <div class='col-3' v-for="list in original_lists">
        <h4>{{list.name}}</h4>

        <div v-for="(card, index) in list.cards" class="card card-body">
          {{card.name}}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"], // props needs to be separate from data
  data: function () {
    return {
      componentMessage: "Lists from vue component"
    }
  }
}
</script>
