<script lang="ts">
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
  import RecipientProfile from "../components/RecipientProfile.svelte";

  // This is needed for URL params
  export let params;
</script>

<Topnav />

<RecipientProfile recipientId={params.recipientId} />

<Footer />

