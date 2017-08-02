package mvc.top
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	

	public class ClearH5spaceModel
	{
		private static var instance:ClearH5spaceModel;
		public function ClearH5spaceModel()
		{
		}
		public static function getInstance():ClearH5spaceModel{
			if(!instance){
				instance = new ClearH5spaceModel();
			}
			return instance;
		}
		private var selectFile:File
		public function run():void
		{
			selectFile=new File
			var txtFilter:FileFilter = new FileFilter("Text", ".gfile;*.gfile;");
			selectFile.browseForOpen("打开工程文件 ",[txtFilter]);
			selectFile.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				
				clearSpaceByFile(selectFile.parent.parent)
			}

		}
		public function runTwo():void
		{
			selectFile=new File
			selectFile.browseForDirectory("打开工程文件 ");
			selectFile.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				clearSpaceByFileTow(selectFile)
			}
			
		}
		
		private function clearSpaceByFileTow($file:File):void
		{
			rootFileUrl=$file.url+"/"
			useFileDic=new Dictionary
			allFileItem=getInFolderFile($file);
			makeUseFileKey();
			clearOther()
			while(clearEmptyDirectory($file)){
			}
			
		}
		private function clearOther():void
		{
			var anum:Number=0
			for(var i:uint=0;i<allFileItem.length;i++)
			{
				var tempUrl:String=allFileItem[i].url.replace(rootFileUrl,"");
				if(!useFileDic[tempUrl]){
					var $delFile:File=new File(rootFileUrl+tempUrl)
					
					if(unDele(tempUrl)	){
						if($delFile.exists){
							trace($delFile.url)
							$delFile.deleteFile()
							anum++
						}
					}
				}
				
			}
			Alert.show("清理了"+anum+"个文件");
			
			
		}
		private var filearr:Array=["ui","rolemovie","base","login"]
		private function unDele($url:String):Boolean
		{
			for(var i:uint=0;i<filearr.length;i++){
				var $tempUrl:String=filearr[i];
				if($url.indexOf($tempUrl)!=-1){
					return false
				}
			}
			return true
		}
	
		private function clearSpaceByFile($file:File):void
		{
			rootFileUrl=$file.url
			useFileDic=new Dictionary
				
			allFileItem=getInFolderFile($file)
			makeUseFileKey();
			clearNoUseFile(selectFile);
			while(clearEmptyDirectory($file)){
			
			}
				
		}
		private function clearEmptyDirectory($file:File):Boolean
		{
			var isHave:Boolean=false
			allFileItem=getEmpFolderFile($file)
			for each(var $tempFile:File in allFileItem){
				if($tempFile.isDirectory){
					if($tempFile.exists){
						
						trace("删除空文件夹",$tempFile.url);
						
						$tempFile.deleteDirectory()
						isHave=true
							
					}
				}
				
			}
			return isHave
			
		}
		private function getEmpFolderFile($sonFile:File):Vector.<File>
		{
			
			var $fileItem:Vector.<File>=new Vector.<File>
			
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					if($tempFile.isDirectory){

						var barr:Array=$tempFile.getDirectoryListing();
						if(barr.length>0){
							$fileItem=$fileItem.concat(getEmpFolderFile($tempFile))
						}else{
							$fileItem.push($tempFile)
						}
					}
					
				}
			}
			
			return $fileItem
		}
		
		
	
		private var allFileItem:Vector.<File>;
		private var  rootFileUrl:String

		private function clearNoUseFile($file:File):void
		{
			var anum:Number=0
			var $fsScene:FileStream = new FileStream;
			$fsScene.open($file,FileMode.READ);
			var $str:String = $fsScene.readUTFBytes($fsScene.bytesAvailable)
				
			$fsScene.close()
			var lines:Array = $str.split(LINE_FEED);
			for(var i:uint = 0; i < lines.length; i++){
				
				var tempUrl:String=trim(lines[i]);
				if(tempUrl.length>0){
				
					
					trace(rootFileUrl+"/"+tempUrl)
					
					if(!useFileDic[tempUrl]){
						var $delFile:File=new File(rootFileUrl+"/"+tempUrl)
						if($delFile.exists){
							$delFile.deleteFile()
							anum++
						}
					}
				
				}
		
				
			}
			Alert.show("清理了"+anum+"个文件");
			
		}
		private var useFileDic:Dictionary
		private function makeUseFileKey():void
		{
			for each(var $tempFile:File in allFileItem){
				if($tempFile.extension=="gfile"){
					if($tempFile.url!=selectFile.url){
						
						meshFileData($tempFile);
						
					}
				
				}
			}
			
		}
		private const LINE_FEED:String = String.fromCharCode(10);
		private function meshFileData($file:File):void
		{
			
			var $fsScene:FileStream = new FileStream;
			$fsScene.open($file,FileMode.READ);
			var $str:String = $fsScene.readUTFBytes($fsScene.bytesAvailable)
			var lines:Array = $str.split(LINE_FEED);
			for(var i:uint = 0; i < lines.length; i++){

				var tempUrl:String=trim(lines[i]);
				if(tempUrl.length){
					if(!useFileDic[tempUrl]){
						useFileDic[tempUrl]=tempUrl
					}
				}
			}

			
		}
		private function trim(str:String):String {
			return str.replace(/([ 　]{1})/g,"");
		}
		
		private function getInFolderFile($sonFile:File):Vector.<File>
		{
			
			var $fileItem:Vector.<File>=new Vector.<File>
			
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					if($tempFile.isDirectory){
						
						
						$fileItem=$fileItem.concat(getInFolderFile($tempFile))
						
						
					}else{
						
						$fileItem.push($tempFile)
					}
					
				}
			}else{
				
				$fileItem.push($sonFile)
				
			}
			
			return $fileItem
		}
		
		
	}
}