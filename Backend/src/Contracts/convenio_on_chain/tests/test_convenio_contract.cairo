// Import the contract module itself
use convenio_contract::ConvenioContract;
// Make the required inner structs available in scope for event assertion
use convenio_contract::ConvenioContract::{AgreementCreated, AgreementSigned};

// Traits derived from the interface, allowing to interact with a deployed contract
use convenio_contract::{IConvenioContractDispatcher, IConvenioContractDispatcherTrait};

// Required for declaring and deploying a contract
use snforge_std::{declare, DeclareResultTrait, ContractClassTrait};
// Cheatcodes to spy on events and assert their emissions
use snforge_std::{EventSpyAssertionsTrait, spy_events};
// Cheatcodes to cheat environment values
use snforge_std::{
    start_cheat_caller_address, stop_cheat_caller_address,
};
use starknet::ContractAddress;
use core::array::ArrayTrait;
use core::result::ResultTrait;
use core::traits::Into;
use core::pedersen::pedersen;
use core::num::traits::Zero;
use snforge_std::byte_array::try_deserialize_bytearray_error;

// Helper function to deploy the contract
fn deploy_contract(
    party_one: felt252, party_two: felt252, agreement_text: felt252
) -> IConvenioContractDispatcher {
    // Deploy the contract
    // 1. Declare the contract class
    let contract = declare("ConvenioContract");
    // 2. Create constructor arguments - serialize each one into a felt252 array
    let mut constructor_args = array![];
    Serde::serialize(@party_one, ref constructor_args);
    Serde::serialize(@party_two, ref constructor_args);
    Serde::serialize(@agreement_text, ref constructor_args);

    // 3. Deploy the contract
    let (contract_address, _err) = contract
        .unwrap()
        .contract_class()
        .deploy(@constructor_args)
        .unwrap();

    // 4. Create a dispatcher to interact with the contract
    IConvenioContractDispatcher { contract_address }
}

#[test]
fn test_constructor_success() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';

    // Setup event spy before deployment to capture constructor events
    let mut spy = spy_events();

    // Deploy the contract
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Verify initial state
    assert(dispatcher.get_party_one() == party_one_addr, 'Wrong party_one');
    assert(dispatcher.get_party_two() == party_two_addr, 'Wrong party_two');
    assert(dispatcher.get_agreement_text() == agreement_txt, 'Wrong agreement_text');
    assert(!dispatcher.get_signed_one(), 'signed_one should be false');
    assert(!dispatcher.get_signed_two(), 'signed_two should be false');

    // Verify agreement hash (re-calculate it)
    let expected_hash = pedersen(party_one_addr, pedersen(party_two_addr, agreement_txt));
    assert(dispatcher.get_agreement_hash() == expected_hash, 'Wrong agreement_hash');

    // Verify event emission: AgreementCreated
    let expected_created_event = ConvenioContract::Event::AgreementCreated(
        AgreementCreated {
            party_one: party_one_addr,
            party_two: party_two_addr,
            agreement_hash: expected_hash,
            agreement_text: agreement_txt,
        }
    );
    let expected_events = array![(dispatcher.contract_address, expected_created_event)];
    spy.assert_emitted(@expected_events);
}

#[test]
#[should_panic(expected: "PartyOne cannot be zero")]
fn test_constructor_party_one_zero_panics() {
    let party_one_addr: felt252 = 0;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';

    deploy_contract(party_one_addr, party_two_addr, agreement_txt);
}

#[test]
#[should_panic(expected: "PartyTwo cannot be zero")]
fn test_constructor_party_two_zero_panics() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 0;
    let agreement_txt: felt252 = 'Agreement Text';

    deploy_contract(party_one_addr, party_two_addr, agreement_txt);
}

#[test]
#[should_panic(expected: "Parties must be different")]
fn test_constructor_parties_same_panics() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 111;
    let agreement_txt: felt252 = 'Agreement Text';

    deploy_contract(party_one_addr, party_two_addr, agreement_txt);
}

