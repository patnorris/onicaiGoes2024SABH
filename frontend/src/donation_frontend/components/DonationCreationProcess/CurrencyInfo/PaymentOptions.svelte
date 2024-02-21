<script lang="ts">
  import { currentDonationCreationObject, supportedPaymentTypes } from "../../../store";

  // Reactive statement to ensure we react to changes in the current donation creation object
  $: currentDonation = $currentDonationCreationObject;

  function updatePaymentType(type) {
    currentDonationCreationObject.update((currentDonation) => {
      currentDonation.donation.paymentType = type;
      return currentDonation;
    });
  }

  // Determine available payment types based on peerToPeerPayment flag
  $: availablePaymentTypes = currentDonation.donation.peerToPeerPayment
    ? Object.entries(currentDonation.recipient.recipientWalletAddresses).filter(([type, address]) => address !== null && address !== "")
    : Object.entries(currentDonation.donationWalletAddresses).filter(([type, address]) => address !== null && address !== "");

  // Extract just the payment types for easier checking against supportedPaymentTypes
  $: enabledPaymentTypes = availablePaymentTypes.map(([type]) => type);
</script>

<div class="mt-4">
  {#each $supportedPaymentTypes as type}
    {#if enabledPaymentTypes.includes(type)}
      <button 
        on:click|preventDefault={() => updatePaymentType(type)} 
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded m-2">
        Select {type}
      </button>
    {:else}
      <button 
        disabled 
        class="bg-gray-500 text-white font-bold py-2 px-4 rounded m-2">
        {type} (Unavailable)
      </button>
    {/if}
  {/each}
</div>
