<script lang="ts">
  import { onMount } from "svelte";
  import { store } from "../store";
  import RecipientPreviews from "./RecipientPreviews.svelte";

  export let embedded = false;

  let hasLoadedRecipients = false;
  let loadedRecipients = [];

  const loadRecipients = async () => {
    // Backend Canister Integration
      // Parameters: record with filters ({include: "schools" | “studentsForSchool”, recipientIdForSchool: “id” | null})
      // Returns: 
        // Success: Ok wraps record with list of RecipientOverviews (including empty list (if none exist))
        // Error: Err wraps more info
        // Result<{recipient : [RecipientOverviews]}, ApiError>;
    const listRecipientsInput = { include: "schools" };
    const recipients = await $store.backendActor.listRecipients(listRecipientsInput);
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

<section id="spaces" class="py-7 space-y-6 items-center text-center bg-slate-100">
  <h3 class="text-xl font-bold">Schools</h3>
    <p id='recipientsSubtext'>Click on any school to find out more and donate.</p>
    {#if hasLoadedRecipients}
      <RecipientPreviews recipientPreviews={loadedRecipients} embedded={embedded} />
    {/if}
</section>

<div class='clearfix'></div>
