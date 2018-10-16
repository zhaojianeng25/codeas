package modules.hierarchy.h5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	
	import _Pan3D.base.ObjData;
	
	import common.AppData;
	
	import modules.materials.MergeLightUV;
	
	import render.ground.TerrainEditorData;

	public class ExpMergLightUvOnlyObj
	{
		private static var instance:ExpMergLightUvOnlyObj;
		public function ExpMergLightUvOnlyObj()
		{
		}
		public static function getInstance():ExpMergLightUvOnlyObj{
			if(!instance){
				instance = new ExpMergLightUvOnlyObj();
			}
			return instance;
		}
		public function mergBuildModeObj($buildItem:Array,$rootUrl:String):void
		{

			if(MergeLightUV.getMergeData()){
				var _rootUrl:String=$rootUrl;
				for(var i:Number=0;i<$buildItem.length;i++){
					var $tempObj:Object=$buildItem[i]
					if($tempObj.merg){
						var $expMergLightVO:ExpMergLightVO=this.getMergeDataById($tempObj.id);
						var $baseObjUrl:String=$tempObj.mergUrl;
						var $url:String=this.expObjsByUrl($baseObjUrl,_rootUrl,$expMergLightVO);


						var $lighturl:String=TerrainEditorData.fileRoot+"mergelightuv/"+"build"+$expMergLightVO.imageid+".jpg";
						$tempObj.lighturl=ExpResourcesModel.getInstance().expPicByUrl($lighturl,_rootUrl)
						$tempObj.objsurl=$url;
					}
				}
				trace("----------------------");
			}
		}
		public function expObjsByUrl($objsUrl:String,$root:String,$mergeData:ExpMergLightVO):String
		{
			$objsUrl=$objsUrl.replace(AppData.workSpaceUrl,"")
			var objsFile:File=new File(AppData.workSpaceUrl+$objsUrl)
			var toXmlUrl:String=decodeURI($root)+ExpResourcesModel.getInstance().Cn2enFun($objsUrl.replace(".objs",".xml"))
			toXmlUrl=toXmlUrl.replace(".xml","_merg.xml");
			this.setObjsToxml(objsFile,toXmlUrl,$mergeData)
			ExpResourcesModel.getInstance().objsItem.push(toXmlUrl)
			return toXmlUrl.replace(decodeURI($root),"");
		}
		private function setObjsToxml($file:File,$toFileUrl:String,$mergeData:ExpMergLightVO):void
		{
			if($file.extension=="objs"){
				var $fs:FileStream = new FileStream;
				if($file.exists){
					$fs.open($file,FileMode.READ);
					var $objList:Object = $fs.readObject();
					var $hasPbr:Boolean=ExpH5ByteModel.getInstance().usePbrUrlObj[$file.url]
					var $hasNormal:Boolean=ExpH5ByteModel.getInstance().useNormalUrlObj[$file.url]
					var $hasDirectLight:Boolean=ExpH5ByteModel.getInstance().directLightUrlObj[$file.url];
					
					var $keyObj:ObjData=this.makeMergeObjData($objList,$mergeData)
					ExpResourcesModel.getInstance().writeFile($keyObj,$toFileUrl,$hasNormal,$hasPbr,$hasDirectLight)
				}
			}
		}
		private function makeMergeObjData($obj:Object,$mergeData:ExpMergLightVO):ObjData
		{
			var $objData:ObjData=new ObjData;
			$objData.vertices=$obj.vertices
			$objData.uvs=$obj.uvs
			$objData.lightUvs=$obj.lightUvs
			$objData.lightUvs=new Vector.<Number>;
			
			var tw:Number=$mergeData.width/$mergeData.imagewidht;
			var th:Number=$mergeData.height/$mergeData.imageheight;
			var tx:Number=	$mergeData.x/$mergeData.imagewidht;
			var ty:Number=	$mergeData.y/$mergeData.imageheight;
			
			for(var i:Number=0;i<$obj.lightUvs.length/2;i++){
				var uv:Point=new Point()
				uv.x=$obj.lightUvs[i*2+0]*tw;
				uv.y=$obj.lightUvs[i*2+1]*th;
				uv.x=uv.x+tx
				uv.y=uv.y+ty
					
				$objData.lightUvs.push(uv.x);
				$objData.lightUvs.push(uv.y);
			
			}
				
			$objData.normals=$obj.normals
			$objData.indexs=$obj.indexs
			return $objData
		}
		private function getMergeDataById($id:Number):ExpMergLightVO
		{
			var $itemObj:Object=MergeLightUV.getMergeData();
			for(var i:Number=0;i<$itemObj.length;i++){
				if($itemObj[i].id==$id){
					
					var $vo:ExpMergLightVO=new ExpMergLightVO()
					$vo.x=$itemObj[i].x
					$vo.y=$itemObj[i].y
					$vo.width=$itemObj[i].width
					$vo.height=$itemObj[i].height
					$vo.id=$itemObj[i].id
					$vo.imageid=$itemObj[i].imageid
					$vo.imagewidht=$itemObj[i].imagewidht
					$vo.imageheight=$itemObj[i].imageheight
					
					return $vo
				}
			}
			return null
			
		}
		
	}
}