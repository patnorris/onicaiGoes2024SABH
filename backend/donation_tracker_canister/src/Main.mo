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

    // -------------------------------------------------------------------------------
    // Define the donation_canister (bitcoin canister) with endpoints to call

    // Select one of these. For local, also update the value to match your local deployment !!
    // LOCAL NETWORK
    let DONATION_CANISTER_ID = "bkyz2-fmaaa-aaaaa-qaaaq-cai";
    // IC MAINNET
    // let DONATION_CANISTER_ID = "ekral-oiaaa-aaaag-acmda-cai";

    let donationCanister = actor (DONATION_CANISTER_ID) : actor {
        get_p2pkh_address : () -> async Text;
        get_balance : (address : Types.BitcoinAddress) -> async Types.Satoshi;
        get_utxos : (address : Types.BitcoinAddress) -> async Types.GetUtxosResponse;
    };

    // -------------------------------------------------------------------------------
    type DTI = Types.DTI;
    type Satoshi = Types.Satoshi;
    type DonationCategories = Types.DonationCategories;
    type Donation = Types.Donation;

    // -------------------------------------------------------------------------------
    // Orthogonal Persisted Data storage

    // Donations for runtime operations.
    private var donations : Buffer.Buffer<Donation> = Buffer.fromArray<Donation>([]);
    // Define the stable variable to persist donations data across upgrades.
    stable var donationsStable : [Donation] = [];

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

    // Initialize recipients and their relationships
    public shared func initRecipients() : async Types.initRecipientsResult {
        // Define school and student recipients
        let school1 : Types.Recipient =
        #School {
            id = "school1";
            name = "Green Valley High";
            thumbnail = "url_to_thumbnail_1";
            address = "123 Green Valley Rd";
        };

        let student1School1 : Types.Recipient =
        #Student {
            id = "student1School1";
            name = "Alex Johnson";
            thumbnail = "url_to_thumbnail_2";
            grade = 10;
            schoolId = "school1";
        };

        let student2School1 : Types.Recipient =
        #Student {
            id = "student2School1";
            name = "Jamie Smith";
            thumbnail = "url_to_thumbnail_3";
            grade = 11;
            schoolId = "school1";
        };

        let school2 : Types.Recipient =
        #School {
            id = "school2";
            name = "Sunnydale Elementary";
            thumbnail = "url_to_thumbnail_4";
            address = "456 Sunnydale St";
        };

        let student1School2 : Types.Recipient =
        #Student {
            id = "student1School2";
            name = "Robin Doe";
            thumbnail = "url_to_thumbnail_5";
            grade = 8;
            schoolId = "school2";
        };

        let student2School2 : Types.Recipient =
        #Student {
            id = "student2School2";
            name = "Taylor Ray";
            thumbnail = "url_to_thumbnail_6";
            grade = 9;
            schoolId = "school2";
        };

        // (re)Initialize recipientsById HashMap
        recipientsById := HashMap.HashMap<Types.RecipientId, Types.Recipient>(0, Text.equal, Text.hash);
        recipientsById.put("school1", school1);
        recipientsById.put("student1School1", student1School1);
        recipientsById.put("student2School1", student2School1);
        recipientsById.put("school2", school2);
        recipientsById.put("student1School2", student1School2);
        recipientsById.put("student2School2", student2School2);

        // (re)Initialize studentsBySchool HashMap
        studentsBySchool := HashMap.HashMap<Types.RecipientId, [Types.RecipientId]>(0, Text.equal, Text.hash);
        studentsBySchool.put("school1", ["student1School1", "student2School1"]);
        studentsBySchool.put("school2", ["student1School2", "student2School2"]);

        // Initialize the counters for schools and students
        var num_schools = 0;
        var num_students = 0;

        // Iterate over the recipientsById to count schools and students
        for ((key, value : Types.Recipient) in recipientsById.entries()) {
            D.print("Key: " # key);
            D.print(debug_show (value));
            switch (value) {
                case (#School(schoolInfo)) { num_schools += 1 };
                case (#Student(studentInfo)) { num_students += 1 };
            };
        };

        D.print("Number of schools: " # debug_show (num_schools));
        D.print("Number of students: " # debug_show (num_students));

        // Return the result with the dynamic counts of schools and students
        return #Ok(?{ num_schools = num_schools; num_students = num_students });

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
            return #Ok(?{ donation = donations.get(dtiRecord.dti) });
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

    public query func listRecipients(recipientFilter : Types.RecipientFilter) : async Types.RecipientsResult {

        var filteredRecipients : [Types.RecipientOverview] = [];
        for ((key, value : Types.Recipient) in recipientsById.entries()) {
            D.print("Key: " # key);
            D.print(debug_show (value));
            if (recipientFilter.include == "schools") {
                switch (value) {
                    case (#School(schoolInfo)) {
                        let recipientOverview : Types.RecipientOverview = {
                            id = schoolInfo.id;
                            name = schoolInfo.name;
                            thumbnail = schoolInfo.thumbnail;
                        };
                        filteredRecipients := Array.append<Types.RecipientOverview>(filteredRecipients, [recipientOverview]);
                    };
                    case (#Student(studentInfo)) {};
                };
            } else if (recipientFilter.include == "studentsForSchool") {
                switch (value) {
                    case (#School(schoolInfo)) {};
                    case (#Student(studentInfo)) {
                        switch (recipientFilter.recipientIdForSchool) {
                            case (null) {};
                            case (?RecipientId) {
                                if (studentInfo.schoolId == RecipientId) {
                                    let recipientOverview : Types.RecipientOverview = {
                                        id = studentInfo.id;
                                        name = studentInfo.name;
                                        thumbnail = studentInfo.thumbnail;
                                    };
                                    filteredRecipients := Array.append<Types.RecipientOverview>(filteredRecipients, [recipientOverview]);
                                };
                            };
                        };
                    };
                };
            };
        };

        if (filteredRecipients.size() > 0) {
            return #Ok({ recipients = filteredRecipients });
        } else {
            return #Err(#Other("No recipients found matching the criteria."));
        };
    };

    public query func getRecipient(idRecord : Types.RecipientIdRecord) : async Types.RecipientResult {
        for ((key, value : Types.Recipient) in recipientsById.entries()) {
            switch (value) {
                case (#School(schoolInfo)) {
                    if (idRecord.recipientId == schoolInfo.id) {
                        return #Ok(?{ recipient = value });
                    };
                };
                case (#Student(studentInfo)) {
                    if (idRecord.recipientId == studentInfo.id) {
                        return #Ok(?{ recipient = value });
                    };
                };
            };
        };

        return #Err(#Other("Recipient not found."));
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

    // Cannot use await in a query function...???
    // public query func getDonationWalletAddress(req : Types.PaymentTypeRecord) : async Types.DonationAddressResult {
    public func getDonationWalletAddress(req : Types.PaymentTypeRecord) : async Types.DonationAddressResult {
        switch (req.paymentType) {
            case (#BTC) {
                // Make an inter-canister call to get the BTC donation address
                try {
                    let btcAddress = await donationCanister.get_p2pkh_address();
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

    // public query func getTotalDonationAmount(req : Types.PaymentTypeRecord) : async Types.DonationAmountResult {
    public func getTotalDonationAmount(req : Types.PaymentTypeRecord) : async Types.DonationAmountResult {
        switch (req.paymentType) {
            case (#BTC) {
                try {
                    let btcAddress = await donationCanister.get_p2pkh_address();
                    let balance : Satoshi = await donationCanister.get_balance(btcAddress);
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

    // public query func getUTXOS() : async Types.GetUtxosResponse {
    public func getUTXOS() : async Types.GetUtxosResponseResult {
        try {
            let btcAddress = await donationCanister.get_p2pkh_address();
            let utxos : Types.GetUtxosResponse = await donationCanister.get_utxos(btcAddress);
            return #Ok({
                getUtxosResponse = utxos;
            });
        } catch (error : Error) {
            // Handle errors, such as donation canister not responding
            return #Err(#Other("Failed to retrieve utxos: "));
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
        donationsStable := Buffer.toArray<Donation>(donations);
        //TODO: donationsByPrincipalStable := Iter.toArray(donationsByPrincipal.entries());
        recipientsByIdStable := Iter.toArray(recipientsById.entries());
        studentsBySchoolStable := Iter.toArray(studentsBySchool.entries());
        donationsByTxIdStable := Iter.toArray(donationsByTxId.entries());
    };

    // System-provided lifecycle method called after an upgrade or on initial deploy.
    system func postupgrade() {
        // After upgrade, reload the runtime state from the stable variable.
        donations := Buffer.fromArray<Donation>(donationsStable);
        donationsStable := [];
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
