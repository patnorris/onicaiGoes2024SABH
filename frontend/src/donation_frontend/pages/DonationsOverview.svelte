<script lang="ts">
  import { onMount } from "svelte";
  import { push } from "svelte-spa-router";

  import { store } from "../store";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import DonationsList from "../components/DonationsList.svelte";
    
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  import spinner from "../assets/loading.gif";

  let hasLoadedDonations = false;
  let loadedDonations : [Donation] = [] as unknown as [Donation];
  let loadingInProgress = true;
  let donationsLoadingError = false;

  const getDonations = async () => {
    // Backend Canister Integration
      // Parameters: record with filters
      // Returns: 
        // Success: Ok wraps record with list of Donations (including empty list if none exist)
        // Error: Err wraps more info 
        // Result<{donations : [Donation]}, ApiError>;
    const getDonationsInput = {
      filters: []
    };
    console.log("DEBUG getDonations getDonationsInput ", getDonationsInput);
    const donationsResponse = await $store.backendActor.getDonations(getDonationsInput);
    console.log("DEBUG getDonations donationsResponse ", donationsResponse);
    // @ts-ignore
    if (donationsResponse.Err) {
      donationsLoadingError = true;
    } else {
      // @ts-ignore
      loadedDonations = donationsResponse.Ok.donations;
      console.log("DEBUG getDonations loadedDonations ", loadedDonations);
      hasLoadedDonations = true;
    };

    loadingInProgress = false;
  };

  onMount(getDonations);
</script>

<Topnav />

<section id="donations" class="py-7 space-y-6 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">Donations</h3>
  {#if loadingInProgress}
    <p id='donationsSubtext'>Loading Donations For You...</p>
    <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
  {:else}
    {#if hasLoadedDonations}
      <DonationsList donations={loadedDonations} />
    {/if}
  {/if}
</section>

<section class="py-7 space-y-6 items-center text-center">
  <h3 class="font-bold">Make a new donation</h3>
  <button type='button' id='donateButton' on:click|preventDefault={() => push("#/donate")} class="active-app-button bg-slate-500 text-white font-bold py-2 px-4 rounded">New Donation</button>
</section>

<div class='clearfix'></div>

<Footer />
