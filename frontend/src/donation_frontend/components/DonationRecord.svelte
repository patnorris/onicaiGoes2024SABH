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

<div>
  <div>
    <div>
      <p>Total Amount: {donation.totalAmount} {Object.keys(donation.paymentType)[0] === "BTC" ? "Satoshi" : ""}</p>
      <p>Payment Type: {Object.keys(donation.paymentType)[0]}</p>
      {#if Object.keys(donation.paymentType)[0] === "BTC"}
        <p>Payment Transaction Id: 
          <a href={`https://blockstream.info/testnet/tx/${donation.paymentTransactionId}`} 
            target="_blank" 
            rel="noopener noreferrer"
            class='underline'>
            {donation.paymentTransactionId}
          </a>
        </p>
      {:else}
        <p>Payment Transaction Id: {donation.paymentTransactionId}</p>
      {/if}
      <p>Date: {new Date(Number(donation.timestamp) / 1000000)}</p>
      <p>Donor: {donorToDisplay}</p>
      <p>Allocation: </p> 
      {#each Object.entries(donation.allocation) as [category, categoryValues], index}
        <p>{categoryNameTranslator[category]}: {categoryValues}</p> 
      {/each}
      
    </div>
    <RecipientProfile recipientId={donation.recipientId} embedded={false} />
  </div>
</div>
