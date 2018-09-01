package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class EnemyShot extends GenericShot
{
	
	
	
	public function new(?X:Float=0, ?Y:Float=0, vx: Float, vy: Float) 
	{
		super(X, Y,vx,vy);
		
		this.velocity.scale(GameProperties.EnemyShotSpeed);
	}
	
	override public function createImage() 
	{
		this.makeGraphic(6, 6, FlxColor.RED);
		this.angularVelocity = 100;
		
	}
	
}