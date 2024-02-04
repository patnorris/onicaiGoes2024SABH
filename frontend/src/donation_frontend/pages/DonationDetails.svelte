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
    // @ts-ignore
    const donationResponse = await $store.backendActor.getDonationDetails(Number(params.donationId));
    
    if (donationResponse.Err) {
      donationLoadingError = true;
    } else {
      donation = donationResponse.Ok;
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
