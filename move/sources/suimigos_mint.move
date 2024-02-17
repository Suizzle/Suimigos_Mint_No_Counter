module suimigos::suimigos_mint {
    use sui::url::{Self, Url};
    use std::string::{utf8, String};
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::transfer::{public_transfer};
    use sui::tx_context::{sender, Self, TxContext};

    use sui::package;
    use sui::display;

    // Consts
    
    const ERR_COLLECTION_ALREADY_MINTED: u64 = 0;

    // Structs

    struct Suimigos has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    struct Counter has key {
        id: UID,
        owner: address,
        value: u64
    }

    // One-Time-Witness for the module.
    struct SUIMIGOS_MINT has drop {}

    // ===== Events =====

    struct NFTMinted has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        // The creator of the NFT
        creator: address,
        // The name of the NFT
        name: String,
    }

    // ===== Getter functions =====

    // Get the NFT's `name`
    public fun name(nft: &Suimigos): &String {
        &nft.name
    }

    // Get the NFT's `description`
    public fun description(nft: &Suimigos): &String {
        &nft.description
    }

    // Get the NFT's `url`
    public fun url(nft: &Suimigos): &Url {
        &nft.url
    }

    // Get the Counter's `value`
    public fun counter_value(counter: &Counter): &u64 {
        &counter.value
    }

    fun init(otw: SUIMIGOS_MINT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description"),
            utf8(b"creator"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{url}"),
            utf8(b"{description}"),
            utf8(b"Suizzle")
        ];

        // Claim the `Publisher` for the package!
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Sumigos` type.
        let display = display::new_with_fields<Suimigos>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);
        public_transfer(publisher, sender(ctx));
        public_transfer(display, sender(ctx));

        transfer::share_object(Counter {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            value: 0
        })
    }

    // ===== Entrypoints =====

    // Create a new ethos nft
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        counter: &mut Counter,
        ctx: &mut TxContext
    ) {
        assert!(counter.value < 4269, ERR_COLLECTION_ALREADY_MINTED);
        let sender = sender(ctx);
        let nft = mint(name, description, url, ctx);
        public_transfer(nft, sender);
        counter.value = counter.value + 1;
    }


    /// Transfer `nft` to `recipient`
    public entry fun transfer(
        nft: Suimigos, recipient: address, _: &mut TxContext
    ) {
        public_transfer(nft, recipient)
    }

    /// Update the `description` of `nft` to `new_description`
    public entry fun update_description(
        nft: &mut Suimigos,
        new_description: vector<u8>,
        _: &mut TxContext
    ) {
        nft.description = utf8(new_description)
    }

    /// Permanently delete `nft`
    public entry fun burn(nft: Suimigos, _: &mut TxContext) {
        let Suimigos { id, name: _, description: _, url: _ } = nft;
        object::delete(id)
    }

    // ===== Public funs =====

    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    public fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ): Suimigos {

        let sender = tx_context::sender(ctx);

        let nft = Suimigos {
            id: object::new(ctx),
            name: utf8(name),
            description: utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        nft
    }
}
