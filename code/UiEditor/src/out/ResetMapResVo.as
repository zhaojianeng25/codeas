package out
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import spark.components.Alert;
	
	public class ResetMapResVo extends ResetResVo
	{
		public static var finishFun:Function;
		public function ResetMapResVo($byte:ByteArray)
		{
			super($byte);
			this.version=  baseByte.readInt();
			
			trace(this.version)
		}
		public static function chuangeFileByFile($file:File ):void
		{
			
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.READ);
			var _byte:ByteArray=new ByteArray;
			$fs.readBytes(_byte,0,$fs.bytesAvailable)
			$fs.close();
			
			var $ResetResMapVo:ResetMapResVo=new ResetMapResVo(_byte);
			
			$ResetResMapVo.read()
			$ResetResMapVo.read()
			$ResetResMapVo.read()
			$ResetResMapVo.read()
				
			$ResetResMapVo.saveFile($file)
		 
			
			
		}
		public static  function oneByOne():void
		{
			
			if(ResetResVo.outFileItem.length){
				var temp:File= ResetResVo.outFileItem.pop();
				ResetMapResVo.chuangeFileByFile(temp)
				setTimeout(oneByOne,100)
	 
			}else{
				if(Boolean(ResetSkillResVo.finishFun)){
					ResetSkillResVo.finishFun()
					return;
				}
				if(ResetResVo.nofileItem.length){
					var $tipStr:String="";
					for(var i:Number=0;i<ResetResVo.nofileItem.length&&i<10;i++){
						$tipStr+=ResetResVo.nofileItem[i] +"\n";
					}
					if(ResetResVo.nofileItem.length>10){
						$tipStr+="\n---共有"+ResetResVo.nofileItem.length+"文件需要补充";
					}
					Alert.show($tipStr,"缺省文件");
				}else{
					Alert.show("转换完成","完成");
				}
			}
			
		}
	}
}