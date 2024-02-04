<script lang="ts">
  import RecipientPreview from "./RecipientPreview.svelte";
  
  export let recipientPreviews; // Array of recipient previews
</script>

<div id='recipientPreviews' class="space-y-4">
  {#each recipientPreviews as recipientPreview}
    <RecipientPreview recipientPreview={recipientPreview} />
  {/each}
</div>
