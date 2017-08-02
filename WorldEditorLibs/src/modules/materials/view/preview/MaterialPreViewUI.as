package modules.materials.view.preview
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;

	public class MaterialPreViewUI extends Canvas
	{
		private var _backColor:UIComponent;
	    private var _materialRenderView:MaterialRenderView
		private var _lineHmove:UIComponent
		private var _lineWmove:UIComponent
		private var _materialPrejectView:MaterialPrejectView;
		private var _material:MaterialTree;

		public function MaterialPreViewUI()
		{
			super();
			
	

			_backColor=new UIComponent
			this.addChild(_backColor);
			
			_materialRenderView=new MaterialRenderView
			this.addChild(_materialRenderView)

				
			_lineHmove=new UIComponent
			this.addChild(_lineHmove)
				
			_lineWmove=new UIComponent
			this.addChild(_lineWmove)
				
			_materialPrejectView=new MaterialPrejectView
			this.addChild(_materialPrejectView)
				
				
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage)
			
			
		}
		
		public function get materialRenderView():MaterialRenderView
		{
			return _materialRenderView;
		}

		protected function addToStage(event:Event):void
		{
			_lineHmove.addEventListener(MouseEvent.MOUSE_DOWN,onLineHmouseDown)
			_lineHmove.addEventListener(MouseEvent.MOUSE_OVER,onLineHmouseOver)
			_lineHmove.addEventListener(MouseEvent.MOUSE_OUT,onLineHmouseOut)
				
			_lineWmove.addEventListener(MouseEvent.MOUSE_DOWN,onLineWmouseDown)
			_lineWmove.addEventListener(MouseEvent.MOUSE_OVER,onLineWmouseOver)
			_lineWmove.addEventListener(MouseEvent.MOUSE_OUT,onLineWmouseOut)
				
				
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage)
			
		}		


		public function set material(value:MaterialTree):void
		{
			_material = value;
			_materialRenderView.material=_material

		}
	
		
		protected function onRemoveFromStage(event:Event):void
		{
			_lineHmove.removeEventListener(MouseEvent.MOUSE_DOWN,onLineHmouseDown)
			_lineHmove.removeEventListener(MouseEvent.MOUSE_OVER,onLineHmouseOver)
			_lineHmove.removeEventListener(MouseEvent.MOUSE_OUT,onLineHmouseOut)
				
			_lineWmove.removeEventListener(MouseEvent.MOUSE_DOWN,onLineWmouseDown)
			_lineWmove.removeEventListener(MouseEvent.MOUSE_OVER,onLineWmouseOver)
			_lineWmove.removeEventListener(MouseEvent.MOUSE_OUT,onLineWmouseOut)
		
		}
		
		protected function onLineWmouseOut(event:MouseEvent):void
		{
			if(!_isLineWDown){
				Mouse.cursor = MouseCursor.AUTO;
			}
			
		}
		
		protected function onLineWmouseOver(event:MouseEvent):void
		{
			Mouse.cursor = "doubelVerArrow";
			
		}
		
	
		protected function onLineWmouseDown(event:MouseEvent):void
		{
			_isLineWDown=true
			Mouse.cursor = "doubelVerArrow";
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
				
		
			
		}
		protected function onLineHmouseOut(event:MouseEvent):void
		{
			if(!_isLineHDown){
				Mouse.cursor = MouseCursor.AUTO;
			}
		
		}
		protected function onLineHmouseOver(event:MouseEvent):void
		{
			Mouse.cursor = "doubelArrow";
		}
		protected function onStageMouseMove(event:MouseEvent):void
		{
			if(_isLineWDown){
				_fengexianNum=Math.min(Math.max(150,this.mouseY+2),this.height-100)
				resetSize(this.width,this.height)
			}
			if(_isLineHDown){
				resetSize(Math.max(210,this.mouseX),this.height)
			}

		}
		private var _isLineHDown:Boolean=false
		private var _isLineWDown:Boolean=false
		protected function onLineHmouseDown(event:MouseEvent):void
		{
			_isLineHDown=true
			Mouse.cursor = "doubelArrow";
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			
			
		}
		protected function onStageMouseUp(event:MouseEvent):void
		{
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			Mouse.cursor = MouseCursor.AUTO;
			_isLineHDown=false
			_isLineWDown=false

		}
		
		public function resetSize($w:Number,$h:Number):void
		{
			if($w==0){
				$w=210
			}
			this.width=$w
			this.height=$h
				
			drawBg($w,$h)
			
			_materialPrejectView.y=_fengexianNum
			_materialPrejectView.resetSize($w-2,$h-_materialPrejectView.y)
			_materialRenderView.x=0
			_materialRenderView.y=0
			_lineWmove.y=_fengexianNum
				
				
			_materialRenderView.resetSize($w,_fengexianNum)

		}
		private var _fengexianNum:Number=210;
		private function drawBg($w:Number,$h:Number):void{
			_backColor.graphics.clear();
			_backColor.graphics.beginFill(0x3c3c3c);//59
			_backColor.graphics.drawRect(0,0,$w,$h);
			
			_backColor.graphics.beginFill(0x4b4b4b);//59
			_backColor.graphics.drawRect($w-2,0,2,$h);
			
			_backColor.graphics.beginFill(0x595959);//59
			_backColor.graphics.drawRect(0,_fengexianNum,$w,2);
			_backColor.graphics.endFill();
			
			
			_lineHmove.x=$w
			_lineHmove.graphics.clear()
			_lineHmove.graphics.beginFill(0xff0000,0.01)
			_lineHmove.graphics.drawRect(-7,0,10,$h)
			_lineHmove.graphics.endFill();

			
			
			_lineWmove.graphics.clear()
			_lineWmove.graphics.beginFill(0xff0000,0.01)
			_lineWmove.graphics.drawRect(0,-5,$w,10)
			_lineWmove.graphics.endFill();
				
		}

	}
}