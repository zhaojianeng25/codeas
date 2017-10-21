package modules.expres
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _me.FpsView;
	import _me.Scene_data;
	
	import common.AppData;

	public class ExpChangeAllObjsNrmModel
	{
		private static var instance:ExpChangeAllObjsNrmModel;
		private var needScanIconUrl:Vector.<String>;
		private var fs:FileStream;
		public function ExpChangeAllObjsNrmModel()
		{
			fs = new FileStream;
		}
		public static function getInstance():ExpChangeAllObjsNrmModel{
			if(!instance){
				instance = new ExpChangeAllObjsNrmModel();
			}
			return instance;
		}
		public function changeObjsnrm():void
		{
			this.needScanIconUrl=new Vector.<String>;
			getSonFile(new File(AppData.workSpaceUrl));
			
			expOneByOne()
	
		}
		private function expOneByOne():void
		{
			if(needScanIconUrl&&needScanIconUrl.length){
				var url:String=needScanIconUrl.pop();
				FpsView.strNotice=String(needScanIconUrl.length)+"=>"+decodeURI(url.replace(AppData.workSpaceUrl,""));
	
	
				var $fileObjs:File=new File(url);
				fs.open($fileObjs,FileMode.READ);
				var $obj:Object = fs.readObject();
				fs.close();
				
	
				
				if(isNaN($obj.version)){
					$obj.version=Scene_data.version;
					var tempNrmals:Vector.<Number>=new Vector.<Number>;
					for(var i:Number=0;i<$obj.normals.length/3;i++){
						tempNrmals.push($obj.normals[i*3+0])
						tempNrmals.push($obj.normals[i*3+2]*-1)  //将之前的换一下新的UV
						tempNrmals.push($obj.normals[i*3+1]*+1)
					}
					$obj.normals=tempNrmals
					fs.open($fileObjs,FileMode.WRITE);
					fs.writeObject($obj);
					fs.close();
					trace(url);
					setTimeout(expOneByOne,100)
				}else{
					expOneByOne()
				}

				
			}else{
				Alert.show("转换NRM完成")
				
			}
		}
		private function getSonFile($disFile:File):void
		{
			if($disFile.isDirectory){
				var arr:Array=$disFile.getDirectoryListing();
				for each(var $file:File in arr){
					if($file.isDirectory){
						getSonFile($file)
					}else{
						if($file.extension=="objs"){
							needScanIconUrl.push($file.url)
						}
						
					}
				}
			}
		}
	}

}