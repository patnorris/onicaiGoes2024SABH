<script>
  import { store } from "../../../../store";
</script>

{#if $store.isAuthed}
  <p>Your donation will be sent from the wallet you're logged in with when submitting the final donation.</p>
{:else}
  <p>Please log in before continuing.</p>
{/if}