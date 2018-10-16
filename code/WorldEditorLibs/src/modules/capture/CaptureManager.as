package modules.capture
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import capture.CaptureStaticMesh;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import pack.BuildMesh;
	
	import proxy.top.model.ICapture;
	import proxy.top.model.IModel;
	import proxy.top.model.IWater;
	import proxy.top.render.Render;
	
	import water.WaterStaticMesh;
	

	public class CaptureManager
	{
		private static var instance:CaptureManager;
		public function CaptureManager()
		{
		}
		public static function getInstance():CaptureManager{
			if(!instance){
				instance = new CaptureManager();
			}
			return instance;
		}
		public var captureDis:Dictionary=new Dictionary
			
		public function getCaptureVoById($id:uint,$bFun:Function):void
		{
			if(captureDis[$id]){
				$bFun(captureDis[$id])
			}else{
				var $captureBmpUrl:String=(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+".jpg"
				BmpLoad.getInstance().addSingleLoad($captureBmpUrl,function ($bitmap:Bitmap,$obj:Object):void{
					var arr:Vector.<BitmapData>=makeArrBmp($bitmap.bitmapData)

					if(!Boolean(captureDis[$id])){
						captureDis[$id]=  TextureManager.getInstance().addBitmapCubeTexture(arr)
					}
					$bFun(captureDis[$id]);
				},{})
			}
		}
		private  function makeArrBmp($tempBmp:BitmapData):Vector.<BitmapData>
		{
			
			if($tempBmp.width/$tempBmp.height!=3/4){
				throw new Error("图片次春不对")
			}
			var arr:Vector.<BitmapData>=new Vector.<BitmapData>
				
			var a0:BitmapData=new BitmapData($tempBmp.width,$tempBmp.height)
			var $m:Matrix=new Matrix
			a0.draw($tempBmp,$m)
			
			$m.scale(0.5,0.5)
			var a1:BitmapData=new BitmapData(a0.width/2,a0.height/2)
			a1.draw(a0,$m)
			var a2:BitmapData=new BitmapData(a1.width/2,a1.height/2)
			a2.draw(a1,$m)
			var a3:BitmapData=new BitmapData(a2.width/2,a2.height/2)
			a3.draw(a2,$m)
			var a4:BitmapData=new BitmapData(a3.width/2,a3.height/2)
			a4.draw(a3,$m)
			var a5:BitmapData=new BitmapData(a4.width/2,a4.height/2)
			a5.draw(a4,$m)
	
			arr.push(a0)
			arr.push(a1)
			arr.push(a2)
			arr.push(a3)
			arr.push(a4)
			arr.push(a5)

			return arr
			
		}
		public var listArr:ArrayCollection
		public function addCaptureModel($id:uint):void
		{
			var $captureStaticMesh:CaptureStaticMesh=new CaptureStaticMesh
			$captureStaticMesh.url="assets/obj/box_0.objs";
			$captureStaticMesh.textureSize=128
			captureDis[$id]=new TextureCubeMapVo
			$captureStaticMesh.textureBaseVo=captureDis[$id]
			
			var $imode:IModel=Render.creatCaptureModel($captureStaticMesh,$id)
			$imode.x=Scene_data.focus3D.x
			$imode.y=Scene_data.focus3D.y
			$imode.z=Scene_data.focus3D.z
			
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.name="立方体贴图"
			$hierarchyFileNode.iModel=$imode;
			$hierarchyFileNode.type=HierarchyNodeType.Capture
			$hierarchyFileNode.data=$captureStaticMesh;
			
			
			
			listArr.addItem($hierarchyFileNode)

			$captureStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
		}
		
		protected function onMeshChange(event:Event):void
		{
			var $captureStaticMesh:CaptureStaticMesh=	CaptureStaticMesh(event.target);
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).data==$captureStaticMesh){
					changeCaptureBmp(HierarchyFileNode($arr[i]))
				}
			}
		}
		private function changeCaptureBmp($hierarchyFileNode:HierarchyFileNode):void
		{
			var $iCapture:ICapture=$hierarchyFileNode.iModel as ICapture
			$iCapture.reset()
		    if($hierarchyFileNode.data as CaptureStaticMesh ){
				var $captureStaticMesh:CaptureStaticMesh = CaptureStaticMesh($hierarchyFileNode.data )
				if($captureStaticMesh.textureBaseVo){
	
					var arr:Vector.<BitmapData>=makeArrBmp($captureStaticMesh.cubeTextureBmp)
					TextureManager.getInstance().addBitmapCubeTexture(arr,TextureCubeMapVo($captureStaticMesh.textureBaseVo))
				}
			}

		}
		public function objToCaptureMesh($obj:Object):CaptureStaticMesh
		{
			var $captureStaticMesh:CaptureStaticMesh = new CaptureStaticMesh();
			for(var i:String in $obj) {
				$captureStaticMesh[i]=$obj[i]
			}
			$captureStaticMesh.textureBaseVo=new TextureCubeMapVo
			$captureStaticMesh.addEventListener(Event.CHANGE,onMeshChange)
			return $captureStaticMesh
		}
		public function changeImodeCaptureId($iMode:IModel,$captureId:uint):void
		{
			var $item:Vector.<FileNode>=FileNodeManage.getListAllFileNode(listArr)
			for(var i:uint=0;i<$item.length;i++){
			    var $hierarchyFileNode:HierarchyFileNode=HierarchyFileNode($item[i])
                if($hierarchyFileNode.iModel==$iMode){
					if($iMode as IWater){
						WaterStaticMesh($hierarchyFileNode.data).captureId=$captureId
					}else
					if($iMode as IModel){
						BuildMesh($hierarchyFileNode.data).captureId=$captureId
					}
				}
			}
			
		}
		public function saveCubeBmp($captureStaticMesh:CaptureStaticMesh,$id:uint):void
		{
			
			var $captureBmpUrl:String=(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+".jpg"
			FileSaveModel.getInstance().saveBitmapdataToJpg($captureStaticMesh.cubeTextureBmp,$captureBmpUrl)
				
			if(!$captureStaticMesh.cubeTextureBmp){
				trace("cubeTextureBmp==null")
				return ;
			}
			var a0:BitmapData=new BitmapData($captureStaticMesh.cubeTextureBmp.width,$captureStaticMesh.cubeTextureBmp.height)
			var $m:Matrix=new Matrix
			a0.draw($captureStaticMesh.cubeTextureBmp,$m)
			$m.scale(0.5,0.5)
			var a1:BitmapData=new BitmapData(a0.width/2,a0.height/2)
			a1.draw(a0,$m)
			var a2:BitmapData=new BitmapData(a1.width/2,a1.height/2)
			a2.draw(a1,$m)
			var a3:BitmapData=new BitmapData(a2.width/2,a2.height/2)
			a3.draw(a2,$m)
			var a4:BitmapData=new BitmapData(a3.width/2,a3.height/2)
			a4.draw(a3,$m)
			var a5:BitmapData=new BitmapData(a4.width/2,a4.height/2)
			a5.draw(a4,$m)
				
			FileSaveModel.getInstance().saveBitmapdataToJpg(a0,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_0.jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg(a1,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_1.jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg(a2,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_2.jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg(a3,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_3.jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg(a4,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_4.jpg")
			FileSaveModel.getInstance().saveBitmapdataToJpg(a5,(AppData.workSpaceUrl + AppData.mapUrl).replace(".lmap","") + "_hide/capture/"+$id+"_5.jpg")
		}
	}
}