package common.utils.ui.prefab
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import PanV2.loadV2.ObjsLoad;
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.frame.BaseComponent;
	
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	
	import pack.GroupMesh;
	import pack.PrefabStaticMesh;
	
	import proxy.top.render.Render;

	public class PrefabRenderWindow extends BaseComponent
	{
		private var _iconBmp:PicBut;
		public function PrefabRenderWindow()
		{
			super();
			_iconBmp=new PicBut
			this.addChild(_iconBmp)
			_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),150,150)
			_iconBmp.y=0
			_iconBmp.x=0
			_iconBmp.buttonMode=false
			_iconBmp.isEvent=false
			this.height=200
			this.isDefault=false
			addEvents();
		}
		private function addEvents():void
		{
			// TODO Auto Generated method stub
			_iconBmp.addEventListener(MouseEvent.MOUSE_DOWN,onBmpMouseDown)
			_iconBmp.addEventListener(MouseEvent.MOUSE_WHEEL,onCamWheel)
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage)
			
		}
		protected function onRemoveFromStage(event:Event):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onBmpMouseDown)
			this.removeEventListener(MouseEvent.MOUSE_WHEEL,onCamWheel)
		}
		protected function onCamWheel(event:MouseEvent):void
		{
			_camDistance+=event.delta*5
			showRender()
			
		}
		private var lastMoustPos:Point=new Point
		private var isMouseDown:Boolean=false
		private var lastCamAngly:Vector3D=new Vector3D
		private var _focus:Focus3D=new Focus3D;
		//private var _cam:Camera3D=new Camera3D;
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
			showRender()
		}
		
		protected function onStageCamMouseUp(event:MouseEvent):void
		{
			isMouseDown=false
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageCamMouseUp)
			Scene_data.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageCamMouseMove)
			
			
		}
		
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				var dde:Object=target[FunKey]
				setData(target[FunKey])
			}
		}
		private var _camDistance:Number;
		private function setData(value:Object):void
		{
			// TODO Auto Generated method stub
			//_prefabStaticMesh=value
			
			_focus.angle_x=-30;
			_focus.angle_y=0;
			_camDistance=200
			showRender(true)

		}
		private function showRender(isNew:Boolean=false):void
		{
			if(AppData.type==0){
				return 
			}
			var $cam:Camera3D=new Camera3D
			var $arr:Array;
			if(isNew){
				$arr=getRenderArr()
				getArrMinAndMax($arr,function ($minAndMax:Object):void{
					var $min:Vector3D=$minAndMax.min;
					var $max:Vector3D=$minAndMax.max;
					var $center:Vector3D=$minAndMax.center;
					for(var i:uint=0;i<$arr.length;i++){
						$arr[i].x-=$center.x
						$arr[i].y-=$center.y
						$arr[i].z-=$center.z
					}
					var $d:Number=Vector3D.distance($max,$min)
					_camDistance=$d*1.5
					Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,200,200));  //特殊更新一下arr
					setTimeout(showRender,50)//
				})
				setTimeout(showRender,2000)//可能没有加载完成，特再1秒后重刷新一下
			}
		
			$cam.distance=_camDistance
			MathUint.catch_Rect_Cam($cam,_focus)
			//var cameraMatrix:Matrix3D=MathCore.renderToBitmapCam(_focus,_camDistance)
			//cameraMatrix=$cam.cameraMatrix
			var $bmp:BitmapData=Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,200,200));
			_iconBmp.setBitmapdata($bmp)
		
		}
		private function getArrMinAndMax($arr:Array,$bfun:Function):void
		{
			var min:Vector3D;
			var max:Vector3D;
			nextObj(0)
			function nextObj($id:uint):void
			{
				if($id<$arr.length){
					ObjsLoad.getInstance().getObjsMaxAndMinByUrl($arr[$id].url,function (KK:Object):void{
						var $min:Vector3D=KK.min;
						var $max:Vector3D=KK.max;
						$min=$min.add(new Vector3D($arr[$id].x,$arr[$id].y,$arr[$id].z))
						$max=$max.add(new Vector3D($arr[$id].x,$arr[$id].y,$arr[$id].z))
						if(min||max){
							min.x=Math.min(min.x,$min.x)
							min.y=Math.min(min.y,$min.y)
							min.z=Math.min(min.z,$min.z)
							max.x=Math.max(max.x,$max.x)
							max.y=Math.max(max.y,$max.y)
							max.z=Math.max(max.z,$max.z)
							
						}else{
							min=$min.clone()
							max=$max.clone()
						}
						nextObj($id+1)
					})
				}else
				{
					if(min||max){
						var centerPos:Vector3D = min.add(max);
						centerPos.scaleBy(0.5);
						$bfun({min:min,max:max,center:centerPos})
					}else{
						$bfun({min:new Vector3D,max:new Vector3D,center:new Vector3D})
						
					}
				}
			}
		}
		private function getRenderArr():Array
		{
			var $arr:Array=new Array;
			var $prefabMesh: PrefabStaticMesh
			var $tempObj:Object
			var $url:String
			if(target as PrefabStaticMesh){
				$prefabMesh=target as PrefabStaticMesh
				$tempObj=new Object
				$url=AppData.workSpaceUrl+$prefabMesh.axoFileName
				$tempObj.url=$url
				$tempObj.material=MaterialTree($prefabMesh.material)
				$tempObj.x=0
				$tempObj.y=0
				$tempObj.z=0
				$arr.push($tempObj)
			}else if(target as GroupMesh){
				var $groupMesh:GroupMesh=target as GroupMesh 
				for(var i:uint=0;i<$groupMesh.prefabItem.length;i++){
					var tempPreObj:Object=$groupMesh.prefabItem[i]
				
						$prefabMesh=tempPreObj.data
						$tempObj=new Object
						$url=AppData.workSpaceUrl+$prefabMesh.axoFileName
						$tempObj.url=$url
						$tempObj.material=MaterialTree($prefabMesh.material)
						$tempObj.x=tempPreObj.x
						$tempObj.y=tempPreObj.y
						$tempObj.z=tempPreObj.z
						$arr.push($tempObj)
				
				}
			}

			return $arr
		}

	}
}