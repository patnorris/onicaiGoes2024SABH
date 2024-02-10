<script lang="ts">
  import { currentDonationCreationObject } from "../../store";

  import RecipientsList from "../RecipientsList.svelte";
  import RecipientPreview from "../RecipientPreview.svelte";

  import type { SchoolInfo, StudentInfo } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  
  let recipientInfo : SchoolInfo | StudentInfo = $currentDonationCreationObject.recipient.recipientInfo;
  currentDonationCreationObject.subscribe((value) => recipientInfo = value.recipient.recipientInfo);

  const handleContinue = () => {
		$currentDonationCreationObject.currentActiveFormStepIndex++;
	};

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-1 sm:px-3 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-3xl sm:text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 3: Choose Donation Recipient</h1>  
    <p class="mt-4">Please choose the school or student you would like to donate to.</p>
    <div class="py-3 space-y-3">
      {#key recipientInfo}
        {#if recipientInfo}
          <div class="py-4 mt-4 space-y-3 bg-blue-50 shadow-md border border-gray-300 rounded-lg">
            <p id='currentRecipientSubtext' class="text-black font-semibold">You have currently selected this recipient:</p>
            <RecipientPreview recipientPreview={recipientInfo} embedded={true} callbackFunction={handleContinue} />
          </div>
        {:else}
          <p id='currentRecipientSubtext'>You have not made your selection yet. Please do so before continuing.</p>
        {/if}
      {/key}
    </div>
    <div class="mt-4">
      <RecipientsList embedded={true} recipientType={"School"} callbackFunction={handleContinue} />
    </div>
  </div>
</section>