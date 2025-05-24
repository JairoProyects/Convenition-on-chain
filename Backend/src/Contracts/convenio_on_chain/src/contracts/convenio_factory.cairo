use starknet::ContractAddress;
use starknet::ClassHash;

// Define the contract interface
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
    ) -> ContractAddress;

    fn get_all_convenios(self: @TContractState) -> Array<ContractAddress>;
}

// Define the contract module
#[starknet::contract]
pub mod ConvenioFactory {
    use starknet::{ContractAddress, ClassHash, syscalls::deploy_syscall};
    use core::array::ArrayTrait;
    use core::array::SpanTrait; // Required for deploy_syscall
    use core::integer::u256;
    use core::integer::u64;
    use starknet::storage::*; // Import all storage traits
    use core::traits::Into; // Required for converting u128 and u64 to felt252

    // Define storage variables
    #[storage]
    pub struct Storage {
        convenio_class_hash: ClassHash,
        deployed_convenios: Vec<ContractAddress>, // Use Vec for dynamic array storage
    }

    // Constructor function
    #[constructor]
    fn constructor(ref self: ContractState, convenio_class_hash: ClassHash) {
        self.convenio_class_hash.write(convenio_class_hash);
    }

    // Implement the contract interface using #[abi(embed_v0)]
    #[abi(embed_v0)]
    pub impl ConvenioFactoryImpl of super::IConvenioFactory<ContractState> {
        // External function to create a new convenio contract
        fn create_convenio(
            ref self: ContractState,
            party_one: felt252,
            party_two: felt252,
            agreement_text: felt252,
            amount: u256,
            currency: felt252,
            extra_conditions: felt252,
            expiration_date: u64,
        ) -> ContractAddress {
            let class_hash = self.convenio_class_hash.read();

            // Prepare constructor calldata as an Array<felt252>
            let mut constructor_calldata = array![];
            constructor_calldata.append(party_one);
            constructor_calldata.append(party_two);
            constructor_calldata.append(agreement_text);
            // Convert u128 parts of u256 to felt252
            constructor_calldata.append(amount.low.into());
            constructor_calldata.append(amount.high.into());
            constructor_calldata.append(currency);
            constructor_calldata.append(extra_conditions);
            // Convert u64 to felt252
            constructor_calldata.append(expiration_date.into());

            // Deploy the convenio contract using deploy_syscall
            // unwrap() is used to handle the Result returned by the syscall
            let (deployed_address, _) = deploy_syscall(
                class_hash, 0, constructor_calldata.span(), false,
            )
                .unwrap();

            // Push the deployed address to the vector storage (using push instead of append)
            self.deployed_convenios.push(deployed_address);

            deployed_address
        }

        // View function to retrieve all deployed convenio addresses
        fn get_all_convenios(self: @ContractState) -> Array<ContractAddress> {
            // Read all elements from the vector storage
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