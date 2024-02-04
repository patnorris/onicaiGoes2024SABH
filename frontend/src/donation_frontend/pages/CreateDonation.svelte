<script lang="ts">
  import { store } from "../store";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";

  //import { canisterId as backendCanisterId } from "canisters/donation_tracker_backend";
  //import { canisterId as donation_frontend_canister_id } from "canisters/donation_frontend";

// Subtexts to display
  const loginSubtext = "Please log in first.";
  const clickDefaultSubtext = "Click and we'll generate this 3D room for you (Your Space, Your Realm, Your Virtual Home) which you can edit afterwards. Fun fact: The Space is an NFT itself and will be sent to your wallet. This way you know it's truly yours!";
  const clickFromModelSubtext = "Click and we'll generate this Space from the provided model for you. Fun fact: The Space is an NFT itself and will be sent to your wallet. This way you know it's truly yours!";
  const inProgressSubtext = "Creating your Personal Web Space, just a moment...";
  const createdSubtext = "Ohh yeah, you just got yourself a new Personal Web Space! You can see it on the My Spaces tab.";
  const fileTooBigText = "Hmm, this file is too big. Please select a file smaller than 2 MB.";

// Manage status of creation to show buttons and subtexts appropriately
  let isDonationCreationInProgress = false;
  let donationToCreate = "";
  let wasDonationCreatedSuccessfully = false;

  const setCreationInProgress = (donation) => {
    isDonationCreationInProgress = true;
    donationToCreate = donation;
  };

  const setDonationWasCreated = () => {
    isDonationCreationInProgress = false;
    wasDonationCreatedSuccessfully = true;
  };

</script>

<Topnav />

<section id="createdonation" class="py-7 space-y-6 items-center text-center bg-slate-100">

  <section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern-dark.svg')]">
    <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">	
      <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
        Donate Bitcoin</h1>
      <p class="mb-8 text-lg font-normal text-gray-500 lg:text-xl sm:px-16 lg:px-48 dark:text-gray-200">
        {#if !$store.isAuthed}
          <p id='createSubtext'>Log in to be rewarded for your donation! You can also donate without logging in.</p>
        {:else}
          <p id='createSubtext'>You're logged in! Your donations will be associated with your account and you can get extra rewards for them.</p>
        {/if}
      </p>
    </div>
  </section>

</section>

<div class='clearfix'></div>

<Footer />

<style>
  .urlInput {
    width: 100%;
  }

  .load-holder {
    background:url(../assets/loading.gif) center center no-repeat;
  }
</style>
