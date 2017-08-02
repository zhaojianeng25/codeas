package modules.terrain
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.utils.Cn2en;
	
	import common.AppData;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.h5.ExpH5ByteModel;
	
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
		private var _saveTourl:String="file:///E:/codets/game/arpg/arpg/res/map/terrain/"
		private function outH5Data():void{
			
			var $fileUrl:String=_saveTourl+"1.txt";
			var fs:FileStream = new FileStream;
			fs.open(new File($fileUrl),FileMode.WRITE);
			
			var $sceneFileByte:ByteArray=new ByteArray;
			
//			var a:ByteArray=this.meshIdMapData();
//			var b:ByteArray=this.meshInfoMapData();
//			$sceneFileByte.writeBytes(a,0,a.length);
//			$sceneFileByte.writeBytes(b,0,b.length);
			
			var c:ByteArray=this.meshIdMapArrToArr();
			$sceneFileByte.writeBytes(c,0,c.length);

			fs.writeBytes($sceneFileByte,0,$sceneFileByte.length);		
			fs.close();
			
		}
		//生存地面信息图
		public function makeTerrainH5IdInfoByteArray():ByteArray
		{
			var $sceneFileByte:ByteArray=new ByteArray
			if(GroundData.showTerrain){
				var $terrainData:ByteArray=	this.meshIdMapArrToArr()
				$sceneFileByte.writeInt($terrainData.length)
				$sceneFileByte.writeBytes($terrainData,0,$terrainData.length);
				this.savesixteenBigJpg();
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
		
		
		private function  savesixteenBigJpg():void
		{
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
			var $sixTeemUrl:String=_saveTourl+"six.jpg";
			FileSaveModel.getInstance().saveBitmapdataToJpg($bigBitmapData,$sixTeemUrl)
			
		}

		/*
		public function Cn2enFun($str:String):String
		{
			
			return Cn2en.toPinyin(decodeURI($str))
		}
		private function  savesixteenBmpurl():ByteArray
		{
			var $byte:ByteArray=new ByteArray;
			for(var i:uint=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++)
			{
				var $fileName:String=AppData.workSpaceUrl+TerrainEditorData.sixTeenFileNodeArr[i]
				var $file:File=new File($fileName)
				if($file.exists){
					var $newFileName:String=Cn2enFun($file.name);
					var $tourl:String=_saveTourl+"b"+i+"_"+$newFileName;
					$byte.writeUTF($newFileName);
					var destination:File = File.documentsDirectory;
					destination = destination.resolvePath($tourl);
					$file.copyTo(destination, true);
				}else{
					Alert.show("文件不存在",$file.url);
				}
			}
			return $byte
			
		}

		private function meshIdMapData():ByteArray
		{
			var bigIdMapBmp:BitmapData=	TerrainEditorData.bigIdMapBmp
			var $byte:ByteArray=new ByteArray;
			$byte.writeInt(bigIdMapBmp.width)
			$byte.writeInt(bigIdMapBmp.height)
			for(var i:Number=0;i<bigIdMapBmp.width;i++)
			{
				var $str:String="";
				for(var j:Number=0;j<bigIdMapBmp.height;j++)
				{
					var $p:Vector3D=	MathCore.hexToArgb(bigIdMapBmp.getPixel32(i,j));
					$byte.writeByte($p.x-128);
					$byte.writeByte($p.y-128);
					$byte.writeByte($p.z-128);
				}
			}
			return $byte;
		}
		private function meshInfoMapData():ByteArray
		{
			var bigInfoMapBmp:BitmapData=	TerrainEditorData.bigInfoMapBmp
			var $byte:ByteArray=new ByteArray;
			$byte.writeInt(bigInfoMapBmp.width)
			$byte.writeInt(bigInfoMapBmp.height)
			for(var i:Number=0;i<bigInfoMapBmp.width;i++)
			{
				var $str:String=""
				for(var j:Number=0;j<bigInfoMapBmp.height;j++)
				{
					var $p:Vector3D=MathCore.hexToArgb(bigInfoMapBmp.getPixel32(i,j));
					$byte.writeByte($p.x-128);
					$byte.writeByte($p.y-128);
					$byte.writeByte($p.z-128);

				}
			}
			return $byte
		}
		*/
	}
}