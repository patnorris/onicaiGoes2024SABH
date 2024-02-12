import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type ApiError = { 'InvalidId' : null } |
  { 'ZeroAddress' : null } |
  { 'Unauthorized' : null } |
  { 'Other' : string };
export interface BitcoinTransaction {
  'totalValue' : bigint,
  'valueDonated' : bigint,
  'bitcoinTransactionId' : PaymentTransactionId,
}
export interface BitcoinTransactionIdRecord {
  'bitcoinTransactionId' : PaymentTransactionId,
}
export interface BitcoinTransactionRecord {
  'bitcoinTransaction' : BitcoinTransaction,
}
export type BitcoinTransactionResult = { 'Ok' : BitcoinTransactionRecord } |
  { 'Err' : ApiError };
export type BlockHash = Uint8Array | number[];
export type DTI = bigint;
export interface Donation {
  'dti' : DTI,
  'rewardsHaveBeenClaimed' : boolean,
  'paymentTransactionId' : PaymentTransactionId,
  'totalAmount' : Satoshi,
  'timestamp' : bigint,
  'paymentType' : PaymentType,
  'allocation' : DonationCategories,
  'personalNote' : [] | [string],
  'donor' : DonorType,
  'recipientId' : RecipientId,
}
export interface DonationAddress {
  'address' : string,
  'paymentType' : PaymentType,
}
export interface DonationAddressRecord { 'donationAddress' : DonationAddress }
export type DonationAddressResult = { 'Ok' : DonationAddressRecord } |
  { 'Err' : ApiError };
export interface DonationAmount {
  'paymentType' : PaymentType,
  'amount' : bigint,
}
export interface DonationAmountRecord { 'donationAmount' : DonationAmount }
export type DonationAmountResult = { 'Ok' : DonationAmountRecord } |
  { 'Err' : ApiError };
export interface DonationCategories {
  'curriculumDesign' : Satoshi,
  'teacherSupport' : Satoshi,
  'lunchAndSnacks' : Satoshi,
  'schoolSupplies' : Satoshi,
}
export interface DonationFiltersRecord { 'filters' : Array<Filter> }
export interface DonationRecord { 'donation' : Donation }
export type DonationResult = { 'Ok' : [] | [DonationRecord] } |
  { 'Err' : ApiError };
export interface DonationTracker {
  'getBtcTransactionDetails' : ActorMethod<
    [BitcoinTransactionIdRecord],
    BitcoinTransactionResult
  >,
  'getBtcTransactionStatus' : ActorMethod<
    [BitcoinTransactionIdRecord],
    BitcoinTransactionResult
  >,
  'getDonationDetails' : ActorMethod<[DtiRecord], DonationResult>,
  'getDonationWalletAddress' : ActorMethod<
    [PaymentTypeRecord],
    DonationAddressResult
  >,
  'getDonations' : ActorMethod<[DonationFiltersRecord], DonationsResult>,
  'getMyDonations' : ActorMethod<[DonationFiltersRecord], DonationsResult>,
  'getRecipient' : ActorMethod<[RecipientIdRecord], RecipientResult>,
  'getTotalDonationAmount' : ActorMethod<
    [PaymentTypeRecord],
    DonationAmountResult
  >,
  'getTxidstext' : ActorMethod<[], TxidstextResult>,
  'getUTXOS' : ActorMethod<[], GetUtxosResponseResult>,
  'initRecipients' : ActorMethod<[], initRecipientsResult>,
  'listRecipients' : ActorMethod<[RecipientFilter], RecipientsResult>,
  'makeDonation' : ActorMethod<[DonationRecord], DtiResult>,
  'whoami' : ActorMethod<[], Principal>,
}
export interface DonationsRecord { 'donations' : Array<Donation> }
export type DonationsResult = { 'Ok' : DonationsRecord } |
  { 'Err' : ApiError };
export type DonorType = { 'Anonymous' : null } |
  { 'Principal' : Principal };
export interface DtiRecord { 'dti' : DTI }
export type DtiResult = { 'Ok' : DtiRecord } |
  { 'Err' : ApiError };
export interface Filter {
  'maxAmount' : [] | [bigint],
  'endDate' : [] | [bigint],
  'minAmount' : [] | [bigint],
  'startDate' : [] | [bigint],
}
export interface GetUtxosResponse {
  'next_page' : [] | [Page],
  'tip_height' : number,
  'tip_block_hash' : BlockHash,
  'utxos' : Array<Utxo>,
}
export interface GetUtxosResponseRecord {
  'getUtxosResponse' : GetUtxosResponse,
}
export type GetUtxosResponseResult = { 'Ok' : GetUtxosResponseRecord } |
  { 'Err' : ApiError };
export interface OutPoint { 'txid' : Uint8Array | number[], 'vout' : number }
export type Page = Uint8Array | number[];
export type PaymentTransactionId = string;
export type PaymentType = { 'BTC' : null };
export interface PaymentTypeRecord { 'paymentType' : PaymentType }
export type Recipient = { 'School' : SchoolInfo } |
  { 'Student' : StudentInfo };
export interface RecipientFilter {
  'include' : string,
  'recipientIdForSchool' : [] | [RecipientId],
}
export type RecipientId = string;
export interface RecipientIdRecord { 'recipientId' : RecipientId }
export interface RecipientOverview {
  'id' : string,
  'thumbnail' : string,
  'name' : string,
}
export interface RecipientOverviewsRecord {
  'recipients' : Array<RecipientOverview>,
}
export interface RecipientRecord { 'recipient' : Recipient }
export type RecipientResult = { 'Ok' : [] | [RecipientRecord] } |
  { 'Err' : ApiError };
export type RecipientsResult = { 'Ok' : RecipientOverviewsRecord } |
  { 'Err' : ApiError };
export type Satoshi = bigint;
export interface SchoolInfo {
  'id' : string,
  'thumbnail' : string,
  'name' : string,
  'address' : string,
}
export interface StudentInfo {
  'id' : string,
  'thumbnail' : string,
  'name' : string,
  'schoolId' : string,
  'grade' : bigint,
}
export interface TxidstextRecord { 'txidstext' : Array<string> }
export type TxidstextResult = { 'Ok' : TxidstextRecord } |
  { 'Err' : ApiError };
export interface Utxo {
  'height' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface initRecipientsRecord {
  'num_students' : bigint,
  'num_schools' : bigint,
}
export type initRecipientsResult = { 'Ok' : [] | [initRecipientsRecord] } |
  { 'Err' : ApiError };
export interface _SERVICE extends DonationTracker {}
