use starknet::ContractAddress;

#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState);
    fn verify(self:TContractState) -> bool;
    fn withdraw(ref self:TContractState);
}
#[starknet::contract]
mod Cryptocash{
    use starknet::{ContractAddress,get_caller_address,storage_access::StorageBaseAddress};
    #[storage]
    struct Storage {

    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {

    }
    #[abi(embed_v0)]
    impl Cryptocash of <ContractState>{
        
    }

}
