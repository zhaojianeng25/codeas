package modules.materials.view
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	import materials.MaterialTreeParam;

	public class MaterialTreeManager
	{
		public function MaterialTreeManager()
		{
		}
		
		private static var dic:Object = new Object;
		private static var dicIns:Object = new Object;
		
		public static function getMaterial($url:String):MaterialTree{
			if(dic[$url]){
				return dic[$url];
			}
			
			var file:File = new File($url);
			var fs:FileStream = new FileStream;
			if(file.exists){
				fs.open(file,FileMode.READ);
				var obj:Object = fs.readObject();
				fs.close();
				
				var materailTree:MaterialTree = new MaterialTree;
				materailTree.url = $url.replace(Scene_data.fileRoot,"");
				materailTree.setData(obj);
				dic[$url] = materailTree;
				
				return materailTree;
			}else{
				return null
			}
			
			
		}
		
		public static function getMaterialInstance($url:String):MaterialTreeParam{
			if(dicIns[$url]){
				return dicIns[$url];
			}
			
			var file:File = new File($url);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			fs.close();
			
			var mtp:MaterialTreeParam = new MaterialTreeParam;
			var $material:MaterialTree = getMaterial(Scene_data.fileRoot + obj.materialUrl);
			mtp.setData(obj,$material);
			dicIns[$url] = mtp;
			
			return mtp;
			
		}
		
	}
}