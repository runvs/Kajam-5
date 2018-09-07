package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author 
 */
class Trigger extends FlxSprite
{
	public var name : String = "";
	public var type : String = "";
	public var action : String = "";
	public var target : Array<String>;

	private var _level : TiledLevel = null;
	
	public var playerOn : Bool = false;
	private var underlay : GlowOverlay;
	
	public function new(?X:Float=0, ?Y:Float=0,w : Int, h:Int, l: TiledLevel)
	{
		super(X, Y);
		_level = l;
		//this.makeGraphic(w, h);
		this.loadGraphic(AssetPaths.lever__png, false, 16, 16);
		target = new Array<String>();
		immovable = true;
		underlay = new GlowOverlay(X + 6, Y + 8, FlxG.camera, 24, 1, 1);
	}
	
	public function perform ()
	{
		if (playerOn) return;
		
		if (type == null || target == null || action == null) return;
		var l : TiledLevel = _level;
		if (type == "trap")
		{
			var t : Array<Trap> = new Array<Trap>();
			for (ti in l.allTraps)
			{
				for (tname in target)
				{
					if (ti.name == tname)
					{
						t.push(ti);
					
					}
				}					
			}
			if (t.length == 0) return;
			
			for (ti in t)
			{
				
				if (action == "disable")
				{
					ti.activated = false;
				}
				else if (action == "enable")
				{
					ti.activated = true;
				}
				else if (action == "toggle")
				{
					ti.activated = !ti.activated;
				}
			}
		}
	}
	
	override public function draw():Void 
	{
		underlay.draw();
		super.draw();
	}
	
	
}