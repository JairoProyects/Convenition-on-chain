use starknet::ContractAddress;
use starknet::ClassHash;

#[starknet::interface]
pub trait IConvenioFactory<TContractState> {
    fn create_convenio(
        ref self: TContractState,
        party_one: felt252,
        party_two: felt252,
        agreement_text: felt252,
        amount: u256,
        currency: felt252,
        extra_conditions: felt252,
        expiration_date: u64,
        status: felt252
    ) -> ContractAddress;

    fn get_all_convenios(self: @TContractState) -> Array<ContractAddress>;
}

#[starknet::contract]
pub mod ConvenioFactory {
    use starknet::{ContractAddress, ClassHash, syscalls::deploy_syscall};
    use core::array::ArrayTrait;
    use core::array::SpanTrait;
    use core::integer::u256;
    use core::integer::u64;
    use starknet::storage::*;
    use core::traits::Into;

    #[storage]
    pub struct Storage {
        convenio_class_hash: ClassHash,
        deployed_convenios: Vec<ContractAddress>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, convenio_class_hash: ClassHash) {
        self.convenio_class_hash.write(convenio_class_hash);
    }

    #[abi(embed_v0)]
    pub impl ConvenioFactoryImpl of super::IConvenioFactory<ContractState> {
        fn create_convenio(
            ref self: ContractState,
            party_one: felt252,
            party_two: felt252,
            agreement_text: felt252,
            amount: u256,
            currency: felt252,
            extra_conditions: felt252,
            expiration_date: u64,
            status: felt252
        ) -> ContractAddress {
            let class_hash = self.convenio_class_hash.read();

            let mut constructor_calldata = array![];
            constructor_calldata.append(party_one);
            constructor_calldata.append(party_two);
            constructor_calldata.append(agreement_text);
            constructor_calldata.append(amount.low.into());
            constructor_calldata.append(amount.high.into());
            constructor_calldata.append(currency);
            constructor_calldata.append(extra_conditions);
            constructor_calldata.append(expiration_date.into());
            constructor_calldata.append(status); // nuevo campo

            let (deployed_address, _) = deploy_syscall(
                class_hash, 0, constructor_calldata.span(), false,
            ).unwrap();

            self.deployed_convenios.push(deployed_address);

            deployed_address
        }

        fn get_all_convenios(self: @ContractState) -> Array<ContractAddress> {
            let mut all_convenios = array![];
            let len = self.deployed_convenios.len();
            let mut i = 0;
            while i < len {
                all_convenios.append(self.deployed_convenios.at(i).read());
                i += 1;
            };
            all_convenios
        }
    }
}
