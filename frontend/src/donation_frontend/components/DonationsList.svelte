<script lang="ts">
  import DonationPreview from "./DonationPreview.svelte";
  
  export let donations; // Array of donation records
</script>

<div id='donationPreviews' class="space-y-4">
  {#if !donations || donations.length === 0}
    <p id='noDonationsSubtext'>There are no donations yet. You can be the first one to donate!</p>
  {:else}
    {#each donations as donation}
      <DonationPreview donation={donation} />
    {/each}
  {/if}
</div>
