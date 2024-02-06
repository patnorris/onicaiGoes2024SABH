import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type ApiError = { 'InvalidId' : null } |
  { 'ZeroAddress' : null } |
  { 'Unauthorized' : null } |
  { 'Other' : string };
export interface BitcoinTransaction { 'bitcoinTransactionId' : string }
export interface BitcoinTransactionIdRecord { 'bitcoinTransactionId' : string }
export interface BitcoinTransactionRecord {
  'bitcoinTransaction' : BitcoinTransaction,
}
export type BitcoinTransactionResult = { 'Ok' : BitcoinTransactionRecord } |
  { 'Err' : ApiError };
export type DTI = bigint;
export interface Donation {
  'totalAmount' : Satoshi,
  'timestamp' : bigint,
  'allocation' : DonationCategories,
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
  'listRecipients' : ActorMethod<[RecipientFiltersRecord], RecipientsResult>,
  'makeDonation' : ActorMethod<[DonationRecord], DtiResult>,
}
export interface DonationsRecord { 'donations' : Array<Donation> }
export type DonationsResult = { 'Ok' : DonationsRecord } |
  { 'Err' : ApiError };
export interface DtiRecord { 'dti' : DTI }
export type DtiResult = { 'Ok' : DtiRecord } |
  { 'Err' : ApiError };
export interface Filter {
  'maxAmount' : [] | [bigint],
  'endDate' : [] | [bigint],
  'minAmount' : [] | [bigint],
  'startDate' : [] | [bigint],
}
export type PaymentType = { 'BTC' : null };
export interface PaymentTypeRecord { 'paymentType' : PaymentType }
export type Recipient = { 'School' : SchoolInfo } |
  { 'Student' : StudentInfo };
export interface RecipientFilter {
  'include' : string,
  'recipientIdForSchool' : [] | [string],
}
export interface RecipientFiltersRecord { 'filters' : Array<RecipientFilter> }
export interface RecipientIdRecord { 'recipientId' : string }
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
export interface _SERVICE extends DonationTracker {}
