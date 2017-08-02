package modules.hierarchy.h5
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.base.ObjData;
	
	import common.AppData;
	import common.utils.ui.file.FileNode;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import pack.BuildMesh;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	import proxy.top.model.IModel;
	
	import render.ground.TerrainEditorData;

	public class ExpToH5MergeModel
	{
		private static var instance:ExpToH5MergeModel;
		private var _buildNodeItem:Vector.<HierarchyFileNode>;
		public function ExpToH5MergeModel()
		{
		}

		public function get buildItem():Array
		{
			return _buildItem;
		}

		public static function getInstance():ExpToH5MergeModel{
			if(!instance){
				instance = new ExpToH5MergeModel();
			}
			return instance;
		}
		/**
		 *判断找到关联的组材质是否一至 
		 * @param $BuildMesh
		 * @return 
		 * 
		 */
		private function canMergeToGroupId($BuildMesh:BuildMesh):Boolean
		{
			
			for(var i:uint=0;i<_buildNodeItem.length;i++)
			{
				if(_buildNodeItem[i].id==$BuildMesh.groupMaterialId){
					var strUrl:String=BuildMesh(_buildNodeItem[i].data).prefabStaticMesh.materialUrl
					if($BuildMesh.prefabStaticMesh.materialUrl==BuildMesh(_buildNodeItem[i].data).prefabStaticMesh.materialUrl){
						return true
					}	
					
					
				}
				
			}
			return false
		}
		private var _buildItem :Array
		public function setHierarchy($arr:Vector.<FileNode>,$rootUrl:String,bfun:Function):void
		{
			
			_rootUrl=$rootUrl;
			_backFun=bfun
			BmpLoad.getInstance().clearDis()
			
			this._groupDis=new Dictionary
			this._buildItem=new Array;
			this._buildNodeItem=new Vector.<HierarchyFileNode>
			for(var i:uint=0;i<$arr.length;i++)
			{
				if(HierarchyFileNode($arr[i]).type==HierarchyNodeType.Prefab){
					_buildNodeItem.push(HierarchyFileNode($arr[i]))
				}
			}
			this.mergeGroupTest()
				
		
		}
		private var _backFun:Function

		private var _rootUrl:String;

		private function mergeGroupTest():void
		{
			for(var i:uint=0;i<_buildNodeItem.length;i++)
			{
		
				var $buildMesh:BuildMesh=BuildMesh(_buildNodeItem[i].data)
				if($buildMesh.groupMaterialId!=_buildNodeItem[i].id){   
					if(!canMergeToGroupId($buildMesh)){
						$buildMesh.groupMaterialId=_buildNodeItem[i].id   //如果打组材质不一样，那就打组取消
					}
				}
				
			}
			this.countGroup()
		}

		private  function  countGroup():void
		{
			
			for(var i:uint=0;i<_buildNodeItem.length;i++)
			{
				pushBuildNodeToDis(_buildNodeItem[i])
			}
			_heirarchItem=new Array;
			_mergeId=0
			for each(var $arr:Vector.<HierarchyFileNode> in _groupDis){
			
				
				_heirarchItem.push($arr)

			}
			oneByOneMergePic()
			
		
		}
		private var _heirarchItem:Array;
		private var _mergeId:uint
		private function oneByOneMergePic():void
		{
			if(_mergeId<_heirarchItem.length){
				_mergeId=_mergeId+1
				MergeOneGroupData(_heirarchItem[_mergeId-1])
		
			}else{
				_backFun()
			}
		

		
		}
		private function getTerrainName():String
		{
			var $file:File=new File(AppData.workSpaceUrl + AppData.mapUrl);
			return decodeURI($file.name.replace("."+$file.extension,""));
		}
		private var BigLightBmp:BitmapData
		private function mathLightUvInfo($arr:Vector.<HierarchyFileNode>,$bfun:Function):void
		{
			var $rects:Vector.<Rectangle> = new Vector.<Rectangle>();
			var $groupMaterialId:uint;
			for(var i:uint=0;i<$arr.length;i++)
			{
				$groupMaterialId=BuildMesh($arr[i].data).groupMaterialId
				$rects.push(new Rectangle(0,0,BuildMesh($arr[i].data).lightMapSize,BuildMesh($arr[i].data).lightMapSize))
			}
			var $maxPos:Point=new Point
			var $endItem:Vector.<Rectangle>;
			if($arr.length>1){
				$endItem=MaxRectsBinPack.makeMin($rects)
			}else{
				$endItem=$rects;
			}
	
			
			for(var j:int = 0; j <$endItem.length; j++) {
				var endRect:Rectangle=$endItem[j]
				$maxPos.x=Math.max($maxPos.x,(endRect.x+endRect.width))
				$maxPos.y=Math.max($maxPos.y,(endRect.y+endRect.height))
			}
			$maxPos.x=Math.pow(2,Math.ceil(Math.log($maxPos.x)/Math.log(2)))
			$maxPos.y=Math.pow(2,Math.ceil(Math.log($maxPos.y)/Math.log(2)))
			trace("maxPos",$maxPos)
			
			if($maxPos.x>1024||$maxPos.y>1024)
			{
				 Alert.show("合并贴图大于了1024=>"+$groupMaterialId)
			}
			
			BigLightBmp=new BitmapData($maxPos.x,$maxPos.y,false,0);
			
			var loadNum:Number=0;
			var bmpArr:Array=new Array 
			
			
			for(var k:uint=0;k<$arr.length;k++)
			{
				var $lighturl:String=TerrainEditorData.fileRoot+"lightuv/"+"build"+$arr[k].id+".jpg";
				var tempObj:Object=new Object;
				tempObj.num=k;
				bmpArr.push(tempObj)
				BmpLoad.getInstance().addSingleLoad($lighturl,function ($bitmap:Bitmap,$obj:Object):void{
					$obj.bmp=$bitmap.bitmapData;
					loadEnd()
					
				},tempObj)
					
			
			}
			function loadEnd():void
			{
				loadNum=loadNum+1
				trace("loadNum",loadNum)
				if(loadNum>=$arr.length){
					for(var p:uint=0;p<bmpArr.length;p++){
						var m:Matrix=new Matrix
						m.tx=$endItem[p].x
						m.ty=$endItem[p].y
						BigLightBmp.draw(bmpArr[p].bmp,m)
					
					}
					var bitBmpUrl:String=ExpResourcesModel.getInstance().Cn2enFun("h5scene/"+getTerrainName()+"/"+$groupMaterialId+".jpg")
					FileSaveModel.getInstance().saveBitmapdataToJpg(BigLightBmp,_rootUrl+bitBmpUrl);
					
					ExpResourcesModel.getInstance().picItem.push(_rootUrl+bitBmpUrl)
						
					//ShowMc.getInstance().setBitMapData(BigLightBmp)
					$bfun($endItem,$maxPos,bitBmpUrl)
				}
			}
			
		
		}
		private function MergeOneGroupData($arr:Vector.<HierarchyFileNode>):void
		{
		
			this.mathLightUvInfo($arr,backFun)
			function backFun(rects:Vector.<Rectangle>,wh:Point,bitBmpUrl:String):void
			{
				var tempObjData:ObjData=new ObjData
				tempObjData.vertices=new Vector.<Number>
				tempObjData.uvs=new Vector.<Number>
				tempObjData.indexs=new Vector.<uint>
				tempObjData.normals=new Vector.<Number>
				tempObjData.lightUvs=new Vector.<Number>
				
				var $hierarchyFileNode:HierarchyFileNode=$arr[0]
				var pos:Vector3D=new Vector3D;
				var nrm:Vector3D=new Vector3D;
				var indexNum:Number=0
				
				var axoFileName:String
				
				for(var i:uint=0;i<$arr.length;i++)
				{
					var objData:ObjData=ProxyPan3dModel($arr[i].iModel).sprite.objData;
					var posMatrix:Matrix3D=ProxyPan3dModel($arr[i].iModel).sprite.posMatrix;
					
					axoFileName=BuildMesh($arr[i].data).prefabStaticMesh.axoFileName
					
					var lightSizeW:Number=BuildMesh($arr[i].data).lightMapSize/wh.x;
					var lightSizeH:Number=BuildMesh($arr[i].data).lightMapSize/wh.y;
					var lightSizeTX:Number=rects[i].x/wh.x
					var lightSizeTY:Number=rects[i].y/wh.y
					
						
					indexNum=tempObjData.vertices.length/3;
					for(var j:uint=0;j<objData.vertices.length/3;j++){
						pos.x=objData.vertices[j*3+0]
						pos.y=objData.vertices[j*3+1]
						pos.z=objData.vertices[j*3+2]
						pos=posMatrix.transformVector(pos)
						tempObjData.vertices.push(pos.x,pos.y,pos.z)
						
						nrm.x=objData.normals[j*3+0]
						nrm.y=objData.normals[j*3+1]
						nrm.z=objData.normals[j*3+2]
						nrm=posMatrix.transformVector(nrm)
						tempObjData.normals.push(nrm.x,nrm.y,nrm.z)
						
						
						tempObjData.uvs.push(objData.uvs[j*2+0])
						tempObjData.uvs.push(objData.uvs[j*2+1])
						
						tempObjData.lightUvs.push(objData.lightUvs[j*2+0]*lightSizeW+lightSizeTX)
						tempObjData.lightUvs.push(objData.lightUvs[j*2+1]*lightSizeH+lightSizeTY)
						
					}
					
					for(var k:uint=0;k<objData.indexs.length;k++){
						tempObjData.indexs.push(objData.indexs[k]+indexNum)
					}
					
				}
				


				var objGroupId:int=BuildMesh($hierarchyFileNode.data).groupMaterialId
				var $MaterialTree:MaterialTree=MaterialTree(BuildMesh($hierarchyFileNode.data).prefabStaticMesh.material)
				
				
				
				var $iModel:IModel=$hierarchyFileNode.iModel;
				var $tempObj:Object=new Object;
				$tempObj.type=$hierarchyFileNode.type;
				$tempObj.x=0;
				$tempObj.y=0;
				$tempObj.z=0;
				$tempObj.rotationX=0;
				$tempObj.rotationY=0;
				$tempObj.rotationZ=0;
				$tempObj.scaleX=1;
				$tempObj.scaleY=1;
				$tempObj.scaleZ=1;
				$tempObj.id=$hierarchyFileNode.id
				
				
				if(true){
					var $objURL:String=ExpResourcesModel.getInstance().Cn2enFun("h5scene/"+getTerrainName()+"/"+objGroupId+".xml");
					ExpResourcesModel.getInstance().expObjData(tempObjData,_rootUrl+$objURL);
					$tempObj.objsurl=$objURL;
				}else{
					$tempObj.objsurl=ExpResourcesModel.getInstance().expObjsByUrl(axoFileName,_rootUrl)  
				}
				
				
				$tempObj.materialurl=ExpResourcesModel.getInstance().expMaterialTreeToH5($MaterialTree,_rootUrl);
				var $lighturl:String=TerrainEditorData.fileRoot+"lightuv/"+"build"+$hierarchyFileNode.id+".jpg";
				//$tempObj.lighturl=ExpResourcesModel.getInstance().expPicByUrl($lighturl,_rootUrl)
				
				$tempObj.lighturl=bitBmpUrl
				trace(bitBmpUrl)
				_buildItem.push($tempObj)
					
				 oneByOneMergePic()
			}
		
		}


		
		private var _groupDis:Dictionary;
		/**
		 *以字典的方式存入数据 
		 * @param $hierarchyFileNode
		 * 
		 */
		private function pushBuildNodeToDis($hierarchyFileNode:HierarchyFileNode):void
		{
			var groupMaterialId:int=BuildMesh($hierarchyFileNode.data).groupMaterialId
			
			if(!_groupDis.hasOwnProperty(groupMaterialId)){
				_groupDis[groupMaterialId]=new Vector.<HierarchyFileNode>;
			}
			_groupDis[groupMaterialId].push($hierarchyFileNode)
			
		}

		
	}
}