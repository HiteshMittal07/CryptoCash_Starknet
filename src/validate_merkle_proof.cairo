use core::pedersen::pedersen;
use core::serde::{Serde};
use cairo_lib::data_structures::mmr::{mmr::{MMR, MMRImpl, MMRTrait}};

#[derive(Serde)]
pub struct Input {
    secret: felt252,
    nullifier: felt252,
    nullifier_hash: felt252,
    commitment: felt252,
    root: felt252,
    index: usize,
    last_pos: usize,
    peaks: Span<felt252>,
    proof: Span<felt252>
}

pub fn validate(input: Input) -> Result<bool, felt252> {
    assert(pedersen(0, input.nullifier) == input.nullifier_hash, 'Invalid nullifier');
    assert(pedersen(input.secret, input.nullifier) == input.commitment, 'Invalid commitment');

    let mmr = MMRImpl::new(input.root, input.last_pos);
    mmr.verify_proof(input.index, input.commitment, input.peaks, input.proof)
}
