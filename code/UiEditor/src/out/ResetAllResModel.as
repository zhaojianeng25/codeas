package out
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import spark.components.Alert;
	
	import modules.scene.sceneSave.FilePathManager;

	public class ResetAllResModel
	{
		public function ResetAllResModel()
		{
		}
		
		private static var instance:ResetAllResModel;
		
		public static function getInstance():ResetAllResModel{
			if(!instance){
				instance = new ResetAllResModel();
			}
			return instance;
		}
		private var resFile:File
		public function run():void
		{
			
			resFile=new File()
			resFile.browseForDirectory("选择导出res路径");
			resFile.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				ResetResVo.nofileItem=[];
				ResetResVo.resRootFile=resFile.nativePath+"/";
			
				changeResetSkillRes(function ():void{
					changeResetRoleRes(function ():void{
						changeResetMapRes(function ():void{
							changeResetModelRes();
						});
					});
				});
			 
			  
			} 
		}
		private function changeResetModelRes(bfun:Function=null):void
		{
		
			ResetResVo.outFileItem=new Vector.<File>;
			var $roleDirectoryFile:File=new File(resFile.nativePath+"/model")
			if($roleDirectoryFile.exists&&$roleDirectoryFile.isDirectory){
				var fileAry:Array = $roleDirectoryFile.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					var $roleFile:File=fileAry[i];
					if($roleFile.extension=="txt" && $roleFile.name.indexOf("base.txt")==-1)
					{
						ResetResVo.outFileItem.push($roleFile)
					}
				}
				ResetModelResVo.oneByOne()
			}else{
				bfun&&bfun()
				Alert.show("没有model文件夹")
			}
			
			
		}
		private function changeResetMapRes(bfun:Function=null):void
		{
			
			ResetResVo.outFileItem=new Vector.<File>;
			var $roleDirectoryFile:File=new File(resFile.nativePath+"/map")
			if($roleDirectoryFile.exists&&$roleDirectoryFile.isDirectory){
				var fileAry:Array = $roleDirectoryFile.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					var $roleFile:File=fileAry[i];
					if($roleFile.extension=="txt" && $roleFile.name.indexOf("base.txt")==-1)
					{
						ResetResVo.outFileItem.push($roleFile)
					}
				}
				ResetMapResVo.oneByOne()
			}else{
				bfun&&bfun()
				Alert.show("没有role文件夹")
			}
			
			
		}
		private function changeResetRoleRes(bfun:Function=null):void
		{
 
			ResetResVo.outFileItem=new Vector.<File>;
			var $roleDirectoryFile:File=new File(resFile.nativePath+"/role")
			if($roleDirectoryFile.exists&&$roleDirectoryFile.isDirectory){
				var fileAry:Array = $roleDirectoryFile.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
					var $roleFile:File=fileAry[i];
					if($roleFile.extension=="txt" && $roleFile.name.indexOf("base.txt")==-1)
					{
						ResetResVo.outFileItem.push($roleFile)
					}
				}
				ResetRoleResVo.oneByOne()
			}else{
				bfun&&bfun()
				Alert.show("没有role文件夹")
			}
		
		
		}
		
		public function changeResetSkillRes(bfun:Function=null):void
		{
			var $skilDirectoryFile:File=new File(resFile.nativePath+"/skill")
			ResetResVo.outFileItem=new Vector.<File>;
			ResetSkillResVo.finishFun=bfun;
			if($skilDirectoryFile.exists&&$skilDirectoryFile.isDirectory){
				var fileAry:Array = $skilDirectoryFile.getDirectoryListing();
				for(var i:int=0;i<fileAry.length;i++){
				   var $skillFile:File=fileAry[i];
				  if($skillFile.name.indexOf("base_byte")==-1 &&!$skillFile.isDirectory &&$skillFile.name.indexOf("byte.txt")!=-1)
				  {
					  ResetResVo.outFileItem.push($skillFile)
				  }
				}
				ResetSkillResVo.oneByOne()
			}else{
				bfun&&bfun()
					
				Alert.show("没有skill文件夹")
			}
			
		
		}

	 

		 
	}
}