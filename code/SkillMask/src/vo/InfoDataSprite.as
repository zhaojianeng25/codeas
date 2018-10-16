package vo
{
	import com.greensock.layout.AlignMode;
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mvc.centen.discenten.DisCentenEvent;
	import mvc.scene.UiSceneEvent;
	
	public class InfoDataSprite extends Sprite
	{
		private var _bg:Sprite;
		private var _line:Sprite;
		private var _moveBut:Sprite
		private var _wText:TextField;
		private var _hText:TextField;
		public var h5UIFileNode:H5UIFileNode
		public function InfoDataSprite()
		{
			super();
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
			if(h5UIFileNode.select&&!event.ctrlKey&&!event.shiftKey){
				ModuleEventManager.dispatchEvent(new UiSceneEvent(UiSceneEvent.START_MOVE_NODE_INFO));
			}
			
		}
		
		protected function onInfoSpriteClik(event:MouseEvent):void
		{
			if(!h5UIFileNode.select||event.ctrlKey||event.shiftKey){
				var $CentenEvent:UiSceneEvent=new UiSceneEvent(UiSceneEvent.SELECT_INFO_NODE)
				
				$CentenEvent.h5UIFileNode=h5UIFileNode;
				$CentenEvent.ctrlKey=event.ctrlKey;
				$CentenEvent.shiftKey=event.shiftKey;
				ModuleEventManager.dispatchEvent($CentenEvent);
			
			}
			
			

		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			if(_mouseDown){
				_mouseDown=false;
				
				HistoryModel.getInstance().saveSeep()
			}
			
			
		
			
		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
		    if(_mouseDown){
				var w:uint=Math.max(10,this.mouseX+_lastPoint.x);
				var h:uint=Math.max(5,this.mouseY+_lastPoint.y);
				h5UIFileNode.rect.width=w;
				h5UIFileNode.rect.height=h;
				drawBack();
			//	ScenePanel(this.parent.parent.parent).infoPanel.refreshViewValue();
				
				ModuleEventManager.dispatchEvent(new DisCentenEvent(DisCentenEvent.REFRESH_SELECT_FILENODE));
			}
	
		}
		
        private var _mouseDown:Boolean=false;
		private var _lastPoint:Point
		
		protected function onmoveButMouseDown(event:MouseEvent):void
		{
			_mouseDown=true
			_lastPoint=new Point(h5UIFileNode.rect.width-this.mouseX,h5UIFileNode.rect.height-this.mouseY);
			
		}


		
	
		private function drawBack():void
		{
			_bg.graphics.clear();
			if(h5UIFileNode.select){
				_bg.graphics.beginFill(0xff0000,0.20);
			}else{
			
				_bg.graphics.beginFill(0x000000,0.01);
			}
			_bg.graphics.drawRect(0,0,h5UIFileNode.rect.width,h5UIFileNode.rect.height);
			
			_line.graphics.clear();
			_line.graphics.lineStyle(1,0xff00ff,0.5);
			_line.graphics.moveTo(0,0);
			_line.graphics.lineTo(h5UIFileNode.rect.width,0);
			_line.graphics.lineTo(h5UIFileNode.rect.width,h5UIFileNode.rect.height);
			_line.graphics.lineTo(0,h5UIFileNode.rect.height);
			_line.graphics.lineTo(0,0);
			

			if(h5UIFileNode.type==FileInfoType.RECTANGLE){
				
				draw9Line();
			}
			if(h5UIFileNode.type==FileInfoType.SECTOR){
				
				drawFrameLine();
			}
			
			
			drawDiandian(new Point(0,5),new Point(h5UIFileNode.rect.width/2-20,5))
			
			_moveBut.x=h5UIFileNode.rect.width-10;
			_moveBut.y=h5UIFileNode.rect.height-10;
			
			
			
			_wText.text=String(h5UIFileNode.rect.width)
			_wText.x=h5UIFileNode.rect.width/2-15
			_wText.y=0
				
		
			_hText.text=String(h5UIFileNode.rect.height)
			_hText.x=0
			_hText.y=h5UIFileNode.rect.height/2-10;
				
			if(Math.min(h5UIFileNode.rect.width,h5UIFileNode.rect.height)>50){
				_wText.visible=true
				_hText.visible=true
			}else{
				_wText.visible=false
				_hText.visible=false
			}
		}
		
		private function drawFrameLine():void
		{
			//if(h5UIFileNode.rowColumn>)
				

			
			var wn:Number=h5UIFileNode.rowColumn.x	;
			var hn:Number=h5UIFileNode.rowColumn.y	;
			
			var tw:Number=h5UIFileNode.rect.width	;
			var th:Number=h5UIFileNode.rect.height	;
			
			
			for(var i:Number=0;i<wn;i++){
				drawPointToPoint(new Point((tw/wn)*i,0),new Point((tw/wn)*i,th))
			}
			for(var j:Number=0;j<hn;j++){
				drawPointToPoint(new Point(0,(th/hn)*j),new Point(tw,(th/hn)*j))
			}
			
			
		}
		private function drawPointToPoint(a:Point,b:Point):void
		{

			_line.graphics.moveTo(a.x,a.y)
			_line.graphics.lineTo(b.x,b.y)
			
		}
		private function draw9Line():void
		{
			var w9:Number=h5UIFileNode.rect9.width
			var h9:Number=h5UIFileNode.rect9.height
			
			drawTemp9Line(new Rectangle(0,0,w9,h9))
			drawTemp9Line(new Rectangle(h5UIFileNode.rect.width-w9,0,w9,h9))
			drawTemp9Line(new Rectangle(h5UIFileNode.rect.width-w9,h5UIFileNode.rect.height-h9,w9,h9))
			drawTemp9Line(new Rectangle(0,h5UIFileNode.rect.height-h9,w9,h9))
		
		}
		private function drawTemp9Line($rect:Rectangle):void
		{
			_line.graphics.lineStyle(1,0xffff00,0.5);
			_line.graphics.moveTo(0+$rect.x,0+$rect.y);
			_line.graphics.lineTo($rect.width+$rect.x,0+$rect.y);
			_line.graphics.lineTo($rect.width+$rect.x,$rect.height+$rect.y);
			_line.graphics.lineTo(0+$rect.x,$rect.height+$rect.y);
			_line.graphics.lineTo(0+$rect.x,0+$rect.y);
			_line.graphics.lineTo($rect.width+$rect.x,$rect.height+$rect.y);
			_line.graphics.lineTo(0+$rect.x,$rect.height+$rect.y);
			_line.graphics.lineTo($rect.width+$rect.x,0+$rect.y);
		}
		private function drawDiandian(a:Point,b:Point):void
		{
			return ;
			_line.graphics.moveTo(a.x,a.y)
			_line.graphics.lineTo(b.x,b.y)
		
		}
		public function updata():void
		{
			this.x=h5UIFileNode.rect.x
			this.y=h5UIFileNode.rect.y
			drawBack()
		}
		
	}
}