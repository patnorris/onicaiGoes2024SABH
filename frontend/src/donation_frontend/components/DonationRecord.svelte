<script lang="ts">
  import RecipientProfile from "./RecipientProfile.svelte";
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  export let donation : Donation;

  const categoryNameTranslator = {
    "curriculumDesign": 'Curriculum Design and Development',
    "teacherSupport": 'Teacher Support',
    "schoolSupplies": 'School Supplies',
    "lunchAndSnacks": 'Lunch and Snacks',
  };

  const donorToDisplay = Object.keys(donation.donor)[0] === "Anonymous" ? Object.keys(donation.donor)[0] : donation.donor[Object.keys(donation.donor)[0]];
</script>

<div class="text-gray-900 dark:text-gray-200">
  <div class="pb-6 space-y-2">
    <p>Total Amount: {donation.totalAmount} {Object.keys(donation.paymentType)[0] === "BTC" ? "Satoshi" : ""}</p>
    <p>Payment Type: {Object.keys(donation.paymentType)[0]}</p>
    {#if Object.keys(donation.paymentType)[0] === "BTC"}
      <div class="break-all">
        Payment Transaction Id: 
        <span class="inline-block break-all">
          <a href={`https://blockstream.info/testnet/tx/${donation.paymentTransactionId}`} 
            target="_blank" 
            rel="noopener noreferrer"
            class="underline hover:text-blue-600 dark:hover:text-blue-400">
            {donation.paymentTransactionId}
          </a>
        </span>
      </div>
    {:else}
      <div class="break-all">
        Payment Transaction Id: 
        <span class="inline-block break-all">
          {donation.paymentTransactionId}
        </span>
      </div>
    {/if}
    <p>Date: {new Date(Number(donation.timestamp) / 1000000).toLocaleDateString()}</p>
    <p>Donor: {donorToDisplay}</p>
    <p>Allocation: </p>
    {#each Object.entries(donation.allocation) as [category, categoryValues], index}
      <p>{categoryNameTranslator[category]}: {categoryValues}</p>
    {/each}
    {#if donation.personalNote[0]}
      <span class="inline-block break-all">
        <p>Personal Note: {donation.personalNote[0]}</p>
      </span>      
    {/if}
  </div>
  <RecipientProfile recipientId={donation.recipientId} embedded={false} />
</div>

