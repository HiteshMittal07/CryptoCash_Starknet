use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState,_commitment:felt252,amount:u256);
    // fn verify(self:@TContractState) -> bool;
    // fn withdraw(ref self:TContractState);
}

#[starknet::contract]
mod Cryptocash{
    use starknet::{ContractAddress,get_caller_address,storage_access::StorageBaseAddress};
    #[storage]
    struct Storage {
        nullifierHashes: LegacyMap<felt252,bool>,
        commitments: LegacyMap<felt252,commitmentStore>,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        let caller=get_caller_address();
        self.owner.write(caller);
    }
    #[abi(embed_v0)]
    impl Cryptocash of super::ICryptoCash<ContractState>{
        fn createNote(ref self: ContractState, _commitment:felt252, amount:u256) {
            let caller=get_caller_address();
            let commitmentStore=self.commitments.read(_commitment);
            assert(!commitmentStore.used==true, 'you can use this commitment');
            assert(amount>0, 'Invalid amount');
            let value=commitmentStore{used:true,owner:caller,commitment:_commitment,amount:amount,recipient:caller};
            self.commitments.write(_commitment,value);
        }
    }
    #[derive(Drop,Serde,starknet::Store)]
    pub struct commitmentStore{
        used: bool,
        owner: ContractAddress,
        commitment: felt252,
        amount: u256,
        recipient: ContractAddress,
    }

}
