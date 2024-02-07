<script lang="ts">
  import { onMount } from "svelte";
  import { push } from "svelte-spa-router";
  import { store } from "../store";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import DonationsList from "../components/DonationsList.svelte";

  import spinner from "../assets/loading.gif";

  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  let isLoading = false;
  let hasLoadedDonations = false;
  let loadedUserDonations : [Donation] = [] as unknown as [Donation];
  let donationsLoadingError = false;

  const loadUserDonations = async () => {
    isLoading = true;
    if($store.isAuthed) {
      // Backend Canister Integration
        // Parameters: empty record
        // Returns: 
          // Success: Ok wraps record with list of Donations (including empty list if none exist)
          // Error: Err wraps more info
          // Result<{donations : [Donation]}, ApiError>;
      const getMyDonationsInput = {
        filters: []
      };
      console.log("DEBUG loadUserDonations getMyDonationsInput ", getMyDonationsInput);
      const userDonationsResponse = await $store.backendActor.getMyDonations(getMyDonationsInput);
      console.log("DEBUG loadUserDonations userDonationsResponse ", userDonationsResponse);
      // @ts-ignore
      if (userDonationsResponse.Err) {
        donationsLoadingError = true;
      } else {
        // @ts-ignore
        const userDonations = userDonationsResponse.Ok.donations;
      console.log("DEBUG loadUserDonations userDonations ", userDonations);
        const numberOfUserDonations = userDonations.length;
        if (numberOfUserDonations < 1) {
          document.getElementById("donationsSubtext").innerText = "You haven't made any donations yet. Get started now if you like!";
        } else {
          document.getElementById("donationsSubtext").innerText = numberOfUserDonations === 1 
            ? `Big success, you have made ${numberOfUserDonations} donation! Let's take a look:`
            : `Big success, you have made ${numberOfUserDonations} donations! Let's take a look:`;

          loadedUserDonations = userDonations;
          hasLoadedDonations = true;
        };
      };
    };
    isLoading = false;
  };

  onMount(loadUserDonations);
</script>

<Topnav />

<section id="donations" class="py-7 space-y-6 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">My Donations</h3>
  {#if !$store.isAuthed}
    <p id='donationsSubtext'>Log in to see which Donations you have made.</p>
  {:else}
    <p id='donationsSubtext'>Let's see which Donations you have made...</p>
    {#if hasLoadedDonations}
      <DonationsList donations={loadedUserDonations} newestToOldest={true} />
    {:else if isLoading}
      <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
    {:else}
      <p hidden>{loadUserDonations()}</p>
    {/if}
  {/if}
</section>

<section class="py-7 space-y-6 items-center text-center">
  <h3 class="font-bold">Make a new donation</h3>
  <button type='button' id='donateButton' on:click|preventDefault={() => push("#/donate")} class="active-app-button bg-slate-500 text-white font-bold py-2 px-4 rounded">New Donation</button>
</section>

<div class='clearfix'></div>

<Footer />
