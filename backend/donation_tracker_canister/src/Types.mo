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
    };
}
