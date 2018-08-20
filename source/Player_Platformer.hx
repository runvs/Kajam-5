package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Player_Platformer extends FlxSprite
{

	private var grav : Float = 250;
	private var acc : Float = 300;
	private var JumpStrength : Float = 120;
	
	public var touchedGround : Bool = false;
	
	public var touchedGroundTimer : Float = 0;
	public var hasDoneDoubleJump : Bool = false;
	
	public function new() 
	{
		super(20, 490);
		
		this.makeGraphic(8, 8);
		color = Palette.color3;
		
		maxVelocity.set(200, 500);
		acceleration.set(0, grav);
		drag.set(1000, 1000);
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		
		this.acceleration.set(0, grav);
		
		
		
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A)
		{
			this.acceleration.set( -acc, grav);
		}
		else if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D)
		{
			this.acceleration.set( acc, grav);
		}
		
		if (touchedGround)
		{
			hasDoneDoubleJump = false;
			touchedGroundTimer = 0;
			//trace("touching");
			if (FlxG.keys.justPressed.SPACE ||FlxG.keys.justPressed.W ||FlxG.keys.justPressed.UP)
			{
				this.velocity.y = - JumpStrength;
			}
		}
		else
		{	// double jump stuff
			touchedGroundTimer += elapsed;
			if (touchedGroundTimer >= 0.2 && hasDoneDoubleJump == false)
			{
				if (FlxG.keys.justPressed.SPACE ||FlxG.keys.justPressed.W ||FlxG.keys.justPressed.UP)
				{
					this.velocity.y = - JumpStrength * 1.3;
					hasDoneDoubleJump = true;
				}
			}
		}
		
		super.update(elapsed);
		//trace(velocity.y);
		
		if (( velocity.x > 0 && acceleration.x < 0) || (velocity.x < 0 && acceleration.x > 0))
		{
			velocity.x *= 0.3;
		}
	}
	
}