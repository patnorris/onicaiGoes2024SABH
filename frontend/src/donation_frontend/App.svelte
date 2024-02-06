<script lang="ts">
  import Router from "svelte-spa-router";

  import Intro from "./pages/Intro.svelte";

  import CreateDonation from "./pages/CreateDonation.svelte";
  import Recipients from "./pages/Recipients.svelte";
  import RecipientDetails from "./pages/RecipientDetails.svelte";

  import DonationsExplorer from "./pages/DonationsExplorer.svelte";
  import MyDonations from "./pages/MyDonations.svelte";
  import DonationsOverview from "./pages/DonationsOverview.svelte";
  import DonationDetails from "./pages/DonationDetails.svelte";

  import About from "./pages/About.svelte";
    
  import NotFound from "./pages/NotFound.svelte";

  const routes = {
    // Exact path (with /# in front of route)
    "/": Intro,
    "/donate": CreateDonation, //e.g. URL: https://....ic0.app/#/donate
    "/recipients": Recipients, 
    "/recipient/:recipientId": RecipientDetails,
    "/explore": DonationsExplorer,
    "/mydonations": MyDonations,
    "/donations": DonationsOverview,
    "/donation/:donationId": DonationDetails,
    "/about": About,
    // Catch-all (this is optional, but if present it must be the last)
    "*": NotFound,
  };
</script>

<div class="App">
  <Router {routes} />
</div>
