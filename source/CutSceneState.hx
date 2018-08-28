package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;

/**
 * ...
 * @author 
 */
class CutSceneState extends FlxSubState
{

	
	private var target : FlxSprite;
	
	private var _state : PlayState;
	
	// needs world from playstate so it can access the levels and the Cutscene can switch back to the level
	//
	// world needs to stay in playstate as there can only be one unique playstate 
	// and by initializing the world (= loading all the levels)
	// the playstate "pointer" has to be known
	
	public function new(s : PlayState) 
	{
		super();
		_state = s;
	}
	
	override public function create() 
	{
		super.create();
		trace("cutscene.create");
		
		//target = new FlxSprite(0, 0);
		//FlxG.camera.follow(target);
	}
	
	public function BackToPlayState()
	{
		//FlxG.switchState(_state);
		this.close();
	}
	
}