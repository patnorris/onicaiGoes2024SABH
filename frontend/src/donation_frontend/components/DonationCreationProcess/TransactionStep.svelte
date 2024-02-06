<script lang="ts">
  import { store, currentDonationCreationObject } from "../../store";

// Manage status of check to show buttons and subtexts appropriately
  let bitcoinTransactionCheckError = false;
  let bitcoinTransactionLoaded = false;

  // Function to check the donation status
  const checkDonationStatus = async () => {
    console.log("Checking status for: ", $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId);
    // Verify the Bitcoin transaction by its ID
    // first check basic validity 

    // Call the backend which then checks with the Bitcoin API
    // Backend Canister Integration
      // Parameters: record with BTC transaction id ({bitcoinTransactionId : "..."})
      // Returns: 
        // Success: Ok wraps record with BtcTransaction (needs to include valueDonated)
        // Error: Err wraps more info (including if not found)
        // Result<{btcTransaction : BtcTransaction}, ApiError>;
    const transactionCheckInput = {
      bitcoinTransactionId: $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId,
    };
    console.log("DEBUG checkDonationStatus transactionCheckInput ", transactionCheckInput);
    const transactionCheckResponse = await $store.backendActor.getBtcTransactionDetails(transactionCheckInput);
    console.log("DEBUG checkDonationStatus transactionCheckResponse ", transactionCheckResponse);
    // @ts-ignore
    if (transactionCheckResponse.Err) {
      bitcoinTransactionCheckError = true;
    } else {
      // @ts-ignore
      $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject = transactionCheckResponse.Ok.bitcoinTransaction;
      bitcoinTransactionLoaded = true;
    };
  };

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern-dark.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 2: Check Bitcoin Transaction</h1>	
    <p class="mt-4">Let's check that your Bitcoin transaction was confirmed on the Bitcoin network before we can proceed.</p>
    <p>Once the transaction is confirmed on the Bitcoin network (this can take a few minutes), you can continue by entering the Bitcoin Transaction Id below and clicking "Check Now".</p>
    <div class="mt-4">
      <input class="border p-2" type="text" bind:value={$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId} placeholder="Enter Bitcoin Transaction Id" />
      <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" on:click|preventDefault={checkDonationStatus}>
        Check Now
      </button>
    </div>
    {#if bitcoinTransactionCheckError}
      <p id='bitcoinTransactionCheckSubtext'>Couldn't find the Bitcoin Transaction. Please double-check the entered Bitcoin Transaction Id and try again in a few minutes, as the transaction might not have been confirmed on the Bitcoin network yet.</p>
    {:else if bitcoinTransactionLoaded}
      <p id='bitcoinTransactionCheckSubtext'>Great success, we found the Bitcoin Transaction!</p>
      <p id='bitcoinTransactionCheckSubtext'>There is {$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.value - $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.valueDonated} transaction value left to donate.</p>
      <p id='bitcoinTransactionCheckSubtext'>Please continue with the next step.</p>
    {/if}
  </div>
</section>