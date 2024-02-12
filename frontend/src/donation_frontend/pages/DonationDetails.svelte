<script lang="ts">
  import { onMount } from "svelte";

  import { store } from "../store";

  import NotFound from "./NotFound.svelte";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  import DonationRecord from "../components/DonationRecord.svelte";

  import spinner from "../assets/loading.gif";

// This is needed for URL params
  export let params;

// Load donation from data stored in backend canister
  let loadingInProgress = true;
  let donationLoadingError = false;
  let donation : Donation;
  let donationLoaded = false;
  
  const loadDonationDetails = async () => {
    if (isNaN(Number(params.donationId)) || params.donationId.includes('.')) {
      donationLoadingError = true;
    } else {
      // If viewer is logged in, make authenticated call (otherwise, default backendActor in store is used)
      // Backend Canister Integration
        // Parameters: record with DTI
        // Returns: 
          // Success: Ok wraps record with Donation
          // Error: Err wraps more info (including if not found)
          // Result<?{donation : Donation}, ApiError>;
      console.log("DEBUG loadDonationDetails params.donationId ", params.donationId);
      const getDonationDetailsInput = {
        dti: BigInt(params.donationId)
      };
      console.log("DEBUG loadDonationDetails getDonationDetailsInput ", getDonationDetailsInput);
      const donationResponse = await $store.backendActor.getDonationDetails(getDonationDetailsInput);
      console.log("DEBUG loadDonationDetails donationResponse ", donationResponse);
      // @ts-ignore
      if (donationResponse.Err) {
        donationLoadingError = true;
      } else {
        // @ts-ignore
        const donationRecord = donationResponse.Ok;
        console.log("DEBUG loadDonationDetails donationRecord ", donationRecord);
        if (donationRecord.length > 0) {
          donation = donationRecord[0].donation;
          donationLoaded = true;
        } else {
          donationLoadingError = true;
        };      
      };
    };

    loadingInProgress = false;
  };

  onMount(loadDonationDetails);
</script>

<Topnav />

<section id="donation-record" class="py-7 space-y-3 items-center text-center bg-slate-100 dark:bg-gray-800">
  <h3 class="text-xl font-bold text-gray-900 dark:text-white">Donation Record</h3>
  
  <div>
    {#if loadingInProgress}
      <h1 class="items-center text-center font-bold text-xl bg-slate-300 dark:bg-slate-600 dark:text-white">Loading Details For You!</h1>
      <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
    {:else if donationLoadingError}
      <p class="text-gray-900 dark:text-gray-200">Make sure the Donation Transaction Id is valid (it's a number)</p>
      <NotFound />
    {:else if donationLoaded}
      <DonationRecord donation={donation}/>
    {/if}
  </div>
</section>

<Footer />
