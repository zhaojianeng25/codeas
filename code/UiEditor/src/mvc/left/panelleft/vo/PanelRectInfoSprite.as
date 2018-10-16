package mvc.left.panelleft.vo
{
	import com.greensock.layout.AlignMode;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mvc.centen.panelcenten.PanelCentenEvent;
	
	public class PanelRectInfoSprite extends Sprite
	{
		private var _bg:Sprite;
		private var _line:Sprite;
		private var _moveBut:Sprite
		private var _wText:TextField;
		private var _hText:TextField;
		private var _panelRectInfoBmp:PanelRectInfoBmp
	
	
		public var panelRectInfoNode:PanelRectInfoNode
		public function PanelRectInfoSprite()
		{
			super();
			
			_panelRectInfoBmp=new PanelRectInfoBmp;
			this.addChild(_panelRectInfoBmp)
			
			_bg=new Sprite;
			this.addChild(_bg);
			_line=new Sprite;
			this.addChild(_line);
		
			
			
			_moveBut=new Sprite();
			this.addChild(_moveBut)
			_moveBut.graphics.clear();
			_moveBut.graphics.beginFill(0x000000,1)
			_moveBut.graphics.moveTo(10,10)
			_moveBut.graphics.lineTo(10,0)
			_moveBut.graphics.lineTo(0,10)
			_moveBut.graphics.lineTo(10,10)
			_moveBut.graphics.endFill();
			
			
			addwText();
			addhText();
			
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage)
			
		}
		public function showHideLine(value:Boolean):void
		{
			_line.visible=value
			_moveBut.visible=value
			_wText.visible=value
			_hText.visible=value
		}
		private function addwText():void
		{
			_wText=new TextField;
			
			var _txtform:TextFormat=new TextFormat();
			_txtform.align=AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			
			_wText.defaultTextFormat=_txtform;
			_wText.type = TextFieldType.DYNAMIC; 
			_wText.wordWrap=true
			_wText.multiline=true
			_wText.height=17
			_wText.width=30
			
			
			this.addChild(_wText)
			_wText.mouseEnabled=false;
			
			
			
			
			
		}
		private function addhText():void
		{
			_hText=new TextField;
			
			var _txtform:TextFormat=new TextFormat();
			_txtform.align=AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			
			_hText.defaultTextFormat=_txtform;
			_hText.type = TextFieldType.DYNAMIC; 
			_hText.wordWrap=true
			_hText.multiline=true
			_hText.height=17
			_hText.width=30
			
			
			this.addChild(_hText)
			_hText.mouseEnabled=false;
			
			
		}
		
		protected function addToStage(event:Event):void
		{
			addEvents();
			
		}
		
		private function addEvents():void
		{
			
			
			_bg.addEventListener(MouseEvent.MOUSE_DOWN,onBgMouseDown)
			_moveBut.addEventListener(MouseEvent.MOUSE_DOWN,onmoveButMouseDown)
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			this.addEventListener(MouseEvent.CLICK,onInfoSpriteClik)
			
			
		}
		
		protected function onBgMouseDown(event:MouseEvent):void
		{
			if(panelRectInfoNode.select&&!event.ctrlKey&&!event.shiftKey){
				ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.PANEL_RECT_INFO_START_MOVE));
			}
			
		}
		
		protected function onInfoSpriteClik(event:MouseEvent):void
		{
			if(!panelRectInfoNode.select||event.ctrlKey||event.shiftKey){
		
				var $CentenEvent:PanelCentenEvent=new PanelCentenEvent(PanelCentenEvent.SELECT_PANEL_INFO_NODE)
				
				$CentenEvent.panelRectInfoNode=panelRectInfoNode;
				$CentenEvent.ctrlKey=event.ctrlKey;
				$CentenEvent.shiftKey=event.shiftKey;
				ModuleEventManager.dispatchEvent($CentenEvent);
			}
			
			
			
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			if(_mouseDown){
				_mouseDown=false;
				

			}
			

		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
			if(_mouseDown){
				var w:uint=Math.max(10,this.mouseX+_lastPoint.x);
				var h:uint=Math.max(5,this.mouseY+_lastPoint.y);
				panelRectInfoNode.rect.width=w;
				panelRectInfoNode.rect.height=h;
				changeSize()
				
				ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SIZE_VIEW));
			}
			
		}
		public function changeSize():void
		{
			this.x=panelRectInfoNode.rect.x
			this.y=panelRectInfoNode.rect.y
			drawBack();
			_panelRectInfoBmp.changeSize()
		
		}
		
		private var _mouseDown:Boolean=false;
		private var _lastPoint:Point
		
		protected function onmoveButMouseDown(event:MouseEvent):void
		{
			_mouseDown=true
			_lastPoint=new Point(panelRectInfoNode.rect.width-this.mouseX,panelRectInfoNode.rect.height-this.mouseY);
			
		}
		
		
		
		
		private function drawBack():void
		{
			_bg.graphics.clear();
			if(panelRectInfoNode.select){
				_bg.graphics.beginFill(0xff0000,0.20);
			}else{
				
				_bg.graphics.beginFill(0x000000,0.01);
			}
			_bg.graphics.drawRect(0,0,panelRectInfoNode.rect.width,panelRectInfoNode.rect.height);
			
			_line.graphics.clear();
			_line.graphics.lineStyle(1,0xff00ff,0.5);
			_line.graphics.moveTo(0,0);
			_line.graphics.lineTo(panelRectInfoNode.rect.width,0);
			_line.graphics.lineTo(panelRectInfoNode.rect.width,panelRectInfoNode.rect.height);
			_line.graphics.lineTo(0,panelRectInfoNode.rect.height);
			_line.graphics.lineTo(0,0);
			
	
			

			
			_moveBut.x=panelRectInfoNode.rect.width-10;
			_moveBut.y=panelRectInfoNode.rect.height-10;
			
			
			
			_wText.text=String(panelRectInfoNode.rect.width)
			_wText.x=panelRectInfoNode.rect.width/2-15
			_wText.y=0
			
			
			_hText.text=String(panelRectInfoNode.rect.height)
			_hText.x=0
			_hText.y=panelRectInfoNode.rect.height/2-10;
			
			if(Math.min(panelRectInfoNode.rect.width,panelRectInfoNode.rect.height)>50){
				_wText.visible=true
				_hText.visible=true
			}else{
				_wText.visible=false
				_hText.visible=false
			}
	
		}
		

		public function updata():void
		{
			this.x=panelRectInfoNode.rect.x
			this.y=panelRectInfoNode.rect.y
			drawBack()
			_panelRectInfoBmp.updata();
		}
	}
}


