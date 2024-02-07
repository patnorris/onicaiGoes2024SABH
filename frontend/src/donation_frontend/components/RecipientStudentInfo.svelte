<script lang="ts">
  export let studentInfo;
</script>

<div>
  <div>
    <div>
      <p>{studentInfo.name}</p>
      <p>{studentInfo.grade}</p>
      <img alt="The student thumbnail" src={studentInfo.thumbnail} />
    </div>
  </div>
</div>
