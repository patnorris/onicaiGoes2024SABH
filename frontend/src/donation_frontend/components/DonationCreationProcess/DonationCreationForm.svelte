<script>
	import CurrencyStep from './CurrencyInfo/CurrencyStep.svelte';
	import TransactionStep from './Transaction/TransactionStep.svelte';
	import RecipientStep from './Recipient/RecipientStep.svelte';
	import DonationStep from './Donation/DonationStep.svelte';
	import ConfirmationStep from './Confirmation/ConfirmationStep.svelte';

	export let active_step;
	
	const handleSubmit = () => {
		console.log("form submitted");
	};

</script>

<form class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-12 text-center max-w-full mx-auto" on:submit={handleSubmit}>
	{#if active_step == 'Recipient'}
		<RecipientStep />
	{:else if active_step == 'Currency'}
		<CurrencyStep />
	{:else if active_step == 'Transaction'}
		<TransactionStep />
    {:else if active_step == 'Donation'}
  		<DonationStep />
	{:else if active_step == 'Confirmation'}
		<ConfirmationStep />
	{/if}
</form>