use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState,_commitment:felt252,amount:u256);
    fn verify(self:TContractState) -> bool;
    fn withdraw(ref self:TContractState);
}
#[starknet::contract]
mod Cryptocash{
    use starknet::{ContractAddress,get_caller_address,storage_access::StorageBaseAddress};
    #[storage]
    struct Storage {
        nullifierHashes: LegacyMap<felt252,bool>,
        commitments: LegacyMap<felt252,commitmentStore>,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {

    }
    #[abi(embed_v0)]
    impl Cryptocash of super::ICryptoCash<ContractState>{
        fn createNote(ref self: ContractState, _commitment:felt252, amount:u256) {
            
        }
    }
    #[derive(Drop,Serde,starknet::Store)]
    pub struct commitmentStore{
        used: bool,
        owner: ContractAddress,
        commitment: felt252,
    }

}
