module MyModule::FitnessChallenges {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// Struct representing a fitness challenge.
    struct Challenge has store, key {
        creator: address,          // Address of the challenge creator
        description: vector<u8>,   // Description of the fitness challenge
        reward_pool: u64,          // Total reward pool for the challenge
        is_active: bool,           // Whether the challenge is active
    }

    /// Function for a user to create a fitness challenge with a reward pool.
    public fun create_challenge(creator: &signer, description: vector<u8>, reward_pool: u64) {
        let challenge = Challenge {
            creator: signer::address_of(creator),
            description,
            reward_pool,
            is_active: true,
        };
        move_to(creator, challenge);
    }

    /// Function for rewarding participants upon completion of the challenge.
    public fun reward_participant(creator: &signer, participant: address, reward_amount: u64) acquires Challenge {
        let challenge = borrow_global_mut<Challenge>(signer::address_of(creator));

        // Ensure the challenge is active and the reward pool is sufficient
        assert!(challenge.is_active, 1);
        assert!(challenge.reward_pool >= reward_amount, 2);

        // Deduct the reward amount from the reward pool
        challenge.reward_pool = challenge.reward_pool - reward_amount;


        // If the reward pool is depleted, mark the challenge as inactive
        if (challenge.reward_pool == 0) {
            challenge.is_active = false;
        }
    }
}
