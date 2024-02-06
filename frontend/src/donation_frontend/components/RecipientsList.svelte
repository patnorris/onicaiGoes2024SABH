<script lang="ts">
  import { onMount } from "svelte";
  import { store } from "../store";
  import RecipientPreviews from "./RecipientPreviews.svelte";

  export let embedded = false;

  let hasLoadedRecipients = false;
  let loadedRecipients = [];
  let loadingRecipientsError = false;

  const loadRecipients = async () => {
    // Backend Canister Integration
      // Parameters: record with filters ({include: "schools" | “studentsForSchool”, recipientIdForSchool: “id” | null})
      // Returns: 
        // Success: Ok wraps record with list of RecipientOverviews (including empty list (if none exist))
        // Error: Err wraps more info
        // Result<{recipients : [RecipientOverviews]}, ApiError>;
    const recipientIdForSchool : [string] = [] as unknown as [string];
    const listRecipientsInput = {
      filters: [{include: "schools", recipientIdForSchool }]
    };
    console.log("DEBUG loadRecipients listRecipientsInput ", listRecipientsInput);
    const listRecipientsResponse = await $store.backendActor.listRecipients(listRecipientsInput);
    console.log("DEBUG loadRecipients listRecipientsResponse ", listRecipientsResponse);
    // @ts-ignore
    if (listRecipientsResponse.Err) {
      loadingRecipientsError = true;
    } else {
      // @ts-ignore
      const recipients = listRecipientsResponse.Ok.recipients;
      console.log("DEBUG loadRecipients recipients ", recipients);
      const numberOfAvailableRecipients = recipients.length;
      if (numberOfAvailableRecipients < 1) {
        document.getElementById("recipientsSubtext").innerText = "There are not recipients available yet. Do you know any school that would be interested?";
      } else {
        document.getElementById("recipientsSubtext").innerText = numberOfAvailableRecipients === 1 
          ? `Great, there is ${numberOfAvailableRecipients} school for you to consider! Let's take a look:`
          : `Great, there are ${numberOfAvailableRecipients} schools for you to consider! Let's take a look:`;

        loadedRecipients = recipients;
        hasLoadedRecipients = true;
      };
    };
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
