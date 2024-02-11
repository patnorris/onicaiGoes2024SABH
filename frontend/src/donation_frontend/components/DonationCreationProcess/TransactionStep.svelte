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

// Before submitting the transaction id to check to the backend, confirm its general validity
  let errorMessage = "";
  function validateBitcoinTransactionId(bitcoinTransactionId) {
    errorMessage = ""; // reset error message
    // Trim the input to remove any leading/trailing whitespace
    bitcoinTransactionId = bitcoinTransactionId.trim();
    // Check if the input is empty
    if (bitcoinTransactionId === "") {
      errorMessage = "Please enter a Bitcoin Transaction Id.";
      return false;
    }
    // Validate Bitcoin Transaction ID format
    else if (!/^[0-9a-fA-F]{64}$/.test(bitcoinTransactionId)) {
      errorMessage = "Bitcoin Transaction Id must be a 64-character hexadecimal string.";
      return false;
    };

    return true;
  };

  // Function to check the transaction status
  const checkTransactionStatus = async () => {
    console.log("Checking status for: ", $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId);
    if (!validateBitcoinTransactionId($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId)) {
      return;
    };
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
    console.log("DEBUG checkTransactionStatus transactionCheckInput ", transactionCheckInput);
    const transactionCheckResponse = await $store.backendActor.getBtcTransactionDetails(transactionCheckInput);
    console.log("DEBUG checkTransactionStatus transactionCheckResponse ", transactionCheckResponse);
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
        <div class="p-6 mt-4 space-y-3 bg-blue-50 dark:bg-blue-800 shadow-md border border-gray-300 dark:border-gray-700 rounded-lg">
          <p id='currentTransactionSubtext' class="text-black dark:text-white font-semibold">Great, you have currently selected this transaction:</p>
          <p class="text-gray-700 dark:text-gray-300">Transaction ID: {transactionInfo.bitcoinTransactionId}</p>
          <p class="text-gray-700 dark:text-gray-300">Total Value: {transactionInfo.totalValue}</p>
          <p class="text-gray-700 dark:text-gray-300">Value Left to Donate: {amountLeft}</p>
        </div>
        {#if amountLeft > 0}
          <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">You can continue with the next step.</p>
          <button on:click|preventDefault={handleContinue} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
            Continue
          </button>
          <p class="dark:text-gray-300">If you prefer, you can also enter another transaction below instead.</p>
        {:else}
          <p class="dark:text-gray-300">Please use another transaction which has value left to donate.</p>
          <p class="dark:text-gray-300">You can continue by entering the Bitcoin Transaction Id below and clicking "Check Now".</p>
        {/if}
      {:else}
        <p id='currentTransactionSubtext' class="mt-4 dark:text-gray-300">Let's check that your Bitcoin transaction was confirmed on the Bitcoin network before we can proceed.</p>
        <p class="dark:text-gray-300">Once the transaction is confirmed on the Bitcoin network (this can take a few minutes), you can continue by entering the Bitcoin Transaction Id below and clicking "Check Now".</p>
      {/if}
    </div>

    <div class="mt-2">
      <input class="border p-2 dark:bg-gray-800 dark:border-gray-600 dark:text-white" type="text" bind:value={$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId} placeholder="Enter Bitcoin Transaction Id" />
      {#if isLoading}
        <button disabled class="opacity-50 cursor-not-allowed bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700">
          Check Now
        </button>
        <div class="items-center">
          <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
        </div>
      {:else}
        <button on:click|preventDefault={checkTransactionStatus} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
          Check Now
        </button>
      {/if}
      {#if errorMessage}
        <p class="text-red-500 dark:text-red-400">{errorMessage}</p>
      {/if}
    </div>
    <div class="p-4 space-y-2">
      {#if bitcoinTransactionCheckError}
        <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">Couldn't find the Bitcoin Transaction. Please double-check the entered Bitcoin Transaction Id and try again in a few minutes, as the transaction might not have been confirmed on the Bitcoin network yet.</p>
      {:else if bitcoinTransactionLoaded}
        <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">Great success, we found the Bitcoin Transaction!</p>
        <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">There is {amountLeft} transaction value left to donate.</p>
        {#if amountLeft > 0}
          <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">Please continue with the next step.</p>
          <button on:click|preventDefault={handleContinue} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
            Continue
          </button>
        {:else}
          <p id='bitcoinTransactionCheckSubtext' class="dark:text-gray-300">Please use another transaction which has value left to donate.</p>
        {/if}
      {/if}
    </div>
  </div>
</section>