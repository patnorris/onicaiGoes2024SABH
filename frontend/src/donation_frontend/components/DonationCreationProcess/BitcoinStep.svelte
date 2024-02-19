<script lang="ts">
  import { currentDonationCreationObject } from "../../store";
</script>

<section class="bg-white dark:bg-gray-900 bg-[url('/images/hero-pattern.svg')]">
  <div class="py-8 px-4 mx-auto max-w-screen-xl text-center lg:py-16 z-10 relative">
    <h1 class="mb-4 text-4xl font-extrabold tracking-tight leading-none text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
      Send Bitcoin</h1>  
    <p class="mt-4 text-gray-600 dark:text-gray-300">Send Bitcoin to the donation wallet shown below, then record your donation details here on the app.</p>
    <div class="mt-2 font-bold text-gray-700 dark:text-gray-100 break-all">
      Donation Wallet Address: 
      <span class="inline-block bg-gray-200 dark:bg-gray-700 rounded px-2 py-1 break-all">
        {$currentDonationCreationObject.donationWalletAddresses.BTC}
      </span>
      <button on:click|preventDefault={() => navigator.clipboard.writeText('mtKKFKUu49WnU4CCPV9v2eV69pPCVU3kZG')} class="ml-2 bg-blue-500 hover:bg-blue-700 text-white font-bold py-1 px-2 rounded text-xs">Copy</button>
    </div>
    <p class="mt-2 font-bold text-gray-700 dark:text-gray-100">Important: this address is on the Bitcoin Testnet. Only use the Testnet, not the Mainnet to send bitcoin, otherwise they will be lost!</p>
    <p class="text-gray-600 dark:text-gray-300">Use any of your Bitcoin wallets to send the bitcoin you want to donate. Make sure to keep the Bitcoin Transaction Id you'll receive from your wallet, you will need it to proceed.</p>
    <p class="text-gray-600 dark:text-gray-300">Once the transaction is confirmed on the Bitcoin network (this can take a few minutes), you can continue by entering the Bitcoin Transaction Id on the next step.</p>
  </div>
</section>
