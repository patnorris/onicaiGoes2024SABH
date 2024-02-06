<script lang="ts">
  import { onMount } from "svelte";

  import { store } from "../store";

  import NotFound from "./NotFound.svelte";

// This is needed for URL params
  export let params;

// Load donation from data stored in backend canister
  let loadingInProgress = true;
  let donationLoadingError = false;
  let donation;
  let donationLoaded = false;
  
  const loadDonationDetails = async () => {
    // If viewer is logged in, make authenticated call (otherwise, default backendActor in store is used)
    // Backend Canister Integration
      // Parameters: record with DTI
      // Returns: 
        // Success: Ok wraps record with Donation
        // Error: Err wraps more info (including if not found)
        // Result<{donation : Donation}, ApiError>;
    const getDonationDetailsInput = {
      dti: Number(params.donationId)
    };
    const donationResponse = await $store.backendActor.getDonationDetails(getDonationDetailsInput);
    
    if (donationResponse.Err) {
      donationLoadingError = true;
    } else {
      donation = donationResponse.Ok.donation;
      donationLoaded = true;
    };

    loadingInProgress = false;
  };

  onMount(loadDonationDetails);
</script>

<div>
  {#if loadingInProgress}
    <h1 class="items-center text-center font-bold text-xl bg-slate-300">Loading Details For You!</h1>
  {:else if donationLoadingError}
    <NotFound />
  {:else if donationLoaded}
  TODO      
  
  {/if}
</div>
