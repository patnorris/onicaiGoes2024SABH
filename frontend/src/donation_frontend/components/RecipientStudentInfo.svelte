<script lang="ts">
  export let studentInfo;
</script>

<div class="py-2 space-y-4 items-center text-center bg-gray-100 dark:bg-gray-700">
  <img class="mx-auto h-52 w-52 rounded-full object-cover shadow-lg" src={studentInfo.thumbnail} alt="The student thumbnail" />
  <div>
    <p class="font-bold text-xl md:text-2xl text-gray-800 dark:text-gray-200">{studentInfo.name}</p>
    <p class="text-gray-600 dark:text-gray-300">Grade {studentInfo.grade}</p>
  </div>
</div>
