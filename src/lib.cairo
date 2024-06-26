use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(
        ref self: TContractState, _commitment: u256, token_address: ContractAddress, amount: u256
    );
    fn get_note_status(self: @TContractState, _commitment: u256) -> bool;
// fn verify(self:@TContractState) -> bool;
// fn withdraw(ref self:TContractState);
}
#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> felt252;

    fn symbol(self: @TContractState) -> felt252;

    fn decimals(self: @TContractState) -> u8;

    fn total_supply(self: @TContractState) -> u256;

    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;

    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;

    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;

    fn transfer_from(
        ref self: TContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256
    ) -> bool;

    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}


#[starknet::contract]
mod Cryptocash {
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address,
        storage_access::StorageBaseAddress
    };
    use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
    #[storage]
    struct Storage {
        owner: ContractAddress,
        nullifierHashes: LegacyMap<felt252, bool>,
        commitments: LegacyMap<u256, commitmentStore>,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        created: created,
    }
    #[derive(Drop, Serde, starknet::Event)]
    struct created {
        #[key]
        creator: ContractAddress,
        price: u256
    }
    #[derive(Drop, Serde, starknet::Store)]
    pub struct commitmentStore {
        used: bool,
        owner: ContractAddress,
        token_address: ContractAddress,
        amount: u256,
    }
    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        self.owner.write(_owner);
    }
    #[abi(embed_v0)]
    impl Cryptocash of super::ICryptoCash<ContractState> {
        fn createNote(
            ref self: ContractState, _commitment: u256, token_address: ContractAddress, amount: u256
        ) {
            let caller = get_caller_address();
            let contract_address = get_contract_address();
            let commitmentStore = self.commitments.read(_commitment);
            assert(!commitmentStore.used == true, 'you can use this commitment');
            assert(amount > 0, 'Invalid amount');
            let token = IERC20Dispatcher { contract_address: token_address };
            assert(token.allowance(caller, contract_address) >= amount, 'Approve first');
            let result = token.transfer_from(caller, contract_address, amount);
            assert(result == true, 'transfer failed');
            let value = commitmentStore {
                used: true, owner: caller, token_address: token_address, amount: amount
            };
            self.commitments.write(_commitment, value);

            //emitting the event
            self.emit(created { creator: caller, price: amount });
        }
        fn get_note_status(self: @ContractState, _commitment: u256) -> bool {
            self.commitments.read(_commitment).used
        }
    }

    #[l1_handler]
    fn invalidateNoteL1Handler(
        ref self: ContractState,
        from_address: felt252,
        nullifier1: u128,
        nullifier2: u128,
        commitment1: u128,
        commitment2: u128,
        recipient1: u128,
        recipient2: u128
    ) {
        let nullifierHash = u256 { low: nullifier1, high: nullifier2 };
        let commitmentHash = u256 { low: commitment1, high: commitment2 };
        let recipient = u256 { low: recipient1, high: recipient2 };
        let contractAddress = get_contract_address();
        let data = self.commitments.read(commitmentHash);
        let token = IERC20Dispatcher { contract_address: data.token_address };
        let status = token.transfer_from(contractAddress, recipient, data.amount);
        assert(status == true, 'transfer failed');
        self.nullifierHashes.write(nullifierHash, true);
        self
            .commitments
            .write(
                commitmentHash,
                commitmentStore { used: false, ..self.commitments.read(commitmentHash) }
            );
    }
}
