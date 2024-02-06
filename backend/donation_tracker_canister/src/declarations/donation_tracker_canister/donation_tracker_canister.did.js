export const idlFactory = ({ IDL }) => {
  const BitcoinTransactionIdRecord = IDL.Record({
    'bitcoinTransactionId' : IDL.Text,
  });
  const BitcoinTransaction = IDL.Record({ 'bitcoinTransactionId' : IDL.Text });
  const BitcoinTransactionRecord = IDL.Record({
    'btcTransaction' : BitcoinTransaction,
  });
  const ApiError = IDL.Variant({
    'InvalidId' : IDL.Null,
    'ZeroAddress' : IDL.Null,
    'Unauthorized' : IDL.Null,
    'Other' : IDL.Text,
  });
  const BitcoinTransactionResult = IDL.Variant({
    'Ok' : BitcoinTransactionRecord,
    'Err' : ApiError,
  });
  const DTI = IDL.Nat;
  const DtiRecord = IDL.Record({ 'dti' : DTI });
  const Satoshi = IDL.Nat64;
  const DonationCategories = IDL.Record({
    'curriculumDesign' : Satoshi,
    'teacherSupport' : Satoshi,
    'lunchAndSnacks' : Satoshi,
    'schoolSupplies' : Satoshi,
  });
  const Donation = IDL.Record({
    'totalAmount' : Satoshi,
    'timestamp' : IDL.Nat64,
    'allocation' : DonationCategories,
  });
  const DonationRecord = IDL.Record({ 'donation' : Donation });
  const DonationResult = IDL.Variant({
    'Ok' : IDL.Opt(DonationRecord),
    'Err' : ApiError,
  });
  const PaymentType = IDL.Variant({ 'BTC' : IDL.Null });
  const PaymentTypeRecord = IDL.Record({ 'paymentType' : PaymentType });
  const DonationAddress = IDL.Record({
    'address' : IDL.Text,
    'paymentType' : PaymentType,
  });
  const DonationAddressRecord = IDL.Record({
    'donationAddress' : DonationAddress,
  });
  const DonationAddressResult = IDL.Variant({
    'Ok' : DonationAddressRecord,
    'Err' : ApiError,
  });
  const Filter = IDL.Record({
    'maxAmount' : IDL.Opt(IDL.Nat),
    'endDate' : IDL.Opt(IDL.Nat64),
    'minAmount' : IDL.Opt(IDL.Nat),
    'startDate' : IDL.Opt(IDL.Nat64),
  });
  const DonationFiltersRecord = IDL.Record({ 'filters' : IDL.Vec(Filter) });
  const DonationsRecord = IDL.Record({ 'donations' : IDL.Vec(Donation) });
  const DonationsResult = IDL.Variant({
    'Ok' : DonationsRecord,
    'Err' : ApiError,
  });
  const RecipientIdRecord = IDL.Record({ 'recipientId' : IDL.Text });
  const SchoolInfo = IDL.Record({
    'id' : IDL.Text,
    'thumbnail' : IDL.Text,
    'name' : IDL.Text,
    'address' : IDL.Text,
  });
  const StudentInfo = IDL.Record({
    'id' : IDL.Text,
    'thumbnail' : IDL.Text,
    'name' : IDL.Text,
    'schoolId' : IDL.Text,
    'grade' : IDL.Nat,
  });
  const Recipient = IDL.Variant({
    'School' : SchoolInfo,
    'Student' : StudentInfo,
  });
  const RecipientRecord = IDL.Record({ 'recipient' : Recipient });
  const RecipientResult = IDL.Variant({
    'Ok' : IDL.Opt(RecipientRecord),
    'Err' : ApiError,
  });
  const DonationAmount = IDL.Record({
    'paymentType' : PaymentType,
    'amount' : IDL.Nat64,
  });
  const DonationAmountRecord = IDL.Record({
    'donationAmount' : DonationAmount,
  });
  const DonationAmountResult = IDL.Variant({
    'Ok' : DonationAmountRecord,
    'Err' : ApiError,
  });
  const RecipientFilter = IDL.Record({
    'include' : IDL.Text,
    'recipientIdForSchool' : IDL.Opt(IDL.Text),
  });
  const RecipientFiltersRecord = IDL.Record({
    'filters' : IDL.Vec(RecipientFilter),
  });
  const RecipientOverview = IDL.Record({
    'id' : IDL.Text,
    'thumbnail' : IDL.Text,
    'name' : IDL.Text,
  });
  const RecipientOverviewsRecord = IDL.Record({
    'recipients' : IDL.Vec(RecipientOverview),
  });
  const RecipientsResult = IDL.Variant({
    'Ok' : RecipientOverviewsRecord,
    'Err' : ApiError,
  });
  const DtiResult = IDL.Variant({ 'Ok' : DtiRecord, 'Err' : ApiError });
  const DonationTracker = IDL.Service({
    'getBtcTransactionDetails' : IDL.Func(
        [BitcoinTransactionIdRecord],
        [BitcoinTransactionResult],
        ['query'],
      ),
    'getBtcTransactionStatus' : IDL.Func(
        [BitcoinTransactionIdRecord],
        [BitcoinTransactionResult],
        ['query'],
      ),
    'getDonationDetails' : IDL.Func([DtiRecord], [DonationResult], []),
    'getDonationWalletAddress' : IDL.Func(
        [PaymentTypeRecord],
        [DonationAddressResult],
        ['query'],
      ),
    'getDonations' : IDL.Func(
        [DonationFiltersRecord],
        [DonationsResult],
        ['query'],
      ),
    'getMyDonations' : IDL.Func([DonationFiltersRecord], [DonationsResult], []),
    'getRecipient' : IDL.Func(
        [RecipientIdRecord],
        [RecipientResult],
        ['query'],
      ),
    'getTotalDonationAmount' : IDL.Func(
        [PaymentTypeRecord],
        [DonationAmountResult],
        ['query'],
      ),
    'listRecipients' : IDL.Func(
        [RecipientFiltersRecord],
        [RecipientsResult],
        ['query'],
      ),
    'makeDonation' : IDL.Func([DonationRecord], [DtiResult], []),
  });
  return DonationTracker;
};
export const init = ({ IDL }) => { return []; };
