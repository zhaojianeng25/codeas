package mvc.left.panelleft.vo
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import _me.Scene_data;
	
	import mvc.centen.panelcenten.PanelCentenEvent;

	public class MovePic  extends Sprite
	{
		private var _pic:Bitmap;
		private var _mc:Sprite;
		private var _pointMcA:Sprite;
		private var _pointMcB:Sprite;
		private var _centenMc:Sprite;
	    private var _baseRect:Rectangle
		private var _r:Number=0;
		private var _mouseDown:Boolean=false;
		private var _AAAAA:uint=0;
		
		
		public function MovePic()
		{
			_mc=new Sprite;
			_pic=new Bitmap();
			_mc.addChild(_pic)
			addChild(_mc)
			addPointA();
			addPointB();
			addCenten();
			addEvents()
	
		}
		
		private function addEvents():void
		{
			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onPicMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove)
			
		}
		
		protected function onPicMouseDown(event:MouseEvent):void
		{
			downEvent()
			
		}
		
		public  function onStageMove(event:MouseEvent):void
		{
			if(_mouseDown){
				if(_AAAAA==1){
					changeRotation(event)
				}
				if(_AAAAA==2){
					changeSize(event)
				}
				
			}

		}

		
		private function changeSize(event:MouseEvent):void
		{
	
			var $m:Matrix=new Matrix;
			$m.rotate((-_r)*Math.PI/180);
			
			var a:Point=$m.transformPoint(new Point(mouseX,mouseY))
			var b:Point=$m.transformPoint(_lastMouse)

			var w:Number=_baseRect.width
			_mc.scaleX=_lastSizeRect.x+(a.x-b.x)/_baseRect.width*2
			_mc.scaleY=_lastSizeRect.y+(a.y-b.y)/_baseRect.height*2
			
			resetPos()
			
		}
		private function changeRotation(event:MouseEvent):void
		{
			var p:Point=new Point(mouseX,mouseY);
			var a:Number=Math.atan2(mouseY,mouseX);
			var b:Number=Math.atan2(_lastMouse.y,_lastMouse.x);
			r=_lastRotation+(a-b)*180/Math.PI;
			resetPos()
			
		}
			
		public  function onStageUp(event:MouseEvent):void
		{
			_mouseDown=false
			_AAAAA=0
		
		}
		
		public function get r():Number
		{
			return _r;
		}

		public function set r(value:Number):void
		{
			_r = value;
			resetPos()
		}

		private function addPointA():void
		{
			_pointMcA=new Sprite;
			_pointMcA.graphics.beginFill(0x000000,1)
			_pointMcA.graphics.drawCircle(0,0,4)
			this.addChild(_pointMcA)
			_pointMcA.addEventListener(MouseEvent.MOUSE_DOWN,_pointMcMouseDownA)
			
		}
		private function addPointB():void
		{
			_pointMcB=new Sprite;
			_pointMcB.graphics.beginFill(0x00FF00,1)
			_pointMcB.graphics.drawCircle(0,0,4)
			this.addChild(_pointMcB)
			_pointMcB.addEventListener(MouseEvent.MOUSE_DOWN,_pointMcMouseDownB)
			
		}
		private var _lastMouse:Point;
		private var _lastRotation:Number;
		private var _lastSizeRect:Point;
		protected function _pointMcMouseDownA(event:MouseEvent):void
		{
			downEvent()
			_AAAAA=1
			ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.PANEL_RECT_INFO_START_MOVE));
		}
		protected function _pointMcMouseDownB(event:MouseEvent):void
		{
			downEvent()
			_AAAAA=2
			ModuleEventManager.dispatchEvent(new PanelCentenEvent(PanelCentenEvent.PANEL_RECT_INFO_START_MOVE));
			
		}
		
		private function downEvent():void
		{
		
			_mouseDown=true
			_lastRotation=r;
			_lastMouse=new Point(mouseX,mouseY)
			_lastSizeRect=new Point(_mc.scaleX,_mc.scaleY)
	
		}
		private function addCenten():void
		{
			_centenMc=new Sprite;
			_centenMc.graphics.beginFill(0x000000,1)
			_centenMc.graphics.drawCircle(0,0,2)
			this.addChild(_centenMc)
			
		}
		
		public function setBmp($bmp:BitmapData):void
		{
			_pic.bitmapData=$bmp;
			_pic.x=-$bmp.width/2
			_pic.y=-$bmp.height/2
			_baseRect=new Rectangle(0,0,$bmp.width,$bmp.height)
			resetPos()
			
		}
		public function resetPos():void
		{
			_mc.rotation=_r;
			var $m:Matrix=new Matrix;
			$m.rotate(_r*Math.PI/180);
			var $p:Point=$m.transformPoint(new Point(_pic.width/2*_mc.scaleX,_pic.height/2*_mc.scaleY))
			_pointMcA.x=$p.x;
			_pointMcA.y=$p.y;
			var $pb:Point=$m.transformPoint(new Point(_pic.width/2*_mc.scaleX,(_pic.height/2*_mc.scaleY)*-1))
			_pointMcB.x=$pb.x
			_pointMcB.y=$pb.y;
			
			
			trace(_mc.scaleX,_mc.scaleY,	_mc.rotation,x,y)
			
		}
	}
}














