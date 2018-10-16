package modules.materials.view
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	import spark.components.TextInput;
	
	import common.msg.event.materials.MEvent_Material;
	import common.utils.ui.file.FileItemRender;
	
	import modules.materials.treedata.NodeTree;
	
	public class BaseMaterialNodeUI extends UIComponent
	{
		private var _color:uint = 0x5f89a8;
		protected var _titleLabel:Label;
		protected var _container:UIComponent;
		protected var _bgContainer:UIComponent;
		protected var inPutItemVec:Vector.<ItemMaterialUI>;
		protected var outPutItemVec:Vector.<ItemMaterialUI>;
		protected var gap:int = 30;
		
		[Embed(source="assets/materialui/phys_marterial.png")]
		public var phys_marterialCls:Class;
		[Embed(source="assets/materialui/phys_materail_01.png")]
		public var phys_marterialCls1:Class;
		[Embed(source="assets/materialui/phys_materail_02.png")]
		public var phys_marterialCls2:Class;
		[Embed(source="assets/materialui/phys_materail_03.png")]
		public var phys_marterialCls3:Class;
		
		public var titleBitmap:Bitmap;
		
		public var nodeTree:NodeTree;
		
		private var _select:Boolean;
		
		private var _eageUI:Shape;
		
		public function BaseMaterialNodeUI()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onChange);
			this.addEventListener(ResizeEvent.RESIZE,onChange);
			this.addEventListener(MouseEvent.CLICK,onClick);
			
			
			_bgContainer = new UIComponent;
			this.addChild(_bgContainer);
			
			_eageUI = new Shape;
			_bgContainer.addChild(_eageUI);
			_eageUI.visible = false;
			
			initLabel();
			
			_titleLabel.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			inPutItemVec = new Vector.<ItemMaterialUI>;
			outPutItemVec = new Vector.<ItemMaterialUI>;
			
			_container = new UIComponent;
			_container.y = 35;
			_container.x = 5
			this.addChild(_container);
			
			this.filters = [getBitmapFilter()];
			
		}
		
		
		public function get textInputTxt():TextInput
		{
			return _textInputTxt;
		}

		public function addItems($nodeUI:ItemMaterialUI):void{
			if($nodeUI.inOut){
				if(inPutItemVec.indexOf($nodeUI) == -1){
					inPutItemVec.push($nodeUI);
					nodeTree.addInput($nodeUI.nodeTreeItem);
				}
			}else{
				if(outPutItemVec.indexOf($nodeUI) == -1){
					outPutItemVec.push($nodeUI);
					nodeTree.addOutput($nodeUI.nodeTreeItem);
				}
			}
			_container.addChild($nodeUI);
			refreshNodePos();
		}
		
		public function removeItem($nodeUI:ItemMaterialUI):void{
			for(var i:int;i<inPutItemVec.length;i++){
				if(inPutItemVec[i] == $nodeUI){
					inPutItemVec.splice(i,1);
				}
			}
			
			nodeTree.removeInput($nodeUI.nodeTreeItem);
			
			for(i = 0;i<outPutItemVec.length;i++){
				if(outPutItemVec[i] == $nodeUI){
					outPutItemVec.splice(i,1);
				}
			}
			
			nodeTree.removeOutput($nodeUI.nodeTreeItem);
			
			if($nodeUI.parent){
				$nodeUI.parent.removeChild($nodeUI);
			}
			
			refreshNodePos();
		}
		
		public function removeAllNodeLine():void{
			for(var i:int;i<inPutItemVec.length;i++){
				inPutItemVec[i].removeAllLine();
			}
			for(i = 0;i<outPutItemVec.length;i++){
				outPutItemVec[i].removeAllLine();
			}
		}
		
		
		public function refreshNodePos():void{
			for(var i:int;i<inPutItemVec.length;i++){
				inPutItemVec[i].y = gap * i;
			}
			
			for(i = 0;i<outPutItemVec.length;i++){
				outPutItemVec[i].y = gap * i;
			}
		}
		
		
		private function initLabel():void{
			_titleLabel = new Label;
			_titleLabel.setStyle("color",0xffffff);
			_titleLabel.setStyle("fontSize",12);
			_titleLabel.setStyle("fontWeight","bold");
			_titleLabel.x = 10;
			_titleLabel.y = 8;
			_titleLabel.height = 30;
			_titleLabel.width = 100;
			_titleLabel.text = "材质"
			this.addChild(_titleLabel);
			
			
			_textInputTxt=new TextInput
			_textInputTxt.visible=false
			this.addChild(_textInputTxt)
		}
		
		
		
		protected function onMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			this.doubleClickEnabled=true
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDubleClik);
			_eX = this.stage.mouseX;
			_eY = this.stage.mouseY;
			//this.dispatchEvent(new Event(Event.SELECT));
		}
		private var _textInputTxt:TextInput;	
		protected function onDubleClik(event:MouseEvent):void
		{
			
			if(this.nodeTree.canDynamic&&this.nodeTree.isDynamic){

				//this.showDynamic();
				_titleLabel.text=""
				_textInputTxt.x = 10;
				_textInputTxt.y = 3;
				_textInputTxt.height = 20;
				_textInputTxt.width = 100;
				_textInputTxt.text=this.nodeTree.paramName
				_textInputTxt.visible=true
				_textInputTxt.addEventListener(FlexEvent.ENTER,onSureTxt);

				_textInputTxt.setFocus()
			}

		}
		
		protected function onSureTxt(event:FlexEvent):void
		{
			_textInputTxt.removeEventListener(FlexEvent.ENTER,onSureTxt);
			_textInputTxt.visible=false
			this.nodeTree.paramName=_textInputTxt.text
			this.showDynamic()
		}
		
		protected function onClick(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.SELECT));
		}
		
		
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
				stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,onMouseUp);
			}
			
			this.x = Math.round(this.x/16) * 16;
			this.y = Math.round(this.y/16) * 16;
			drawLine();
		}
		private var _eX:int;
		private var _eY:int;
		protected function onMove(event:MouseEvent):void
		{
			this.x -= _eX - this.stage.mouseX;
			this.y -= _eY - this.stage.mouseY;
			
			_eX = this.stage.mouseX;
			_eY = this.stage.mouseY;
			drawLine();
		}
		
		public function drawLine():void{
			for(var i:int;i<inPutItemVec.length;i++){
				inPutItemVec[i].drawLine()
			}
			
			for(i = 0;i<outPutItemVec.length;i++){
				outPutItemVec[i].drawLine()
			}
		}
		
		protected function onChange(event:Event):void
		{
			drawBg();
		}
		
		public function addTitleImg():void{
			_bgContainer.addChild(titleBitmap);
			titleBitmap.x = 0;
			titleBitmap.y = 1;
		}
		public function drawBg():void{
			_bgContainer.graphics.clear();
			_bgContainer.graphics.beginFill(0x1f211f,0.8);
			_bgContainer.graphics.lineStyle(1,0);
			//this.graphics.drawRect(0,0,this.width,this.height);
			_bgContainer.graphics.drawRoundRect(0,0,this.width,this.height,8,8);
//			this.graphics.beginFill(_color,1);
//			this.graphics.drawRect(1,4,this.width-2,25);
//			this.graphics.drawRect(1,31,this.width-2,4);
			_bgContainer.graphics.endFill();
			
			_eageUI.graphics.clear();
			_eageUI.graphics.lineStyle(2,0xffff00);
			_eageUI.graphics.drawRoundRect(-1,0,this.width + 2,this.height + 2,8,8);
		}
		
		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 8;
			var blurY:Number = 8;
			var distance:Number = 5;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.x = this.x;
			obj.y = this.y;
			obj.name = this.name;
			obj.isDynamic = this.nodeTree.isDynamic;
			obj.paramName = this.nodeTree.paramName;
			return obj;
		}
		
		public function setData(obj:Object):void{
			this.x = obj.x;
			this.y = obj.y;
			this.nodeTree.isDynamic = obj.isDynamic;
			this.nodeTree.paramName = obj.paramName;
		}
		
		public function setInItemByData(ary:Array):void{
			
		}
		
		public function setOutItemByData(ary:Array):void{
			
		}
		
		public function getInItem($id:int):ItemMaterialUI{
			return inPutItemVec[$id];
		}
		
		public function getOutItem($id:int):ItemMaterialUI{
			return outPutItemVec[$id];
		}

		public function get select():Boolean
		{
			return _select;
		}
		private var glow:GlowFilter = new GlowFilter(0xffff00, 0.5, 2.0, 2.0, 10, 1, false, false)
		public function set select(value:Boolean):void
		{
			_select = value;
			_eageUI.visible = value;
			if(value){
				var evt:MEvent_Material = new MEvent_Material(MEvent_Material.MEVENT_MATERIAL_PROP);
				evt.nodeTreeView = this;
				ModuleEventManager.dispatchEvent(evt);
			}else{
				
				if(_textInputTxt.visible){
					_textInputTxt.removeEventListener(FlexEvent.ENTER,onSureTxt);
					_textInputTxt.visible=false
					this.showDynamic()
				}
			}

		}
		
		public function changeDynamic():void{
			if(!nodeTree.canDynamic){
				return;
			}
			nodeTree.isDynamic = !nodeTree.isDynamic;
		}
		public function showDynamic():void{
			
		}

		
	}
}