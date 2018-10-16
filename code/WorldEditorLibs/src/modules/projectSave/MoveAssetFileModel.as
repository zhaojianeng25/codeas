package modules.projectSave
{
	import flash.filesystem.File;
	
	import common.AppData;

	public class MoveAssetFileModel
	{
		private static var instance:MoveAssetFileModel;
		public function MoveAssetFileModel()
		{
		}
		public static function getInstance():MoveAssetFileModel{
			if(!instance){
				instance = new MoveAssetFileModel();
			}
			return instance;
		}
		public function moveAsSetFile():void
		{
		
			if(new File(AppData.workSpaceUrl).exists){
	
				var a:File=File.applicationDirectory
				var b:File=new File(a.url+"assets/materials")
				var fileAry:Array = b.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					
					var tempFile:File=File(fileAry[i])
					var $tourl:String=AppData.workSpaceUrl+"assets/"+tempFile.name;
					if(!Boolean(new File($tourl).exists)){
						var destination:File = File.documentsDirectory;
						destination = destination.resolvePath($tourl);
						tempFile.copyTo(destination, true);
					}
			
				}
			}
			
	
			
		
	     
		}
		
		
	}
}