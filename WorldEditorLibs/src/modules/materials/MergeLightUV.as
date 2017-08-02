package modules.materials
{
	import com.adobe.crypto.MD5;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import render.ground.TerrainEditorData;

	public class MergeLightUV
	{
		public function MergeLightUV()
		{
		}
		public static function getMd5():String{
			var str:String = "";
			var file:File = new File(TerrainEditorData.fileRoot+"lightuv");
			var ary:Array = file.getDirectoryListing();
			var fs:FileStream = new FileStream();
			var byte:ByteArray = new ByteArray();
			for(var i:int=0;i<ary.length;i++){
				file = ary[i];
				fs.open(file,FileMode.READ);
				fs.readBytes(byte,byte.length);
				fs.close();
			}
			return MD5.hashBytes(byte)
		}
		
		public static function getMergeData():Object{
			var file:File = new File(TerrainEditorData.fileRoot+"mergelightuv/config.txt");
			if(file.exists){
				var fs:FileStream = new FileStream();
				fs.open(file,FileMode.READ);
				var md5str:String = fs.readUTF();
				var obj:Object = fs.readObject();
				fs.close();
				var curMd5:String = MergeLightUV.getMd5();
				if(curMd5 == md5str){
					return obj;
				}else{
					return null;
				}
			}else{
				return null;
			}
			
		}
	}
}