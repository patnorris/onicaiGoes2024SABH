export const idlFactory = ({ IDL }) => {
  const Satoshi = IDL.Nat64;
  const DonationCategories = IDL.Record({
    'curriculumDesign' : Satoshi,
    'teacherSupport' : Satoshi,
    'lunchAndSnacks' : Satoshi,
    'schoolSupplies' : Satoshi,
  });
  const Donation = IDL.Record({
    'totalAmount' : Satoshi,
    'allocation' : DonationCategories,
  });
  const DTI = IDL.Nat;
  const DonationTracker = IDL.Service({
    'getDonationDetails' : IDL.Func([IDL.Nat], [IDL.Opt(Donation)], []),
    'getMyDonations' : IDL.Func([], [IDL.Vec(DTI)], []),
    'makeDonation' : IDL.Func([Donation], [DTI], []),
  });
  return DonationTracker;
};
export const init = ({ IDL }) => { return []; };
