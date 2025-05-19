#[cfg(test)]
mod tests {
    use crate::contracts::convenio_contract::convenio_contractDispatcher;

    const PARTY_ONE: felt252 = 123456789;
    const PARTY_TWO: felt252 = 987654321;
    const AGREEMENT_TEXT: felt252 = 12345678901234567890;

    #[test]
    fn test_constructor() {
        let contract = convenio_contractDispatcher::deploy(PARTY_ONE, PARTY_TWO, AGREEMENT_TEXT);
        assert(contract.party_one() == PARTY_ONE, 'Party one incorrect');
        assert(contract.party_two() == PARTY_TWO, 'Party two incorrect');
        assert(contract.agreement_text() == AGREEMENT_TEXT, 'Agreement text incorrect');
    }

    #[test]
    fn test_sign_agreement() {
        let contract = convenio_contractDispatcher::deploy(PARTY_ONE, PARTY_TWO, AGREEMENT_TEXT);
        contract.sign_agreement();
        let status = contract.get_status();
        assert(status.signed_by_one || status.signed_by_two, 'At least one party should be signed');
    }

    #[test]
    fn test_status_view() {
        let contract = convenio_contractDispatcher::deploy(PARTY_ONE, PARTY_TWO, AGREEMENT_TEXT);
        let status = contract.get_status();
        assert(!status.signed_by_one, 'Party one should not be signed initially');
        assert(!status.signed_by_two, 'Party two should not be signed initially');
        assert(!status.is_fully_signed, 'Agreement should not be fully signed initially');
    }
}