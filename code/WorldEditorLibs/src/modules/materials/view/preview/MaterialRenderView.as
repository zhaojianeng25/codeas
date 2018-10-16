package modules.materials.view.preview
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;
	
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	
	import _me.Scene_data;
	
	import common.utils.ui.prefab.PicBut;
	
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	
	import proxy.top.render.Render;
	
	public class MaterialRenderView extends UIComponent
	{
	
		private var _renderBimp:Bitmap;
		private var _material:MaterialTree;
		private var _urlArr:Array
		public function MaterialRenderView()
		{
			super();
			_focus.angle_x=-45
			_focus.angle_y=0
			_cam.distance=1000;
			_renderBimp=new Bitmap
			this.addChild(_renderBimp)
			addButs()
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage)
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage)
				
			_urlArr=new Array

				
			_urlArr.push("assets/obj/Box.objs")
			_urlArr.push("assets/obj/Box.objs")
			_urlArr.push("assets/obj/Cylinder.objs")
			_urlArr.push("assets/obj/Plane.objs")
			_urlArr.push("assets/obj/Sphere.objs")
			_urlArr.push("assets/obj/Teapot.objs")

			
		}
		
		public function get selectId():uint
		{
			return _selectId;
		}

		public function set selectId(value:uint):void
		{
			_selectId = value;
			_lastArr=null
		}

		public function get renderBimp():Bitmap
		{
			return _renderBimp;
		}

		public function resetSize($w:Number,$h:Number):void
		{
	
			
			this.width=$w
			this.height=$h
				
	
			_boxBut.x=$w-160
			_cylinderlBut.x=$w-130
			_planeBut.x=$w-100
			_sphereBut.x=$w-70
			_teapotBut.x=$w-40
		}
		private function addButs():void
		{
			
			_boxBut=new PicBut
			_boxBut.setBitmapdata(BrowerManage.getIcon("Box001"))
			this.addChild(_boxBut)
			_cylinderlBut=new PicBut
			_cylinderlBut.setBitmapdata(BrowerManage.getIcon("Cylinder001"))
			this.addChild(_cylinderlBut)
				
			_planeBut=new PicBut
			_planeBut.setBitmapdata(BrowerManage.getIcon("Plane001"))
			this.addChild(_planeBut)
				
			_sphereBut=new PicBut
			_sphereBut.setBitmapdata(BrowerManage.getIcon("Sphere001"))
			this.addChild(_sphereBut)
				
			_teapotBut=new PicBut
			_teapotBut.setBitmapdata(BrowerManage.getIcon("Teapot001"))
			this.addChild(_teapotBut)
				
		
				
			_boxBut.y=3
			_cylinderlBut.y=3
			_planeBut.y=3
			_sphereBut.y=3
			_teapotBut.y=3

			
		}
		

		protected function addToStage(event:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame)
			this.addEventListener(MouseEvent.MOUSE_DOWN,onBmpMouseDown)
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onCamWheel)
				
				
			_boxBut.addEventListener(MouseEvent.CLICK,_boxButClik)
			_cylinderlBut.addEventListener(MouseEvent.CLICK,_cylinderlButClik)
			_planeBut.addEventListener(MouseEvent.CLICK,_planeButClik)
			_sphereBut.addEventListener(MouseEvent.CLICK,_sphereButClik)
			_teapotBut.addEventListener(MouseEvent.CLICK,_teapotButClik)
			
		}
		
		protected function _teapotButClik(event:MouseEvent):void
		{
			selectId=5
			
		}
		
		protected function _sphereButClik(event:MouseEvent):void
		{
			selectId=4
			
		}		
	
		protected function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame)
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onBmpMouseDown)
			this.removeEventListener(MouseEvent.MOUSE_WHEEL,onCamWheel)
				
			_boxBut.removeEventListener(MouseEvent.CLICK,_boxButClik)
			_cylinderlBut.removeEventListener(MouseEvent.CLICK,_cylinderlButClik)
			_planeBut.removeEventListener(MouseEvent.CLICK,_planeButClik)
			_sphereBut.removeEventListener(MouseEvent.CLICK,_sphereButClik)
			_teapotBut.removeEventListener(MouseEvent.CLICK,_teapotButClik)
			
		}
		
		protected function _boxButClik(event:MouseEvent):void
		{
			selectId=1
			
		}
		protected function _cylinderlButClik(event:MouseEvent):void
		{
			selectId=2
			
		}
		protected function _planeButClik(event:MouseEvent):void
		{
			selectId=3
			
		}
		protected function onCamWheel(event:MouseEvent):void
		{
			_cam.distance+=event.delta*5
			
		}
		private var lastMoustPos:Point=new Point
		private var isMouseDown:Boolean=false
		private var lastCamAngly:Vector3D=new Vector3D
		protected function onBmpMouseDown(event:Event):void
		{
			isMouseDown=true
			lastMoustPos=new Point(this.mouseX,this.mouseY)
			lastCamAngly=new Vector3D(_focus.angle_x,_focus.angle_y,0)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageCamMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageCamMouseMove)
			
		}
		
		protected function onStageCamMouseMove(event:MouseEvent):void
		{
			_focus.angle_x=lastCamAngly.x-(this.mouseY-lastMoustPos.y)
			_focus.angle_y=lastCamAngly.y-(this.mouseX-lastMoustPos.x)
			
		}
		
		protected function onStageCamMouseUp(event:MouseEvent):void
		{
			isMouseDown=false
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageCamMouseUp)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageCamMouseMove)

			
		}
	
		
		public function set material(value:MaterialTree):void
		{
			_material = value;
			_lastArr=null

		}

		public function setBmp($bmp:BitmapData):void
		{
			if($bmp){
				_renderBimp.x=2
				_renderBimp.y=2
				_renderBimp.bitmapData=$bmp
				_renderBimp.smoothing=true;
	
			}
		}
		private var _focus:Focus3D=new Focus3D;
		private var _cam:Camera3D=new Camera3D;
		private var _boxBut:PicBut;
		private var _cylinderlBut:PicBut;
		private var _selectId:uint=1
		private var _planeBut:PicBut;
		private var _sphereBut:PicBut;
		private var _teapotBut:PicBut;
		protected function onEnterFrame(event:Event):void
		{
			if(_material){
				catch_cam(_cam, _focus)
				var $rct:Rectangle=new Rectangle(0,0,uint(this.width-5),uint(this.height-2))
				//MathUint.catch_cam(Scene_data.cam3D, Scene_data.focus3D)
					
				setBmp(getNewBmp())
			}
		}
	    private var _lastArr:Array
		private function getNewBmp():BitmapData
		{
			var $needChange:Boolean=true
			if(_lastArr){
				$needChange=false
			}
			if($needChange){
				_lastArr=new Array;
				var $tempObj:Object=new Object
				$tempObj.url=_urlArr[selectId]
				$tempObj.material=_material
				$tempObj.scale=0.1
				$tempObj.x=0
				$tempObj.y=0
				$tempObj.z=0
				_lastArr.push($tempObj)
			}
			var $rct:Rectangle=new Rectangle(0,0,uint(this.width-5),uint(this.height-2))
			var bfbmp:BitmapData=Render.renderBuildToBitmapData($needChange?_lastArr:null,_cam,$rct);  //特殊更新一下arr
			return bfbmp
		
		}
		private  function catch_cam(_Cam:Camera3D, _focus_3d:Focus3D,shake:Vector3D=null):void
		{
			var  $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_focus_3d.angle_x, Vector3D.X_AXIS);
			$m.appendRotation(-_focus_3d.angle_y, Vector3D.Y_AXIS);
			$m.appendTranslation( _focus_3d.x, _focus_3d.y, _focus_3d.z)
			var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-_Cam.distance))
			_Cam.x=$p.x
			_Cam.y=$p.y
			_Cam.z=$p.z
			_Cam.rotationX=_focus_3d.angle_x;
			_Cam.rotationY=_focus_3d.angle_y;
			
			_Cam.cameraMatrix.identity();
			//_Cam.cameraMatrix.prependScale(1,1,1);
			_Cam.cameraMatrix.prependScale(1*(500/this.width*2), this.width / this.height*(500/this.width*2), 1);
			_Cam.cameraMatrix.prependTranslation(0, 0, _Cam.distance);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationX, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.rotationY, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);
			
			
			
		}
		
	}
}