package modules.materials.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import common.msg.event.materials.MEvent_Material_Connect;
	
	import modules.materials.treedata.NodeTreeInputItem;
	import modules.materials.treedata.NodeTreeItem;
	import modules.materials.treedata.NodeTreeOutoutItem;
	
	public class ItemMaterialUI extends UIComponent
	{
		private var _titleLabel:Label;
		private var _sp:CircleSprite;
		private var _type:String;
		public var hasConnet:Boolean;
		public var inOut:Boolean;//true为in false为out
		public var outLineList:Vector.<MaterialNodeLineUI> = new Vector.<MaterialNodeLineUI>;
		private var _inLine:MaterialNodeLineUI;
		
		public var nodeTreeItem:NodeTreeItem;
		public function ItemMaterialUI(name:String,$type:String,$inOut:Boolean=true)
		{
			super();
			inOut = $inOut;
			initLabel();
			initSp();
			_titleLabel.text = name;
			_titleLabel.mouseEnabled = false;
			_titleLabel.mouseChildren = false;
			
			this.mouseEnabled = false;
			_sp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if($inOut){
				nodeTreeItem = new NodeTreeInputItem;
			}else{
				nodeTreeItem = new NodeTreeOutoutItem;
			}
			type = $type;
			drawSp();
		}
		
		public function getStagePoint():Point{
			return this.localToGlobal(new Point(_sp.x + 6,_sp.y + 6));
		}
		
		public function removeOut($line:MaterialNodeLineUI):void{
			for(var i:int;i<outLineList.length;i++){
				if(outLineList[i] == $line){
					outLineList.splice(i,1);
					break;
				}
			}
			if(!inOut && outLineList.length == 0){
				hasConnet = false;
				this.dispatchEvent(new Event("DisConnect"));
			}
		}
		
		public function removeIn():void{
			_inLine = null;
			if(inOut){
				hasConnet = false;
				this.dispatchEvent(new Event("DisConnect"));
			}
		}
		
		public function setConnect():void{
			hasConnet = true;
			this.dispatchEvent(new Event("Connect"));
		}
		
		public function changeType($type:String):void{
			type = $type;
			drawSp();
		}
		
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(event.altKey){
				removeAllLine();
				return;
			}
			var evt:MEvent_Material_Connect = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_STARTDRAG);
			evt.itemNode = this;
			ModuleEventManager.dispatchEvent(evt);
		}
		
		public function removeAllLine():void{
			var evt:MEvent_Material_Connect;
			for(var i:int = outLineList.length-1 ;i>=0;i--){
				evt = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_REMOVELINE);
				evt.line = outLineList[i];
				ModuleEventManager.dispatchEvent(evt);
			}
			if(_inLine){
				evt = new MEvent_Material_Connect(MEvent_Material_Connect.MEVENT_MATERIAL_CONNECT_REMOVELINE);
				evt.line = _inLine;
				ModuleEventManager.dispatchEvent(evt);
			}
		}
		
		private function initLabel():void{
			_titleLabel = new Label;
			_titleLabel.setStyle("color",0xffffff);
			_titleLabel.height = 20;
			_titleLabel.width = 130;
			if(inOut){
				_titleLabel.x = 16;
				_titleLabel.setStyle("textAlign","left");
			}else{
				_titleLabel.x = 0;
				_titleLabel.setStyle("textAlign","right");
			}
			
			_titleLabel.y = 2;
			
			this.addChild(_titleLabel);
		}
		
		private function initSp():void{
			_sp = new CircleSprite;
			if(!inOut){
				_sp.x = 135;
			}
			this.addChild(_sp);
		}
		private function drawSp():void{
			_sp.graphics.clear();
			_sp.graphics.beginFill(0xffffff,1);
			_sp.graphics.drawCircle(6,6,6);
			if(_type == MaterialItemType.FLOAT){
				_sp.graphics.beginFill(0x00ff00,1);
			}else if(_type == MaterialItemType.VEC2){
				_sp.graphics.beginFill(0xffff00,1);
			}else if(_type == MaterialItemType.VEC3){
				_sp.graphics.beginFill(0x00ffff,1);
			}else if(_type == MaterialItemType.VEC4){
				_sp.graphics.beginFill(0xff00ff,1);
			}else if(_type == MaterialItemType.UNDEFINE){
				_sp.graphics.beginFill(0x999999,1);
			}
			_sp.graphics.drawCircle(6,6,5);
			if(!hasConnet){
				//_sp.graphics.beginFill(0xb1bbc4,1);
				//_sp.graphics.drawCircle(6,6,3);
			}
			_sp.graphics.endFill();
		}
		
		public function drawLine():void{
			for(var i:int;i<outLineList.length;i++){
				outLineList[i].draw();
			}
			if(_inLine){
				_inLine.draw();
			}
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			_titleLabel.width = this.width;
		}

		public function get inLine():MaterialNodeLineUI
		{
			return _inLine;
		}

		public function set inLine(value:MaterialNodeLineUI):void
		{
			
			_inLine = value;
			//NodeTreeInputItem(nodeTreeItem) = _inLine.fromNode.nodeTreeItem;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			nodeTreeItem.type = value;
		}
		
		
		
	}
}