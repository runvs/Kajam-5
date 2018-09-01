package;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class GameProperties
{
    // ################################################################
    // # General ######################################################
    // ################################################################
	
    public static var TileSize        : Int       = 16;
	
    // ################################################################
    // # World ########################################################
    // ################################################################

	static public var WorldShotLifeTimeMax : Float = 7.5;
	static public var WorldMaxWaveNumber (default, null) : Int = 10;
    // ################################################################
    // # Player #######################################################
    // ################################################################
    public static var PlayerMovementAcceleration  : Float    = 500.0;
    public static var PlayerMovementDrag          : FlxPoint = new FlxPoint(2500, 2500);
    public static var PlayerMovementMaxVelocity  (default, null) : FlxPoint = new FlxPoint(80, 80);
    public static var PlayerMovementDashCooldown  : Float    = 0.9;
	public static var PlayerMovementMaxDashLength : Float    = 40.0;
    public static var PlayerAttackBaseDamage      : Float    = 10.0;
    public static var PlayerAttackCooldown        : Float    = 0.45;
	public static var PlayerHealthMaxDefault      : Float    = 3.0;
	
	static public var PlayerDamageWallTime (default, null) : Float = 0.35;
	
	static public var PlayerBowSlowDownFactor (default, null) : Float = 0.3;
	static public var PlayerBowMaxTimer (default, null) : Float = 0.7;
    
	// ################################################################
    // # Enemy ########################################################
    // ################################################################
    
	static public var EnemyMovementRandomWalkThinkTime (default, null): Float  = 1;
	static public var EnemyShotSpeed (default, null) : Float = 180;

	
    // ################################################################
    // # NPC ##########################################################
    // ################################################################
	
	public static var NPCSpeechFadeOutTime (default, null) : Float = 0.4;
	static public var EnemyRunnerChargeTime (default, null) : Float = 0.65;
	static public var WorldShopInputWallTime (default, null) : Float = 0.15;
	
	

    
    // ################################################################
    // # Merchant #####################################################
    // ################################################################
    
	// ################################################################
    // # Colors #######################################################
    // ################################################################
	
	// ################################################################
    // # Healer #######################################################
    // ################################################################
    
    // ################################################################
    // # Trainer ######################################################
    // ################################################################
    
    //#################################################################

    public static function roundForDisplay(input : Float) : String
    {
        var dec = Std.int((input * 10) % 10);
		if (dec < 0) dec *= -1;
		return '${Std.string(Std.int(input))}.${Std.string(dec)}';
    }
}
