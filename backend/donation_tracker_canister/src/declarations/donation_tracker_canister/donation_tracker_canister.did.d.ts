import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type DTI = bigint;
export interface Donation {
  'totalAmount' : Satoshi,
  'allocation' : DonationCategories,
}
export interface DonationCategories {
  'curriculumDesign' : Satoshi,
  'teacherSupport' : Satoshi,
  'lunchAndSnacks' : Satoshi,
  'schoolSupplies' : Satoshi,
}
export interface DonationTracker {
  'getDonationDetails' : ActorMethod<[bigint], [] | [Donation]>,
  'getMyDonations' : ActorMethod<[], Array<DTI>>,
  'makeDonation' : ActorMethod<[Donation], DTI>,
}
export type Satoshi = bigint;
export interface _SERVICE extends DonationTracker {}
