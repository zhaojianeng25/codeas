package modules.prefabs
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import PanV2.loadV2.ObjsLoad;
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.hierarchy.FileSaveModel;
	import modules.materials.view.MaterialTreeManager;
	
	import pack.GroupMesh;
	import pack.PrefabStaticMesh;
	
	import proxy.top.render.Render;
	

	public class PrefabRenderToBmpModel
	{
		private static var instance:PrefabRenderToBmpModel;
		public function PrefabRenderToBmpModel()
		{
		}
		public static function getInstance():PrefabRenderToBmpModel{
			if(!instance){
				instance = new PrefabRenderToBmpModel();
			}
			return instance;
		}
		private var _focus:Focus3D=new Focus3D;
		public function scaPrefabToBmp($prefabStaticMesh:PrefabStaticMesh,$bfun:Function):void
		{
			var $cam:Camera3D=new Camera3D
			var $url:String=AppData.workSpaceUrl+$prefabStaticMesh.axoFileName
			if($url.search(".objs")!=-1){
				ObjsLoad.getInstance().getObjsMaxAndMinByUrl($url,function (KK:Object):void{
					var $min:Vector3D=KK.min;
					var $max:Vector3D=KK.max;
					var $centen:Vector3D=$min.add($max);
					$centen.scaleBy(-0.5);
					var $d:Number=Vector3D.distance($max,$min)
					var _camDistance:Number=$d*1.5
					_focus.angle_x=-30
					_focus.angle_y=0
					$prefabStaticMesh.material = MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$prefabStaticMesh.materialUrl);
		
					var $arr:Array
					if(true){
						$arr=new Array;
						var tempObj:Object=new Object
						var $url:String=AppData.workSpaceUrl+$prefabStaticMesh.axoFileName
						tempObj.url=$url
						tempObj.material=MaterialTree($prefabStaticMesh.material)
						tempObj.x=$centen.x
						tempObj.y=$centen.y
						tempObj.z=$centen.z
						$arr.push(tempObj)
					}
					Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,128,128));
					setTimeout(function():void{
						
						$cam.distance=_camDistance
						MathUint.catch_Rect_Cam($cam,_focus)
						var $bmp:BitmapData=Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,128,128));
						if(Boolean($bfun)){
							$bfun($bmp)
						}
					},50)
				})
				
			
			}else{
				trace("不是显示的objs模型数据")
			}
		}
		public function scanPrefabToBmpByUrl($url:String,$fun:Function=null):void
		{
			var $editPreFab:PrefabStaticMesh = PrefabManager.getInstance().getPrefabByUrl($url)
			MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$editPreFab.materialUrl);//先加载一次基本纹理
			PrefabRenderToBmpModel.getInstance().scaPrefabToBmp($editPreFab,function ($bmp:BitmapData):void
			{
				if($bmp){
					var $bmp128:BitmapData=new BitmapData(128,128);
					var $m:Matrix=new Matrix()
					$m.scale($bmp128.width/$bmp.width,$bmp128.height/$bmp.height)
					$bmp128.draw($bmp,$m)
					var $bmpFileName:String=$url.replace(".prefab","prefab.jpg")
					$bmpFileName=$bmpFileName.replace(AppData.workSpaceUrl,"")
					var $tourl:String=File.desktopDirectory.url+"/world/"+$bmpFileName
					var $iconBmp:BitmapData=BrowerManage.getIcon("prefab")
					var $mIcon:Matrix=new Matrix
					if($iconBmp){
						$mIcon.scale(20/$iconBmp.width,20/$iconBmp.height);
						$mIcon.tx=105
						$mIcon.ty=5
						$bmp128.draw($iconBmp,$mIcon)
					}
					
					FileSaveModel.getInstance().saveBitmapdataToJpg($bmp128,$tourl)
					
					//ShowMc.getInstance().setBitMapData($bmp128)
				}
				
			})
				
		}
		public function scanObjsToBmpByUrl($url:String,$fun:Function=null):void
		{
			var $editPreFab:PrefabStaticMesh=new PrefabStaticMesh;
			$editPreFab.axoFileName=$url.replace(AppData.workSpaceUrl,"")
			$editPreFab.materialUrl=AppData.defaultMaterialUrl
			MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$editPreFab.materialUrl);//先加载一次基本纹理
			PrefabRenderToBmpModel.getInstance().scaPrefabToBmp($editPreFab,function ($bmp:BitmapData):void
			{
				if($bmp){
					var $bmp128:BitmapData=new BitmapData(128,128);
					var $m:Matrix=new Matrix()
					$m.scale($bmp128.width/$bmp.width,$bmp128.height/$bmp.height)
					$bmp128.draw($bmp,$m)
					var $bmpFileName:String=$editPreFab.axoFileName.replace(".objs","objs.jpg")
					var $tourl:String=File.desktopDirectory.url+"/world/"+$bmpFileName;
					var $iconBmp:BitmapData=BrowerManage.getIcon("objs")
					var $mIcon:Matrix=new Matrix
					if($iconBmp){
						$mIcon.scale(20/$iconBmp.width,20/$iconBmp.height);
						$mIcon.tx=105
						$mIcon.ty=5
						$bmp128.draw($iconBmp,$mIcon)
					}
					
					FileSaveModel.getInstance().saveBitmapdataToJpg($bmp128,$tourl)
					if(new File($tourl).exists){
						
					}else{
						
					}
					
				
				}
				
			})
		
		}
			

		public function scanGroupToBmp($groupMesh:GroupMesh,$bfun:Function):void
		{
			var $arr:Array=new Array;
			for(var i:uint=0;i<$groupMesh.prefabItem.length;i++){
				var tempPreObj:Object=$groupMesh.prefabItem[i]
				
				var $prefabMesh:PrefabStaticMesh=tempPreObj.data
				var $tempObj:Object=new Object
				var $url:String=AppData.workSpaceUrl+$prefabMesh.axoFileName
				$tempObj.url=$url
				$tempObj.material=MaterialTree($prefabMesh.material)
				$tempObj.x=tempPreObj.x
				$tempObj.y=tempPreObj.y
				$tempObj.z=tempPreObj.z
				$arr.push($tempObj)
				
			}
			
			var $cam:Camera3D=new Camera3D
			$cam.distance=200
			_focus.angle_x=-30;
			_focus.angle_y=0;
			MathUint.catch_Rect_Cam($cam,_focus)
				
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
				$cam.distance=$d*1.5
				Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,200,200));  //特殊更新一下arr
				setTimeout(function ():void{
					MathUint.catch_Rect_Cam($cam,_focus)
					var bfbmp:BitmapData=Render.renderBuildToBitmapData($arr,$cam,new Rectangle(0,0,200,200));  //特殊更新一下arr
				    if(Boolean($bfun)){
						$bfun(bfbmp)
					}
				
				},100)//
			})
			
			
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
		
		
	}
}