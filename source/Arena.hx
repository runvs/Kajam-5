package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxTimer;

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
	private var _level : TiledLevel;
	public var currentwave : Int = 0;
	private var enemies : Array<String>;
								
	
	public function new(?X:Float=0, ?Y:Float=0,w: Int, h: Int, l : TiledLevel) 
	{
		super(X + GameProperties.TileSize / 2, Y + GameProperties.TileSize / 2);
		_level = l;
		this.makeGraphic(w - GameProperties.TileSize, h - GameProperties.TileSize);
		enemies = new Array<String>();
		for (i in 1 ... GameProperties.WorldMaxWaveNumber)
			enemies.push("");
		gates = new Array<FlxPoint>();
	}
	public function addGate(i : Int, j : Int)
	{
		var p : FlxVector = new FlxVector(i, j);
		gates.push(p);
	}
	public function addWave(i:Int, e:String)
	{
		if (i <= 0 || i >= enemies.length)
		{
			trace("Error: illegal wave number: " + Std.string(i));
			return;
		}
		
		enemies[i] = e;
	}
	
	private function spawn()
	{
		trace("spawn wave nr: " + currentwave);
		if (enemies[currentwave] == "") return;
		var spl1 : Array<String> = enemies[currentwave].split(";");
		for (einfo in spl1)
		{
			var spl2 : Array<String> = einfo.split(",");
			if (spl2.length != 3) continue;
			
			var type : String = spl2[0];
			if (type== "smash") type = "smashground";
			var i : Int = Std.parseInt(spl2[1]);
			var j : Int = Std.parseInt(spl2[2]);
			
			if (_level.allEnemies.length() == 0)
			{
				_level.spawnEnemy(type, i * GameProperties.TileSize, j * GameProperties.TileSize);
			}
			else
			{
				var t : FlxTimer = new FlxTimer();
				t.start(FlxG.random.float(0.125, 0.5), function (t) { _level.spawnEnemy(type, i * GameProperties.TileSize, j * GameProperties.TileSize); } );
			}
			
		}
		
	}
	public function nextWave()
	{
		currentwave++;
		spawn();
		
	}
	
	public function resetArena() 
	{
		currentwave = 0;
		state = 0;
		active = true;
	}
}