package;

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

	private var _state : PlayState = null;
	
	public var playerOn : Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0,w : Int, h:Int, s: PlayState)
	{
		super(X, Y);
		_state = s;
		this.makeGraphic(w, h);
		target = new Array<String>();
	}
	
	public function perform ()
	{
		if (playerOn) return;
		
		if (type == null || target == null || action == null) return;
		var l : TiledLevel = _state.level;
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
	
	
	
}