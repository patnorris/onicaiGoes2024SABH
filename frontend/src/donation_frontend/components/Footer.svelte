<script lang="ts">
  import { location } from 'svelte-spa-router';
  import { submitEmailSignUpForm } from "../helpers/utils.js";

  let message = "";
  const submitForm = async (event) => {
    event.preventDefault();
    const email = document.getElementById('hero-email').value;
    message = await submitEmailSignUpForm(email, $location);
  };
</script>

<footer class='py-6 text-center bg-orange-100 dark:bg-gray-800' id='about'>
  <div>
    <p class="text-gray-500 dark:text-gray-400 mb-2 mt-12"><sup>*</sup>developed for 
      <a href='https://knowledgefound.org/token.html' target='_blank' rel="noreferrer" class='underline'>Knowledge Foundation</a>
      at <a href='https://summit.immersiveeducation.org/SouthAfrica/2024/hackathon.html' target='_blank' rel="noreferrer" class='underline'>2024 SOUTH AFRICAN BLOCKCHAIN Hackathon</a>
      by <a href='https://github.com/patnorris/onicaiGoes2024SABH' target='_blank' rel="noreferrer" class='underline'>Arjaan Buijk & Patrick Friedrich</a>
      and hosted on <a href='https://internetcomputer.org/' target='_blank' rel="noreferrer" class='underline dark:hover:text-blue-300'>Internet Computer</a></p>
    <p class="text-4xl text-gray-700 dark:text-gray-200 mt-0 mb-12">Want to be the first to hear about updates?</p>

    <form on:submit={submitForm} class="email-signup-form mb-12">
      <input type="email" id="hero-email" class="email-signup-form-input rounded-l-full" placeholder="&nbsp;&nbsp;&nbsp;Enter your email...">
      <button type="submit" class="w-48 text-white bg-blue-700 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 rounded-r-full text-sm px-5 py-3 text-center mr-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Submit</button>
    </form>
    {#if message}
      <h2 class="dark:text-white">{message}</h2>
    {/if}
  </div>
</footer>

<footer class="bg-white dark:bg-gray-700 rounded-lg shadow">
  <div class="w-full max-w-screen-xl mx-auto p-4 md:py-8">
    <div class="sm:flex sm:items-center sm:justify-between">
      <a href="#top" class="flex items-center mb-4 sm:mb-0">
        <img src="/images/bitcoinDonationApp_logo_app.svg" class="h-9 mr-8" alt="logo" />
      </a>
      <ul class="flex flex-wrap items-center mb-6 text-sm font-medium text-gray-500 sm:mb-0 dark:text-gray-400">
        <li>
          <a href="#/donate" class="mr-4 hover:underline md:mr-6 dark:hover:text-blue-300">Donate</a>
        </li>
        <li>
          <a href="#/explore" class="mr-4 hover:underline md:mr-6 dark:hover:text-blue-300">Donations</a>
        </li>
        <li>
          <a href="#/recipients" class="mr-4 hover:underline md:mr-6 dark:hover:text-blue-300">Recipients</a>
        </li>
        <li>
          <a href="#/about" class="mr-4 hover:underline md:mr-6 dark:hover:text-blue-300">About</a>
        </li>
      </ul>
    </div>
    <hr class="my-6 border-gray-200 sm:mx-auto dark:border-gray-700 lg:my-8" />
    <span class="block text-sm text-gray-500 sm:text-center dark:text-gray-400">Powered by <a href='https://internetcomputer.org/' target='_blank' rel="noreferrer" class='underline dark:hover:text-blue-300'>Internet Computer</a></span>
  </div>
</footer>

<style>
  .email-signup-form {
      display: flex;
      justify-content: center;
      align-items: center;
  }

  .email-signup-form-input[type="email"] {
      padding: 10px;
      font-size: 1em;
      margin-right: 10px;
      color: #000000;
  }

  .email-signup-form-input {
    width: 50vw;
    background: #dddddd;
    color: #1d1d2f;
  }

  .email-signup-form-button {
      padding: 10px 20px;
      font-size: 1em;
      background-color: #4ebaa5;
      color: #ffffff;
      border: none;
      cursor: pointer;
  }
  </style>
