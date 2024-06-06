use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState,_commitment:felt252,amount:u256);
    fn get_owner(self:@TContractState ) -> ContractAddress;
    fn get_note_status(self:@TContractState, _commitment:felt252) -> bool; 
    // fn verify(self:@TContractState) -> bool;
    // fn withdraw(ref self:TContractState);
}

#[starknet::contract]
mod Cryptocash{
    use starknet::{ContractAddress,get_caller_address,storage_access::StorageBaseAddress};
    use openzeppelin::token::erc20::ERC20;
    #[storage]
    struct Storage {
        nullifierHashes: LegacyMap<felt252,bool>,
        commitments: LegacyMap<felt252,commitmentStore>,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState,initial_supply:u256,recipient:ContractAddress) {
        let caller=get_caller_address();
        self.owner.write(caller);
        let name = 'Crypto_Cash';
        let symbol = 'CC';

        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::InternalImpl::initializer(ref unsafe_state, name, symbol);
        ERC20::InternalImpl::_mint(ref unsafe_state, recipient, initial_supply);
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
        fn get_owner(self:@ContractState)-> ContractAddress {
            self.owner.read()
        }
        fn get_note_status(self:@ContractState, _commitment:felt252)->bool{
            self.commitments.read(_commitment).used
        }
    }
    #[external(v0)]
    #[generate_trait]
    impl Ierc20Impl of Ierc20 {
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            let unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::balance_of(@unsafe_state, account)
        }

        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
            let mut unsafe_state = ERC20::unsafe_new_contract_state();
            ERC20::ERC20Impl::transfer(ref unsafe_state, recipient, amount)
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
