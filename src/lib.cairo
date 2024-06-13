use starknet::ContractAddress;
#[starknet::interface]
pub trait ICryptoCash<TContractState> {
    fn createNote(ref self:TContractState,_commitment:u256,amount:u256);
    fn get_owner(ref self:TContractState ) -> ContractAddress;
    fn get_note_status(self:@TContractState, _commitment:u256) -> bool; 
    fn deposit(ref self:TContractState,target:ContractAddress,amount:u256)->bool;
    fn get_caller(ref self:TContractState)->ContractAddress;
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
        mod Cryptocash{
            use starknet::{ContractAddress,get_caller_address,get_contract_address,storage_access::StorageBaseAddress};
             use super::IERC20DispatcherTrait;
    use super::IERC20Dispatcher;
        // use openzeppelin::token::erc20::ERC20Component;
        // component!(path: ERC20Component, storage: erc20, event: ERC20Event);
        #[derive(Copy, Drop)]
        struct DualCaseERC20 {
            contract_address: ContractAddress
        }
        #[storage]
        struct Storage {
            // #[substorage(v0)]
            // erc20: ERC20Component::Storage,
            nullifierHashes: LegacyMap<felt252,bool>,
            commitments: LegacyMap<u256,commitmentStore>,
            owner: ContractAddress
        }

        // #[event]
        // #[derive(Drop, starknet::Event)]
        // enum Event {
        //     #[flat]
        //     ERC20Event: ERC20Component::Event
        // }

        #[constructor]
        fn constructor(ref self: ContractState,initialSupply:u256) {
            let name = 'MyToken';
            let symbol = 'MTK';

            let caller=get_caller_address();
            // self.erc20.initializer(name,symbol);
            // self.erc20._mint(caller,initialSupply);
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
        fn get_owner(ref self:ContractState)-> ContractAddress {
            self.owner.read()
        }
        fn get_note_status(self:@ContractState, _commitment:u256)->bool{
            self.commitments.read(_commitment).used
        }
        fn get_caller(ref self:ContractState)->ContractAddress{
            get_caller_address()
        }
        fn deposit(ref self:ContractState,target:ContractAddress,amount:u256)->bool{
            let caller=get_caller_address();
            IERC20Dispatcher{contract_address:target}.approve(caller,amount)
        }
        
            
            }
            // #[abi(embed_v0)]
            // impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;
            // #[abi(embed_v0)]
            // impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>;
            // #[abi(embed_v0)]
            // impl ERC20CamelOnlyImpl = ERC20Component::ERC20CamelOnlyImpl<ContractState>;
            // impl ERC20InternalImpl = ERC20Component::InternalImpl<ContractState>;
            
            // #[external(v0)]
            // fn _balance(self:@ContractState,account:ContractAddress)->u256{
            //     self.erc20.balance_of(account)
            //     }
            //     #[external(v0)]
            //     fn _transfer(ref self:ContractState,sender:ContractAddress,recipient:ContractAddress,amount:u256){
            //         let result=self.erc20.transfer_from(sender,recipient,amount);
            //         assert(result==true, 'cannot transfer');
            //         }
            //         #[external(v0)]
            //         fn mint(ref self:ContractState,recipient:ContractAddress,amount:u256){
            //             self.erc20._mint(recipient,amount);
            //             self.erc20.approve(recipient,amount);
            //         }
                    #[derive(Drop,Serde,starknet::Store)]
                    pub struct commitmentStore{
                        used: bool,
                        owner: ContractAddress,
                        amount: u256,
                        recipient: ContractAddress,
                        }
                        
                        
}
