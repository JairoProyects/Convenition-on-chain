// Define the contract interface
#[starknet::interface]
pub trait IConvenioContract<TContractState> {
    fn sign_agreement(ref self: TContractState);
    fn get_party_one(self: @TContractState) -> felt252;
    fn get_party_two(self: @TContractState) -> felt252;
    fn get_agreement_text(self: @TContractState) -> felt252;
    fn get_agreement_hash(self: @TContractState) -> felt252;
    fn get_signed_one(self: @TContractState) -> bool;
    fn get_signed_two(self: @TContractState) -> bool;
    fn get_status(self: @TContractState) -> (bool, bool, felt252, bool);
    fn get_amount(self: @TContractState) -> u256;
    fn get_currency(self: @TContractState) -> felt252;
    fn get_extra_conditions(self: @TContractState) -> felt252;
    fn get_expiration_date(self: @TContractState) -> u64;
    fn get_status_string(self: @TContractState) -> felt252;
}

#[starknet::contract]
pub mod ConvenioContract {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::*;
    use core::pedersen::pedersen;
    use core::bool;
    use core::integer::u64;
    use core::integer::u256;
    use core::traits::Into;
    use core::num::traits::Zero;

    #[storage]
    pub struct Storage {
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
        agreement_hash: felt252,
        signed_one: bool,
        signed_two: bool,
        amount: u256,
        currency: felt252,
        extra_conditions: felt252,
        expiration_date: u64,
        status: felt252, // nuevo campo
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        AgreementCreated: AgreementCreated,
        AgreementSigned: AgreementSigned,
    }

    #[derive(Drop, starknet::Event)]
    pub struct AgreementCreated {
        party_one: felt252,
        party_two: felt252,
        agreement_hash: felt252,
        agreement_text: felt252,
        amount: u256,
        currency: felt252,
        extra_conditions: felt252,
        expiration_date: u64,
    }

    #[derive(Drop, starknet::Event)]
    pub struct AgreementSigned {
        signer: felt252,
        signed_one_status: bool,
        signed_two_status: bool,
    }

    #[constructor]
    pub fn constructor(
        ref self: ContractState,
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
        amount: u256,
        currency: felt252,
        extra_conditions: felt252,
        expiration_date: u64,
        status: felt252,
    ) {
        assert(!party_one.is_zero(), 'PartyOne cannot be zero');
        assert(!party_two.is_zero(), 'PartyTwo cannot be zero');
        assert(party_one != party_two, 'Parties must be different');
        assert(!agreement_text.is_zero(), 'Agreement text cannot be empty');

        self.party_one.write(party_one);
        self.party_two.write(party_two);
        self.agreement_text.write(agreement_text);
        self.amount.write(amount);
        self.currency.write(currency);
        self.extra_conditions.write(extra_conditions);
        self.expiration_date.write(expiration_date);
        self.status.write(status); // nuevo campo

        let hash = pedersen(party_one, pedersen(party_two, agreement_text));
        self.agreement_hash.write(hash);

        self.signed_one.write(false);
        self.signed_two.write(false);

        self.emit(Event::AgreementCreated(
            AgreementCreated {
                party_one,
                party_two,
                agreement_hash: hash,
                agreement_text,
                amount,
                currency,
                extra_conditions,
                expiration_date,
            }
        ));
    }

    #[abi(embed_v0)]
    pub impl ConvenioContractImpl of super::IConvenioContract<ContractState> {
        fn sign_agreement(ref self: ContractState) {
            let caller = get_caller_address().into();

            let party_one = self.party_one.read();
            let party_two = self.party_two.read();
            let mut signed_one = self.signed_one.read();
            let mut signed_two = self.signed_two.read();

            if caller == party_one {
                assert!(!signed_one, "PartyOne already signed");
                self.signed_one.write(true);
                signed_one = true;
            } else if caller == party_two {
                assert!(!signed_two, "PartyTwo already signed");
                self.signed_two.write(true);
                signed_two = true;
            } else {
                assert!(false, "Caller is not a party");
            }

            self.emit(Event::AgreementSigned(
                AgreementSigned {
                    signer: caller,
                    signed_one_status: signed_one,
                    signed_two_status: signed_two,
                }
            ));
        }

        fn get_party_one(self: @ContractState) -> felt252 {
            self.party_one.read()
        }

        fn get_party_two(self: @ContractState) -> felt252 {
            self.party_two.read()
        }

        fn get_agreement_text(self: @ContractState) -> felt252 {
            self.agreement_text.read()
        }

        fn get_agreement_hash(self: @ContractState) -> felt252 {
            self.agreement_hash.read()
        }

        fn get_signed_one(self: @ContractState) -> bool {
            self.signed_one.read()
        }

        fn get_signed_two(self: @ContractState) -> bool {
            self.signed_two.read()
        }

        fn get_status(self: @ContractState) -> (bool, bool, felt252, bool) {
            let signed_one = self.signed_one.read();
            let signed_two = self.signed_two.read();
            let agreement_hash = self.agreement_hash.read();
            let fully_signed = signed_one && signed_two;
            (signed_one, signed_two, agreement_hash, fully_signed)
        }

        fn get_amount(self: @ContractState) -> u256 {
            self.amount.read()
        }

        fn get_currency(self: @ContractState) -> felt252 {
            self.currency.read()
        }

        fn get_extra_conditions(self: @ContractState) -> felt252 {
            self.extra_conditions.read()
        }

        fn get_expiration_date(self: @ContractState) -> u64 {
            self.expiration_date.read()
        }

        fn get_status_string(self: @ContractState) -> felt252 {
            self.status.read()
        }
    }
}
