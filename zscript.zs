version "4.9"

class JGP_SlotHandler : EventHandler
{
    override void PlayerSpawned(PlayerEvent e)
    {
        if (!PlayerInGame[e.PlayerNumber])
            return;
        
        PlayerPawn pmo = players[e.PlayerNumber].mo;
        if (!pmo)
            return;
        
        pmo.GiveInventory("JGP_SlotController", 1);
    }
}

class JGP_SlotController : Inventory
{
    protected Weapon weaponToPick;
    protected Weapon possWeapon;

    Default
    {
        +INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.PERSISTENTPOWER
        Inventory.maxamount 1;
    }

    override bool HandlePickup(Inventory item)
    {
        if (!owner || !owner.player)
            return false;

        let toPick = Weapon(item);
        if (!toPick)
            return false;
        
        //console.printf("Trying to pick up %s", toPick.GetTag());
        
        bool b; int thisSlot;
        [b, thisSlot] = owner.player.weapons.LocateWeapon(toPick.GetClass());
        //console.printf("%s uses slot %d", toPick.GetTag(), thisSlot);

        for (let iitem = owner.inv; iitem != null; iitem = iitem.inv)
        {
            let curWeapon = Weapon(iitem);
            //console.printf("Iterator found %s. It's %s", iitem.GetTag(), curWeapon ? "a weapon!" : "NOT a weapon");
            if (!curWeapon)
                continue;
            
            int newSlot;
            [b, newSlot] = owner.player.weapons.LocateWeapon(curWeapon.GetClass());
            //console.printf("%s found in  slot %d", curweapon.GetTag(), newSlot);
            if (toPick.GetClass() != curWeapon.GetClass() && thisSlot != -1 && thisSlot == newSlot)
            {
                //Array <int> keys;
                //Bindings.GetAllKeysForCommand(keys, "+use");
                //string keynames = Bindings.NameAllKeys(keys);
                //keynames.Replace(", ", "/");
                /*console.midprint(
                    "Confont",
                    String.Format(
                        "\c[White]Slot \c[Green]%d\c[White] occupied.\n"
                        "\c[White]Press %s to swap \c[Green]%s\c[White] for \c[Green]%s",
                        thisSlot,
                        keynames,
                        curWeapon.GetTag(),
                        toPick.GetTag()
                    )
                );*/
                
                console.midprint(
                    "Confont",
                    String.Format(
                        "\c[White]Slot \c[Green]%d\c[White] occupied.\n"
                        "Drop \c[Green]%s\c[White] to be able to pick up \c[Green]%s",
                        thisSlot,
                        curWeapon.GetTag(),
                        toPick.GetTag()
                    )
                );
                //console.printf("Suggested swapping %s for %s", curweapon.GetTag(), toPick.GetTag());
                //possWeapon = curWeapon;
                //weaponToPick = toPick;
                return true;
            }
        }
        return false;
    }

    override void Tick()
    {
        //console.printf("possWeapon: %s | weaponToPick: %s", possWeapon ? possWeapon.GetTag() : "...", weaponToPick ? weaponToPick.GetTag() : "...");
    }

    // unused
    void SwapWeapon()
    {
        if (!weaponToPick)
        {
            return;
        }

        if (!owner || !owner.player || owner.health <= 0)
        {
            return;
        }   

        if (weapontoPick.owner || owner.Distance3D(weaponToPick) > (owner.radius + weaponToPick.radius))
        {
            weaponToPick = null;
            possWeapon = null;
            return;
        }

        if (weaponToPick && possweapon && possweapon.owner && possweapon.owner == owner)
        {
            owner.DropInventory(possWeapon);
            possWeapon.A_Stop();
            possWeapon.SetOrigin(weapontoPick.pos, false);
            weaponToPick.CallTryPickup(owner);
            owner.A_StartSound(weaponToPick.pickupsound, CHAN_AUTO);
            let w = possWeapon;
            possWeapon = weaponToPick;
            weaponToPick = w;
        }
    }

    /*override void DoEffect()
    {
        if (!owner || !owner.player || owner.health <= 0)
            return;

        //console.printf("Has: %s | trying to pick up: %s", possWeapon ? possWeapon.GetTag() : "...", weaponToPick ? weaponToPick.GetTag() : "...");
       
        if ((owner.player.cmd.buttons & BT_USE) && !(owner.player.oldbuttons & BT_USE))
        {
            SwapWeapon();
        }
    }*/
}