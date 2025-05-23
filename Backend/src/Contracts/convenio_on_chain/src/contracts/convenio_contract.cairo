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
}

// Define the contract module
#[starknet::contract]
pub mod ConvenioContract {
    // Updated imports to use 'starknet' directly as recommended by the warnings
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::*;
    use core::pedersen::pedersen;
    use core::num::traits::Zero;
    use core::bool;

    // Define storage variables
    #[storage]
    pub struct Storage {
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
        agreement_hash: felt252,
        signed_one: bool,
        signed_two: bool,
    }

    // Define events
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
    }

    #[derive(Drop, starknet::Event)]
    pub struct AgreementSigned {
        signer: felt252,
        signed_one_status: bool,
        signed_two_status: bool,
    }

    // Constructor function
    #[constructor]
    pub fn constructor(
        ref self: ContractState,
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
    ) {
        assert(!party_one.is_zero(), 'PartyOne cannot be zero');
        assert(!party_two.is_zero(), 'PartyTwo cannot be zero');
        assert(party_one != party_two, 'Parties must be different');
        assert(!agreement_text.is_zero(), 'Agreement text cannot be empty');

        self.party_one.write(party_one);
        self.party_two.write(party_two);
        self.agreement_text.write(agreement_text);

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
            }
        ));
    }

    // Implement the contract interface
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
    }
}