<script lang="ts">
  export let schoolInfo;
</script>

<div>
  <div>
    <div>
      <p>{schoolInfo.name}</p>
      <p>{schoolInfo.address}</p>
      <img alt="The student thumbnail" src={schoolInfo.thumbnail} />
    </div>
  </div>
</div>
