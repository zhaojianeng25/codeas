package modules.hierarchy.h5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	
	public class ExpAllSpaceLyfToH5 extends ExpGroupToH5Model
	{
		private static var instance:ExpAllSpaceLyfToH5;
		public static function getInstance():ExpAllSpaceLyfToH5{
			if(!instance){
				instance = new ExpAllSpaceLyfToH5();
			}
			return instance;
		}


		public function ExpAllSpaceLyfToH5()
		{
			super();
		}
	 	override public function expToH5($file:File):void
		{
			_outFile=$file;
		
			this.outFilename=AppData.expSpaceUrl+"/lyf/"+	this.Cn2enFun($file.name);
		
			this.onFileWorkChg(new File(AppData.expSpaceUrl))

		}
		private var  outFilename:String;
		

		override protected function returnFun():void
		{
			
	
			
			var $fs:FileStream;
			var $byte:ByteArray;
			
			var $oneUrl:String=this.outFilename;
			$oneUrl=$oneUrl.replace(".lyf","_lyf_"+this.skipNum+".txt")
			
			MakeResFileList.getInstance().pushUrl($oneUrl)
			$fs = new FileStream;
			$fs.open(new File($oneUrl),FileMode.WRITE);
			$byte=new ByteArray;
			
			
			ExpH5ByteModel.getInstance().WriteByte($byte,true,[1,2,3,4],false);
			$fs.writeInt(Scene_data.version)//写入版本号
			$fs.writeBytes($byte,0,$byte.length);//写入资源
			$fs.writeBytes(_groupByte,0,_groupByte.length);//写入引用数据
			$fs.close()
			
		
			this.skipNum++
			setTimeout(function ():void{
					expOneByOne()
			},1000)
	
			
		}
		
		public function outAll():void
		{
			this.allFileItem=this.getFileListBB(new File(AppData.workSpaceUrl));
			this.totalFileNum=this.allFileItem.length
			this.expOneByOne()
		}
		private var totalFileNum:Number
		
		private var allFileItem:Vector.<File>
		
		private function expOneByOne():void
		{
			if(this.allFileItem.length){
				
				var tempFile:File=this.allFileItem.pop();
				this.expToH5(tempFile);
			}else{
				Alert.show("导出结束,共导出"+this.totalFileNum+"个文件","提示")
			}
			
	
			
		}
		
		private var skipNum:Number=0

		public function getFileListBB($tempFile:File):Vector.<File>
		{
			var $fileItem:Vector.<File>=new Vector.<File>
			if($tempFile.exists && $tempFile.isDirectory)
			{
				var arr:Array=$tempFile.getDirectoryListing();
				for each(var $file:File in arr)
				{
					if($file.isHidden)
					{
						continue;
					}else{
						if($file.nativePath.search("_hide")!=-1){
						}else{
							if($file.isDirectory)
							{
								if($fileItem.length<100){
									$fileItem=$fileItem.concat(getFileListBB($file))
								}
							}else{
								if($file.extension=="lyf"){
									$fileItem.push($file)
								}
							}
							
						}
					}
				}
			}
			return $fileItem;
		}
	
	}
}