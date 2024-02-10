<script lang="ts">
  import RecipientPreview from "./RecipientPreview.svelte";

  import type { RecipientOverview } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";
    
  export let recipientPreviews : [RecipientOverview]; // Array of recipient previews
  export let embedded = false;
  export let callbackFunction = null;
</script>

<div id='recipientPreviews' class="space-y-4">
  {#each recipientPreviews as recipientPreview}
    <RecipientPreview recipientPreview={recipientPreview} embedded={embedded} callbackFunction={callbackFunction} />
  {/each}
</div>
