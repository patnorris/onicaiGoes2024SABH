<script lang="ts">
  import { push } from "svelte-spa-router";
  
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";

  import spinner from "../assets/loading.gif"; // load other assets (e.g. html pages) similarly (see https://vitejs.dev/guide/assets.html: Referenced assets are included as part of the build assets graph, will get hashed file names, and can be processed by plugins for optimization)

  let loading = false;
  let dtiToSearchFor = "";
  let errorMessage = "";

  function searchDonation() {
    errorMessage = ""; // Reset error message
    if (dtiToSearchFor.trim() === "") {
      errorMessage = "Please enter a Donation Transaction Id (DTI).";
      return;
    };
    
    if (isNaN(Number(dtiToSearchFor)) || dtiToSearchFor.includes('.')) {
      errorMessage = "DTI must be a number.";
      return;
    };
    
    loading = true;
    push(`#/donation/${dtiToSearchFor}`); // Navigate to the donation details page
  };
</script>

<Topnav />

<section id="donations-explorer" class="py-7 space-y-3 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">Donation Transaction Explorer</h3>

  <section class="py-4 text-center">
    <h4 class="text-lg font-bold">Search For a Donation</h4>
    <p class="mb-2">Look up a specific donation by entering its DTI (Donation Transaction Id)</p>
    <input type="text" bind:value={dtiToSearchFor} placeholder="Enter DTI to search" class="mb-4 text-center"/>
    <button on:click|preventDefault={searchDonation} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Search</button>
    {#if errorMessage}
      <p class="text-red-500">{errorMessage}</p>
    {/if}
    {#if loading}
      <p id='searchingDonationSubtext'>Searching the Donation record for you...</p>
      <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
    {/if}
  </section>

  <section class="py-4 text-center">
    <h4 class="text-lg font-bold">All Donations</h4>
    <p class="mb-2">View a list of all the donations made. Explore the generosity of our community.</p>
    <button on:click|preventDefault={() => push('#/donations')} class="text-blue-500 hover:underline">View All Donations</button>
  </section>
  
  <section class="py-4 text-center">
    <h4 class="text-lg font-bold">My Donations</h4>
    <p class="mb-2">Check out the donations you have made. Review your personal contribution history.</p>
    <button on:click|preventDefault={() => push('#/mydonations')} class="text-blue-500 hover:underline">View My Donations</button>
  </section>
</section>

<div class='clearfix'></div>

<Footer />
