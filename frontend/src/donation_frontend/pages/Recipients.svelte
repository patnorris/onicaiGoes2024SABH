<script lang="ts">
  import { onMount } from "svelte";
  import { push } from "svelte-spa-router";
  import { store } from "../store";
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import RecipientPreviews from "../components/RecipientPreviews.svelte";

  let hasLoadedRecipients = false;
  let loadedRecipients = [];

  const loadRecipients = async () => {
    const recipients = await $store.backendActor.listRecipients({include: "schools"});
    const numberOfAvailableRecipients = recipients.length;
    if (numberOfAvailableRecipients < 1) {
      document.getElementById("recipientsSubtext").innerText = "There are not recipients available yet. Do you know any school that would be interested?";
    } else {
      document.getElementById("recipientsSubtext").innerText = numberOfAvailableRecipients === 1 
        ? `Great, there is ${numberOfAvailableRecipients} school for you to consider! Let's take a look:`
        : `Great, there are ${numberOfAvailableRecipients} schools for you to consider! Let's take a look:`;

      loadedRecipients = recipients;
      hasLoadedRecipients = true;
    }
  };

  onMount(loadRecipients);
</script>

<Topnav />

<section id="spaces" class="py-7 space-y-6 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">Schools</h3>
    <p id='recipientsSubtext'>Click on any school to find out more and donate.</p>
    {#if hasLoadedRecipients}
      <RecipientPreviews recipientPreviews={loadedRecipients} />
    {/if}
</section>

<div class='clearfix'></div>

<Footer />
