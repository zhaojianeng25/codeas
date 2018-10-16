package modules.terrain
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.core.MathCore;
	
	import _me.FpsView;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	import terrain.GroundMath;

	public class TerrainDataSaveToA3D
	{
		private static var instance:TerrainDataSaveToA3D;
		public function TerrainDataSaveToA3D()
		{
		}
		public static function getInstance():TerrainDataSaveToA3D
		{
			
			if(!instance){
				instance=new TerrainDataSaveToA3D()
			}
			return instance;
		}
		private var _outRootUrl:String
	    public  function toDo($urlRoot:String):void
		{
			_outRootUrl=$urlRoot
			if(TerrainEditorData.sixTeenFileNodeArr.length<=0){
				return ;
			}
			setTimeout(saveSixteenPic,1000)
			saveUvInfo()
		}
		private var cellItem:Vector.<Vector3D>
		private function saveUvInfo():void
		{
			cellItem=new Vector.<Vector3D>
			for(var i:uint=0;i<GroundData.cellNumX;i++)
			{
				for(var j:uint=0;j<GroundData.cellNumZ;j++)
				{
				
					cellItem.push(new Vector3D(i,0,j))
				}
			}
			drawTempCellUvInfo()
		}
		private function drawTempCellUvInfo():void
		{
			if(cellItem.length<=0){
				FpsView.strNotice=""
				Alert.show("场景导出a3d地面信息完毕");
				return ;
			}
			
			var writeData:Object = new Object;
			
			
			var kkk:Vector3D=cellItem.pop()
			var cellx:uint=kkk.x
			var cellz:uint=kkk.z
			
			FpsView.strNotice= cellx+"-"+cellz+"正在输出: "+uint((1-cellItem.length/(GroundData.cellNumX*GroundData.cellNumZ))*100)+"%";
				
			var $num:uint=Math.ceil(Math.LOG2E *Math.log(TerrainEditorData.sixTeenFileNodeArr.length))
			var $num40:uint=GroundMath.getInstance().Area_Cell_Num;
			var ID_MAP_SCALE:uint=GroundMath.getInstance().ID_MAP_SCALE;
			var $idMapBmp:BitmapData=new BitmapData($num40*ID_MAP_SCALE,$num40*ID_MAP_SCALE,false,MathCore.argbToHex16(2,1,1))
			var $infoBmp:BitmapData=new BitmapData($num40*ID_MAP_SCALE,$num40*ID_MAP_SCALE,false,MathCore.argbToHex16(255/3,255/3,255/3))
			
			$idMapBmp.copyPixels(TerrainEditorData.bigIdMapBmp,new Rectangle((cellx*$num40*ID_MAP_SCALE),(cellz*$num40*ID_MAP_SCALE),$idMapBmp.width,$idMapBmp.height),new Point)
			$infoBmp.copyPixels(TerrainEditorData.bigInfoMapBmp,new Rectangle((cellx*$num40*ID_MAP_SCALE),(cellz*$num40*ID_MAP_SCALE),$idMapBmp.width,$idMapBmp.height),new Point)

			var bmpArr:Vector.<BitmapData>=new Vector.<BitmapData>
			for(var k:uint=0;k<TerrainEditorData.sixTeenFileNodeArr.length;k++){
				var $tempinfoBmp:BitmapData=new BitmapData($infoBmp.width,$infoBmp.height,false,0x000000);
				bmpArr.push($tempinfoBmp)
			}
			
			for(var i:uint=0;i<$idMapBmp.width;i++)
			{
				for(var j:uint=0;j<$idMapBmp.height;j++)
				{
					var $idV:Vector3D=MathCore.hexToArgb($idMapBmp.getPixel(i,j));
					var $colorV:Vector3D=MathCore.hexToArgb($infoBmp.getPixel(i,j));
					
					var $id:uint
					var $color:uint
					
					$colorV.x=0xFF-$colorV.y-$colorV.z
						
					$id=Math.min($idV.x,bmpArr.length-1)
					$color=$colorV.x
					bmpArr[$id].setPixel(i,j,0xffffff*$color/0xFF)
						
					$id=Math.min($idV.y,bmpArr.length-1)
					$color=$colorV.y
					bmpArr[$id].setPixel(i,j,0xffffff*$color/0xFF)
						
					$id=Math.min($idV.z,bmpArr.length-1)
					$color=$colorV.z
					bmpArr[$id].setPixel(i,j,0xffffff*$color/0xFF)

				}
			}
			
			
			for(var l:uint=0;l<bmpArr.length;l++){
				var $w:uint=Math.pow(2,Math.ceil(Math.LOG2E *Math.log(bmpArr[l].width)))
		        var $b:BitmapData=new BitmapData($w,$w,false,0x000000)
				var $m:Matrix=new Matrix;
				$m.scale($w/bmpArr[l].width,$w/bmpArr[l].height)
				$b.draw(bmpArr[l],$m)
				bmpArr[l]=$b.clone()
				savePic(_outRootUrl+"terrain/"+"info"+cellx+"_"+cellz+"by"+l+".jpg",	$b)
			}
			
			var width:int = bmpArr[0].width;
			var height:int = bmpArr[0].height;
			
			for(var d:int=0;d<width;d++){
				for(var h:int=0;h<height;h++){
					var num:int = 0;
					for(var s:int=0;s<bmpArr.length;s++){
						num += MathCore.hexToArgb(bmpArr[s].getPixel(d,h),false).x;
					}
					if(num!=255){
						trace(i,j,num);
					}
				}
			}
		
			
			var imgAry:Array = new Array;
			for(l=0;l<bmpArr.length;l++){
				var obj:Object = new Object;
				obj.infoImg = "info"+cellx+"_"+cellz+"by"+l+".jpg";
				obj.brushImg = "sixteen" + l + ".jpg";
				obj.density = TerrainEditorData.sixteenUvMiduArr[l];
				imgAry.push(obj);
			}
			var numID:int = cellx * GroundData.cellNumZ + cellz;
			writeData.img = imgAry;
			writeData.ver = TerrainDataSaveToObj.getTerrainToByteObj(GroundManager.getInstance().terrainArr[numID]);
			writeData.x = cellx * GroundMath.getInstance().Area_Size;
			writeData.z = cellz * GroundMath.getInstance().Area_Size;
			var file:File = new File(_outRootUrl+"terrain/terrain" + numID + ".data");			
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			fs.writeObject(writeData);
			fs.close();
			
			setTimeout(drawTempCellUvInfo,100)
			
		}
		
		private function saveSixteenPic():void
		{

			var $bmp:BitmapData=new BitmapData(TerrainEditorData.sixteenUvSize,TerrainEditorData.sixteenUvSize,false,0xff0000)
			var $finishNum:uint=0
			for(var i:uint=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++){
				var $url:String=TerrainEditorData.workSpaceUrl+TerrainEditorData.sixTeenFileNodeArr[i];
				BmpLoad.getInstance().addSingleLoad($url,function ($bitmap:Bitmap,$obj:Object):void{
					var $m:Matrix=new Matrix
					
					$m.scale(TerrainEditorData.sixteenUvSize/$bitmap.bitmapData.width,TerrainEditorData.sixteenUvSize/$bitmap.bitmapData.height)
					$bmp.draw($bitmap.bitmapData,$m)
					savePic(_outRootUrl+"terrain/"+"sixteen"+$obj.id+".jpg",$bmp)
				},{id:i})
			}	
			
		}
		private  var jpgEncoder:JPEGEncoder;
		private  function savePic($picUrl:String,$bmp:BitmapData):void
		{
			if(!jpgEncoder){
				jpgEncoder = new JPEGEncoder(100);
			}
			var by:ByteArray;
			var bd:BitmapData;
			var fs:FileStream = new FileStream();
			
			var file:File = new File($picUrl);			
			fs.open(file,FileMode.WRITE);
			by = jpgEncoder.encode($bmp);
			by.position = 0;
			fs.writeBytes(by);
			by.clear();
			by = null;
			fs.close();
		}
		
	}
}