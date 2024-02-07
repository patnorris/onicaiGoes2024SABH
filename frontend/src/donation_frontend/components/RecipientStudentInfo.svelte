<script lang="ts">
  export let studentInfo;
</script>

<div class="py-2 space-y-3 items-center text-center">
  <div>
    <div>
      <p class="font-semibold text-lg">{studentInfo.name}</p>
      <p>{studentInfo.grade}</p>
      <img alt="The student thumbnail" src={studentInfo.thumbnail} />
    </div>
  </div>
</div>
