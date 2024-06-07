use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState,_commitment:u256,amount:u256);
    fn get_owner(self:@TContractState ) -> ContractAddress;
    fn get_note_status(self:@TContractState, _commitment:u256) -> bool; 
    // fn verify(self:@TContractState) -> bool;
    // fn withdraw(ref self:TContractState);
}

#[starknet::contract]
mod Cryptocash{
    use starknet::{ContractAddress,get_caller_address,storage_access::StorageBaseAddress};
    use openzeppelin::token::erc20::{ERC20Component, ERC20HooksEmptyImpl};

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);
    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
        nullifierHashes: LegacyMap<felt252,bool>,
        commitments: LegacyMap<u256,commitmentStore>,
        owner: ContractAddress
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState,initial_supply:u256) {
        let caller=get_caller_address();
        self.owner.write(caller);

        self.erc20.initializer("Cryto_cash","CC");
        self.erc20._mint(caller, initial_supply);
    }
    #[abi(embed_v0)]
    impl Cryptocash of super::ICryptoCash<ContractState>{
        fn createNote(ref self: ContractState, _commitment:u256, amount:u256) {
            let caller=get_caller_address();
            let commitmentStore=self.commitments.read(_commitment);
            assert(!commitmentStore.used==true, 'you can use this commitment');
            assert(amount>0, 'Invalid amount');
            let value=commitmentStore{used:true,owner:caller,amount:amount,recipient:caller};
            self.commitments.write(_commitment,value);
        }
        fn get_owner(self:@ContractState)-> ContractAddress {
            self.owner.read()
        }
        fn get_note_status(self:@ContractState, _commitment:u256)->bool{
            self.commitments.read(_commitment).used
        }
    }
     #[abi(embed_v0)]
    impl ERC20MixinImpl = ERC20Component::ERC20MixinImpl<ContractState>;
    impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[generate_trait]
    #[abi(per_item)]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn burn(ref self: ContractState, value: u256) {
            self.erc20._burn(get_caller_address(), value);
        }

        #[external(v0)]
        fn mint(ref self: ContractState, recipient: ContractAddress, amount: u256) {
            self.erc20._mint(recipient, amount);
        }
    }
    #[derive(Drop,Serde,starknet::Store)]
    pub struct commitmentStore{
        used: bool,
        owner: ContractAddress,
        amount: u256,
        recipient: ContractAddress,
    }
    

}
