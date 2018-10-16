package modules.terrain
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.graphics.codec.JPEGEncoder;
	
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;

	public class TerrainDataSaveToData
	{
		private static var instance:TerrainDataSaveToData;
		public function TerrainDataSaveToData()
		{
		}
		public static function getInstance():TerrainDataSaveToData
		{
			
			if(!instance){
				instance=new TerrainDataSaveToData()
			}
			return instance;
		}
		public function  saveTerrainData():void
		{
			
			var file:File=new File;
			file.browseForSave("保存文件");
			file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				var saveFiledic:File = e.target as File;
				if(!(saveFiledic.extension=="data")){
					saveFiledic=new File(saveFiledic.nativePath+".data");
				}
				
				saveData(saveFiledic)
				
				Alert.show("导出地形数据完成");
			}
			
			
			
			
		}
		private function saveData($file:File):void
		{

//			var obj:Object={};
//			obj.cellX=GroundData.cellNumX   
//			obj.cellZ=GroundData.cellNumZ
//			obj.terrainMidu=GroundData.terrainMidu    
//			obj.cellScale=GroundData.cellScale
//			obj.idMapScale=GroundData.idMapScale
//			obj.sixteenUvSize=TerrainEditorData.sixteenUvSize
//			obj.sixTeenFileNodeArr=TerrainEditorData.sixTeenFileNodeArr
//			obj.sixteenUvMiduArr=TerrainEditorData.sixteenUvMiduArr
			
			var i:uint;

			var fs:FileStream = new FileStream();
			fs.open($file,FileMode.WRITE);
			fs.writeInt(GroundData.cellNumX)
			fs.writeInt(GroundData.cellNumZ)
			fs.writeShort(GroundData.terrainMidu)
			fs.writeShort(GroundData.cellScale)
			fs.writeShort(GroundData.idMapScale)
			fs.writeShort(TerrainEditorData.sixteenUvSize)
			
			fs.writeInt(TerrainEditorData.sixTeenFileNodeArr.length)
			for(i=0;i<TerrainEditorData.sixTeenFileNodeArr.length;i++){
				fs.writeUTF(TerrainEditorData.sixTeenFileNodeArr[i])   //写入图片地址
			}
			fs.writeInt(TerrainEditorData.sixteenUvMiduArr.length)
			for(i=0;i<TerrainEditorData.sixteenUvMiduArr.length;i++){
				fs.writeShort(TerrainEditorData.sixteenUvMiduArr[i])  //写入笔刷密度
			}
			var jpgEncoder:JPEGEncoder = new JPEGEncoder(100);
			var heightByte:ByteArray=jpgEncoder.encode(TerrainEditorData.bigHeightBmp)
			fs.writeInt(heightByte.length)
			fs.writeBytes(heightByte);
			
			
	
				
			fs.close();
		
			
		}
	}
}