#[test]
#[should_panic(expected: "Agreement text cannot be empty")]
fn test_constructor_agreement_text_zero_panics() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 0;

    deploy_contract(party_one_addr, party_two_addr, agreement_txt);
}


#[test]
fn test_sign_agreement_party_one() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Setup event spy
    let mut spy = spy_events();

    // Set caller address to party_one
    let caller: ContractAddress = party_one_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller);

    // Party One signs
    dispatcher.sign_agreement();

    // Verify state change
    assert(dispatcher.get_signed_one(), 'PartyOne should be signed');
    assert(!dispatcher.get_signed_two(), 'PartyTwo should not be signed');

    // Verify event emission: AgreementSigned
    let expected_signed_event = ConvenioContract::Event::AgreementSigned(
        AgreementSigned {
            signer: party_one_addr,
            signed_one_status: true,
            signed_two_status: false,
        }
    );
    let expected_events = array![(dispatcher.contract_address, expected_signed_event)];
    spy.assert_emitted(@expected_events);

    stop_cheat_caller_address(dispatcher.contract_address);
}

#[test]
fn test_sign_agreement_party_two() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Setup event spy
    let mut spy = spy_events();

    // Set caller address to party_two
    let caller: ContractAddress = party_two_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller);

    // Party Two signs
    dispatcher.sign_agreement();

    // Verify state change
    assert(!dispatcher.get_signed_one(), 'PartyOne should not be signed');
    assert(dispatcher.get_signed_two(), 'PartyTwo should be signed');

    // Verify event emission: AgreementSigned
    let expected_signed_event = ConvenioContract::Event::AgreementSigned(
        AgreementSigned {
            signer: party_two_addr,
            signed_one_status: false,
            signed_two_status: true,
        }
    );
    let expected_events = array![(dispatcher.contract_address, expected_signed_event)];
    spy.assert_emitted(@expected_events);

    stop_cheat_caller_address(dispatcher.contract_address);
}

#[test]
fn test_sign_agreement_both_parties() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Setup event spy
    let mut spy = spy_events();

    // Party One signs
    let caller_one: ContractAddress = party_one_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller_one);
    dispatcher.sign_agreement();
    stop_cheat_caller_address(dispatcher.contract_address);

    // Verify Party One state
    assert(dispatcher.get_signed_one(), 'PartyOne should be signed after first call');
    assert(!dispatcher.get_signed_two(), 'PartyTwo should not be signed after first call');

    // Party Two signs
    let caller_two: ContractAddress = party_two_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller_two);
    dispatcher.sign_agreement();
    stop_cheat_caller_address(dispatcher.contract_address);

    // Verify final state
    assert(dispatcher.get_signed_one(), 'PartyOne should remain signed');
    assert(dispatcher.get_signed_two(), 'PartyTwo should be signed after second call');

    // Verify event emissions (expecting two events)
    let expected_signed_event_one = ConvenioContract::Event::AgreementSigned(
        AgreementSigned {
            signer: party_one_addr,
            signed_one_status: true, // State after Party One signs
            signed_two_status: false,
        }
    );
    let expected_signed_event_two = ConvenioContract::Event::AgreementSigned(
        AgreementSigned {
            signer: party_two_addr,
            signed_one_status: true, // State after Party Two signs
            signed_two_status: true,
        }
    );
    let expected_events = array![
        (dispatcher.contract_address, expected_signed_event_one),
        (dispatcher.contract_address, expected_signed_event_two),
    ];
    spy.assert_emitted(@expected_events);
}

