<script lang="ts">
  import { onMount } from "svelte";

  import { store } from "../store";

  import NotFound from "./NotFound.svelte";

// This is needed for URL params
  export let params;

// Load recipient from data stored in backend canister
  let loadingInProgress = true;
  let recipientLoadingError = false;
  let recipient;
  let recipientLoaded = false;
  
  const loadRecipientDetails = async () => {
    // If viewer is logged in, make authenticated call (otherwise, default backendActor in store is used)
    // @ts-ignore
    const recipientResponse = await $store.backendActor.getRecipient(Number(params.recipientId));
    
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
  TODO      
  
  {/if}
</div>
