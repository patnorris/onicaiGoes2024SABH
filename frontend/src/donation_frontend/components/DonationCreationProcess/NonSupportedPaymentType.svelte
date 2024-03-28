<script>
	import { currentDonationCreationObject } from "../../store";
  
	let paymentType = $currentDonationCreationObject.donation.paymentType;
  </script>
  
  <div>
	<p>The payment type <strong>{paymentType}</strong> is not supported.</p>
	<p>Please select a different payment type.</p>
  </div>  