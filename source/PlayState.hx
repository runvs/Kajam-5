package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.debug.watch.Tracker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends BasicState
{
	// for reviving player
	var lastEntryID:Int;
	var lastTarget:String;	
	
	public var player : Player;
	public static var world : World = null;
	
	private var activeArena : Arena = null;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		trace("playstate create begin");
		
		if(world == null)
			world = new World(this);
		
		level = world.getLevelByName("wimborne.tmx");
		
		FlxG.worldBounds.set(0, 0, level.fullWidth, level.fullHeight);
		FlxG.camera.setScrollBounds(0, level.fullWidth, 0, level.fullHeight);
		
		player = new Player(this);
		
		FlxG.camera.follow(player, flixel.FlxCameraFollowStyle.TOPDOWN);
		trace("playstate create end");
	}
	
	
	public function switchToCutScene(c : CutSceneState)
	{
		//FlxG.switchState(c);
		this.openSubState(c);
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function drawObjects():Void 
	{
		super.drawObjects();
		
		level.baseTiles.draw();
		
		
		
		level.midTiles.draw();
		
		level.allTrigger.draw();
		for (ti in level.allTraps)
		{
			var t : Trap = ti;
			if (t.name != "" && ! t.activated) t.draw();
		}
		
		level.allShrines.draw();
		level.deadEnemies.draw();
		
		//trace(level.allGates.length);
		level.allGates.draw();
		
		level.allTP.draw();
		
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
	}
	
	override public function drawOverlay():Void 
	{
		for (s in level.allShrines)
		{
			s.drawOverlay();
		}
		for (n in level.allNSCs)
		{
			n.drawOverlay();
		}
		
		super.drawOverlay();
		player.drawHud();
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
		
		//trace(camera.target);
		
		if (!ending)
		{
			level.midTiles.update(elapsed);
			player.update(elapsed);
			level.allEnemies.update(elapsed);
			level.allNSCs.update(elapsed);
			level.allEnemyShots.update(elapsed);
			level.allPlayerShots.update(elapsed);
			level.allShrines.update(elapsed);
			
			
			
			level.allGates.update(elapsed);
			
			FlxG.collide(player, level.collisionMap);
			FlxG.collide(player, level.allGates);
			
			for (n in level.allNSCs.getList())
			{
				FlxG.collide(player, n);
			}
			
			for (ti in level.allTP)
			{
				var t : TownPortal = ti;
				t.update(elapsed);
				if (t.wasOverlapping) continue;
				
				if (FlxG.overlap(player, t))
				{
					if (t.thisPortalLevel == "wimborne.tmx")
					{
						if (TownPortal.lastTPLevel == "") continue;
						switchLevel(TownPortal.lastTPLevel, TownPortal.lastTPEntryID, true);
					}
					else
					{
						TownPortal.lastTPLevel = t.thisPortalLevel;
						TownPortal.lastTPEntryID = t.thisPortalEntryID;
						
						switchLevel("wimborne.tmx", 2, true);
					}
					
					
				}
				
			}
			
			for (e  in level.allEnemies.getList())
			{
				FlxG.collide(e, level.collisionMap);
				FlxG.collide(e, level.allTraps);
				FlxG.collide(e, level.allGates);
				if (!FlxG.worldBounds.containsPoint(new FlxPoint(e.x, e.y)))
				{
					e.alive = false;
				}
				if (e.isHurtingPlayer())
				{
					if (FlxG.overlap(player, e))
					{
						player.takeDamage(1);
					}
				}	
			}
			for (s in level.allEnemyShots)
			{
				if (FlxG.overlap(s, level.collisionMap))
				{
					s.alive = false;
				}
				if (FlxG.overlap(s, player))
				{
					player.takeDamage(0.5);
					s.alive = false;
				}
			}
			for (s in level.allPlayerShots)
			{
				if (s.alive == false) continue;
				if (FlxG.overlap(s, level.collisionMap))
				{
					s.alive = false;
				}
				for (ei in level.allEnemies)
				{
					var e : Enemy = ei;
					if (FlxG.overlap(s, e))
					{
						s.alive = false;	
						e.hit(s.damage, s.velocity.x, s.velocity.y);
						level.spladder(e.x + GameProperties.TileSize/2, e.y + GameProperties.TileSize/2, e.enemySpladderColor);
					}
				}
				for (ti in level.allTrigger)
				{
					var t : Trigger = ti;
					if (FlxG.overlap(s, ti))
					{
						s.alive = false;
						t.perform();
					}
				}
			}
			
			for (ti in level.allTrigger)
			{
				var t : Trigger = ti;
				if (FlxG.overlap(player, t))
				{
					//t.perform();
					t.playerOn = true;
				}
				else
				{
					t.playerOn = false;
				}
				FlxG.collide(player, t);
			}
			
			CheckTraps();
			CheckArenas();
			CheckPlayerDead();
			
			
			CheckForLevelChange();
		}
		
		if (FlxG.keys.justPressed.F5)
		{
			var c : Scene_Intro = new Scene_Intro(this);
			switchToCutScene(c);
		}
	}	
	
	function CheckPlayerDead() 
	{
		if (player.alive  == false)
		{
			player.heal(player.healthMax);
			player.alive = true;
			if (activeArena == null)
			{
				RestartLevel();
			}
			else
			{
				activeArena.resetArena();
				
				level.allGates = new FlxSpriteGroup();
				activeArena = null;
				RestartLevel();
			}
		}
	}
	
	function RestartLevel() 
	{
		switchLevel(lastTarget, lastEntryID);
		
	}
	
	function CheckArenas()
	{
		if (activeArena == null)
		{
			for (ai in level.allArenas)
			{
				var a : Arena = ai;
				if (a.state == 0)
				{
					if (FlxG.overlap(player, a))
					{
						//trace(level.allGates.length);
						//trace("activate!");
						level.activateArena(a);
						//trace(level.allGates.length);
						activeArena = a;
						break;
					}
				}
			}
		}
		else
		{
			if (level.allEnemies.length() == 0)
			{
				if (activeArena.currentwave >= GameProperties.WorldMaxWaveNumber)
				{
					level.deactivateArena(activeArena);
					activeArena = null;
					
				}
				else
				{
					activeArena.nextWave();	
				}
			}
		}
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
				switchLevel(exit.target, exit.entryid, true);
			}
			
		}
	}
	public function switchLevel ( target : String, entryid : Int, restartMusic : Bool = false)
	{
		ending = true;
		
		
		//trace("switch level: " + target);
		
		for (s in level.allEnemyShots)
			s.alive = false;
		
		
		FlxTween.tween(FlxG.sound.music, { volume: 0 }, 0.7);	
		FlxTween.tween(overlay, { alpha: 1 }, 0.85, { onComplete : 
		function (t) : Void 
		{ 
			var newLevel : TiledLevel = world.getLevelByName(target);
			if (newLevel == null) 
			{
				trace ("warning: Level: " + target + " not found!!");
				return;
			}
		
			//trace("restart 1");
			if (restartMusic)
			{
				//trace("restart 1");
				if (level._music != newLevel._music)
				{
					//trace("restart 2");
					if (newLevel._music != "")
					{
						//trace("restart 3");
						var t:FlxTimer = new FlxTimer();
						t.start(0.25, function(t) { StartMusic(newLevel._music); } );
					}
				}
			}
			
			level =  newLevel;
			var entry : Entry = level.getEntry(entryid);
			if (entry != null)
				player.setPosition(entry.x, entry.y);
			else
			{
				player.setPosition(0, 0);
				trace("WARNING: no entry found!");
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
	
	function StartMusic(track : String) 
	{
		//trace("restart 4");
		if (track == "exploration")
		{
			FlxG.sound.playMusic(AssetPaths.exploration_theme__ogg, 0.6);
		}
		else if (track == "city")
		{
			FlxG.sound.playMusic(AssetPaths.town_music__ogg, 0.6);
		}
		else if (track == "puzzle" ||track == "puzzel")
		{
			FlxG.sound.playMusic(AssetPaths.puzzle_music__ogg, 0.6);
		}
		else
		{
			trace ("ERROR: music not found: " + track);
		}
	}

	
	
	
	function CheckTraps():Void 
	{
		if (player.timeSinceDash <= 0.2)
			return;
		
		var overlapping : Bool = false;
		for (ti in level.allTraps)
		{
			var t : Trap = ti;
			if (t.activated == false) continue;
			
			if (FlxG.overlap(player, t))
			{
				overlapping = true;
				player.timeInTrap += FlxG.elapsed;
				if (player.timeInTrap > 0.15)
					RestartLevel();
			}	
		}
		if (!overlapping)
			player.timeInTrap = 0;
		
	}

}