use cairo_verifier::{StarkProof, StarkProofImpl};
use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(
        ref self: TContractState, _commitment: felt252, amount: u256, token_address: ContractAddress
    );
    fn get_note_status(self: @TContractState, _commitment: felt252) -> bool;
    fn withdraw(
        ref self: TContractState,
        proof: StarkProof,
        commitmentHash: felt252,
        recipient: ContractAddress,
        nullifier_hash: felt252
    );
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
    use cairo_verifier::stark::StarkProofTrait;
    use cairo_verifier::{StarkProof, StarkProofImpl};
    use core::hash::{HashStateTrait, HashStateExTrait};
    use starknet::{
        ContractAddress, get_caller_address, get_contract_address,
        storage_access::StorageBaseAddress
    };
    use super::IERC20Dispatcher;
    use super::IERC20DispatcherTrait;
    const SECURITY_BITS: felt252 = 50;
    #[storage]
    struct Storage {
        owner: ContractAddress,
        nullifierHashes: LegacyMap<felt252, bool>,
        commitments: LegacyMap<felt252, commitmentStore>,
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
            ref self: ContractState,
            _commitment: felt252,
            amount: u256,
            token_address: ContractAddress
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

            self.emit(created { creator: caller, price: amount });
        }
        
        fn get_note_status(self: @ContractState, _commitment: felt252) -> bool {
            self.commitments.read(_commitment).used
        }

        fn withdraw(
            ref self: ContractState,
            proof: StarkProof,
            commitmentHash: felt252,
            recipient: ContractAddress,
            nullifier_hash: felt252
        ) {
            let commitmentStore = self.commitments.read(commitmentHash);
            let token_address = commitmentStore.token_address;
            let amount = commitmentStore.amount;
            assert(self.nullifierHashes.read(nullifier_hash) == false, 'Nullifier already used');
            proof.verify(SECURITY_BITS);
            self.nullifierHashes.write(nullifier_hash, true);
            let token = IERC20Dispatcher { contract_address: token_address };
            let status = token.transfer(recipient, amount);
            assert(status == true, 'transfer failed');
        }
    }
}
