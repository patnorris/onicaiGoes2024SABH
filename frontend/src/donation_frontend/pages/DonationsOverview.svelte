<script lang="ts">
  import { onMount } from "svelte";
  import { push } from "svelte-spa-router";

  import { store } from "../store";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import DonationsList from "../components/DonationsList.svelte";

  let hasLoadedDonations = false;
  let loadedDonations = [];
  let loadingInProgress = true;
  let donationsLoadingError = false;

  const getDonations = async () => {
    const donationsResponse = await $store.backendActor.getDonations({}); //TODO 
    if (donationsResponse.Err) {
      donationsLoadingError = true;
    } else {
      loadedDonations = donationsResponse.Ok;
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
  {:else}
    {#if hasLoadedDonations}
      <DonationsList donations={loadedDonations} />
    {/if}
  {/if}
</section>

<section class="py-7 space-y-6 items-center text-center">
  <h3 class="font-bold">Make a new donation</h3>
  <button type='button' id='donateButton' on:click={() => push("#/donate")} class="active-app-button bg-slate-500 text-white font-bold py-2 px-4 rounded">New Donation</button>
</section>

<div class='clearfix'></div>

<Footer />
