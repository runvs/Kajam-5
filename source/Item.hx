package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Item extends FlxSprite
{
	// Modifiers are additive, multipliers... guess what

	public var evasionModifier       : Float = 0;
	public var walkSpeedModifier     : Float = 0;
	public var dashDistanceModifier  : Float = 0;
	public var dashCooldownModifier  : Float = 0;
	
	public var damageMultiplier      : Float = 0;
	public var attackSpeedMultiplier : Float = 0;
	public var critChanceModifier    : Float = 0;
	public var critDamageModifier    : Float = 0;
	public var lifeLeechModifier     : Float = 0;

	public function new() 
	{
		super();

	}
	
}