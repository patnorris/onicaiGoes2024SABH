<script lang="ts">
  import { onMount } from "svelte";
  import { currentDonationCreationObject } from "../../../store";

  import NonSupportedPaymentType from '../NonSupportedPaymentType.svelte';

  import { calculateCurrencyUnitAddition } from '../../../helpers/utils.js';

  let updateToggle = 0;

  let availableAmountToDonate = 0.0;
  let totalDonationIsBiggerThanAvailableAmountToDonate = false;
  let isValidSplit = true;

  // Donation details
  let totalDonationAmount = $currentDonationCreationObject.donation.totalDonation;
  let donationSplits = {
    'Curriculum Design and Development': { percent: 25, amount: $currentDonationCreationObject.donation.categorySplit.curriculumDesign },
    'Teacher Support': { percent: 25, amount: $currentDonationCreationObject.donation.categorySplit.teacherSupport },
    'School Supplies': { percent: 25, amount: $currentDonationCreationObject.donation.categorySplit.schoolSupplies },
    'Lunch and Snacks': { percent: 25, amount: $currentDonationCreationObject.donation.categorySplit.lunchAndSnacks },
  };
  let personalNote = $currentDonationCreationObject.donation.personalNote;

  const initiateDonationValues = async () => {
    // Set values according to payment type
    setValuesForPaymentType();

    // Adjust donationSplit percentages based on any existing values
    updateCategoryPercentages();
  };

  let isUnsupportedPaymentType = false;
  let currencyUnitText = $currentDonationCreationObject.donation.currencyUnitText;
  let needsCurrencyUnitAddition = $currentDonationCreationObject.donation.needsCurrencyUnitAddition;

  // Some values are flexible and need to be set based on which payment type is selected
  const setValuesForPaymentType = () => {
    switch($currentDonationCreationObject.donation.paymentType) {
      case 'BTC':
        setValuesForBTC();
        break;
      // Add cases for other supported payment types here
      default:
        isUnsupportedPaymentType = true; // Will show an error
    };
  };

  const setValuesForBTC = () => {
    // Calculate available amount to donate
    if ($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject) {
      availableAmountToDonate = Number($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.totalValue - $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.valueDonated);
    };
    $currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate = availableAmountToDonate;
  };

  const setPersonalNote = () => {
    $currentDonationCreationObject.donation.personalNote = personalNote;
    updateToggle += 1;
  };

  const categoryNameTranslator = {
    'Curriculum Design and Development': "curriculumDesign",
    'Teacher Support': "teacherSupport",
    'School Supplies': "schoolSupplies",
    'Lunch and Snacks': "lunchAndSnacks",
  };

  const setCurrentDonationCreationObject = () => {
    $currentDonationCreationObject.donation.totalDonation = totalDonationAmount;
    // only exact split is needed (not percentage)
    let categorySplit = {
      curriculumDesign: 0.0,
      teacherSupport: 0.0,
      schoolSupplies: 0.0,
      lunchAndSnacks: 0.0,
    };
    for (let category in donationSplits) {
      categorySplit[categoryNameTranslator[category]] = donationSplits[category].amount;
    };
    $currentDonationCreationObject.donation.categorySplit = categorySplit;
    $currentDonationCreationObject.donation.personalNote = personalNote;
    updateToggle += 1;
  };

  // Function to update the split to be equal
  function updateToEqualDonationSplits() {
    const equalSplit = 100 / Object.keys(donationSplits).length;
    for (let category in donationSplits) {
      donationSplits[category].percent = equalSplit;
    };
  };

  function handleTotalDonationUpdate() {
    if (totalDonationAmount > availableAmountToDonate) {
      totalDonationIsBiggerThanAvailableAmountToDonate = true;
    };
    updateCategoryAmounts();
    validateSplits();
  };

  function setTotalDonationToAvailable() {
    totalDonationAmount = availableAmountToDonate;
    handleTotalDonationUpdate();
  };

  function validateSplits() {
    let totalPercentage : number = 0;

    totalPercentage = Object.values(donationSplits).reduce((total, { percent }) => total + percent, 0);
    
    // Update the isValidSplit based on whether the total percentage equals 100
    isValidSplit = totalPercentage === 100;
    setCurrentDonationCreationObject();
  };

  // Function to update category amounts when total or percentages change
  function updateCategoryAmounts() {
    const totalPercent = 100; // Assuming the total percent should always equal 100
    Object.entries(donationSplits).forEach(([category, { percent }]) => {
      donationSplits[category].amount = parseFloat((totalDonationAmount * percent / totalPercent).toFixed(0));
    });
  };

  // Function to update category percentages when amounts change
  function updateCategoryPercentages() {
    // Calculate the total amount to ensure the sum of individual category amounts
    const totalAmount = Object.values(donationSplits).reduce((total, { amount }) => total + amount, 0);
    // Check to avoid division by zero in case totalAmount is 0
    if (totalAmount > 0) {
      Object.keys(donationSplits).forEach(category => {
        // Update the percentage based on the category split
        donationSplits[category].percent = (donationSplits[category].amount / totalAmount) * 100;
      });
    };
  };

  // Function to update category percentages and amounts directly
  function updateCategoryDetail(category, value, isSettingAmount = false) {
    if (isSettingAmount) {
      const totalAmount = Object.values(donationSplits).reduce((total, { amount }) => total + amount, 0);
      donationSplits[category].amount = value;
      if (totalAmount != totalDonationAmount) {
        isValidSplit = false;
      };
      updateCategoryPercentages();
    } else {
      donationSplits[category].percent = value;
      updateCategoryAmounts();
    };
    validateSplits();
  };

  onMount(initiateDonationValues);

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Specify Donation Details</h1>
    {#if isUnsupportedPaymentType}
      <NonSupportedPaymentType />
    {:else}
      <p class="mt-4 text-gray-600 dark:text-gray-300">Please fill out the following details about your donation.</p>
      <p class="font-semibold mt-4 text-gray-600 dark:text-gray-300">Available amount to donate:</p>
      <p class="font-semibold py-2 text-gray-600 dark:text-gray-300">{availableAmountToDonate} {currencyUnitText} {needsCurrencyUnitAddition ? calculateCurrencyUnitAddition($currentDonationCreationObject.donation.paymentType, availableAmountToDonate) : ""}</p>
      <button on:click|preventDefault={setTotalDonationToAvailable} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
        Set Total Donation to Available Amount
      </button>
      {#if totalDonationIsBiggerThanAvailableAmountToDonate}
        <p id='totalDonationTooBigSubtext' class="text-red-500 dark:text-red-400">Your Total Donation cannot be bigger than your available amount!</p>
      {/if}
      <div class="mt-4">
        <label for="totalDonation" class="font-semibold block mb-2 text-gray-600 dark:text-gray-300">Total Donation:</label>
        <input
          type="number"
          id="totalDonation"
          min="0"
          step="1"
          bind:value={totalDonationAmount}
          on:input={handleTotalDonationUpdate}
          class="border p-2 w-full dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          placeholder="Enter amount to donate"
        />
        <p class="text-gray-600 dark:text-gray-300">{currencyUnitText} {needsCurrencyUnitAddition ? calculateCurrencyUnitAddition($currentDonationCreationObject.donation.paymentType, totalDonationAmount) : ""}</p>
      </div>
      {#if !isValidSplit}
        <p id='categorySplitNotValidSubtext' class="text-red-500 dark:text-red-400">Your Category split needs to sum up to 100% and to your Total Donation!</p>
      {/if}
      <div class="mt-4">
        {#each Object.entries(donationSplits) as [category, categoryValues], index}
          <div class="mt-4">
            <label class="font-semibold block mb-2 text-gray-600 dark:text-gray-300">{category}:</label>
            <div>
              <input
                type="number"
                min="0"
                max="100"
                class="border p-2 w-1/2 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                placeholder="Percentage"
                bind:value={donationSplits[category].percent}
                on:input={(e) => updateCategoryDetail(category, parseFloat(e.target.value) || 0.0)}
              />
              <p class="text-gray-600 dark:text-gray-300">% of Total Donation</p>
            </div>
            <div>
              <input
                type="number"
                min="0"
                step="1"
                class="border p-2 w-1/2 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                placeholder="Exact amount for category"
                bind:value={donationSplits[category].amount}
                on:input={(e) => updateCategoryDetail(category, parseFloat(e.target.value) || 0.0, true)}
              />
              <p class="text-gray-600 dark:text-gray-300">{currencyUnitText} {needsCurrencyUnitAddition ? calculateCurrencyUnitAddition($currentDonationCreationObject.donation.paymentType, donationSplits[category].amount) : ""}</p>
            </div>
          </div>
        {/each}
      </div>
      <div class="mt-4">
        <label for="personalNote" class="block mb-2 text-gray-600 dark:text-gray-300">Personal Note (Optional):</label>
        <textarea
          id="personalNote"
          bind:value={personalNote}
          on:input={setPersonalNote}
          class="border p-2 w-full dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          rows="4"
          placeholder="Add a personal note..."
        ></textarea>
      </div>      
    {/if}  
  </div>
</section>