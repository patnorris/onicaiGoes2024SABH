<script>
	import BitcoinStep from './BitcoinStep.svelte';
	import TransactionStep from './TransactionStep.svelte';
	import RecipientStep from './RecipientStep.svelte';
	import DonationStep from './DonationStep.svelte';
	import ConfirmationStep from './ConfirmationStep.svelte';

	export let active_step;
	let formData = {
		name: '',
		surname: '',
		email: '',
		password: '',
		address: '',
		city: '',
		country: '',
		postcode: '',
		account_name: '',
		card_no: ''
	}
	
	const handleSubmit = () => {
		console.log("Your form data => ", formData)
	}

</script>

<form class="form-container" on:submit={handleSubmit}>
	{#if active_step == 'Bitcoin'}
		<!-- <InputField type={'password'} label={'Password'} bind:value={formData.password}/> -->
		<BitcoinStep />
	{:else if active_step == 'Transaction'}
		<!-- <InputField label={'Address'} bind:value={formData.address}/> -->
		<TransactionStep />
	{:else if active_step == 'Recipient'}
		<RecipientStep />
  {:else if active_step == 'Donation'}
  		<DonationStep />
	{:else if active_step == 'Confirmation'}
		<!-- <div class="message">
			<h2>Thank you for choosing us</h2>
			<button class="btn submit">Finish </button>
		</div> -->
		<ConfirmationStep />
	{/if}
</form>

<style>
	
	.form-container {
		background-color: #fff;
		border-radius: 10px;
		box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1), 0 6px 6px rgba(0, 0, 0, 0.1);
		padding: 50px 20px;
		text-align: center;
		max-width: 100%;
		width: 350px;
	}
	.btn{
		color: white;
		padding: 0.5rem 0;
		margin-top: 0.5rem;
		display: inline-block;
		width: 100%;
		border-radius: 0.25rem;
		cursor:pointer;
	}
	.submit{
		background:linear-gradient(to bottom, #44c767 5%, #50b01c 100%);
		background-color:#44c767;
	}
	.submit:hover {
		background:linear-gradient(to bottom, #50b01c 5%, #44c767 100%);
		background-color:#50b01c;
	}
	.message{
		text-align: center;
	}
</style>