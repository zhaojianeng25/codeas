package common.utils.ui.tab
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import common.GameUIInstance;
	import common.utils.frame.BasePanel;
	
	import manager.LayerManager;
	
	public class TabPanel extends Canvas
	{
		
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		private var _shape:UIComponent;
		public var type:int;
		public var hasLayOut:Boolean;
		public function TabPanel()
		{
			super();
			
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			
			_bg = new UIComponent;
			this.addChild(_bg);
			_bg.addEventListener(MouseEvent.CLICK,onBgClick);
			
			_shape = new UIComponent;
			this.addChild(_shape);
			
			_btnVec = new Vector.<TabButton>;
			_panelVec = new Vector.<BasePanel>;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
			_shape.addEventListener(MouseEvent.CLICK,onClick);
			
			this.horizontalScrollPolicy = "off";
		}
		
		protected function onBgClick(event:MouseEvent):void
		{
			_bg.setFocus();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			_shape.setFocus();
		}
		
		protected function onStage(event:Event):void
		{
			drawback();
			
		}
		
		public function addItem(name:String,$panel:BasePanel):void{
			
			for(var i:int;i<_btnVec.length;i++){
				if(_btnVec[i].label == name){
					var removePanle:BasePanel = _btnVec[i].panel;
					_panelVec[getIndex(removePanle)] = $panel;
					_btnVec[i].panel = $panel;
					if(removePanle.parent){
						removePanle.parent.removeChild(removePanle);
					}
					setSelected(_btnVec[i]);
					return;
				}
			}
			
			_panelVec.push($panel);
			
			var _btn:TabButton = new TabButton;
			this.addChild(_btn);
			_btn.label = name;
			_btn.x = _btnVec.length *  _btn._baseWidth - 1;
			_btnVec.push(_btn);
			
			_btn.panel = $panel;
			
			setSelected(_btn);
			_btn.addEventListener(MouseEvent.CLICK,onBtnClick);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
			
			drawback();
		}
		
		public function getIndex($panel:BasePanel):int{
			for(var i:int=0;i<_panelVec.length;i++){
				if(_panelVec[i] == $panel){
					return i;
				}
			}
			return 0;
		}
		
		
		public function removeItem($panel:BasePanel):void{
			for(var i:int;i<_btnVec.length;i++){
				
				if(_btnVec[i].panel == $panel){
					var _btn:TabButton = _btnVec[i];
					
					this.removeChild(_btn);
					if($panel.parent)
						$panel.parent.removeChild($panel);
					_btnVec.splice(i,1);
					break;
				}
				
			}
			
			for(i=0;i<_panelVec.length;i++){
				if(_panelVec[i] == $panel){
					_panelVec.splice(i,1);
				}
				break;
			}
			
			for(i=0;i<_btnVec.length;i++){
				_btnVec[i].x = i *  _btnVec[i]._baseWidth - 1;
			}
			
			if(_btnVec.length){
				setSelected(_btnVec[0]);
			}else{
				LayerManager.getInstance().delPanel(this);
			}
			drawback();
		}
		
		
		private var timeID:uint;
		protected function onBtnDown(event:MouseEvent):void
		{
			LayerManager.getInstance().dragPanel = TabButton(event.currentTarget).panel;
			LayerManager.getInstance().dragTabPanel = this;
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			
			timeID = setTimeout(showGrid,200);
		}
		
		private function showGrid():void{
			GameUIInstance.layoutBottom.visible = true;
			
			GameUIInstance.application.nativeWindow.activate();
		}
		
		protected function onUp(event:MouseEvent):void
		{
			LayerManager.getInstance().dragPanel = null;
			GameUIInstance.layoutBottom.visible = false;
			clearTimeout(timeID);
			
		}
		
		protected function onMove(event:MouseEvent):void
		{
			
			
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			setSelected(event.currentTarget as TabButton);
		}
		
		public function setSelected(_btn:TabButton):void{
			for(var i:int=0;i<_btnVec.length;i++){
				if(_btn == _btnVec[i]){
					_btnVec[i].selected = true; 
					_btnVec[i].panel.show(this);
				}else{
					_btnVec[i].selected = false;
					_btnVec[i].panel.hide();
				}
			}
		}
		
		private function drawback():void{
			_shape.graphics.clear();
			_shape.graphics.beginFill(0x303030,1);
			_shape.graphics.lineStyle(1,0x151515);
			var _xpos:int = _btnVec.length *  60 - 1;
			_shape.graphics.drawRect(_xpos,0,this.width-_xpos,20);
			_shape.graphics.endFill();
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			if(this.type == 1){
				_bg.graphics.drawRect(0,0,this.width,60);
			}else{
				_bg.graphics.drawRect(0,0,this.width,this.height);
			}
			
			_bg.graphics.endFill();
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		public function changeSize():void{
			drawback();
			for(var i:int;i<_panelVec.length;i++){
				_panelVec[i].changeSize();
			}
			
		}
		
		public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
		
	}
}