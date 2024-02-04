<script lang="ts">
  import { push } from "svelte-spa-router";

  export let recipientPreview;
</script>

<div class="responsive">
  <div class="space space-y-1">
    <div class="recipient-preview-content">
      <p>{recipientPreview.name}</p>
      <p>TODO: Image</p>
    </div>
    <button on:click={() => push(`#/recipient/${recipientPreview.id}`)} class="active-app-button bg-slate-500 text-white py-2 px-4 rounded font-semibold">View Profile</button>
  </div>
</div>
