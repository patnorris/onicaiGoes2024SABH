<script lang="ts">
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  export let donation : Donation;
</script>

<div>
  <div>
    <div>
      <p>Total Amount: {donation.totalAmount}</p>
      <p>Payment Type: {donation.paymentType}</p>    
      <p>Date: {donation.timestamp}</p>
    </div>
  </div>
</div>
