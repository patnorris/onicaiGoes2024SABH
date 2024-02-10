<script lang="ts">
    import { onMount } from "svelte";
  
    import { store, currentDonationCreationObject } from "../store";
  
    import NotFound from "../pages/NotFound.svelte";
    import RecipientSchoolInfo from "./RecipientSchoolInfo.svelte";
    import RecipientStudentInfo from "./RecipientStudentInfo.svelte";
    import RecipientsList from "./RecipientsList.svelte";

    import { push } from "svelte-spa-router";

    import type { RecipientResult, Recipient, SchoolInfo, StudentInfo } from "src/declarations/donation_tracker_canister/donation_tracker_canister.did";

    import spinner from "../assets/loading.gif";
  
    export let recipientId;
    export let embedded = false;
    export let callbackFunction = null;

    let recipientProfileSelected = $currentDonationCreationObject.recipient.recipientId === recipientId;

    const handleClick = async () => {
      $currentDonationCreationObject.recipient.recipientId = recipientId;
      $currentDonationCreationObject.recipient.type = recipientType;
      $currentDonationCreationObject.recipient.recipientObject = recipient;
      $currentDonationCreationObject.recipient.recipientInfo = recipientInfo;

      if (embedded) {
        recipientProfileSelected = true;
        if (callbackFunction) {
          callbackFunction();
        };
      } else {
        push(`#/donate`);
      };
    };
  
  // Load recipient from data stored in backend canister
    let loadingInProgress = true;
    let recipientLoadingError = false;
    let recipient : Recipient;
    let recipientType;
    let recipientInfo : SchoolInfo | StudentInfo;
    let recipientLoaded = false;
    
    const loadRecipientDetails = async () => {
      console.log("DEBUG loadRecipientDetails recipientId ", recipientId);
      if (!recipientId) {
        recipientLoadingError = true;
      } else {
        // If viewer is logged in, make authenticated call (otherwise, default backendActor in store is used)
        // Backend Canister Integration
          // Parameters: record with id
          // Returns: 
            // Success: Ok wraps record with Recipient
            // Error: Err wraps more info (including if not found)
            // Result<?{recipient : Recipient}, ApiError>;

        const getRecipientInput = {
          recipientId
        };
        const recipientResponse : RecipientResult = await $store.backendActor.getRecipient(getRecipientInput);
        // @ts-ignore
        if (recipientResponse.Err) {
          recipientLoadingError = true;
        } else {
          // @ts-ignore
          const recipientRecord = recipientResponse.Ok;
          if (recipientRecord.length > 0) {
            recipient = recipientRecord[0].recipient;
            // @ts-ignore
            if (recipient.School) {
              recipientType = "School";
              // @ts-ignore
              recipientInfo = recipient.School;
              // @ts-ignore
            } else if (recipient.Student) {
              recipientType = "Student";
              // @ts-ignore
              recipientInfo = recipient.Student;
            } else {
              recipientLoadingError = true;
            };
            recipientLoaded = true;
          } else {
            recipientLoadingError = true;
          };
        };
      };
  
      loadingInProgress = false;
    };
  
    onMount(loadRecipientDetails);
  </script>

<section id="recipient-profile" class="py-7 space-y-3 items-center text-center bg-slate-200 dark:bg-gray-700">
  <h3 class="text-xl font-bold text-gray-900 dark:text-white">Recipient Profile</h3>
  <div>
    {#if loadingInProgress}
      <h1 class="items-center text-center font-bold text-xl bg-slate-300 dark:bg-slate-600 dark:text-white">Loading Details For You!</h1>
      <img class="h-12 mx-auto p-2" src={spinner} alt="loading animation" />
    {:else if recipientLoadingError}
      <NotFound />
    {:else if recipientLoaded}
        <div>
          {#if recipientType === "School"}
            <RecipientSchoolInfo schoolInfo={recipientInfo} />
          {:else if recipientType === "Student"}
            <RecipientStudentInfo studentInfo={recipientInfo} />
          {/if}
          <div class="py-3 space-y-3 items-center text-center">
            {#if embedded}
              <button on:click|preventDefault={handleClick} class="bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded font-semibold dark:bg-slate-600 dark:hover:bg-slate-800">Set as Donation Recipient</button>
              {#if recipientProfileSelected}
                  <p class="dark:text-gray-300">You have currently selected this recipient for your donation. Please continue on the Donate tab.</p>
              {:else}
                  <p class="dark:text-gray-300">This recipient is not selected for your donation currently.</p>
              {/if}
            {:else}
              <button on:click|preventDefault={handleClick} class="bg-slate-500 hover:bg-slate-700 text-white py-2 px-4 rounded font-semibold dark:bg-slate-600 dark:hover:bg-slate-800">Donate</button>
            {/if}
          </div>
          {#if recipientType === "School"}
            <RecipientsList embedded={true} recipientType={"StudentsForSchool"} schoolRecipientId={recipientId} callbackFunction={callbackFunction} />
          {/if}
        </div>
    {/if}
  </div>  
</section>
  