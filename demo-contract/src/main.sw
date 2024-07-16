contract;

use pyth_interface::{data_structures::price::{Price, PriceFeedId}, PythCore, PythInfo};

use std::bytes::Bytes;

configurable {
    PYTH_CONTRACT_ID: b256 = 0xc8210e27604707c8647e8924cdb708fd056dcf5bbdcce156ee3b3db37106a2b6,
    FUEL_ETH_BASE_ASSET_ID: b256 = 0xf8f8b6283d7fa5b672b530cbb84fcccb4ff8dc40f8176ef4544ddb1f1952ad07,
}

abi UpdatePrice {
    fn chain_id() -> u16;

    fn valid_time_period() -> u64;

    fn get_price(price_feed_id: PriceFeedId) -> Price;

    fn update_fee(update_data: Vec<Bytes>) -> u64;

    #[payable]
    fn update_price_feeds(update_fee: u64, update_data: Vec<Bytes>);
}

impl UpdatePrice for Contract {
    fn chain_id() -> u16 {
        let pyth_abi = abi(PythInfo, PYTH_CONTRACT_ID);
        pyth_abi.chain_id()
    }

    fn valid_time_period() -> u64 {
        let pyth_abi = abi(PythCore, PYTH_CONTRACT_ID);
        pyth_abi.valid_time_period()
    }

    fn get_price(price_feed_id: PriceFeedId) -> Price {
        let pyth_abi = abi(PythCore, PYTH_CONTRACT_ID);
        pyth_abi.price(price_feed_id)
    }

    fn update_fee(update_data: Vec<Bytes>) -> u64 {
        let pyth_abi = abi(PythCore, PYTH_CONTRACT_ID);
        pyth_abi.update_fee(update_data)
    }

    #[payable]
    fn update_price_feeds(update_fee: u64, update_data: Vec<Bytes>) {
        let pyth_abi = abi(PythCore, PYTH_CONTRACT_ID);

        pyth_abi
            .update_price_feeds {
                asset_id: FUEL_ETH_BASE_ASSET_ID,
                coins: update_fee,
            }(update_data);
    }
}
