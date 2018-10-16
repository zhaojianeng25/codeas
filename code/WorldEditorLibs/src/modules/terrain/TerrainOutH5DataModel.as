package modules.terrain
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import _Pan3D.core.MathCore;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.h5.ExpResourcesModel;
	
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;

	public class TerrainOutH5DataModel
	{
		private static var instance:TerrainOutH5DataModel;
		public function TerrainOutH5DataModel()
		{
		}
		public static function getInstance():TerrainOutH5DataModel
		{
			
			if(!instance){
				instance=new TerrainOutH5DataModel()
			}
			return instance;
		}


		//生存地面信息图
		public function makeTerrainH5IdInfoByteArray(_terrainName:String):ByteArray
		{
			var $sceneFileByte:ByteArray=new ByteArray
			if(GroundData.showTerrain){
				var $terrainData:ByteArray=	this.meshIdMapArrToArr();
				$terrainData.writeUTF("map/"+_terrainName+"/six.jpg");
				$terrainData.compress();
				$sceneFileByte.writeInt($terrainData.length)
				$sceneFileByte.writeBytes($terrainData,0,$terrainData.length);
			}else{
				$sceneFileByte.writeInt(0);
			}
			return $sceneFileByte;
		}
		private function  meshIdMapArrToArr():ByteArray
		{
			var $byte:ByteArray=new ByteArray;
			var bigIdMapBmp:BitmapData=	TerrainEditorData.bigIdMapBmp;
			var bigInfoMapBmp:BitmapData=	TerrainEditorData.bigInfoMapBmp;
			var $tw:Number=bigIdMapBmp.width/GroundData.cellNumX;
			var $th:Number=bigIdMapBmp.height/GroundData.cellNumZ;
			
			$byte.writeInt(GroundData.cellNumX);
			$byte.writeInt(GroundData.cellNumZ);
			var $maxIdeNum:Number=3  //最大索引编号，和小图数量-1
			for(var i:Number=0;i<GroundData.cellNumX;i++){
				for(var j:Number=0;j<GroundData.cellNumZ;j++){
					var $pos:Point=new Point(i*$tw,j*$th);
					$byte.writeInt(i);
					$byte.writeInt(j);
					$byte.writeInt($tw);
					$byte.writeInt($th);
					for(var k:Number=0;k<$tw;k++){
						for(var h:Number=0;h<$th;h++){
							var $pId:Vector3D=MathCore.hexToArgb(bigIdMapBmp.getPixel32(k+$pos.x,h+$pos.y));
							var $pinfo:Vector3D=MathCore.hexToArgb(bigInfoMapBmp.getPixel32(k+$pos.x,h+$pos.y));
						    $pId.x=Math.min(Math.max($pId.x,0),$maxIdeNum);
							$pId.y=Math.min(Math.max($pId.y,0),$maxIdeNum);
							$pId.z=Math.min(Math.max($pId.z,0),$maxIdeNum);
							if($pId.x<$pId.y&&$pId.y<$pId.z){
								//排序正常
							}else{
								this.changeIndexIdInfo($pId,$pinfo)
							}
							$byte.writeByte(this.getIndxByIdVec($pId))
								
							if(($pinfo.x+$pinfo.y)>255){
								var kscale:Number=255/($pinfo.x+$pinfo.y);
								$pinfo.x=Math.floor($pinfo.x*kscale);
								$pinfo.y=Math.floor($pinfo.y*kscale);
							}
							$byte.writeByte($pinfo.x-128);  //只写两从头位，最后用减法得到 加起来为255
							$byte.writeByte($pinfo.y-128);
						}
					}
				}
			}
			return $byte;
		}
		private function getIndxByIdVec($pId:Vector3D):Number
		{
			var $str:String=String($pId.x)+String($pId.y)+String($pId.z);
			var $indexKey:Number=0
			switch($str)
			{
				case "012":
				{
					$indexKey=0
					break;
				}
				case "013":
				{
					$indexKey=1
					break;
				}
				case "023":
				{
					$indexKey=2
					break;
				}
				case "123":
				{
					$indexKey=3
					break;
				}
				default:
				{
					throw new Error("没有组合:"+$str)
					break;
				}
			}
			
			
		    return $indexKey
		}
		
		//组成一个顺序排列的索引信息图
		private function changeIndexIdInfo($pId:Vector3D,$pinfo:Vector3D):void
		{
			var $baseID:Array=[0,1,2]; //空出对象
			var $idArr:Array=new Array();
			function pushToNew($i:Number,$num:Number):void{
				var $isTrue:Boolean=true
				for(var j:Number=0;j<$idArr.length;j++){
					if($idArr[j].i==$i){
						$isTrue=false
						$idArr[j].num+=$num;
					}
				}
				if($isTrue){//没有时添加
					$idArr.push({i:$i ,num:$num});
				}
			}
			function getEmpty():Object{
				var $canUseId:Number;
				for(var i:Number=0;i<$baseID.length;i++){
					var $isTrue:Boolean=true
					for(var j:Number=0;j<$idArr.length;j++){
						if($idArr[j].i==$baseID[i]){
							$isTrue=false
						}
					}
					if($isTrue){
						$canUseId=i
					}
				}
				return {i:$canUseId ,num:0}  //插入一个空的编号
			}
			pushToNew($pId.x,$pinfo.x)
			pushToNew($pId.y,$pinfo.y)
			pushToNew($pId.z,$pinfo.z)
			while($idArr.length<3){
				$idArr.push(getEmpty())
			}
			

			$idArr.sortOn("i",Array.CASEINSENSITIVE | Array.NUMERIC); 
			
			$pId.x=$idArr[0].i;
			$pId.y=$idArr[1].i;
			$pId.z=$idArr[2].i;
				
			$pinfo.x=$idArr[0].num;
			$pinfo.y=$idArr[1].num;
			$pinfo.z=$idArr[2].num;
		}
		
	//	private var _saveTourl:String="file:///E:/codets/game/arpg/arpg/res/map/terrain/"
		public function  savesixteenBigJpg(_rootUrl:String,_terrainName:String):void
		{
			if(GroundData.showTerrain){
				if(TerrainEditorData.sixteenslotBmpArr.length!=4){
				    Alert.show("地面贴图数量导出H5斩时设置为4种")
				}
				TerrainEditorData.sixteenUvSize=256
				var $num128:Number=TerrainEditorData.sixteenUvSize;
				var $bigBitmapData:BitmapData=new BitmapData($num128*2,$num128*2);
				for(var i:uint=0;i<TerrainEditorData.sixteenslotBmpArr.length;i++)
				{
					var $pos:Point=new Point();
					$pos.x=(i%2)*$num128
					$pos.y=Math.floor(i/2)*$num128
					var $bmp:BitmapData=TerrainEditorData.sixteenslotBmpArr[i];
					var $m:Matrix=new Matrix();
					$m.scale($num128/$bmp.width,$num128/$bmp.height)
					$m.tx=$pos.x;
					$m.ty=$pos.y;
					$bigBitmapData.draw($bmp,$m);
				}
				var $sixTeemUrl:String = this.getSixUrl(_rootUrl,_terrainName);

				FileSaveModel.getInstance().saveBitmapdataToJpg($bigBitmapData,$sixTeemUrl)
				ExpResourcesModel.getInstance().picItem.push($sixTeemUrl);
			}
		}
		private function getSixUrl(_rootUrl:String,_terrainName:String):String
		{
			var $sixTeemUrl:String = _rootUrl + "map/"+_terrainName+"/six.jpg"
			return $sixTeemUrl;
		}

		
	}
}