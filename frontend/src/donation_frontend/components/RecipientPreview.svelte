<script lang="ts">
  import { push } from "svelte-spa-router";

  import RecipientProfile from "../components/RecipientProfile.svelte";

  import type { RecipientOverview } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
  
  export let recipientPreview : RecipientOverview;
  export let embedded = false;
  export let callbackFunction = null;

  let loadRecipientProfile = false;

  const handleClick = async () => {
    if (embedded) {
      loadRecipientProfile = true;
    } else {
      push(`#/recipient/${recipientPreview.id}`);
    };
  };
</script>

<div class="items-center text-center py-3 space-y-4 bg-white dark:bg-gray-800 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200 ease-in-out">
  {#if loadRecipientProfile}
    <RecipientProfile recipientId={recipientPreview.id} embedded={embedded} callbackFunction={callbackFunction} />
  {:else}
    <div class="space space-y-1">
      <div class="flex items-center space-x-3 w-full">
        <img class="w-24 h-24 rounded-full object-cover" alt="Recipient thumbnail" src={recipientPreview.thumbnail} />
        <p class="font-semibold text-lg flex-grow text-gray-900 dark:text-gray-200">{recipientPreview.name}</p>
      </div>
      <button on:click|preventDefault={handleClick} class="bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded font-semibold dark:bg-slate-600 dark:hover:bg-slate-800">View Profile</button>
    </div>
  {/if}
</div>
