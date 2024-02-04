import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

import Types "Types";
import Utils "Utils";

actor class DonationTracker() {
    type DTI = Types.DTI;
    type Satoshi = Types.Satoshi;
    type DonationCategories = Types.DonationCategories;
    type Donation = Types.Donation;

    // -------------------------------------------------------------------------------
    // Data storage

    // Define the stable variable to persist donations data across upgrades.
    stable var stableDonations : [Donation] = [];

    // Mutable copy of donations for runtime operations.
    var donations : [Donation] = stableDonations;

    // Map each principal to a list of donation indices (DTIs)
    private let donationsByPrincipal = HashMap.HashMap<Principal, Buffer.Buffer<DTI>>(0, Principal.equal, Principal.hash);

    // -------------------------------------------------------------------------------
    // Canister Endpoints

    public shared (msg) func makeDonation(donation : Donation) : async DTI {
        let caller = Principal.toText(msg.caller);
        let dti = donations.size(); // Simply use index into donations Array as the DTI

        // TODO
        // donations := Array.append<Donation>(donations, [donation]);

        // // Update the map for the caller's principal
        // let existingDonations = switch (donationsByPrincipal.get(Principal.caller())) {
        //     case (null) { [] };
        //     case (?ds) { ds };
        // };
        // donationsByPrincipal.put(Principal.caller(), Array.append<DTI>(existingDonations, [dti]));

        return dti;
    };

    public shared (msg) func getDonationDetails(dti : Nat) : async ?Donation {
        if (dti < donations.size()) {
            return ?donations[dti];
        } else {
            return null;
        };
    };

    public shared (msg) func getMyDonations() : async [DTI] {
        let caller = Principal.toText(msg.caller);
        // TODO
        return [];
        // return switch (donationsByPrincipal.get(caller)) {
        //     case (null) { [] };
        //     case (?ds) { ds };
        // };
    };

    /// Sends the given amount of bitcoin from this canister to the given address.
    /// Returns the transaction ID.
    //public func send(request : SendRequest) : async Text {
    //  Utils.bytesToText(await BitcoinWallet.send(NETWORK, DERIVATION_PATH, KEY_NAME, request.destination_address, request.amount_in_satoshi))
    //};

    // -------------------------------------------------------------------------------
    // Canister upgrades

    // System-provided lifecycle method called before an upgrade.
    system func preupgrade() {
        // Copy the runtime state back into the stable variable before upgrade.
        stableDonations := donations;
    };

    // System-provided lifecycle method called after an upgrade or on initial deploy.
    system func postupgrade() {
        // After upgrade, reload the runtime state from the stable variable.
        donations := stableDonations;
    };
    // -------------------------------------------------------------------------------
};
