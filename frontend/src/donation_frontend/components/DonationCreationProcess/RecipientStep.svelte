<script lang="ts">
  import { currentDonationCreationObject } from "../../store";

  import RecipientsList from "../RecipientsList.svelte";
  import RecipientPreview from "../RecipientPreview.svelte";

  let recipientObject = $currentDonationCreationObject.recipient.recipientObject;
  currentDonationCreationObject.subscribe((value) => recipientObject = value.recipient.recipientObject);

</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern-dark.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Step 3: Choose Donation Recipient</h1>	
    <p class="mt-4">Please choose the school or student you would like to donate to.</p>
    {#key recipientObject}
      {#if recipientObject}
        <p id='currentRecipientSubtext'>You have currently selected this recipient:</p>
        <!-- <p id='currentRecipientObjectSubtext'>TODO: {$currentDonationCreationObject.recipient.recipientObject}</p> -->
        <RecipientPreview recipientPreview={recipientObject} embedded={true}/>
      {:else}
        <p id='currentRecipientSubtext'>You have not made your selection yet. Please do so before continuing.</p>
      {/if}
    {/key}
    <div class="mt-4">
      <RecipientsList embedded={true}/>
    </div>
  </div>
</section>