package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var backgroundSprite : FlxSprite;
	public var overlay : FlxSprite;
	private var ending : Bool;
	var lastEntryID:Int;
	var lastTarget:String;
	
	
	public var player : Player;
	
	public var world : World;
	public var level : TiledLevel;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		backgroundSprite = new FlxSprite();
		backgroundSprite.makeGraphic(FlxG.width, FlxG.height);
		backgroundSprite.color = Palette.color1;
		add(backgroundSprite);
		
		FlxG.camera.pixelPerfectRender = true;
		FlxG.camera.zoom = 2;
		
		world = new World(this);
		
		level = world.getLevelByName("wimborne.tmx");
		//switchLevel("wimborne.tmx",1);
		//add(level.baseTiles);
		//add(level.midTiles);
		
		player = new Player(this);
		//add(player);
		FlxG.camera.follow(player, flixel.FlxCameraFollowStyle.TOPDOWN);
		
		//add(level.allNSCs);
		
		//add(level.topTiles);
		
		
		ending = false;
		overlay = new FlxSprite();
		overlay.makeGraphic(FlxG.width, FlxG.height);
		overlay.color = Palette.color1;
		overlay.alpha = 1;
		//add(overlay);
	
		FlxTween.tween (overlay, { alpha : 0 }, 0.25);
		
		
	}
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function draw() : Void
	{
		super.draw();
		
		level.baseTiles.draw();
		level.allTrigger.draw();
		//level.allTraps.draw();
		for (ti in level.allTraps)
		{
			var t : Trap = ti;
			if (t.activated) t.draw();
		}
		level.midTiles.draw();
		level.allShrines.draw();
		level.deadEnemies.draw();
		
		level.goreLayer.draw();
		
		player.draw();
	
		for (e in level.allEnemies)
		{
			e.drawUnderlay();
		}
		
		
		level.allNSCs.draw();
		level.allEnemies.draw();
		
		level.allEnemyShots.draw();
		level.allPlayerShots.draw();
		level.topTiles.draw();
		
		
		for (s in level.allShrines)
		{
			s.drawOverlay();
		}
		for (n in level.allNSCs)
		{
			n.drawOverlay();
		}
		
		overlay.draw();
		player.drawHud();
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
		
		if (!ending)
		{
			level.midTiles.update(elapsed);
			player.update(elapsed);
			level.allEnemies.update(elapsed);
			level.allNSCs.update(elapsed);
			level.allEnemyShots.update(elapsed);
			level.allPlayerShots.update(elapsed);
			level.allShrines.update(elapsed);
			
			FlxG.collide(player, level.collisionMap);
			
			for (n in level.allNSCs.getList())
			{
				FlxG.collide(player, n);
			}
			
			for (e  in level.allEnemies.getList())
			{
				FlxG.collide(e, level.collisionMap);
				FlxG.collide(e, level.allTraps);
			}
			for (s in level.allEnemyShots)
			{
				if (FlxG.overlap(s, level.collisionMap))
				{
					s.alive = false;
				}
			}
			for (s in level.allPlayerShots)
			{
				if (FlxG.overlap(s, level.collisionMap))
				{
					s.alive = false;
				}
				for (ei in level.allEnemies)
				{
					s.alive = false;
					var e : Enemy = ei;
					e.hit(s.damage, s.velocity.x, s.velocity.y);
				}
			}
			
			for (ti in level.allTrigger)
			{
				var t : Trigger = ti;
				if (FlxG.overlap(player, t))
				{
					t.perform();
					t.playerOn = true;
				}
				else
				{
					t.playerOn = false;
				}
			}
			
			CheckTraps();
			
			
			
			CheckForLevelChange();
		}
	}	
	
	function RestartLevel() 
	{
		switchLevel(lastTarget, lastEntryID);
		
	}
	
	function CheckForLevelChange() 
	{
		for (ei  in level.exits)
		{
			var exit : Exit = ei;
			
			var p : FlxPoint = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			//trace("checking overlap");
			//trace(p);
			//trace(exit.x + " " + exit.y);
			if (exit.overlapsPoint(p))
			{
				switchLevel(exit.target, exit.entryid);
			}
			
		}
	}
	public function switchLevel ( target : String, entryid : Int)
	{
		ending = true;
		
		
		//trace("switch level: " + target);
		
		for (s in level.allEnemyShots)
			s.alive = false;
		
		FlxTween.tween(overlay, { alpha: 1 }, 0.75, { onComplete : 
		function (t) : Void 
		{ 
			var newLevel : TiledLevel = world.getLevelByName(target);
			if (newLevel == null) 
			{
				trace ("warning: Level: " + target + " not found!!");
				return;
			}
			level =  newLevel;
			var entry : Entry = level.getEntry(entryid);
			if (entry != null)
				player.setPosition(entry.x, entry.y);
			else
			{
				player.setPosition(0, 0);
				trace("warning: no entry found!");
			}
		
			lastTarget = target;
			lastEntryID = entryid;
			ending = false; 
			overlay.alpha = 0; 
			
			FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
			FlxG.camera.setScrollBounds(0, level.fullWidth, 0, level.fullHeight);
		}
		} );
	}

	
	function EndGame() 
	{
		if (!ending)
		{
			ending = true;
			
			
			
			FlxTween.tween(overlay, {alpha : 1.0}, 0.9);
			
			var t: FlxTimer = new FlxTimer();
			t.start(1,function(t:FlxTimer): Void {MenuState.setNewScore(0); FlxG.switchState(new MenuState()); } );
		}
		
	}
	
	function CheckTraps():Void 
	{
		if (player.timeSinceDash <= 0.2)
			return;
		
		for (ti in level.allTraps)
		{
			var t : Trap = ti;
			if (t.activated == false) continue;
			
			if (FlxG.overlap(player, t))
			{
				RestartLevel();
			}	
		}
		
	}
	
}