package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyShot extends FlxSprite
{
	private var age : Float = 0;

	public function new(?X:Float=0, ?Y:Float=0, vx: Float, vy: Float) 
	{
		super(X, Y);
		
		this.makeGraphic(6, 6, FlxColor.RED);
		this.velocity.set(vx * GameProperties.EnemyShotSpeed, vy * GameProperties.EnemyShotSpeed);
		this.angularVelocity = 100;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		age += elapsed;
		
		if (age >= GameProperties.WorldShotLifeTimeMax)
			alive = false;
	}
	
}