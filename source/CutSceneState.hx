package;

import flixel.FlxCamera.FlxCameraFollowStyle;
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
		
		target = new FlxSprite(0, 0);
		FlxG.camera.follow(target, flixel.FlxCameraFollowStyle.TOPDOWN);
	}
	
	public function BackToPlayState()
	{
		trace("back to playstate");
		//FlxG.switchState(_state);
		trace(_state.player);
		FlxG.camera.follow(_state.player, flixel.FlxCameraFollowStyle.TOPDOWN);
		trace(FlxG.camera.target);
		this.close();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		_state.level.allNSCs.update(elapsed);
	}
	
}