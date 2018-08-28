package;
import flixel.FlxG;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Scene_Intro extends CutSceneState
{

	public function new(s:PlayState) 
	{
		super(s);
	}
	
	override public function create() 
	{
		
		super.create();
		trace("scene_intro.creat");
		//var t : FlxTimer = new FlxTimer();
		//t.start(5, function (t) { BackToPlayState(); } );
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		trace("intro.update");
		if (FlxG.keys.justPressed.F6)
		{
			BackToPlayState();
		}
	}
	
	
}