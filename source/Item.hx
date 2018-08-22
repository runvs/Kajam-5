package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

enum ItemType
{
	Sword;
	Armor;
	Bow;
	Consumable;
}

/**
 * ...
 * @author 
 */
class Item extends FlxSprite
{
	public var name : String;
	public var type : ItemType;

	public var evasionMultiplier      : Float = 1.0;
	public var walkSpeedMultiplier    : Float = 1.0;
	public var dashDistanceMultiplier : Float = 1.0;
	public var dashCooldownMultiplier : Float = 1.0;
	
	public var damageMultiplier       : Float = 1.0;
	public var attackSpeedMultiplier  : Float = 1.0;
	public var critChanceMultiplier   : Float = 1.0;
	public var critDamageMultiplier   : Float = 1.0;

	public function new() 
	{
		super();
	}

	// ################################################################
	// # Swords #######################################################
	// ################################################################
	public static GetShortSword() : Item
	{
		var item  = new Item();
		item.name = 'ShortSword';
		item.type = ItemType.Sword;

		item.evasionMultiplier      = 1.1;
		item.walkSpeedMultiplier    = 1.1;
		item.dashDistanceMultiplier = 0.8;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetDagger() : Item
	{
		var item = new Item();
		item.name = 'Dagger';
		item.type = ItemType.Sword;

		item.evasionMultiplier      = 1.5;
		item.walkSpeedMultiplier    = 1.1;
		item.dashDistanceMultiplier = 0.8;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 0.6;
		item.attackSpeedMultiplier  = 1.5;
		item.critChanceMultiplier   = 5.0;
		item.critDamageMultiplier   = 10.0;

		return item;
	}

	public static GetClaymore() : Item
	{
		var item = new Item();
		item.name = 'Claymore';
		item.type = ItemType.Sword;

		item.evasionMultiplier      = 0.9;
		item.walkSpeedMultiplier    = 0.9;
		item.dashDistanceMultiplier = 0.8;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetKatana() : Item
	{
		var item = new Item();
		item.name = 'Katana';
		item.type = ItemType.Sword;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	// ################################################################
	// # Armor ########################################################
	// ################################################################
	public static GetRobe() : Item
	{
		var item = new Item();
		item.name = 'Robe';
		item.type = ItemType.Armor;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetLeatherArmor() : Item
	{
		var item = new Item();
		item.name = 'Leather Armor';
		item.type = ItemType.Armor;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetChainMail() : Item
	{
		var item = new Item();
		item.name = 'Chain Mail';
		item.type = ItemType.Armor;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetPlateMail() : Item
	{
		var item = new Item();
		item.name = 'Plate Mail';
		item.type = ItemType.Armor;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	// ################################################################
	// # Bows #########################################################
	// ################################################################
	public static GetSelfbow() : Item
	{
		var item = new Item();
		item.name = 'Selfbow';
		item.type = ItemType.Bow;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetLongbow() : Item
	{
		var item = new Item();
		item.name = 'Longbow';
		item.type = ItemType.Bow;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetRecurveBow() : Item
	{
		var item = new Item();
		item.name = 'Recurve bow';
		item.type = ItemType.Bow;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static GetCrossbow() : Item
	{
		var item = new Item();
		item.name = 'Crossbow';
		item.type = ItemType.Bow;

		item.evasionMultiplier      = 1.0;
		item.walkSpeedMultiplier    = 1.0;
		item.dashDistanceMultiplier = 1.0;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	// ################################################################
	// # Consumables ##################################################
	// ################################################################
	// ... TBD
}