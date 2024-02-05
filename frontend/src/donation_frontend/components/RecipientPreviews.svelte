<script lang="ts">
  import RecipientPreview from "./RecipientPreview.svelte";
  
  export let recipientPreviews; // Array of recipient previews
  export let embedded = false;
</script>

<div id='recipientPreviews' class="space-y-4">
  {#each recipientPreviews as recipientPreview}
    <RecipientPreview recipientPreview={recipientPreview} embedded={embedded} />
  {/each}
</div>
