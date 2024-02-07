<script lang="ts">
  import DonationPreview from "./DonationPreview.svelte";
  
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  export let donations : [Donation]; // Array of donation records
  export let newestToOldest = false; // Whether donations should be ordered by increasing or decreasing age

  $: orderedDonations = newestToOldest ? [...donations].reverse() : donations;
</script>

<div id='donationPreviews' class="space-y-4">
  {#if !donations || donations.length < 1}
    <p id='noDonationsSubtext'>There are no donations yet. You can be the first one to donate!</p>
  {:else}
    {#each orderedDonations as donation}
      <DonationPreview donation={donation} />
    {/each}
  {/if}
</div>
