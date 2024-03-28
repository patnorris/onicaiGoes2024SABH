export const idlFactory = ({ IDL }) => {
  const AuthRecord = IDL.Record({ 'auth' : IDL.Text });
  const ApiError = IDL.Variant({
    'InvalidId' : IDL.Null,
    'ZeroAddress' : IDL.Null,
    'Unauthorized' : IDL.Null,
    'Other' : IDL.Text,
  });
  const AuthRecordResult = IDL.Variant({ 'Ok' : AuthRecord, 'Err' : ApiError });
  const PaymentTransactionId = IDL.Text;
  const BitcoinTransactionIdRecord = IDL.Record({
    'bitcoinTransactionId' : PaymentTransactionId,
  });
  const BitcoinTransaction = IDL.Record({
    'totalValue' : IDL.Nat64,
    'valueDonated' : IDL.Nat64,
    'bitcoinTransactionId' : PaymentTransactionId,
  });
  const BitcoinTransactionRecord = IDL.Record({
    'bitcoinTransaction' : BitcoinTransaction,
  });
  const BitcoinTransactionResult = IDL.Variant({
    'Ok' : BitcoinTransactionRecord,
    'Err' : ApiError,
  });
  const DTI = IDL.Nat;
  const DtiRecord = IDL.Record({ 'dti' : DTI });
  const Satoshi = IDL.Nat64;
  const PaymentType = IDL.Variant({ 'BTC' : IDL.Null });
  const DonationCategories = IDL.Record({
    'curriculumDesign' : Satoshi,
    'teacherSupport' : Satoshi,
    'lunchAndSnacks' : Satoshi,
    'schoolSupplies' : Satoshi,
  });
  const DonorType = IDL.Variant({
    'Anonymous' : IDL.Null,
    'Principal' : IDL.Principal,
  });
  const RecipientId = IDL.Text;
  const Donation = IDL.Record({
    'dti' : DTI,
    'rewardsHaveBeenClaimed' : IDL.Bool,
    'paymentTransactionId' : PaymentTransactionId,
    'hasBeenDistributed' : IDL.Opt(IDL.Bool),
    'totalAmount' : Satoshi,
    'timestamp' : IDL.Nat64,
    'paymentType' : PaymentType,
    'allocation' : DonationCategories,
    'personalNote' : IDL.Opt(IDL.Text),
    'donor' : DonorType,
    'recipientId' : RecipientId,
  });
  const DonationRecord = IDL.Record({ 'donation' : Donation });
  const DonationResult = IDL.Variant({
    'Ok' : IDL.Opt(DonationRecord),
    'Err' : ApiError,
  });
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
  const EmailSubscriber = IDL.Record({
    'subscribedAt' : IDL.Nat64,
    'emailAddress' : IDL.Text,
    'pageSubmittedFrom' : IDL.Text,
  });
  const RecipientIdRecord = IDL.Record({ 'recipientId' : RecipientId });
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
  const TxidstextRecord = IDL.Record({ 'txidstext' : IDL.Vec(IDL.Text) });
  const TxidstextResult = IDL.Variant({
    'Ok' : TxidstextRecord,
    'Err' : ApiError,
  });
  const Page = IDL.Vec(IDL.Nat8);
  const BlockHash = IDL.Vec(IDL.Nat8);
  const OutPoint = IDL.Record({
    'txid' : IDL.Vec(IDL.Nat8),
    'vout' : IDL.Nat32,
  });
  const Utxo = IDL.Record({
    'height' : IDL.Nat32,
    'value' : Satoshi,
    'outpoint' : OutPoint,
  });
  const GetUtxosResponse = IDL.Record({
    'next_page' : IDL.Opt(Page),
    'tip_height' : IDL.Nat32,
    'tip_block_hash' : BlockHash,
    'utxos' : IDL.Vec(Utxo),
  });
  const GetUtxosResponseRecord = IDL.Record({
    'getUtxosResponse' : GetUtxosResponse,
  });
  const GetUtxosResponseResult = IDL.Variant({
    'Ok' : GetUtxosResponseRecord,
    'Err' : ApiError,
  });
  const InitRecipientsRecord = IDL.Record({
    'num_students' : IDL.Nat,
    'num_schools' : IDL.Nat,
  });
  const InitRecipientsResult = IDL.Variant({
    'Ok' : IDL.Opt(InitRecipientsRecord),
    'Err' : ApiError,
  });
  const RecipientFilter = IDL.Record({
    'include' : IDL.Text,
    'recipientIdForSchool' : IDL.Opt(RecipientId),
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
  const SignUpFormInput = IDL.Record({
    'emailAddress' : IDL.Text,
    'pageSubmittedFrom' : IDL.Text,
  });
  const DonationTracker = IDL.Service({
    'amiController' : IDL.Func([], [AuthRecordResult], []),
    'deleteEmailSubscriber' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'getBtcTransactionDetails' : IDL.Func(
        [BitcoinTransactionIdRecord],
        [BitcoinTransactionResult],
        [],
      ),
    'getBtcTransactionStatus' : IDL.Func(
        [BitcoinTransactionIdRecord],
        [BitcoinTransactionResult],
        [],
      ),
    'getDonationDetails' : IDL.Func([DtiRecord], [DonationResult], []),
    'getDonationWalletAddress' : IDL.Func(
        [PaymentTypeRecord],
        [DonationAddressResult],
        [],
      ),
    'getDonations' : IDL.Func(
        [DonationFiltersRecord],
        [DonationsResult],
        ['query'],
      ),
    'getEmailSubscribers' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, EmailSubscriber))],
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
        [],
      ),
    'getTxidstext' : IDL.Func([], [TxidstextResult], []),
    'getUTXOS' : IDL.Func([], [GetUtxosResponseResult], []),
    'initRecipients' : IDL.Func([], [InitRecipientsResult], []),
    'isControllerLogicOk' : IDL.Func([], [AuthRecordResult], []),
    'listRecipients' : IDL.Func(
        [RecipientFilter],
        [RecipientsResult],
        ['query'],
      ),
    'makeDonation' : IDL.Func([DonationRecord], [DtiResult], []),
    'submitSignUpForm' : IDL.Func([SignUpFormInput], [IDL.Text], []),
    'whoami' : IDL.Func([], [IDL.Principal], []),
  });
  return DonationTracker;
};
export const init = ({ IDL }) => { return [IDL.Text]; };
