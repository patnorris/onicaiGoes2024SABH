<script lang="ts">
  import { store, currentDonationCreationObject } from "../../store";
  import spinner from "../../assets/loading.gif";
  
  import type { BitcoinTransaction } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

  let transactionInfo : BitcoinTransaction = $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject;
  
// Manage status of check to show buttons and subtexts appropriately
  let isLoading = false;
  let bitcoinTransactionCheckError = false;
  let bitcoinTransactionLoaded = false;

  let amountLeft = $currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate || 0;

  // Function to check the donation status
  const checkDonationStatus = async () => {
    console.log("Checking status for: ", $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId);
    isLoading = true;
    bitcoinTransactionCheckError = false;
    bitcoinTransactionLoaded = false;
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
      calculateAvailableBTC();
      bitcoinTransactionLoaded = true;
    };
    isLoading = false;
  };

  const calculateAvailableBTC = () => {
    if ($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject) {
      amountLeft = $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject?.totalValue - $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject?.valueDonated;
    };
    $currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate = amountLeft;
  };

  const handleContinue = () => {
		$currentDonationCreationObject.currentActiveFormStepIndex++;
	};

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 2: Check Bitcoin Transaction</h1>	
    <div class="p-6 space-y-3">
      {#if transactionInfo}
        <div class="p-6 mt-4 space-y-3 bg-blue-50 shadow-md border border-gray-300 rounded-lg">
          <p id='currentTransactionSubtext' class="text-black font-semibold">Great, you have currently selected this transaction:</p>
          <p class="text-gray-700">Transaction ID: {transactionInfo.bitcoinTransactionId}</p>
          <p class="text-gray-700">Total Value: {transactionInfo.totalValue}</p>
          <p class="text-gray-700">Value Left to Donate: {amountLeft}</p>
        </div>
        {#if amountLeft > 0}
          <p id='bitcoinTransactionCheckSubtext'>You can continue with the next step.</p>
          <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" on:click|preventDefault={handleContinue}>
            Continue
          </button>
          <p>If you prefer, you can also enter another transaction below instead.</p>
        {:else}
          <p>Please use another transaction which has value left to donate.</p>
          <p>You can continue by entering the Bitcoin Transaction Id below and clicking "Check Now".</p>
        {/if}
      {:else}
        <p id='currentTransactionSubtext' class="mt-4">Let's check that your Bitcoin transaction was confirmed on the Bitcoin network before we can proceed.</p>
        <p>Once the transaction is confirmed on the Bitcoin network (this can take a few minutes), you can continue by entering the Bitcoin Transaction Id below and clicking "Check Now".</p>
      {/if}
    </div>

    <div class="mt-4">
      <input class="border p-2" type="text" bind:value={$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId} placeholder="Enter Bitcoin Transaction Id" />
      {#if isLoading}
        <button disabled class="opacity-50 cursor-not-allowed bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" >
          Check Now
        </button>
        <div class="items-center">
          <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
        </div>
      {:else}
        <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" on:click|preventDefault={checkDonationStatus}>
          Check Now
        </button>
      {/if}
    </div>
    <div class="p-4 space-y-2">
      {#if bitcoinTransactionCheckError}
        <p id='bitcoinTransactionCheckSubtext'>Couldn't find the Bitcoin Transaction. Please double-check the entered Bitcoin Transaction Id and try again in a few minutes, as the transaction might not have been confirmed on the Bitcoin network yet.</p>
      {:else if bitcoinTransactionLoaded}
        <p id='bitcoinTransactionCheckSubtext'>Great success, we found the Bitcoin Transaction!</p>
        <p id='bitcoinTransactionCheckSubtext'>There is {amountLeft} transaction value left to donate.</p>
        {#if amountLeft > 0}
          <p id='bitcoinTransactionCheckSubtext'>Please continue with the next step.</p>
          <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" on:click|preventDefault={handleContinue}>
            Continue
          </button>
        {:else}
          <p id='bitcoinTransactionCheckSubtext'>Please use another transaction which has value left to donate.</p>
        {/if}
      {/if}
    </div>
  </div>
</section>