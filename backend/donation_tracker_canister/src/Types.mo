module Types {
    //-------------------------------------------------------------------------
    // Copied from donation_canister types
    /// The type of Bitcoin network the dapp will be interacting with.
    public type Network = {
        #mainnet;
        #testnet;
        #regtest;
    };

    public type BitcoinAddress = Text;
    public type BlockHash = [Nat8];
    public type Page = [Nat8];
    public type Satoshi = Nat64;

    /// A reference to a transaction output.
    public type OutPoint = {
        txid : Blob;
        vout : Nat32;
    };

    /// An unspent transaction output.
    public type Utxo = {
        outpoint : OutPoint;
        value : Satoshi;
        height : Nat32;
    };

    /// The response returned for a request to get the UTXOs of a given address.
    public type GetUtxosResponse = {
        utxos : [Utxo];
        tip_block_hash : BlockHash;
        tip_height : Nat32;
        next_page : ?Page;
    };

    //-------------------------------------------------------------------------
    public type DTI = Nat;

    public type DonationCategories = {
        curriculumDesign : Satoshi;
        teacherSupport : Satoshi;
        schoolSupplies : Satoshi;
        lunchAndSnacks : Satoshi;
    };

    public type DonorType = {
        #Anonymous;
        #Principal : Principal;
    };

    public type PaymentTransactionId = Text;

    public type Donation = {
        dti : DTI;
        totalAmount : Satoshi;
        allocation : DonationCategories;
        timestamp : Nat64;
        paymentTransactionId : PaymentTransactionId;
        paymentType : PaymentType; // Assuming payment types are strings, you might want to define an enum if you have a fixed set of payment types
        recipientId : RecipientId;
        donor : DonorType;
        personalNote : ?Text; // Optional field for personal note from donor to recipient
        rewardsHaveBeenClaimed : Bool;
        hasBeenDistributed : ?Bool; // TODO: placeholder for future functionality
    };

    //-------------------------------------------------------------------------
    public type ApiError = {
        #Unauthorized;
        #InvalidId;
        #ZeroAddress;
        #Other : Text;
    };

    public type Result<S, E> = {
        #Ok : S;
        #Err : E;
    };

    //-------------------------------------------------------------------------
    public type AuthRecord = {
        auth : Text;
    };

    public type AuthRecordResult = Result<AuthRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type InitRecipientsRecord = {
        num_schools : Nat;
        num_students : Nat;
    };
    public type InitRecipientsResult = Result<?InitRecipientsRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type DtiRecord = {
        dti : DTI;
    };

    public type DtiResult = Result<DtiRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type DonationRecord = {
        donation : Donation;
    };

    public type DonationResult = Result<?DonationRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type DonationsRecord = {
        donations : [Donation];
    };

    public type DonationsResult = Result<DonationsRecord, ApiError>;

    //-------------------------------------------------------------------------
    type Filter = {
        // TODO: Define the exact filters
        minAmount : ?Nat;
        maxAmount : ?Nat;
        startDate : ?Nat64;
        endDate : ?Nat64;
    };

    public type DonationFiltersRecord = {
        filters : [Filter];
    };

    //-------------------------------------------------------------------------
    public type RecipientOverview = {
        id : Text;
        name : Text;
        thumbnail : Text; // URL or CID for the thumbnail image
    };

    public type RecipientFilter = {
        include : Text; // "schools" | "studentsForSchool"
        recipientIdForSchool : ?RecipientId; // "id" for a specific school or null
    };

    public type RecipientOverviewsRecord = {
        recipients : [RecipientOverview];
    };

    public type RecipientsResult = Result<RecipientOverviewsRecord, ApiError>;

    public type SchoolInfo = RecipientOverview and {
        address : Text;
        // Add more school-specific fields as necessary
    };

    public type StudentInfo = RecipientOverview and {
        grade : Nat;
        schoolId : Text;
        // Add more student-specific fields as necessary
    };

    public type Recipient = {
        #School : SchoolInfo;
        #Student : StudentInfo;
    };

    public type RecipientId = Text;

    public type RecipientIdRecord = {
        recipientId : RecipientId;
    };

    public type RecipientRecord = {
        recipient : Recipient;
    };

    public type RecipientResult = Result<?RecipientRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type BitcoinTransaction = {
        bitcoinTransactionId : PaymentTransactionId;
        totalValue : Nat64; // Total value of the BTC transaction
        valueDonated : Nat64; // How much of the total value has been donated
        // TODO: Add more fields as necessary, e.g., timestamp, confirmations, etc.
    };

    public type BitcoinTransactionIdRecord = {
        bitcoinTransactionId : PaymentTransactionId;
    };

    public type BitcoinTransactionRecord = {
        bitcoinTransaction : BitcoinTransaction;
    };

    public type BitcoinTransactionResult = Result<BitcoinTransactionRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type PaymentType = {
        #BTC;
        // Future payment types can be added here as new variants.
    };

    public type DonationAddress = {
        paymentType : PaymentType;
        address : Text;
    };

    public type PaymentTypeRecord = {
        paymentType : PaymentType;
    };

    public type DonationAddressRecord = {
        donationAddress : DonationAddress;
    };

    public type DonationAddressResult = Result<DonationAddressRecord, ApiError>;

    public type DonationAmount = {
        paymentType : PaymentType;
        amount : Nat64; // Use Nat64 assuming large numbers for cryptocurrency amounts, adjust based on your needs
    };

    public type DonationAmountRecord = {
        donationAmount : DonationAmount;
    };

    public type DonationAmountResult = Result<DonationAmountRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type GetUtxosResponseRecord = {
        getUtxosResponse : GetUtxosResponse;
    };

    public type GetUtxosResponseResult = Result<GetUtxosResponseRecord, ApiError>;

    public type TxidstextRecord = {
        txidstext : [Text];
    };

    public type TxidstextResult = Result<TxidstextRecord, ApiError>;

    //-------------------------------------------------------------------------
    public type SignUpFormInput = {
        emailAddress : Text; // provided by user on signup
        pageSubmittedFrom : Text; // capture for analytics
    };

    public type EmailSubscriber = {
        emailAddress : Text;
        pageSubmittedFrom : Text;
        subscribedAt : Nat64;
    };
};
