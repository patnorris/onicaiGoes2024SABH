module Types {
    public type DTI = Nat;
    public type Satoshi = Nat64;

    public type DonationCategories = {
        curriculumDesign: Satoshi;
        teacherSupport: Satoshi;
        schoolSupplies: Satoshi;
        lunchAndSnacks: Satoshi;
    };

    public type Donation = {
        totalAmount: Satoshi;
        allocation: DonationCategories;
        timestamp: Nat64;
    };

    public type ApiError = {
        #Unauthorized;
        #InvalidId;
        #ZeroAddress;
        #Other: Text;
    };

    public type Result<S, E> = {
        #Ok : S;
        #Err : E;
    };

    public type DtiRecord = {
        dti: DTI;
    };

    public type DtiResult = Result<DtiRecord, ApiError>;

    public type DonationRecord = {
        donation: Donation;
    };

    public type DonationResult = Result<?DonationRecord, ApiError>;

    public type DonationsRecord = {
        donations: [Donation];
    };

    public type DonationsResult = Result<DonationsRecord, ApiError>;

    type Filter = {
        // TODO: Define the exact filters
        minAmount: ?Nat;
        maxAmount: ?Nat;
        startDate: ?Nat64;
        endDate: ?Nat64;
    };

    public type DonationFiltersRecord = {
        filters: [Filter];
    };

    public type RecipientOverview = {
        id: Text;
        name: Text;
        thumbnail: Text; // URL or CID for the thumbnail image
    };

    public type RecipientFilter = {
        include: Text; // "schools" | "studentsForSchool"
        recipientIdForSchool: ?Text; // "id" for a specific school or null
    };

    public type RecipientFiltersRecord = {
        filters: [RecipientFilter];
    };

    public type RecipientOverviewsRecord = {
        recipients : [RecipientOverview];
    };

    public type RecipientsResult = Result<RecipientOverviewsRecord, ApiError>;

    public type SchoolInfo = {
        id: Text;
        name: Text;
        address: Text;
        thumbnail: Text; // URL or CID for the thumbnail image
        // Add more school-specific fields as necessary
    };

    public type StudentInfo = {
        id: Text;
        name: Text;
        grade: Nat;
        schoolId: Text;
        thumbnail: Text; // URL or CID for the thumbnail image
        // Add more student-specific fields as necessary
    };

    public type Recipient = {
        #School : SchoolInfo;
        #Student : StudentInfo;
    };

    public type RecipientIdRecord = {
        recipientId: Text;
    };

    public type RecipientRecord = {
        recipient: Recipient;
    };

    public type RecipientResult = Result<?RecipientRecord, ApiError>;

    public type BitcoinTransaction = {
        bitcoinTransactionId: Text;
        //totalValue: Nat64; // Total value of the BTC transaction
        //valueDonated: Nat64; // How much of the total value has been donated
        // TODO: Add more fields as necessary, e.g., timestamp, confirmations, etc.
    };

    public type BitcoinTransactionIdRecord = {
        bitcoinTransactionId: Text;
    };

    public type BitcoinTransactionRecord = {
        bitcoinTransaction: BitcoinTransaction;
    };

    public type BitcoinTransactionResult = Result<BitcoinTransactionRecord, ApiError>;

    public type PaymentType = {
        #BTC;
        // Future payment types can be added here as new variants.
    };

    public type DonationAddress = {
        paymentType: PaymentType;
        address: Text;
    };

    public type PaymentTypeRecord = {
        paymentType: PaymentType;
    };

    public type DonationAddressRecord = {
        donationAddress: DonationAddress;
    };

    public type DonationAddressResult = Result<DonationAddressRecord, ApiError>;

    public type DonationAmount = {
        paymentType: PaymentType;
        amount: Nat64; // Use Nat64 assuming large numbers for cryptocurrency amounts, adjust based on your needs
    };

    public type DonationAmountRecord = {
        donationAmount: DonationAmount;
    };

    public type DonationAmountResult = Result<DonationAmountRecord, ApiError>;
}
