<script lang="ts">
  import { currentDonationCreationObject } from "../../../store";
  import TransactionInfo from "./TransactionInfo.svelte"; // This component displays info on the relevant transaction (based on selected paymentType)
</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]" >
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Check Transaction</h1>  

    <p class="mt-4 text-black dark:text-white font-semibold">Currently selected payment type: {$currentDonationCreationObject.donation.paymentType}</p>
    <p class="mt-2 text-black dark:text-white">You can change the payment type on the previous step.</p>

    <div class="py-4 mt-4 space-y-3 bg-blue-50 dark:bg-blue-800 shadow-md border border-gray-300 dark:border-gray-700 rounded-lg">
      <TransactionInfo />
    </div>

  </div>  
</section>