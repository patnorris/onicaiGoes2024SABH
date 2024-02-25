<script lang="ts">
  import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  import { store, currentDonationCreationObject } from "../../../store";
  import { push } from "svelte-spa-router";

  import spinner from "../../../assets/loading.gif";

  import { calculateCurrencyUnitAddition } from '../../../helpers/utils.js';

  let validationErrors = [];
  let confirmNewTotal = false;

  let currencyUnitText = $currentDonationCreationObject.donation.currencyUnitText;
  let needsCurrencyUnitAddition = $currentDonationCreationObject.donation.needsCurrencyUnitAddition;

  let transactionInfoToDisplay = "";
  let finalPaymentType = { BTC: null }; // set BTC as default
  let finalPaymentTransactionId = "";

  // Function to validate the donation details
  function validateDonationDetails() {
    validationErrors = []; // Reset errors

    $currentDonationCreationObject.recipient.recipientId || validationErrors.push('Recipient ID is missing. Please select a recipient on the Recipient step.');
    
    if ($currentDonationCreationObject.donation.totalDonation <= 0) {
      validationErrors.push('Total donation must be greater than 0. Please adjust your donation on the Donation step.');
    };

    validatePaymentTypeSpecifics();

    // Validate categorySplit sums up to total donation
    const totalSum = Object.values($currentDonationCreationObject.donation.categorySplit).reduce((total, percent) => total + Number(percent), 0);
    if (totalSum !== $currentDonationCreationObject.donation.totalDonation) {
      $currentDonationCreationObject.donation.totalDonation = totalSum;
      confirmNewTotal = true;
    };
  };

  // Some checks depend on selected payment type
  function validatePaymentTypeSpecifics() {
    switch($currentDonationCreationObject.donation.paymentType) {
      case 'BTC':
        validateBTCSpecifics();
        break;
      case 'ckBTC':
        validateCKBTCSpecifics();
        break;
      // Add cases for other supported payment types here
      default:
        validationErrors.push('Unsupported payment type. Please change your selection.');
    };
  };

  // Specific checks for BTC as selected payment type
  function validateBTCSpecifics() {
    $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId || validationErrors.push('Bitcoin transaction ID is missing. Please provide a Bitcoin Transaction Id on the Transaction step.');
    if ($currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate <= 0) {
      validationErrors.push('There is no BTC left to donate on this transaction. Please use another Bitcoin Transaction Id on the Transaction step.');
    };

    if ($currentDonationCreationObject.donation.totalDonation > $currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate) {
      validationErrors.push('Total donation cannot be greater than the amount left to donate on the transaction. Please adjust your donation on the Donation step.');
    };

    // Set any values to BTC specifics
    transactionInfoToDisplay = `Bitcoin Transaction ID: ${$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId}`;
    finalPaymentType = { BTC: null };
    finalPaymentTransactionId = $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId;
  };

  // Specific checks for ckBTC as selected payment type
  function validateCKBTCSpecifics() {
    // Set any values to ckBTC specifics
    transactionInfoToDisplay = `Please make sure your ckBTC transaction was successful.`;
    finalPaymentType = { CKBTC: null };
  };

  // Call validation on component mount
  validateDonationDetails();

  let submittingDonationInProgress = false;
  let submitDonationError = false;
  let submitDonationSuccess = false;
  let createdDonationTransactionId;

  async function finalizeDonation() {
    // Submit the donation details to the backend
    submittingDonationInProgress = true;
    // Backend Canister Integration
      // Parameters: record with Donation ({donation : {totalAmount: …, allocation: …, …}})
      // Returns: 
        // Success: Ok wraps record with with DTI
        // Error: Err wraps more info (including if not found)
        // Result<{dti : DTI}, ApiError>;

    const totalAmountConverted = BigInt($currentDonationCreationObject.donation.totalDonation);
    let categorySplit = $currentDonationCreationObject.donation.categorySplit;
    let categorySplitConverted = {
      curriculumDesign: BigInt(0.0),
      teacherSupport: BigInt(0.0),
      schoolSupplies: BigInt(0.0),
      lunchAndSnacks: BigInt(0.0),
    };
    for (let category in categorySplit) {
      categorySplitConverted[category] = BigInt(categorySplit[category].amount);
    };

    const finalDonation : Donation = {
      totalAmount: totalAmountConverted,
      allocation: categorySplitConverted,
      paymentTransactionId: finalPaymentTransactionId, // This might be filled by the backend, depending on the payment type
      paymentType: finalPaymentType,
      personalNote: [$currentDonationCreationObject.donation.personalNote],
      recipientId: $currentDonationCreationObject.recipient.recipientId,
      // The following fields will be updated by the backend
      timestamp: 0n,
      dti: 0n,
      rewardsHaveBeenClaimed: false,
      donor: {
        Anonymous: null
      },
    };
    const makeDonationInput = {
      donation: finalDonation
    };
    const submitDonationResponse = await $store.backendActor.makeDonation(makeDonationInput);
    // @ts-ignore
    if (submitDonationResponse.Err) {
      submitDonationError = true;
    } else {
      // @ts-ignore
      createdDonationTransactionId = submitDonationResponse.Ok.dti;
      submitDonationSuccess = true;
    };
    submittingDonationInProgress = false;
  };

  function viewNewDonation() {
    push(`#/donation/${createdDonationTransactionId}`); // Navigate to the donation details page
  };

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Confirm Donation</h1>
    {#if submitDonationSuccess}
      <div class="text-gray-800 dark:text-gray-200">
        <h3>Donation Created</h3>
        <h3>Thank you for donating!</h3>
        <span class="inline-block break-all">
          <p>Your Donation Transaction Id (DTI) is {createdDonationTransactionId}.</p>
        </span>
        <button on:click|preventDefault={viewNewDonation} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">View Donation</button>
      </div>
    {:else}
      <div class="space-y-2 text-gray-800 dark:text-gray-200">
        <p class="mt-4">Let's double-check that all donation details are looking good.</p>
        <span class="inline-block break-all">
          <p>{transactionInfoToDisplay}</p>
        </span>
        <p>Recipient Name: {$currentDonationCreationObject.recipient.recipientInfo?.name}</p>
        <p>Total Donation: {$currentDonationCreationObject.donation.totalDonation} {currencyUnitText} {needsCurrencyUnitAddition ? calculateCurrencyUnitAddition($currentDonationCreationObject.donation.paymentType, $currentDonationCreationObject.donation.totalDonation) : ""}</p>
        <p>Payment Type: {$currentDonationCreationObject.donation.paymentType}</p>
        <p>Category Split:</p>
        <ul>
          {#each Object.entries($currentDonationCreationObject.donation.categorySplit) as [category, amount]}
            <li class="py-1">{category}: {amount} {currencyUnitText} {needsCurrencyUnitAddition ? calculateCurrencyUnitAddition($currentDonationCreationObject.donation.paymentType, amount) : ""}</li>
          {/each}
        </ul>
        {#if confirmNewTotal}
          <p class="mt-4">The category split did not sum up to your total donation. We thus corrected the total. Please adjust if needed.</p>
        {/if}
        {#if validationErrors.length}
          <p class="mt-4">Please correct the following details:</p>
          <ul class="text-red-500 dark:text-red-400">
            {#each validationErrors as error}
              <li>{error}</li>
            {/each}
          </ul>
          <button disabled class="opacity-50 cursor-not-allowed bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700">
            Finalize Donation
          </button>
        {:else}
          <p class="mt-4">Great, everything is in place! If you're ready, you can finalize the donation now.</p>
          {#if submittingDonationInProgress}
            <button disabled class="opacity-50 cursor-not-allowed bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700">
              Finalize Donation
            </button>
            <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
          {:else}
            <button on:click|preventDefault={finalizeDonation} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800" >
              Finalize Donation
            </button>
          {/if}
        {/if}
        {#if submitDonationError}
          <div class="text-red-500 dark:text-red-400">
            <p class="mt-4">Unfortunately, there was an error. Please try finalizing the donation again.</p>
          </div>
        {/if}
      </div>      
    {/if}
  </div>
</section>