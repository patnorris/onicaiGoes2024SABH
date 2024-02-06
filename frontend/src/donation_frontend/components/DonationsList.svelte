<script lang="ts">
  import DonationPreview from "./DonationPreview.svelte";
  
  export let donations; // Array of donation records
</script>

<div id='donationPreviews' class="space-y-4">
  {#each donations as donation}
    <DonationPreview donation={donation} />
  {/each}
</div>
