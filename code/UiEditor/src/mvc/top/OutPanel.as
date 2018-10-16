package mvc.top
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.TextInput;
	
	import common.msg.event.projectSave.MEvent_ProjectData;
	import common.utils.frame.BasePanel;
	
	public class OutPanel extends BasePanel
	{

	
		private var _bg:UIComponent;
		private var _outText:TextInput;
	

		
		
		
		
		
		public function OutPanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			addBack();
			addInputTxt();
			addEvents();
			
		}


		private function addInputTxt():void
		{
			_outText = new TextInput;
			_outText.setStyle("contentBackgroundColor",0x404040);
			_outText.setStyle("borderVisible",true);
			_outText.setStyle("color",0x9f9f9f);
			_outText.setStyle("paddingTop",4);
			_outText.x=25
			_outText.y=25
			
			_outText.width=750
			_outText.height=550
			this.addChild(_outText);
			
		}
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
		}
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
	
			
		}
		

		
		protected function onWorkSpaceDoubleClik(event:MouseEvent):void
		{
			
			
			ModuleEventManager.dispatchEvent(new MEvent_ProjectData(MEvent_ProjectData.PROJECT_WORKSPACE_CHANGE));
			
		}
		
		
		protected function onStage(event:Event):void
		{
			drawback();

		}
		
		private function drawback():void{
			
			
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x282828,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			
			
			
		
			

			
	
			
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();
			
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		public function setText($str:String):void
		{
			_outText.text=$str
			
		}
		private var strItem:Array;
		public function addLine($str:String):void
		{
			if(!strItem){
				strItem=new Array
			}
			strItem.push($str)
				
			if(strItem.length>20){
			
				strItem.shift()
			}
			
			_outText.text=""
			for(var i:uint=0;i<strItem.length;i++)
			{
				_outText.text+=strItem[i]+"\n";
			}
				
		
	
		}
	}
}





