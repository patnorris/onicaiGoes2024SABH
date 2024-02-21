<script lang="ts">
  import { onMount } from "svelte";
  import { currentDonationCreationObject } from "../../../store";

  let updateToggle = 0;

  const categoryNameTranslator = {
    'Curriculum Design and Development': "curriculumDesign",
    'Teacher Support': "teacherSupport",
    'School Supplies': "schoolSupplies",
    'Lunch and Snacks': "lunchAndSnacks",
  };

  const setCurrentDonationCreationObject = () => {
    $currentDonationCreationObject.donation.totalDonation = totalDonationBTC;
    // only exact split is needed (not percentage)
    let categorySplit = {
      curriculumDesign: BigInt(0.0),
      teacherSupport: BigInt(0.0),
      schoolSupplies: BigInt(0.0),
      lunchAndSnacks: BigInt(0.0),
    };
    for (let category in donationSplits) {
      categorySplit[categoryNameTranslator[category]] = donationSplits[category].btc;
    };
    $currentDonationCreationObject.donation.categorySplit = categorySplit;
    $currentDonationCreationObject.donation.personalNote = personalNote;
    updateToggle += 1;
  };

  let availableBTC = 0.0;
  let totalDonationIsBiggerThanAvailableBTC = false;
  let isValidSplit = true;

  const calculateAvailableBTC = async () => {
    if ($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject) {
      availableBTC = Number($currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.totalValue - $currentDonationCreationObject.bitcoinTransaction.bitcoinTransactionObject.valueDonated);
    };
    $currentDonationCreationObject.bitcoinTransaction.valueLeftToDonate = availableBTC;
  };

  // Donation details
  let totalDonationBTC = 0.0;
  let donationSplits = {
    'Curriculum Design and Development': { percent: 25, btc: 0.0 },
    'Teacher Support': { percent: 25, btc: 0.0 },
    'School Supplies': { percent: 25, btc: 0.0 },
    'Lunch and Snacks': { percent: 25, btc: 0.0 },
  };
  let personalNote = '';

  // Function to update the split to be equal
  function updateToEqualDonationSplits() {
    const equalSplit = 100 / Object.keys(donationSplits).length;
    for (let category in donationSplits) {
      donationSplits[category].percent = equalSplit;
    };
  };

  function handleTotalDonationUpdate() {
    if (totalDonationBTC > availableBTC) {
      totalDonationIsBiggerThanAvailableBTC = true;
    };
    updateCategoryBTC();
    validateSplits();
  };

  function setTotalDonationToAvailable() {
    totalDonationBTC = availableBTC;
    handleTotalDonationUpdate();
  };

  function validateSplits() {
    let totalPercentage : number = 0;

    totalPercentage = Object.values(donationSplits).reduce((total, { percent }) => total + percent, 0);
    
    // Update the isValidSplit based on whether the total percentage equals 100
    isValidSplit = totalPercentage === 100;
    setCurrentDonationCreationObject();
  };

  // Function to update BTC amounts when total or percentages change
  function updateCategoryBTC() {
    const totalPercent = 100; // Assuming the total percent should always equal 100
    Object.entries(donationSplits).forEach(([category, { percent }]) => {
      donationSplits[category].btc = parseFloat((totalDonationBTC * percent / totalPercent).toFixed(0));
    });
  };

  function updatePercentagesBasedOnBTCSplit() {
    // Calculate the total BTC to ensure the sum of individual BTC amounts.
    const totalBTC = Object.values(donationSplits).reduce((total, { btc }) => total + btc, 0);
    // Check to avoid division by zero in case totalBTC is 0
    if (totalBTC > 0) {
      Object.keys(donationSplits).forEach(category => {
        // Update the percentage based on the BTC split
        donationSplits[category].percent = (donationSplits[category].btc / totalBTC) * 100;
      });
    };
  };

  // Function to update percentages and BTC amounts directly
  function updateCategoryDetail(category, value, isBTC = false) {
    if (isBTC) {
      const totalBTC = Object.values(donationSplits).reduce((total, { btc }) => total + btc, 0);
      donationSplits[category].btc = value;
      if (totalBTC != totalDonationBTC) {
        isValidSplit = false;
      };
      updatePercentagesBasedOnBTCSplit();
    } else {
      donationSplits[category].percent = value;
      updateCategoryBTC();
    };
    validateSplits();
  };

  onMount(calculateAvailableBTC);

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Specify Donation Details</h1>  
    <p class="mt-4 text-gray-600 dark:text-gray-300">Please fill out the following details about your donation.</p>
    <p class="font-semibold mt-4 text-gray-600 dark:text-gray-300">Available bitcoin (from the transaction step):</p>
    <p class="font-semibold py-2 text-gray-600 dark:text-gray-300">{availableBTC} Satoshi (equals {(availableBTC / 100000000.0).toFixed(8)} BTC)</p>
    <button on:click|preventDefault={setTotalDonationToAvailable} class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
      Set Total Donation to Available BTC
    </button>
    {#if totalDonationIsBiggerThanAvailableBTC}
      <p id='totalDonationTooBigSubtext' class="text-red-500 dark:text-red-400">Your Total Donation cannot be bigger than your available BTC!</p>
    {/if}
    <div class="mt-4">
      <label for="totalDonation" class="block mb-2 text-gray-600 dark:text-gray-300">Total Donation:</label>
      <input
        type="number"
        id="totalDonation"
        min="0"
        step="1"
        bind:value={totalDonationBTC}
        on:input={handleTotalDonationUpdate}
        class="border p-2 w-full dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        placeholder="Enter amount in Satoshi"
      />
      <p class="text-gray-600 dark:text-gray-300">Satoshi (equals {(totalDonationBTC / 100000000.0).toFixed(8)} BTC)</p>
    </div>
    {#if !isValidSplit}
      <p id='categorySplitNotValidSubtext' class="text-red-500 dark:text-red-400">Your Category split needs to sum up to 100% and the allocated BTC to your Total Donation!</p>
    {/if}
    <div class="mt-4">
      {#each Object.entries(donationSplits) as [category, categoryValues], index}
        <div class="mt-4">
          <label class="block mb-2 text-gray-600 dark:text-gray-300">{category}:</label>
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
              placeholder="BTC amount"
              bind:value={donationSplits[category].btc}
              on:input={(e) => updateCategoryDetail(category, parseFloat(e.target.value) || 0.0, true)}
            />
            <p class="text-gray-600 dark:text-gray-300">Satoshi (equals {(donationSplits[category].btc / 100000000.0).toFixed(8)} BTC)</p>
          </div>
        </div>
      {/each}
    </div>
    <div class="mt-4">
      <label for="personalNote" class="block mb-2 text-gray-600 dark:text-gray-300">Personal Note (Optional):</label>
      <textarea
        id="personalNote"
        bind:value={personalNote}
        class="border p-2 w-full dark:bg-gray-700 dark:border-gray-600 dark:text-white"
        rows="4"
        placeholder="Add a personal note..."
      ></textarea>
    </div>    
  </div>
</section>