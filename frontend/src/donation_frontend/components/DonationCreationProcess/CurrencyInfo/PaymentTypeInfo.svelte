<script lang="ts">
  import { currentDonationCreationObject } from "../../../store";
  import { onMount } from 'svelte';

  let PaymentInfoComponent;

  const loadPaymentInfoComponent = async (paymentType) => {
    switch(paymentType) {
      case 'BTC':
        PaymentInfoComponent = (await import('./PaymentTypes/BitcoinPaymentInfo.svelte')).default;
        break;
      // Add cases for other payment types here
      default:
        PaymentInfoComponent = null;
    }
  };

  // Reactively update the PaymentInfoComponent based on the selected payment type
  $: $currentDonationCreationObject.donation.paymentType, loadPaymentInfoComponent($currentDonationCreationObject.donation.paymentType);

  onMount(() => {
    loadPaymentInfoComponent($currentDonationCreationObject.donation.paymentType);
  });
</script>

{#if PaymentInfoComponent}
  <svelte:component this={PaymentInfoComponent} />
{:else}
  <p>Please select a payment type to see more information.</p>
{/if}
