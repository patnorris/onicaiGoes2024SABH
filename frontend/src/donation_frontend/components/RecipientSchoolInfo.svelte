<script lang="ts">
  export let schoolInfo;
</script>

<div class="py-2 space-y-3 items-center text-center">
  <div>
    <div>
      <p class="font-semibold text-lg">{schoolInfo.name}</p>
      <p>{schoolInfo.address}</p>
      <img alt="The school thumbnail" src={schoolInfo.thumbnail} />
    </div>
  </div>
</div>
