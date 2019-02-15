package modules.hierarchy.h5
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import modules.expres.ExpResFunVo;
	import modules.expres.ExpResModel;
	import modules.expres.ExpResPanel;
	
	import pack.BuildMesh;
	
	import render.build.BuildManager;
	
	public class ExpGroupToByteModel
	{
		private static var instance:ExpGroupToByteModel;
	 
		public static function getInstance():ExpGroupToByteModel{
			if(!instance){
				instance = new ExpGroupToByteModel();
			}
			return instance;
		}
		public function expToH5($file:File):void
		{
			var $tabelItemStr:Array=["tb_creature#avatar,name,id","tb_item#id,name,id"]
			var directory:File = File.applicationDirectory; 
			var $configFile:File=new File(directory.nativePath+"/config.txt");
			if($configFile.exists){
				var fs:FileStream = new FileStream;
				fs.open($configFile,FileMode.READ);
				var $str:String = fs.readUTFBytes(fs.bytesAvailable)
				fs.close();
				var $item:Object=JSON.parse($str);
				if($item.model&&$item.model){
					$tabelItemStr=$item.model
				}
			}
			
			_outFile=$file;
			if(ExpResModel.expArpg){
				ExpResPanel.initExpPanel(selectBackFun,$tabelItemStr);
			}else{
				var file:File = new File;
				file.addEventListener(Event.SELECT,selectFile);
				file.browseForDirectory("选择文件夹");
			}
		}
		private function selectFile(event:Event):void
		{
			_groupName=Cn2enFun(_outFile.name.replace("."+_outFile.extension,""))
			this.onFileWorkChg(event.target as File)
		}
		private var isUi:Boolean=false
		private function selectBackFun($obj:ExpResFunVo):void
		{
			isUi=$obj.isUi
			_groupName=String($obj.id)
			this.onFileWorkChg(new File(AppData.expSpaceUrl))
		}
		
		public function Cn2enFun($str:String):String
		{
			return Cn2en.toPinyin(decodeURI($str))
		}
		protected var _outFile:File
		
		protected function onFileWorkChg(file:File):void
		{
			
			_rootUrl=decodeURI(file.url+"/")
			
			_groupByte=new ByteArray;
			
	 
			
			expToPrefab(_outFile)
 
			
		}
		
		 
		private function expToPrefab($file:File):void
		{
			_groupByte.writeBoolean(false)
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $obj:Object = $fs.readObject();	
				var $buildMesh:BuildMesh=BuildManager.getInstance().objToBuildMesh($obj);
				var $objUrl:String=decodeURI($buildMesh.prefabStaticMesh.axoFileName)
					
		 
				
				var $objsFile:File=new File(AppData.workSpaceUrl+$objUrl)
				$fs.open($objsFile,FileMode.READ);
				var objsTampe:Object = $fs.readObject();	
				var outstr:String= JSON.stringify(objsTampe)
					
					
				this.setObjsToxml(outstr)

			 
				
			}
			
		}
		private function setObjsToxml(outstr:String):void
		{
			
			var $fs:FileStream;
 
			var $oneUrl:String = _rootUrl +"model/" + _groupName+"_objs.txt"
	
			$fs = new FileStream;
			$fs.open(new File($oneUrl),FileMode.WRITE);
			$fs.writeMultiByte(outstr,"utf-8");
			$fs.close()
			
			 Alert.show($oneUrl)
 
		}
		 
		private var _rootUrl:String;
		private var _groupName:String;
		protected var _groupByte:ByteArray
		
	 
		
	}
}
 
