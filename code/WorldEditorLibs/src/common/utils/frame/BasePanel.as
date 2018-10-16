package common.utils.frame
{
	import com.zcp.frame.Processor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.events.ResizeEvent;
	
	public class BasePanel extends Canvas
	{
		private var _processor:Processor;
		public var defaultType:int;
		public function BasePanel()
		{
			super();
			
			this.setStyle("left",0);
			this.setStyle("right",0);
			this.setStyle("top",30);
			this.setStyle("bottom",0);
			
			this.horizontalScrollPolicy = "off";
			
			this.addEventListener(Event.ADDED_TO_STAGE,onSize);
			this.addEventListener(ResizeEvent.RESIZE,onSize);
		}
		
		public function onSize(event:Event= null):void
		{
			
		}
		
		public function init($processor:Processor,$name:String,$type:int):void{
			_processor = $processor;
			this.name = $name;
			this.defaultType = $type;
		}

		public function get processor():Processor
		{
			return _processor;
		}
		
		public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		public function hide():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
			this.dispatchEvent(new Event("hide"));
		}
		
		public function changeSize():void{
			
		}
		
		public function getAtt():Array{
			
			return null;
		}
		
		
	}
}