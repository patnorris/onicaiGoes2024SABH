<script lang="ts">
  import { store, currentDonationCreationObject } from "../../store";

  import RecipientsList from "../RecipientsList.svelte";

// Manage status of check to show buttons and subtexts appropriately
  let bitcoinTransactionCheckError = false;
  let bitcoinTransactionLoaded = false;

  // Function to check the donation status
  const checkDonationStatus = async () => {
    console.log("Checking status for: ", $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId);
    // Verify the Bitcoin transaction by its ID
    // first check basic validity 

    // Call the backend which then checks with the Bitcoin API
    const transactionCheckInput = {
      bitcoinTransactionId: $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId,
    };
    const transactionCheckResponse = await $store.backendActor.getBtcTransactionDetails(transactionCheckInput);
    if (transactionCheckResponse.Err) {
      bitcoinTransactionCheckError = true;
    } else {
      $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject = transactionCheckResponse.Ok;
      bitcoinTransactionLoaded = true;
    };
  }

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern-dark.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 3: Choose Donation Recipient</h1>	
    <p class="mt-4">Please choose the school or student you would like to donate to.</p>
    {#if $currentDonationCreationObject.recipient.recipientObject}
      <p id='currentRecipientSubtext'>You have currently selected this recipient:</p>
      <p id='currentRecipientObjectSubtext'>TODO: {$currentDonationCreationObject.recipient.recipientObject}</p>
    {:else}
      <p id='currentRecipientSubtext'>You have not made your selection yet. Please do so before continuing.</p>
    {/if}
    <div class="mt-4">
      <RecipientsList embedded={true}/>
    </div>
  </div>
</section>