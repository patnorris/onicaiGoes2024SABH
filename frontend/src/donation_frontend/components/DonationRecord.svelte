<script lang="ts">
  import RecipientProfile from "./RecipientProfile.svelte";
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  export let donation : Donation;
</script>

<div>
  <div>
    <div>
      <p>Total Amount: {donation.totalAmount}</p>
      <p>Payment Type: {donation.paymentType}</p>
      <p>Payment Transaction Id: {donation.paymentTransactionId}</p>
      <p>Allocation: {donation.allocation}</p>      
      <p>Date: {donation.timestamp}</p>
      <p>Donor: {donation.donor}</p>
    </div>
    <RecipientProfile recipientId={donation.recipientId} embedded={false} />
  </div>
</div>
