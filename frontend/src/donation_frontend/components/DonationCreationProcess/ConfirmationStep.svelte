<script lang="ts">
    import type { Donation } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  import { store, currentDonationCreationObject } from "../../store";
    import { now } from "svelte/internal";

  let validationErrors = [];

  // Function to validate the donation details
  function validateDonationDetails() {
    validationErrors = []; // Reset errors

    $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId || validationErrors.push('Bitcoin transaction ID is missing. Please provide a Bitcoin Transaction Id on Transaction.');
    if ($currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate <= 0) {
      validationErrors.push('There is no BTC left to donate on this transaction. Please use another Bitcoin Transaction Id on Transaction.');
    };
    $currentDonationCreationObject.recipient.recipientId || validationErrors.push('Recipient ID is missing. Please select a recipient on Recipient.');
    
    if ($currentDonationCreationObject.donation.totalDonation <= 0) {
      validationErrors.push('Total donation must be greater than 0. Please adjust your donation on Donation.');
    };

    // Validate categorySplit sums up to 100%
    const totalPercent = Object.values($currentDonationCreationObject.donation.categorySplit).reduce((total, percent) => total + Number(percent), 0);
    if (totalPercent !== 100) {
      validationErrors.push('The category split percentages must sum up to 100%. Please adjust your split on Donation.');
    };
  }

  // Call validation on component mount
  validateDonationDetails();

  let submitDonationError = false;
  let submitDonationSuccess = false;
  let createdDonationTransactionId;

  async function finalizeDonation() {
    // Implement your logic to submit the donation details
    console.log('Finalizing donation with details: ', $currentDonationCreationObject);
    // Backend Canister Integration
      // Parameters: record with Donation ({donation : {totalAmount: …, allocation: …, …}})
      // Returns: 
        // Success: Ok wraps record with with DTI
        // Error: Err wraps more info (including if not found)
        // Result<{dti : DTI}, ApiError>;

    const finalDonation : Donation = {
        totalAmount: BigInt($currentDonationCreationObject.donation.totalDonation),
        allocation: $currentDonationCreationObject.donation.categorySplit,
        timestamp: BigInt(now()),
        dti: 0n,
        rewardsHaveBeenClaimed: false,
        paymentTransactionId: $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId,
        paymentType: {
          BTC: null
        },
        personalNote: [$currentDonationCreationObject.donation.personalNote],
        donor: {
          Anonymous: null
        },
        recipientId: $currentDonationCreationObject.recipient.recipientId
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
  };

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern-dark.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 5: Confirm Donation</h1>
    <p class="mt-4">Let's double-check that all donation details are looking good.</p>
    <!-- Display donation details -->
    <p>Bitcoin Transaction ID: {$currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionId}</p>
    <p>Recipient Name: {$currentDonationCreationObject.recipient.recipientObject?.name}</p>
    <p>Total Donation: {$currentDonationCreationObject.donation.totalDonation} {$currentDonationCreationObject.donation.paymentType}</p>
    <p>Category Split:</p>
    <ul>
      {#each Object.entries($currentDonationCreationObject.donation.categorySplit) as [category, btc]}
        <li>{category}: {btc} Satoshi</li>
      {/each}
    </ul>
    <!-- Conditional rendering based on validationErrors -->
    {#if validationErrors.length}
      <p class="mt-4">Please correct the following details:</p>
      <ul class="text-red-500">
        {#each validationErrors as error}
          <li>{error}</li>
        {/each}
      </ul>
    {:else}
      <p class="mt-4">Great, everything is in place! If you're ready, you can finalize the donation now.</p>
      <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" on:click|preventDefault={finalizeDonation}>
        Finalize Donation
      </button>
    {/if}
  </div>
</section>