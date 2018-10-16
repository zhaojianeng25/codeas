package out
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	import tempest.data.map.MapConfig;

	public class OutShderByTxt
	{
		private static var instance:OutShderByTxt;
		public function OutShderByTxt()
		{
		}
		public static function getInstance():OutShderByTxt{
			if(!instance){
				instance = new OutShderByTxt();
			}
			return instance;
		}
		
		public  function run():void
		{
			var $file:File=new File;
			//var txtFilter:FileFilter = new FileFilter("Text", ".xml;*.xml;");
			var txtFilter:FileFilter = new FileFilter("Text",".txt;*.TXT;");
			$file.browseForOpen("打开导入的文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
			
				readAST($file)
			}
		}
		private function outTrace($str:String):void
		{
		
			if($str.length>5){
			
				trace($str)
			}
			
		}
		private function readAST($file:File):void
		{
			var $fs:FileStream = new FileStream();   
			$fs.open($file,FileMode.READ);    
			var  $baseStr:String=$fs.readUTFBytes($fs.bytesAvailable);
			$fs.close();
		
			var configText:Array=$baseStr.split("\n");
			for(var i:Number=0;i<configText.length;i++){
				var $tempStr:String=configText[i];
				$tempStr=	$tempStr.replace("\r","")
					
			    var $arr:Array=	$tempStr.split(";")	
				var $outstr:String=""
				if($arr.length>1){
					for(var j:Number=0;j<$arr.length;j++){
						var $tempStrB:String=$arr[j];
						if(j<($arr.length-1)){
							$outstr="\""+$arr[j]+";\\n\"+";
						}else{
							$outstr="\""+$arr[j]+"\\n\"+";
							
						}
						outTrace($outstr)
					}
				}else{
					 $outstr="\""+$tempStr+"\\n\"+";
					 outTrace($outstr)
				}
	
			
			}

			
		}
	}
}