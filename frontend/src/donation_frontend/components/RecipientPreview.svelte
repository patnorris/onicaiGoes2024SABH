<script lang="ts">
  import { push } from "svelte-spa-router";

  import RecipientProfile from "../components/RecipientProfile.svelte";

  export let recipientPreview;
  export let embedded = false;

  let loadRecipientProfile = false;

  const handleClick = async () => {
    if (embedded) {
      loadRecipientProfile = true;
    } else {
      push(`#/recipient/${recipientPreview.id}`);
    };
  };
</script>

<div class="responsive">
  {#if loadRecipientProfile}
    <RecipientProfile recipientId={recipientPreview.id} embedded={embedded} />
  {:else}
    <div class="space space-y-1">
      <div class="recipient-preview-content">
        <p>{recipientPreview.name}</p>
        <p>TODO: Image</p>
      </div>
      <button on:click|preventDefault={handleClick} class="active-app-button bg-slate-500 text-white py-2 px-4 rounded font-semibold">View Profile</button>
    </div>
  {/if}
</div>
