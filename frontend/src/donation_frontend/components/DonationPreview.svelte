<script lang="ts">
  import { push } from "svelte-spa-router";
  
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  export let donation : Donation;

  function viewDonation() {
    push(`#/donation/${donation.dti}`); // Navigate to the donation details page
  };
</script>

<div class="text-gray-900 dark:text-gray-200">
  <p>Total Amount: {donation.totalAmount} {Object.keys(donation.paymentType)[0] === "BTC" ? "Satoshi" : ""}</p>
  <p>Payment Type: {Object.keys(donation.paymentType)[0]}</p>
  <p>Date: {new Date(Number(donation.timestamp) / 1000000).toLocaleDateString()}</p>
  <button on:click|preventDefault={viewDonation} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-800">View Donation</button>
</div>
