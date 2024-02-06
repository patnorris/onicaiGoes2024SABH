import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

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
    var donations : Buffer.Buffer<Donation> = Buffer.fromArray<Donation>(stableDonations);

    // Map each principal to a list of donation indices (DTIs)
    private var donationsByPrincipal = HashMap.HashMap<Principal, Buffer.Buffer<DTI>>(0, Principal.equal, Principal.hash);
    //TODO: stable var donationsByPrincipalStable : [(Principal, Buffer.Buffer<DTI>)] = [];
        // Alternative: use [DTI] instead of Buffer.Buffer<DTI>; less efficient but straightforward to make stable
        // Or: stable Buffer implementation?

    // Store recipients and map each recipientId to the corresponding Recipient record
    private var recipientsById = HashMap.HashMap<Types.RecipientId, Types.Recipient>(0, Text.equal, Text.hash);
    stable var recipientsByIdStable : [(Text, Types.Recipient)] = [];

    // Map School (via its recipientId) to its Students (via their recipientIds)
    private var studentsBySchool = HashMap.HashMap<Types.RecipientId, [Types.RecipientId]>(0, Text.equal, Text.hash);
    stable var studentsBySchoolStable : [(Types.RecipientId, [Types.RecipientId])] = [];

    // Map paymentTransactionId to a list of Donations (e.g. bitcoin transaction to the donations that were paid from it)
    private var donationsByTxId = HashMap.HashMap<Types.PaymentTransactionId, [Donation]>(0, Text.equal, Text.hash);
    stable var donationsByTxIdStable : [(Types.PaymentTransactionId, [Donation])] = [];

    // -------------------------------------------------------------------------------
    // Canister Endpoints

    public shared (msg) func whoami() : async Principal {
        return msg.caller;
    };

    public shared (msg) func makeDonation(donationRecord : Types.DonationRecord) : async Types.DtiResult {
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

        return #Ok({ dti });
    };

    public shared (msg) func getDonationDetails(dtiRecord : Types.DtiRecord) : async Types.DonationResult {
        if (dtiRecord.dti < donations.size()) {
            return #Ok(?{donation = donations.get(dtiRecord.dti)});
        } else {
            return #Err(#InvalidId);
        };
    };

    public query func getDonations(filtersRecord : Types.DonationFiltersRecord) : async Types.DonationsResult {
        // Here, you would apply the filters to your data retrieval logic.
        // For simplicity, we're ignoring the filters and returning all donations.

        // If there was an error, you would return something like:
        // return Err({code = 404, message = "No donations found."});

        // On success, return the list of donations
        let donationsRecord = {
            donations : [Donation] = [];
        };
        return #Ok(donationsRecord);
    };

    //TODO: input: Types.DonationFiltersRecord or empty record?
    public shared (msg) func getMyDonations(filtersRecord : Types.DonationFiltersRecord) : async Types.DonationsResult {
        let caller = Principal.toText(msg.caller);
        // TODO
        return #Ok({ donations = [] });
        // return switch (donationsByPrincipal.get(caller)) {
        //     case (null) { [] };
        //     case (?ds) { ds };
        // };
    };

    public query func listRecipients(filtersRecord : Types.RecipientFiltersRecord) : async Types.RecipientsResult {
        // TODO: Mock implementation - replace with actual logic to fetch and filter recipients

        let mockRecipients : [Types.RecipientOverview] = [
            // Mock data - replace with actual recipient data
            {
                id = "school1";
                name = "School One";
                thumbnail = "thumbnail1.jpg";
            },
            {
                id = "student1";
                name = "Student One";
                thumbnail = "thumbnail2.jpg";
            }
            // Add more mock recipients as needed
        ];

        // Example filter application
        let filteredRecipients = mockRecipients;
        /* let filteredRecipients = switch (filtersRecord.filters.include) {
            case ("schools") {
                // Return only schools
                mockRecipients.filter(recipient -> recipient.id.startsWith("school"))
            };
            case ("studentsForSchool") {
                // Return students for a specific school if recipientIdForSchool is not null
                filtersRecord.filters.recipientIdForSchool == null ? [] :
                mockRecipients.filter(recipient ->
                    recipient.id.startsWith("student") and
                    // Assuming a convention to relate students to schools by ID
                    recipient.id.endsWith(filtersRecord.filters.recipientIdForSchool.unwrap())
                )
            };
            case _ {
                // Invalid filter
                []
            };
        }; */

        if (filteredRecipients.size() > 0) {
            return #Ok({ recipients = filteredRecipients });
        } else {
            return #Err(#Other("No recipients found matching the criteria."));
        };
    };

    public query func getRecipient(idRecord : Types.RecipientIdRecord) : async Types.RecipientResult {
        // Mock recipient data for demonstration
        let mockRecipients : [Types.Recipient] = [
            // Mock schools
            #School({
                id = "school1";
                name = "Primary School One";
                address = "123 Main St";
                thumbnail = "school-thumbnail1.jpg";
            }),
            // Mock students
            #Student({
                id = "student1";
                name = "John Doe";
                grade = 5;
                schoolId = "school1";
                thumbnail = "student-thumbnail1.jpg";
            })
            // Add more mock recipients as needed
        ];
        let recipient = Array.find<Types.Recipient>(
            mockRecipients,
            func(r) : Bool {
                switch (r) {
                    case (#School(school)) { school.id == idRecord.recipientId };
                    case (#Student(student)) {
                        student.id == idRecord.recipientId;
                    };
                };
            },
        );

        switch (recipient) {
            case (null) { return #Err(#Other("Recipient not found.")) };
            case (?r) { return #Ok(?{ recipient = r }) };
        };
    };

    public query func getBtcTransactionStatus(idRecord : Types.BitcoinTransactionIdRecord) : async Types.BitcoinTransactionResult {
        // Example: Check against a mock list of known transaction IDs
        let knownTransactions : [Types.BitcoinTransaction] = [
            // Mock transactions
            { bitcoinTransactionId = "txid1" },
            { bitcoinTransactionId = "txid2" }
            // Add more mock transactions as necessary
        ];

        // Attempt to find the transaction by ID
        let transaction = Array.find<Types.BitcoinTransaction>(
            knownTransactions,
            func(t) : Bool {
                t.bitcoinTransactionId == idRecord.bitcoinTransactionId;
            },
        );

        switch (transaction) {
            case (null) {
                // Transaction not found
                return #Err(#Other("Bitcoin transaction not found."));
            };
            case (?t) {
                // Transaction found
                return #Ok({ bitcoinTransaction = t });
            };
        };
    };

    // Assume this is a function that can query the Bitcoin canister or an external API to get the transaction value
    private func getTransactionValueFromCanister(bitcoinTransactionId : Text) : Nat64 {
        // Mock implementation - replace with actual call to Bitcoin canister
        // For example: return await BitcoinCanister.getTransactionValue(bitcoinTransactionId);
        return 10_000; // Mock value in satoshis
    };

    public query func getBtcTransactionDetails(idRecord : Types.BitcoinTransactionIdRecord) : async Types.BitcoinTransactionResult {
        // First, determine the total value donated from this transaction
        let valueDonated = ""; // Calculate this based on your internal records

        // Then, query the Bitcoin canister or external service for the total transaction value
        let totalValue = getTransactionValueFromCanister(idRecord.bitcoinTransactionId);

        // Check if the transaction exists and has a valid value
        if (totalValue > 0) {
            return #Ok({
                bitcoinTransaction = {
                    bitcoinTransactionId = idRecord.bitcoinTransactionId;
                    totalValue = totalValue;
                    valueDonated = valueDonated;
                };
            });
        } else {
            return #Err(#Other("Bitcoin transaction not found or has no value."));
        };
    };

    public query func getDonationWalletAddress(req : Types.PaymentTypeRecord) : async Types.DonationAddressResult {
        switch (req.paymentType) {
            case (#BTC) {
                // Make an inter-canister call to get the BTC donation address
                try {
                    let btcAddress = ""; //await donationCanister.get_p2pkh_address();
                    return #Ok({
                        donationAddress = {
                            paymentType = #BTC;
                            address = btcAddress;
                        };
                    });
                } catch (error : Error) {
                    // Handle errors, such as donation canister not responding
                    return #Err(#Other("Failed to retrieve BTC donation address: "));
                };
            };
            // Handle other payment types as they are added
        };
    };

    public query func getTotalDonationAmount(req : Types.PaymentTypeRecord) : async Types.DonationAmountResult {
        switch (req.paymentType) {
            case (#BTC) {
                try {
                    // Assuming get_balance returns the balance as Nat64 for the specified payment type
                    let balance : Nat64 = 5; //await donationCanister.get_balance(#BTC);
                    return #Ok({
                        donationAmount = {
                            paymentType = #BTC;
                            amount = balance;
                        };
                    });
                } catch (error : Error) {
                    // Handle errors, such as donation canister not responding
                    return #Err(#Other("Failed to retrieve total donation amount for BTC: "));
                };
            };
            // Handle other payment types as they are added
        };
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
        stableDonations := Buffer.toArray<Donation>(donations);
        //TODO: donationsByPrincipalStable := Iter.toArray(donationsByPrincipal.entries());
        recipientsByIdStable := Iter.toArray(recipientsById.entries());
        studentsBySchoolStable := Iter.toArray(studentsBySchool.entries());
        donationsByTxIdStable := Iter.toArray(donationsByTxId.entries());
    };

    // System-provided lifecycle method called after an upgrade or on initial deploy.
    system func postupgrade() {
        // After upgrade, reload the runtime state from the stable variable.
        donations := Buffer.fromArray<Donation>(stableDonations);
        //TODO: donationsByPrincipal := HashMap.fromIter(Iter.fromArray(donationsByPrincipalStable), donationsByPrincipalStable.size(), Text.equal, Text.hash);
        //TODO: donationsByPrincipalStable := [];
        recipientsById := HashMap.fromIter(Iter.fromArray(recipientsByIdStable), recipientsByIdStable.size(), Text.equal, Text.hash);
        recipientsByIdStable := [];
        studentsBySchool := HashMap.fromIter(Iter.fromArray(studentsBySchoolStable), studentsBySchoolStable.size(), Text.equal, Text.hash);
        studentsBySchoolStable := [];
        donationsByTxId := HashMap.fromIter(Iter.fromArray(donationsByTxIdStable), donationsByTxIdStable.size(), Text.equal, Text.hash);
        donationsByTxIdStable := [];
    };
    // -------------------------------------------------------------------------------
};
