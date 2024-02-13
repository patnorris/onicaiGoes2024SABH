<script lang="ts">
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
</script>

<Topnav />

<!-- Main Hero Section -->
<div class="relative flex flex-col items-center justify-center h-screen w-full text-center py-20 bg-cover bg-center" style="background-image: url('./BitcoinDonationApp_banner.png');">
  <div class="relative z-10">
    <h1 class="text-4xl font-bold text-white dark:text-gray-200">Thank you for Donating</h1>
    <p class="mt-4 text-xl text-gray-200 dark:text-gray-400">Donate bitcoin to Schools and Students you care about.</p>
  </div>
  <div class="absolute top-0 left-0 w-full h-full bg-black bg-opacity-30 dark:bg-opacity-60"></div>
</div>

<!-- Detailed Information -->
<section id="about-detail" class="py-16 text-center bg-gray-100 dark:bg-gray-900">
  <h3 class="text-3xl mb-4 text-gray-800 dark:text-gray-200">The Bitcoin Donation App</h3>
  <img src="./BitcoinDonationApp_img.png" alt="The Bitcoin Donation App" class="mx-auto mb-4 max-w-md h-auto">
  <p class="text-lg mb-4 text-gray-600 dark:text-gray-400">Bitcoin Donations</p>
  <p class="text-lg mb-4 text-gray-600 dark:text-gray-400">For Schools and Students</p>
  <p class="text-lg mb-4 text-gray-600 dark:text-gray-400">With an App running on the decentralized cloud Internet Computer</p>
</section>

<Footer />

<style>
  /* Custom Text Shadows */
  .text-shadow {
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
  }

  /* Since Tailwind doesn't support text shadows directly, we define it here. */
  /* For any specific gradients or effects not covered by Tailwind. */

  .intro-hero-section::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(rgba(0, 0, 0, 0.15), rgba(0, 0, 0, 0.15));
    background-repeat: no-repeat;
    background-position: center center;
    background-attachment: fixed;
    z-index: 0; /* Ensure it's above the background image but below text */
  }
</style>

