<script lang="ts">
  import { onMount, afterUpdate } from "svelte";
  import { store } from "../store";
  
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import DonationRecord from "../components/DonationRecord.svelte";

  import spinner from "../assets/loading.gif"; // TODO: load other assets (e.g. html pages) similarly (see https://vitejs.dev/guide/assets.html: Referenced assets are included as part of the build assets graph, will get hashed file names, and can be processed by plugins for optimization)

  let loading = false;

  let dtiToSearchFor;
</script>

<Topnav />

<!-- TODO: input for DTI, search and display Donation record -->
<!-- TODO: link to All Donations -->
<!-- TODO: link to My Donations -->

<section id="spaces" class="py-7 space-y-3 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">Explore Donations</h3>

  {#if loading}
    <p id='searchingDonationSubtext'>Searching the Donation record for you...</p>
    <img class="h-12 mx-auto" src={spinner} alt="loading animation" />
  {:else}
    <div id='foundDonation' class="space-y-1">
      {#key dtiToSearchFor}
        <DonationRecord dti={dtiToSearchFor}/>
      {/key}
    </div>
  {/if}
</section>

<div class='clearfix'></div>

<Footer />
