<script lang="ts">
  import Topnav from "../components/Topnav.svelte";
  import Footer from "../components/Footer.svelte";
</script>

<Topnav />

<!-- Main Hero Section -->
<div class="intro-hero-section">
  <img src="./BitcoinDonationApp_banner.png" alt="Open Internet Metaverse banner" class="intro-hero-background-image">
  <div class="intro-hero-overlay">
    <h1>Thank you for Donating</h1>
    <p class="intro-lead-text">Donate bitcoin to Schools and Students you care about.</p>
  </div>
</div>

<!-- Detailed Information -->
<section id="oim-detail" class="intro-section-container intro-bg-alternate">
  <h3 class="intro-section-header">The Bitcoin Donation App</h3>
  <img src="./BitcoinDonationApp_img.png" alt="The Bitcoin Donation App" class="intro-detail-image">
  
  <p class="intro-section-text">
    Bitcoin Donations
  </p>

  <p class="intro-section-text">
    For Schools and Students
  </p>

  <p class="intro-section-text">
    With an App running on the decentralized cloud Internet Computer
  </p>
</section>

<Footer />

<style>
/* NOTE: these styles are global and affect any element in the app. Thus, ensure that there aren't any conflicts with the class names chosen (i.e. avoid generic names as they might conflict with an A-Frame class, e.g. content which is used in the Inspector)  */

  .intro-hero-section {
    position: relative; /* Added to make it a parent for absolute positioning */
    height: 100vh;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 5rem 0;
    text-align: center;
  }
  .intro-hero-section h1 {
    font-size: 3.5rem;
    color: #fff;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
    font-weight: bold;
  }
  .intro-lead-text {
    font-size: 1.7rem;
    color: #ddd;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
    font-weight: bold;
  }
  .intro-hero-background-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: -1; /* Set z-index to -1 to make it below the text content */
    object-fit: cover; /* Cover the entire div without distortion */
  }
  .intro-hero-section::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(rgba(0, 0, 0, 0.15), rgba(0, 0, 0, 0.15));
    background-repeat: no-repeat;
    background-position: center center;
    background-attachment: fixed;
    z-index: 0; /* Layer it above the image but below the text */
  }
  .intro-hero-overlay {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    width: 100%;
  }
  .intro-section-container {
    padding: 4rem 0;
    text-align: center;
  }
  .intro-section-header {
    font-size: 2.2rem;
    margin-bottom: 1rem;
  }
  .intro-section-text {
    font-size: 1.1rem;
    margin-bottom: 2rem;
  }
  .intro-bg-alternate {
    background-color: #eaf1f7;
  }
  .intro-detail-image {
    display: block;
    max-width: 400px;
    height: auto;
    margin: auto;
    margin-bottom: 1rem;
  }
</style>
