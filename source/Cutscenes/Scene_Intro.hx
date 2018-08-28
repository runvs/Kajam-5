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
		//trace("scene_intro.creat");
		
		target.setPosition(700, 700);
		
		var a : NPC_Annesa = new NPC_Annesa(_state);
		
		_state.level.allNSCs.add(a);
		a.setPosition(672, 830);
		
		
		var t1: FlxTimer = new FlxTimer();
		t1.start(0.5, function (t) 
		{ 
			a.velocity.set(-3, -40);
			a.animation.play("walk_north", true);
			a.overrideMessage = "";
			
		} );
		
		var t2 : FlxTimer = new FlxTimer();
		t2.start(5, function (t)
		{
			a.velocity.set();
			a.animation.play("idle",true);
			a.speak("As a token of your love, bring me the artifact!", 2.5);
		});
		var t3 : FlxTimer = new FlxTimer();
		t3.start(7.75, function (t)
		{
			a.setPosition( -500, -500);
			BackToPlayState();
		});
		
		
		//var t : FlxTimer = new FlxTimer();
		//t.start(5, function (t) { BackToPlayState(); } );
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		//trace("intro.update");
		
	}
	
	
}