#[test]
#[feature("safe_dispatcher")]
fn test_sign_agreement_already_signed_panics() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Set caller address to party_one
    let caller: ContractAddress = party_one_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller);

    // Party One signs successfully
    dispatcher.sign_agreement();

    // Try to sign again with Party One, expect a panic
    let safe_dispatcher = IConvenioContractSafeDispatcher { contract_address: dispatcher.contract_address };

    match safe_dispatcher.sign_agreement() {
        Result::Ok(_) => panic!("Entrypoint did not panic"),
        Result::Err(panic_data) => {
            let str_err = try_deserialize_bytearray_error(panic_data.span()).expect('wrong format');
            assert(str_err == "PartyOne already signed", 'Wrong panic message');
        },
    };

    stop_cheat_caller_address(dispatcher.contract_address);
}

#[test]
#[feature("safe_dispatcher")]
fn test_sign_agreement_not_party_panics() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let non_party_addr: felt252 = 333;
    let agreement_txt: felt252 = 'Agreement Text';
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Set caller address to a non-party
    let caller: ContractAddress = non_party_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller);

    // Try to sign with non-party, expect a panic
    let safe_dispatcher = IConvenioContractSafeDispatcher { contract_address: dispatcher.contract_address };

    match safe_dispatcher.sign_agreement() {
        Result::Ok(_) => panic!("Entrypoint did not panic"),
        Result::Err(panic_data) => {
            let str_err = try_deserialize_bytearray_error(panic_data.span()).expect('wrong format');
            assert(str_err == "Caller is not a party", 'Wrong panic message');
        },
    };

    stop_cheat_caller_address(dispatcher.contract_address);
}

#[test]
fn test_view_functions() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let expected_hash = pedersen(party_one_addr, pedersen(party_two_addr, agreement_txt));

    // Deploy the contract
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Verify view functions return correct initial state
    assert(dispatcher.get_party_one() == party_one_addr, 'get_party_one failed');
    assert(dispatcher.get_party_two() == party_two_addr, 'get_party_two failed');
    assert(dispatcher.get_agreement_text() == agreement_txt, 'get_agreement_text failed');
    assert(dispatcher.get_agreement_hash() == expected_hash, 'get_agreement_hash failed');
    assert(!dispatcher.get_signed_one(), 'get_signed_one failed initially');
    assert(!dispatcher.get_signed_two(), 'get_signed_two failed initially');
}

#[test]
fn test_get_status() {
    let party_one_addr: felt252 = 111;
    let party_two_addr: felt252 = 222;
    let agreement_txt: felt252 = 'Agreement Text';
    let expected_hash = pedersen(party_one_addr, pedersen(party_two_addr, agreement_txt));
    let dispatcher = deploy_contract(party_one_addr, party_two_addr, agreement_txt);

    // Check status initially
    let (s1, s2, hash, fully_signed) = dispatcher.get_status();
    assert(!s1, 'Status s1 initial');
    assert(!s2, 'Status s2 initial');
    assert(hash == expected_hash, 'Status hash initial');
    assert(!fully_signed, 'Status fully_signed initial');

    // Party One signs
    let caller_one: ContractAddress = party_one_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller_one);
    dispatcher.sign_agreement();
    stop_cheat_caller_address(dispatcher.contract_address);

    // Check status after Party One signs
    let (s1, s2, hash, fully_signed) = dispatcher.get_status();
    assert(s1, 'Status s1 after party one');
    assert(!s2, 'Status s2 after party one');
    assert(hash == expected_hash, 'Status hash after party one');
    assert(!fully_signed, 'Status fully_signed after party one');

    // Party Two signs
    let caller_two: ContractAddress = party_two_addr.try_into().unwrap();
    start_cheat_caller_address(dispatcher.contract_address, caller_two);
    dispatcher.sign_agreement();
    stop_cheat_caller_address(dispatcher.contract_address);

    // Check status after both parties sign
    let (s1, s2, hash, fully_signed) = dispatcher.get_status();
    assert(s1, 'Status s1 after both parties');
    assert(s2, 'Status s2 after both parties');
    assert(hash == expected_hash, 'Status hash after both parties');
    assert(fully_signed, 'Status fully_signed after both parties');
}