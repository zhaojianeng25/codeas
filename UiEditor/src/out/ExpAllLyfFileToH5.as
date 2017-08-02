package out
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;

	public class ExpAllLyfFileToH5
	{
		private static var instance:ExpAllLyfFileToH5;
		public function ExpAllLyfFileToH5()
		{
		}
		public static function getInstance():ExpAllLyfFileToH5{
			if(!instance){
				instance = new ExpAllLyfFileToH5();
			}
			return instance;
		}
	
		public function  getFileDicLyfName():void
		{
			//E:\codets\game\arpg\arpg\res\role
			//var baseURL:String="file:///C:/Users/liuxingsheng/Desktop/stuff/webgl/WebGLEngine/assets/ui/data.h5ui"
			var baseURL:String="file:///E:/codets/game/arpg/arpg/res/lyf"
			var $file:File=new File(baseURL)
			var $dis:Dictionary=new Dictionary;
			var $fileArrStr:Array=new Array()
			if($file.exists){
				var eeee:Array=$file.getDirectoryListing();
				var fs:FileStream = new FileStream();    
				for(var i:Number=0;i<eeee.length;i++)
				{
					var sonFile:File=eeee[i];
					
					if(sonFile.exists&&!sonFile.isDirectory){
						
						fs.open(sonFile,FileMode.READ);    
						if($dis.hasOwnProperty(fs.bytesAvailable)){
							//trace("不需要",sonFile.name)
							
						}else{
							$dis[fs.bytesAvailable]=true;
							var $name:String=sonFile.name;
							
							
								$fileArrStr.push($name.replace(".txt",""))
							
						}
						
					}
				}
				
				var $outStr:String=""
				for(var j:Number=0;j<$fileArrStr.length;j++){
					$outStr+=($fileArrStr[j]);
					$outStr+=","
				}
				trace($outStr)
				
			}
		}
		public function  getFileDicName():void
		{
			//E:\codets\game\arpg\arpg\res\role
			//var baseURL:String="file:///C:/Users/liuxingsheng/Desktop/stuff/webgl/WebGLEngine/assets/ui/data.h5ui"
			var baseURL:String="file:///E:/codets/game/arpg/arpg/res/role"
			var $file:File=new File(baseURL)
			var $dis:Dictionary=new Dictionary;
			var $fileArrStr:Array=new Array()
			if($file.exists){
				var eeee:Array=$file.getDirectoryListing();
				var fs:FileStream = new FileStream();    
				for(var i:Number=0;i<eeee.length;i++)
				{
					var sonFile:File=eeee[i];
					
					if(sonFile.exists&&!sonFile.isDirectory){
						
						fs.open(sonFile,FileMode.READ);    
						if($dis.hasOwnProperty(fs.bytesAvailable)){
							//trace("不需要",sonFile.name)
							
						}else{
							$dis[fs.bytesAvailable]=true;
							var $name:String=sonFile.name;
							
							if(Number($name.replace(".txt",""))>0){
								$fileArrStr.push(Number($name.replace(".txt","")))
							}
						}
						
					}
				}
				
				var $outStr:String=""
				for(var j:Number=0;j<$fileArrStr.length;j++){
					$outStr+=($fileArrStr[j]);
					$outStr+=","
				}
				trace($outStr)
				
			}
		}

			
	}
}