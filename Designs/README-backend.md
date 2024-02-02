# Backend Canister

NOTE: This is all in very early draft status, generated with ChatGPT

To design a solution for the given requirements on the Internet Computer using Motoko for the backend logic and Candid for defining the interface, let's break down the solution into two main parts: the data structure and the Candid interface, then we will address the tracking system with a unique Donation Transaction Identifier (DTI).

### Part 1: Motoko Data Structure

For the backend data structure, we need to represent donations, categories, and allocation of funds. We will use a `Decimal` type for handling Bitcoin amounts with precision, a `Donation` type to capture the total donation and its allocation, and a `DonationCategories` type for the specific allocations.

```motoko
type Decimal = Float64; // Represents Bitcoin with precision for 8 decimal places

type DonationCategories = {
    curriculumDesign: Decimal;
    teacherSupport: Decimal;
    schoolSupplies: Decimal;
    lunchAndSnacks: Decimal;
};

type Donation = {
    totalAmount: Decimal;
    allocation: DonationCategories;
};
```

Given that Bitcoin transactions and the corresponding allocations need to be precise, using `Float64` (double precision floating point) is a pragmatic choice for representing `Decimal` types in Motoko, noting the potential for minor precision errors which are generally acceptable for this context. Ensure that calculations are done carefully to maintain the required precision.


### Part 2: Donation Tracking System with DTI

For tracking donations, each donation needs a unique identifier (DTI). This can be implemented by using the index into a vector as the DTI:

```motoko
// Using a Vector to store donations ensures that each donation has a unique index
import Array "mo:base/Array";

var donations: [Donation] = [];

public func makeDonation(donation: Donation): async Nat {
    let index = donations.size();
    donations := Array.append<Donation>(donations, [donation]);
    return index; // Use the array index as the DTI
}

public func getDonationDetails(dti: Nat): async ?Donation {
    if (dti < donations.size()) {
        return ?donations[dti];
    } else {
        return null;
    }
}
```

### Part 3: Candid Interface

For the Candid interface, we need to define methods for:
- Making a donation specifying the total amount and the allocation across categories.
- Optionally, specifying allocations as percentages.
- Retrieving donation details using the DTI.

```candid
type Decimal = float64;

type DonationCategories = record {
    curriculumDesign: Decimal;
    teacherSupport: Decimal;
    schoolSupplies: Decimal;
    lunchAndSnacks: Decimal;
};

type DonationInput = record {
    totalAmount: Decimal;
    allocation: DonationCategories;
};

service : {
    makeDonation: (DonationInput) -> (nat) ; // Returns DTI as a natural number (index)
    getDonationDetails: (nat) -> (opt DonationInput) query; // Retrieve donation details by DTI (index)
};
```