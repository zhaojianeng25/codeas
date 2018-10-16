package view.byteFile
{
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.display3D.analysis.AnalysisServer;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * mesh文件转二进制 
	 * @author liuyanfei QQ:421537900
	 * 
	 */
	public class MeshFileToByteUtils
	{
		private var uvItem:Vector.<ObjectUv>;
		private var triItem:Vector.<ObjectTri>;
		private var weightItem:Vector.<ObjectWeight>;
		private var boneItem:Vector.<ObjectBone>;
		
		private var byte:ByteArray = new ByteArray;
		
		public function MeshFileToByteUtils()
		{
		}
		/**
		 * 处理文件 
		 * @param file
		 * 
		 */		
		public function process(file:File):void{
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable)
			fs.close();
			
			var meshData:MeshData = AnalysisServer.getInstance().analysisMesh(str);
			
			uvItem = meshData.uvItem;
			triItem = meshData.triItem;
			weightItem = meshData.weightItem;
			boneItem = meshData.boneItem;
			
			writeUv();
			writeTri();
			writeWeight();
			
			if(AppDataBone.version == 2){
				writeBone();
			}
			
			byte.compress();
			
			var newUrl:String = file.parent.url + "/" + file.name.split(".")[0] + ".mb";
			var newFile:File = new File(newUrl);
			fs = new FileStream();
			fs.open(newFile,FileMode.WRITE);
			fs.writeBytes(byte,0,byte.length);
			fs.close();
			
			//删除md5mesh文件
			file.deleteFile();
		}
		/**
		 * 写入uv信息 
		 * 
		 */		
		private function writeUv():void{
			byte.writeInt(uvItem.length);
			for(var i:int;i<uvItem.length;i++){
				byte.writeFloat(uvItem[i].x);
				byte.writeFloat(uvItem[i].y);
				
				byte.writeInt(uvItem[i].a);
				byte.writeInt(uvItem[i].b);
			}
			
		}
		/**
		 * 写入index信息 
		 * 
		 */		
		private function writeTri():void{
			byte.writeInt(triItem.length);
			for(var i:int;i<triItem.length;i++){
				byte.writeInt(triItem[i].t0);
				byte.writeInt(triItem[i].t1);
				byte.writeInt(triItem[i].t2);
			}
		}
		/**
		 * 写入权重信息 
		 * 
		 */		
		private function writeWeight():void{
			byte.writeInt(weightItem.length);
			for(var i:int;i<weightItem.length;i++){
				byte.writeInt(weightItem[i].boneId);
				byte.writeFloat(weightItem[i].w);
				
				byte.writeFloat(weightItem[i].x);
				byte.writeFloat(weightItem[i].y);
				byte.writeFloat(weightItem[i].z);
				
			}
		}
		
		private function writeBone():void{
			byte.writeInt(1);
			byte.writeInt(boneItem.length);
			for(var i:int=0;i<boneItem.length;i++){
				byte.writeInt(boneItem[i].father);
				byte.writeFloat(boneItem[i].tx);
				byte.writeFloat(boneItem[i].ty);
				byte.writeFloat(boneItem[i].tz);
				
				byte.writeFloat(boneItem[i].qx);
				byte.writeFloat(boneItem[i].qy);
				byte.writeFloat(boneItem[i].qz);
			}
		}
		
	}
}