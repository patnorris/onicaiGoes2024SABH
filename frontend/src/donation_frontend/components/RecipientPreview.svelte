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

<div class="items-center text-center space-y-4 p-4 bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200 ease-in-out">
  {#if loadRecipientProfile}
    <RecipientProfile recipientId={recipientPreview.id} embedded={embedded} callbackFunction={callbackFunction} />
  {:else}
    <div class="space space-y-1">
      <div class="flex items-center space-x-3">
        <img class="w-16 h-16 rounded-full object-cover" alt="Recipient thumbnail" src={recipientPreview.thumbnail} />
        <p class="font-semibold text-lg">{recipientPreview.name}</p>
      </div>
      <button on:click|preventDefault={handleClick} class="active-app-button bg-slate-500 text-white py-2 px-4 rounded font-semibold">View Profile</button>
    </div>
  {/if}
</div>
