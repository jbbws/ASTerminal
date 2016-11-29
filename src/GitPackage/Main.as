package GitPackage
{
	import flash.display.Sprite;
	import flash.events.Event;
	import GitPackage.Terminal;
	import GitPackage.GitParser;
	/**
	 * ...
	 * @author Matskan
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace(stage.stageHeight);
			trace(stage.stageWidth);
			var Term:Terminal = new Terminal(stage.x, stage.y, stage.stageWidth, stage.stageHeight);
			addChild(Term.Screen);
			addChild(Term.Console);
			trace("DEBUG");
			// entry point
		}
		
	}	
}