package;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class Scene_Intro extends CutSceneState
{

	var a : NPC_Annesa;
	
	var townsfolk : FlxTypedGroup<NPC_townpeople>;
	
	public function new(s:PlayState) 
	{
		super(s);
	}
	
	override public function create() 
	{
		
		super.create();
		//trace("scene_intro.creat");
		
		target.setPosition(200, 600);
		
		target.velocity.set(45, 0);
		
		townsfolk = new FlxTypedGroup<NPC_townpeople>();
		_state.player.setPosition(39 * GameProperties.TileSize, 43*GameProperties.TileSize);
		
		{
			var t : NPC_townpeople = new NPC_townpeople(_state);
			t.setPosition(15 * GameProperties.TileSize, 39 * GameProperties.TileSize);
			townsfolk.add(t);
			_state.level.allNSCs.add(t);
		}
		
		{
			var t : NPC_townpeople = new NPC_townpeople(_state);
			t.setPosition(26 * GameProperties.TileSize, 40 * GameProperties.TileSize);
			townsfolk.add(t);
			_state.level.allNSCs.add(t);
		}
		
		{
			var t : NPC_townpeople = new NPC_townpeople(_state);
			t.setPosition(35 * GameProperties.TileSize, 37* GameProperties.TileSize);
			townsfolk.add(t);
			_state.level.allNSCs.add(t);
		}
		{
			var t : NPC_townpeople = new NPC_townpeople(_state);
			t.setPosition(40 * GameProperties.TileSize, 39* GameProperties.TileSize);
			townsfolk.add(t);
			_state.level.allNSCs.add(t);
		}
		
		
		townsfolk.members[0].speak("Look, a clairvoyant is visiting!", 5.5);
		
		var ts1 : FlxTimer = new FlxTimer();
		ts1.start(3.5, function(t)
		{
			townsfolk.members[1].speak("She might bring news about our future!", 3.5);
		});
		var ts2 : FlxTimer = new FlxTimer();
		ts2.start(6.5, function(t)
		{
			townsfolk.members[2].speak("I hope she will tell some stories!", 3.5);
		});
		var ts3 : FlxTimer = new FlxTimer();
		ts3.start(9.5, function(t)
		{
			target.velocity.set(0, 20);
			townsfolk.members[3].speak("There she comes! Ohhh, she is beautiful!", 3.5);
		});
		
		a = new NPC_Annesa(_state);
		_state.level.allNSCs.add(a);
		a.setPosition(650, 830);
		
		
		var t1: FlxTimer = new FlxTimer();
		t1.start(10.5, function (t) 
		{ 
			a.velocity.set(-3, -40);
			a.animation.play("walk_north", true);
			a.overrideMessage = "";
			
		} );
		
		var ta1 : FlxTimer = new FlxTimer();
		ta1.start(15, function (t)
		{
			a.velocity.set();
			a.animation.play("idle",true);
			a.speak("I have a story to tell ...", 2.5);
		});
		
		var ta2 : FlxTimer = new FlxTimer();
		ta2.start(18, function (t)
		{
			a.speak("of a young hero ...", 2.5);
		});
		
		var ta3 : FlxTimer = new FlxTimer();
		ta3.start(21, function (t)
		{
			a.speak("who will explore the  FOCA ruins ...", 2.5);
		});
		
		var ta4 : FlxTimer = new FlxTimer();
		ta4.start(24, function (t)
		{
			a.speak("and retrieve the ancient artifact ...", 2.5);
		});
		var ta5 : FlxTimer = new FlxTimer();
		ta5.start(27, function (t)
		{
			a.speak("which has been lost for centuries!", 2.5);
		});
		
		
		
		var t3 : FlxTimer = new FlxTimer();
		t3.start(30.0, function (t)
		{
			BackToPlayState();
		});
		
		
	}
	
	
	override public function draw():Void 
	{
		super.draw();
		//target.draw();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		target.update(elapsed);
		//trace("intro.update");
		
	}
	
	override function LeaveCallback() 
	{
		super.LeaveCallback();
		a.alive = false;
		for (t in townsfolk)
		{
			//t.alive = false;
		}
	}
	
}