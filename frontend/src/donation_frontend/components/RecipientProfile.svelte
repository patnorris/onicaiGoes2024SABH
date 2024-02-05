<script lang="ts">
    import { onMount } from "svelte";
  
    import { store, currentDonationCreationObject } from "../store";
  
    import NotFound from "../pages/NotFound.svelte";

    import { push } from "svelte-spa-router";
  
  // This is needed for URL params
    export let recipientId;
    export let embedded = false;

    let recipientProfileSelected = false;

    const handleClick = async () => {
        $currentDonationCreationObject.recipient.recipientId = recipientId;
        $currentDonationCreationObject.recipient.recipientObject = recipient;

        if (embedded) {
            recipientProfileSelected = true;
        } else {
            push(`#/donate`);
        };
    };
  
  // Load recipient from data stored in backend canister
    let loadingInProgress = true;
    let recipientLoadingError = false;
    let recipient;
    let recipientLoaded = false;
    
    const loadRecipientDetails = async () => {
      // If viewer is logged in, make authenticated call (otherwise, default backendActor in store is used)
      // @ts-ignore
      const recipientResponse = await $store.backendActor.getRecipient(recipientId);
      
      if (recipientResponse.Err) {
        recipientLoadingError = true;
      } else {
        recipient = recipientResponse.Ok;
        recipientLoaded = true;
      };
  
      loadingInProgress = false;
    };
  
    onMount(loadRecipientDetails);
  </script>
  
  <div>
    {#if loadingInProgress}
      <h1 class="items-center text-center font-bold text-xl bg-slate-300">Loading Details For You!</h1>
    {:else if recipientLoadingError}
      <NotFound />
    {:else if recipientLoaded}
        <div class="space space-y-1">
            <div class="recipient-profile-content">
            <p>{recipient.name}</p>
            <p>TODO: More info</p>
            </div>
            {#if embedded}
                <button on:click={handleClick} class="active-app-button bg-slate-500 text-white py-2 px-4 rounded font-semibold">Set as Donation Recipient</button>
                {#if recipientProfileSelected}
                    <p>You have currently selected this recipient for your donation.</p>
                {:else}
                    <p>This recipient is not selected for your donation currently.</p>
                {/if}
            {:else}
                <button on:click={handleClick} class="active-app-button bg-slate-500 text-white py-2 px-4 rounded font-semibold">Donate</button>
            {/if}
        </div>
    {/if}
  </div>
  