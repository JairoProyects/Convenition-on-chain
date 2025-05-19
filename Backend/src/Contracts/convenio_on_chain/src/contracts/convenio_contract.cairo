// Cairo 2.x migration
// SPDX-License-Identifier: MIT

#[starknet::contract]
mod convenio_contract {
    use starknet::contract;
    use starknet::get_caller_address;
    use starknet::event;
    use core::bool::{bool, TRUE, FALSE};
    use core::integer::u256;
    use core::integer::u256::U256;
    use starknet::pedersen::pedersen;

    #[storage]
    struct Storage {
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
        agreement_hash: felt252,
        party_one_signed: bool,
        party_two_signed: bool,
    }

    #[event]
    fn AgreementSigned(signer: felt252, timestamp: u256::U256) {}

    #[event]
    fn AgreementCreated(party_one: felt252, party_two: felt252, agreement_hash: felt252) {}

    #[constructor]
    fn constructor(ref self: ContractState, _party_one: felt252, _party_two: felt252, _agreement_text: felt252) {
        assert(_party_one != _party_two, 'Las partes deben ser diferentes');
        assert(_party_one != 0 && _party_two != 0, 'Las direcciones no pueden ser 0');
        assert(_agreement_text != 0, 'El texto del acuerdo no puede ser vacío');

        self.party_one.write(_party_one);
        self.party_two.write(_party_two);
        self.agreement_text.write(_agreement_text);

        let hash = pedersen(_party_one, _party_two);
        let final_hash = pedersen(hash, _agreement_text);
        self.agreement_hash.write(final_hash);

        self.party_one_signed.write(FALSE);
        self.party_two_signed.write(FALSE);

        AgreementCreated::emit(_party_one, _party_two, final_hash);
    }

    #[view]
    fn get_status(self: @ContractState) -> (signed_by_one: bool, signed_by_two: bool, hash: felt252, is_fully_signed: bool) {
        let signed_by_one = self.party_one_signed.read();
        let signed_by_two = self.party_two_signed.read();
        let hash = self.agreement_hash.read();
        let is_fully_signed = signed_by_one && signed_by_two;
        (signed_by_one, signed_by_two, hash, is_fully_signed)
    }

    #[external]
    fn sign_agreement(ref self: ContractState) {
        let caller = get_caller_address();
        let p1 = self.party_one.read();
        let p2 = self.party_two.read();

        assert(caller == p1 || caller == p2, 'Solo las partes pueden firmar');

        if (caller == p1) {
            let already_signed = self.party_one_signed.read();
            assert(!already_signed, 'La parte ya ha firmado');
            self.party_one_signed.write(TRUE);
        } else {
            let already_signed = self.party_two_signed.read();
            assert(!already_signed, 'La parte ya ha firmado');
            self.party_two_signed.write(TRUE);
        }

        AgreementSigned::emit(caller, u256::U256 { low: 0, high: 0 });
    }

    // Métodos de lectura para tests y clientes
    #[view]
    fn party_one(self: @ContractState) -> felt252 {
        self.party_one.read()
    }
    #[view]
    fn party_two(self: @ContractState) -> felt252 {
        self.party_two.read()
    }
    #[view]
    fn agreement_text(self: @ContractState) -> felt252 {
        self.agreement_text.read()
    }
    #[view]
    fn agreement_hash(self: @ContractState) -> felt252 {
        self.agreement_hash.read()
    }
    #[view]
    fn party_one_signed(self: @ContractState) -> bool {
        self.party_one_signed.read()
    }
    #[view]
    fn party_two_signed(self: @ContractState) -> bool {
        self.party_two_signed.read()
    }
}
