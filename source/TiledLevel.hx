package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import haxe.io.Path;

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	private var tileSet:TiledTileSet;
	
	
	public var levelPath : String = "";
	
	
	
	
	
	public var baseTiles:FlxGroup;
	public var midTiles:FlxGroup;
	public var topTiles:FlxGroup;
	
	public var allShrines : FlxTypedGroup<Shrine>;
	
	// Array of Int used for collision
	var collisionArray : Array<Int>;
	// final collisionMap with refined collisions
	public var collisionMap : FlxSpriteGroup;
	
	public var exits : FlxTypedGroup<Exit>;
	public var entries : FlxTypedGroup<Entry>;
	
	public var allEnemies : AdministratedList<Enemy>;
	public var deadEnemies : FlxSpriteGroup;
	public var allEnemyShots : AdministratedList<EnemyShot>;
	public var allPlayerShots : AdministratedList<PlayerShot>;
	
	public var allNSCs : AdministratedList<NPC>;
	
	public var allTraps : FlxTypedGroup<Trap>;
	public var allTrigger : FlxTypedGroup<Trigger>;
	public var goreLayer : FlxSprite;
	
	public var allGates : FlxSpriteGroup;
	public var allArenas : FlxTypedGroup<Arena>;
	
	private var _state : PlayState;
	
	
	
	public function new(tiledLevel:Dynamic, s : PlayState)
	{
		super(tiledLevel);
		_state = s;
		
		levelPath = tiledLevel ;

		
		
		baseTiles= new FlxGroup();
		midTiles = new FlxGroup();
		topTiles = new FlxGroup();
		
		collisionMap = new FlxSpriteGroup();
		
		exits = new FlxTypedGroup<Exit>();
		entries = new FlxTypedGroup<Entry>();
		
		allEnemies = new AdministratedList<Enemy>();
		allEnemies.DestroyCallBack.push( function (e : Enemy ) : Void  { addDeadEnemy(e); } );
		
		allNSCs = new AdministratedList<NPC>();
		
		allEnemyShots = new  AdministratedList<EnemyShot>();
		allPlayerShots = new  AdministratedList<PlayerShot>();
		
		tileSet = tilesets["tileset.png"];
		
		
		allTraps = new FlxTypedGroup<Trap>();
		allTrigger = new FlxTypedGroup<Trigger>();
		
		goreLayer  = new FlxSprite(0, 0 );
		deadEnemies = new FlxSpriteGroup();
	
		collisionArray = new Array<Int>();
		
		allShrines = new FlxTypedGroup<Shrine>();
			
		allArenas = new FlxTypedGroup<Arena>();
		allGates = new FlxSpriteGroup();
		
		//trace(this.width);
		
		var wit : Int = this.width; 
		var hit : Int = this.height; 
		
		
		
		
		
		// Load Tile Maps
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;
			
			for (j in 0...hit)
			{
				for (i in 0...wit)
				{
				
					var idx = i + j * wit;
					if (tileLayer.name == "top")
					{
						var tileType : Int = tileLayer.tileArray[idx];// tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						topTiles.add(s);
					}
					else if (tileLayer.name == "mid")
					{
						var tileType : Int = tileLayer.tileArray[idx];// tilemap.getTile(i, j);
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						midTiles.add(s);
					}
					else
					{
						var tileType : Int = tileLayer.tileArray[idx];
						var s : FlxSprite = new FlxSprite(i * 16, j * 16);
						s.immovable = true;
						s.loadGraphic(AssetPaths.tileset__png, true, 16, 16);
						s.animation.add("idle", [tileType-1]);
						s.animation.play("idle");
						baseTiles.add(s);
						
						CheckForRandomOverlays(i,j,tileType);
						
						CreateCollisionTile(i, j, tileType);
					}
				}
			}
		}
		
		refineCollisions(wit, hit);
		
		loadObjects();
		
		goreLayer.makeGraphic(this.fullWidth, fullHeight, FlxColor.TRANSPARENT, true);
	}
	
	function CheckForRandomOverlays(i: Int, j : Int , tileType:Int) 
	{
		if (tileType == 2)
		{
			//trace("spawn grass");
			if (FlxG.random.bool(50))
			{
				
				var ot : Int = FlxG.random.int(0, 7);
				var s : FlxSprite = new FlxSprite();
				s.loadGraphic(AssetPaths.grass_overlay__png, true, 16, 16, false);
				s.animation.add("idle", [ot,ot,ot,ot,ot,ot,ot,ot,ot,ot,ot,ot, ot+8], 3, true);
				s.animation.play("idle",false, false, -1);
				s.setPosition(i * GameProperties.TileSize, j * GameProperties.TileSize);
				midTiles.add(s);
			}
		}
	}
	
	
	
	function CreateCollisionTile(x : Int, y : Int, type : Int) 
	{
		var cols : Int = tileSet.numCols;
		var rows : Int = tileSet.numRows;
		
		var rowIndex :Int = Std.int((type-1) / rows);
		//trace(Std.string(cols) + " " + Std.string(rows));
		
		if (rowIndex == 0)
		{	
			collisionArray.push(0);
			return;
		}
		else /*if (rowIndex == 1 ||rowIndex == 2)*/
		{
			collisionArray.push(1);
		}
	}
	
	private function loadSpecialTile(x:Int, y:Int, type : Int)
	{
		if (type == 0) return;
		
		//if (type == 5 || type == 16 || type == 17|| type ==26)
		//{
			//var bt :BreakableTile = new BreakableTile(x * 32, y * 32, type);
			
		//}
		//else if (type == 6 || type == 7)
		//{
			//var ds : FlxSprite = new FlxSprite(x * 32, y * 32);
			//ds.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//ds.animation.add("idle", (type == 6? [5] : [6]));
			//ds.animation.play("idle");
			
		//}
		//else if ( type == 9|| type == 19 || type == 29)  // onOff Switch 1
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type +1;
			
			//CreateCollisionTile(x, y, 2);
		//}
		//else if ( type == 10 ||type == 20 ||type == 30) // onOff Block
		//{
			//var s : FlxSprite = new FlxSprite(x * 32, y * 32);
			//s.loadGraphic(AssetPaths.tilesheet__png, true, 32, 32);
			//s.origin.set(16, 32);
			//s.animation.add("idle", [(type-1)]);
			//s.animation.play("idle");
			//s.immovable = true;
			//s.ID = type;
			
		//}
		//
	}
	
	
	public function loadObjects()
	{
		var layer:TiledObjectLayer;
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			
			//objects layer
			if (layer.name == "objects" )
			{
				trace("load object layer");
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					trace("load object: " + o.name);
					if (o.type.toLowerCase() == "npc")
					{
						loadNSC( o, objectLayer);
					}
					else if (o.type.toLowerCase() == "entry")
					{
						loadEntry(o, objectLayer);
					}
					else if (o.type.toLowerCase() == "exit")
					{
						loadExit(o, objectLayer);
					}
					else if (o.type.toLowerCase() == "shrine")
					{
						loadShrine(o, objectLayer);
					}
					else if (o.type.toLowerCase() == "trigger")
					{
						loadTrigger(o, objectLayer);
					}
					else
					{
						trace("Warning: unknown object: " + o.type + " with name: " + o.name);
					}
				}
			}
			else if (layer.name == "traps")
			{
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					loadTrap(o,objectLayer);
				}
			}
			else if (layer.name == "enemies")
			{
				trace("load enemy layer");
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					loadEnemy(o, objectLayer);
				}
			}
			else if (layer.name.toLowerCase() == "arena")
			{
				for (oi in objectLayer.objects)
				{
					var o : TiledObject = oi;
					loadArena(o, objectLayer);
				}
			}
		}
	}
	
	function loadArena(o:TiledObject, g:TiledObjectLayer) 
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		var w = o.width;
		var h = o.height;
		
		var a : Arena = new Arena(x, y, w, h, _state);
		allArenas.add(a);
		{
			var gateString : String = o.properties.get("gate");
			if (gateString != null)
			{
				var gateArray : Array<String> = gateString.split(";");
				for (gp in gateArray)
				{
					var spl : Array<String> = gp.split(",");
					if (spl.length != 2) continue;
					var x : Int = Std.parseInt(gp.split(",")[0]);
					var y : Int = Std.parseInt(gp.split(",")[1]);
					a.addGate(x, y);
				}
			}
		}
		{
			for (i in 1 ... GameProperties.WorldMaxWaveNumber)
			{
				var name :String = "wave" + Std.string(i);
				var prop : String = o.properties.get(name);
				if (prop == null) continue;
				
				a.addWave(i, prop);
			}
		}
	}
	
	function loadTrigger(o:TiledObject, objectLayer:TiledObjectLayer) 
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		var w = o.width;
		var h = o.height;
		
		var s : Trigger = new Trigger(x, y,w,h, _state);
		s.name = o.name;
		
		s.action = o.properties.get("action");
		s.type = o.properties.get("type");
		var t : String = o.properties.get("target");
		s.target = t.split(",");
		
		allTrigger.add(s);
	}
	
	
	function loadTrap(o:TiledObject, objectLayer:TiledObjectLayer) 
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		var w = o.width;
		var h = o.height;
	
		
		var s : Trap = new Trap(x, y);
		s.name = o.name;
		s.makeGraphic(w, h, FlxColor.BLACK);
		
		var act : String = o.properties.get("activated");
		if (act != null && act == "false")
		{
			s.activated = false;
		}
		
		allTraps.add(s);
	}
	
	function loadShrine(o:TiledObject, g:TiledObjectLayer) 
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		
		var shrineID = o.properties.get("id");
		if (shrineID != null)
		{
			var id : Int = Std.parseInt(shrineID);		
			var s :Shrine= new Shrine(x, y, id);
			allShrines.add(s);
			collisionMap.add(s);
		}
	}
	
	
	public function spawnEnemy(t : String, x, y)
	{
		if (t == "smashground")
		{
			//trace();
			var e : Enemy_SmashGround = new Enemy_SmashGround(_state);
			e.setPosition(x, y);
			allEnemies.add(e);
		}
		else if (t == "runner")
		{
			//trace();
			var e : Enemy_Runner = new Enemy_Runner(_state);
			e.setPosition(x, y);
			allEnemies.add(e);
		}
		else if (t == "shooter")
		{
			//trace();
			var e : Enemy_Shooter = new Enemy_Shooter(_state);
			e.setPosition(x, y);
			allEnemies.add(e);
		}
		else
		{
			trace("ERROR: unknown enemy Type: " + t);
		}
	}
	
	private function loadEnemy(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		var type : String = o.type.toLowerCase();
		
		spawnEnemy(type, x, y);
		
	}
	
	private function loadEntry(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y;
		
		var entryid = o.properties.get("entryid");
		if (entryid != null)
		{
			var id : Int = Std.parseInt(entryid);		
			var e :Entry = new Entry(x, y, id);
			entries.add(e);
		}
	}
	
	private function loadExit(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y -1;
		
		
		var entryid = o.properties.get("entryid");
		var target = o.properties.get("target");
		if (entryid != null && target != null)
		{
			var id : Int = Std.parseInt(entryid);		
			var e : Exit = new Exit(x, y, o.width, o.height,target, id);
			exits.add(e);
		}
	}
	
	private function loadNSC(o:TiledObject, g:TiledObjectLayer)
	{
		//trace("load object of type " + o.type);
		var x:Int = o.x;
		var y:Int = o.y -1;
		
		
		var nsctype = o.properties.get("npctype");
		if (nsctype != null)
		{
			var n : NPC;
			if (nsctype.toLowerCase() == "guard")
			{
				//trace(x);
				n = new NPC_Guard(_state);
				n.setPosition(x , y );
				n.objectName = o.name;
				allNSCs.add(n);
				trace("add nsc guard '" +  n.objectName + "'");
			}
			else //if (nsctype.toLowerCase() == "smith")
			{
				n = new NPC_Smith(_state);
				n.setPosition(x, y);
				n.objectName = o.name;
				allNSCs.add(n);
			}
			var msg : String = o.properties.get("message");
			if (msg != null) n.overrideMessage = msg;
		}
		
	}
	
	function refineCollisions(wit: Int, hit: Int):Void 
	{
		var blubb : Array<Array<Int> > = new Array<Array<Int> >();
		blubb = CollisionMerger.Merge(collisionArray, wit, hit);
		
		trace(collisionArray.length + " " + wit * hit + " " + blubb.length);
		
		for (i in 0 ... blubb.length)
		{
			if (blubb[i][0] != 0)
			{
				var t : FlxSprite = new FlxSprite(0, 0);
				t.makeGraphic(Std.int( GameProperties.TileSize * blubb[i][1]), Std.int(GameProperties.TileSize  * blubb[i][0]));
				
				t.setPosition((i % wit ) * GameProperties.TileSize, Std.int(i / wit) * GameProperties.TileSize);
				t.update(0.1);
				t.color = Palette.color2;
				t.immovable = true;
				collisionMap.add(t);
			}
		}
	}
		
	public function spladder (x: Float, y : Float)
	{
		var s : FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.random.int(1, 3), FlxG.random.int(1, 3), FlxColor.fromRGB(175,0,0));
		
		var N : Int = 5;
		
		for (i in 0 ... N)
		{
			var px : Int = Std.int(FlxG.random.floatNormal(x, GameProperties.TileSize / 2.5));
			var py : Int = Std.int(FlxG.random.floatNormal(y, GameProperties.TileSize / 2.5));
			goreLayer.stamp(s, px, py);
		}
	}
	
	public function addDeadEnemy(e:Enemy)
	{
		e.color = FlxColor.fromRGB(100, 100, 100);
		e.scale.set(0.9,1);
		e.angle = 90;
		deadEnemies.add(e);
	}
	
	public function getEntry (entryid : Int ) :Entry
	{
		for (ei in entries)
		{
			var e : Entry = ei;
			if (e.entryID == entryid)
				return e;
		}
		return null;
	}
	
	public function activateArena (a : Arena)
	{
		if (a.state != 0) return;
		
		a.state = 1;
		for (gi in a.gates)
		{
			var g : FlxPoint = gi;
			var spr : FlxSprite = new FlxSprite(g.x * GameProperties.TileSize, g.y * GameProperties.TileSize);
			spr.makeGraphic(GameProperties.TileSize, GameProperties.TileSize, FlxColor.PURPLE, true);
			spr.immovable = true;
			allGates.add(spr);
		}
	}
	
	public function deactivateArena ( a : Arena)
	{
		if (a.state != 1) return;
		a.state = 2;
		a.active = false;
		allGates = new FlxSpriteGroup();
	}
}