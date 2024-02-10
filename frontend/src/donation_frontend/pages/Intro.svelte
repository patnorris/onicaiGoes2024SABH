<script lang="ts">
  import { push } from "svelte-spa-router";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
</script>

<Topnav />

<div class="grid grid-cols-1 md:grid-cols-2 gap-0">
  <div class="bg-blue-600 dark:bg-blue-800">
    <img class="w-full" src="/images/bitcoinDonationApp_intro_donate.png" alt="Create Donation graphic" />
  </div>
  <div class="p-12 flex flex-col justify-center bg-gray-100 dark:bg-gray-700">
    <h3 class="text-4xl text-gray-600 dark:text-gray-300 mb-8">Your Bitcoin Donations</h3>
    <p class="mb-8 text-lg text-gray-500 dark:text-gray-400">
      Donate bitcoin to schools and students here.
    </p>
    <button type="button" id='donateButton' on:click|preventDefault={() => push("#/donate")} class="w-48 text-white bg-blue-700 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 rounded-full text-sm px-5 py-2.5 text-center mr-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Donate Here</button>
  </div>
</div>

<div class="grid grid-cols-1 md:grid-cols-2 gap-0">
  <div class="p-12 flex flex-col justify-center bg-gray-100 dark:bg-gray-700">
    <h3 class="text-4xl text-gray-600 dark:text-gray-300 mb-8">Explore Donations</h3>
    <p class="mb-8 text-lg text-gray-500 dark:text-gray-400">
      View your donations, all donations or find a specific donation.
    </p>
    <button type='button' id='exploreDonationsButton' on:click|preventDefault={() => push("#/explore")} class="w-48 text-white bg-blue-700 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 rounded-full text-sm px-5 py-2.5 text-center mr-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Explore Donations</button>
  </div>
  <div class="bg-amber-200 dark:bg-amber-600">
    <img class="w-full" src="/images/bitcoinDonationApp_intro_explore.png" alt="Explore Donations graphic" />
  </div>
</div>

<div class="grid grid-cols-1 md:grid-cols-2 gap-0">
  <div class="bg-yellow-400 dark:bg-yellow-600">
    <img class="w-full" src="/images/bitcoinDonationApp_intro_recipients.png" alt="Discover Recipients graphic" />
  </div>
  <div class="p-12 flex flex-col justify-center bg-gray-100 dark:bg-gray-700">
    <h3 class="text-4xl text-gray-600 dark:text-gray-300 mb-8">
      Discover Causes Worth Donating For
    </h3>
    <p class="mb-8 text-lg text-gray-500 dark:text-gray-400">
      Find out who the schools and students you can donate to are.
    </p>
    <button type="button" id='recipientsButton' on:click|preventDefault={() => push("#/recipients")} class="w-48 text-white bg-blue-700 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 rounded-full text-sm px-5 py-2.5 text-center mr-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">View Recipients</button>
  </div>
</div>

<div class='clearfix'></div>

<Footer />

<style global>
/* NOTE: these styles are global and affect any element in the app. Thus, ensure that there aren't any conflicts with the class names chosen (i.e. avoid generic names as they might conflict with an A-Frame class, e.g. content which is used in the Inspector)  */
  .App-logo {
    height: 15vmin;
    pointer-events: none;
  }

  .App-header {
    margin-top: 150px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: calc(10px + 2vmin);
  }

  .App-link {
    color: rgb(26, 117, 255);
  }

  .demo-button {
    background: #a02480;
    padding: 0 1.3em;
    margin-top: 1em;
    border-radius: 60px;
    font-size: 0.7em;
    height: 35px;
    outline: 0;
    border: 0;
    cursor: pointer;
    color: white;
  }

  .demo-button:active {
    color: white;
    background: #979799;
  }

  .active-app-button:hover {
    background-color: #555;
  }
</style>
