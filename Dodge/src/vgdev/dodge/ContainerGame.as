﻿package vgdev.dodge
{
	import flash.events.Event;
	import vgdev.dodge.mechanics.ObstacleManager;
	import vgdev.dodge.mechanics.ObstacleTimeline;
	import vgdev.dodge.props.ABST_Obstacle;
	import vgdev.dodge.props.Player;
	import vgdev.dodge.mechanics.TimeScale;
	
	/**
	 * Primary game container and controller.
	 * 
	 * @author Alexander Huynh
	 */
	public class ContainerGame extends ABST_Container
	{		
		public var engine:Engine;		// the game's Engine
		public var game:SWC_Game;		// the Game SWC, containing all the base assets
		
		public var player:Player;
		
		private var obstacleTimeline:ObstacleTimeline;
		private var obstacleManager:ObstacleManager;

		/**
		 * A MovieClip containing all of a Dodge level.
		 * @param	eng			A reference to the Engine.
		 */
		public function ContainerGame(eng:Engine)
		{
			super();
			engine = eng;
			game = new SWC_Game();
			addChild(game);
			for (var i:int = 0; i < 100; i++)
				game.mc_bg.addChild(new StarTemp());
				
			player = new Player(this);
			game.addChild(player.mc_object);
			
			var ONE:int = 60;
			var TWO:int = 180;
			var THREE:int = 270;
			
			// TODO make better later
			obstacleTimeline = new ObstacleTimeline();
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":100, "y":100}), ONE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-100, "y":100}), ONE + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, { "x":100, "y": -100} ), ONE + 60);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":2}), TWO);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":4}), TWO + 30);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":100, "scale":2}), TWO + 60);
			
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":0, "y":0, "scale":6, "circle":true, "spawn":60}), THREE);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":6, "circle":true, "spawn":60}), THREE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":6, "circle":true, "spawn":60}), THREE + 60);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":6, "circle":true, "spawn":60}), THREE + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":200, "scale":6, "circle":true, "spawn":60}), THREE + 120);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":-200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":200, "y":-200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			obstacleTimeline.addObstacle(new ABST_Obstacle(this, {"x":-200, "y":200, "scale":5, "circle":true, "spawn":60}), THREE + 180);
			
			obstacleManager = new ObstacleManager(this, obstacleTimeline);
		}

		/**
		 * called by Engine every frame
		 * @return		completed, true if this container is done
		 */
		override public function step():Boolean
		{			
			player.step();
			obstacleManager.step();
			
			game.scaleX = game.scaleY = .95 + TimeScale.s_scale * .05;
			
			return completed;			// return the state of the container (if true, it is done)
		}

		/**
		 * Clean-up code
		 * 
		 * @param	e	the captured Event, unused
		 */
		protected function destroy(e:Event):void
		{
			//removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			if (game && contains(game))
				removeChild(game);
			game = null;

			engine = null;
		}
	}
}
