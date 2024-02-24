<script>
  import { currentDonationCreationObject } from "../../../store";
  import InAppPaymentCheck from './PaymentTypes/InAppPaymentCheck.svelte';
  import NonSupportedPaymentType from '../NonSupportedPaymentType.svelte';

  let TransactionComponent;

  $: if ($currentDonationCreationObject.donation.inAppPayment) {
    TransactionComponent = InAppPaymentCheck;
  } else {
    // Dynamically import based on the payment type
    switch($currentDonationCreationObject.donation.paymentType) {
      case 'BTC':
        import('./PaymentTypes/BitcoinTransaction.svelte').then(module => {
          TransactionComponent = module.default;
        });
        break;
      // Add cases for other supported payment types here
      default:
        TransactionComponent = NonSupportedPaymentType; // Use the non-supported payment type component for unsupported types
    };
  }
</script>

<svelte:component this={TransactionComponent} />