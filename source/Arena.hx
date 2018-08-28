package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Arena extends FlxSprite
{

	public var gates : Array<FlxPoint>;
	public var state : Int = 0;	// 0 waiting for player
								// 1 player is in, waiting for enemies
								// 2 all enemies dead, leave arena
	
	public function new(?X:Float=0, ?Y:Float=0,w: Int, h: Int, s : PlayState) 
	{
		super(X + GameProperties.TileSize/2, Y+ GameProperties.TileSize/2);
		this.makeGraphic(w - GameProperties.TileSize, h - GameProperties.TileSize);
		
		gates = new Array<FlxPoint>();
	}
	public function addGate(i : Int, j : Int)
	{
		var p : FlxVector = new FlxVector(i, j);
		gates.push(p);
	}
	
}