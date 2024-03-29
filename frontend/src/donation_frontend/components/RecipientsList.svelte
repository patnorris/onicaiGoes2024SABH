<script lang="ts">
  import { onMount } from "svelte";
  import { store } from "../store";
  import RecipientPreviews from "./RecipientPreviews.svelte";

  import type { RecipientOverview } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  
  import spinner from "../assets/loading.gif";

  export let embedded = false;
  export let recipientType = "School"; // or StudentsForSchool
  export let schoolRecipientId = ""; // only needed for recipientType StudentsForSchool
  export let callbackFunction = null;

  let isLoading = false;
  let hasLoadedRecipients = false;
  let loadedRecipients : [RecipientOverview] = [] as unknown as [RecipientOverview];
  let loadingRecipientsError = false;

  const loadRecipients = async () => {
    isLoading = true;
    // Backend Canister Integration
      // Parameters: record with filters ({include: "schools" | “studentsForSchool”, recipientIdForSchool: “id” | null})
      // Returns: 
        // Success: Ok wraps record with list of RecipientOverviews (including empty list (if none exist))
        // Error: Err wraps more info
        // Result<{recipients : [RecipientOverviews]}, ApiError>;
    let recipientIdForSchool : [string] = [] as unknown as [string];
    let include = "schools";
    if (recipientType === "StudentsForSchool") {
      include = "studentsForSchool";
      recipientIdForSchool = [schoolRecipientId];
    };
    let listRecipientsInput = {
      include,
      recipientIdForSchool
    };
    const listRecipientsResponse = await $store.backendActor.listRecipients(listRecipientsInput);
    // @ts-ignore
    if (listRecipientsResponse.Err) {
      loadingRecipientsError = true;
    } else {
      // @ts-ignore
      const recipients : [RecipientOverview] = listRecipientsResponse.Ok.recipients;
      loadedRecipients = recipients;
      hasLoadedRecipients = true;
    };
    isLoading = false;
  };

  onMount(loadRecipients);
</script>

<section id="spaces" class="py-7 space-y-6 items-center text-center bg-slate-100 dark:bg-gray-800">
  {#if recipientType === "School"}
    <h3 class="text-xl font-bold text-gray-900 dark:text-white">Schools</h3>
    <p class="text-gray-600 dark:text-gray-300">Click on any school to find out more and donate.</p>
  {:else if recipientType === "StudentsForSchool"}
    <h3 class="text-xl font-bold text-gray-900 dark:text-white">Students</h3>
    <p class="text-gray-600 dark:text-gray-300">Click on any student to find out more and donate.</p>
  {/if}
  {#if isLoading}
    <p id='recipientsSubtext' class="text-gray-600 dark:text-gray-300">Finding recipients for you...</p>
    <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
  {/if}
  {#if hasLoadedRecipients}
    {#if loadedRecipients.length > 0}
      <p id='recipientsSubtext' class="text-gray-600 dark:text-gray-300">Great, there {loadedRecipients.length === 1 ? `is ${loadedRecipients.length} recipient` : `are ${loadedRecipients.length} recipients`} for you to consider! Let's take a look:</p>
      <RecipientPreviews recipientPreviews={loadedRecipients} embedded={embedded} callbackFunction={callbackFunction} />     
    {:else}
      <p id='recipientsSubtext' class="text-gray-600 dark:text-gray-300">There are no recipients available yet. Do you know anyone who would be interested?</p>
    {/if}
  {/if}
</section>

<div class='clearfix'></div>
