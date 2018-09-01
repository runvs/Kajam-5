package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

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

		this.scrollFactor.set();
	}

	// ################################################################
	// # Swords #######################################################
	// ################################################################
	public static function GetShortSword() : Item
	{
		var item  = new Item();
		item.name = 'Short Sword';
		item.type = ItemType.SWORD;
		item.loadGraphic(AssetPaths.shortsword__png, false, 16, 16);

		item.evasionMultiplier      = 1.1;
		item.walkSpeedMultiplier    = 1.1;
		item.dashDistanceMultiplier = 1.1;
		item.dashCooldownMultiplier = 1.0;

		item.damageMultiplier       = 1.0;
		item.attackSpeedMultiplier  = 1.0;
		item.critChanceMultiplier   = 1.0;
		item.critDamageMultiplier   = 1.0;

		return item;
	}

	public static function GetDagger() : Item
	{
		var item = new Item();
		item.name = 'Dagger';
		item.type = ItemType.SWORD;
		item.loadGraphic(AssetPaths.dagger__png, false, 16, 16);

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

	public static function GetClaymore() : Item
	{
		var item = new Item();
		item.name = 'Claymore';
		item.type = ItemType.SWORD;
		item.loadGraphic(AssetPaths.claymore__png, false, 16, 16);

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

	public static function GetKatana() : Item
	{
		var item = new Item();
		item.name = 'Katana';
		item.type = ItemType.SWORD;
		item.loadGraphic(AssetPaths.katana__png, false, 16, 16);

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
	public static function GetRobe() : Item
	{
		var item = new Item();
		item.name = 'Robe';
		item.type = ItemType.ARMOR;
		item.loadGraphic(AssetPaths.robe__png, false, 16, 16);

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

	public static function GetLeatherArmor() : Item
	{
		var item = new Item();
		item.name = 'Leather Armor';
		item.type = ItemType.ARMOR;
		item.loadGraphic(AssetPaths.leatherarmor__png, false, 16, 16);

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

	public static function GetChainMail() : Item
	{
		var item = new Item();
		item.name = 'Chain Mail';
		item.type = ItemType.ARMOR;
		item.loadGraphic(AssetPaths.chainmail__png, false, 16, 16);

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

	public static function GetPlateMail() : Item
	{
		var item = new Item();
		item.name = 'Plate Mail';
		item.type = ItemType.ARMOR;
		item.loadGraphic(AssetPaths.platemail__png, false, 16, 16);

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
	public static function GetSelfbow() : Item
	{
		var item = new Item();
		item.name = 'Selfbow';
		item.type = ItemType.BOW;
		item.loadGraphic(AssetPaths.selfbow__png, false, 16, 16);

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

	public static function GetLongbow() : Item
	{
		var item = new Item();
		item.name = 'Longbow';
		item.type = ItemType.BOW;
		item.loadGraphic(AssetPaths.longbow__png, false, 16, 16);

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

	public static function GetRecurveBow() : Item
	{
		var item = new Item();
		item.name = 'Recurve bow';
		item.type = ItemType.BOW;
		item.loadGraphic(AssetPaths.recurvebow__png, false, 16, 16);

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

	public static function GetCrossbow() : Item
	{
		var item = new Item();
		item.name = 'Crossbow';
		item.type = ItemType.BOW;
		item.loadGraphic(AssetPaths.crossbow__png, false, 16, 16);

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