package modules.hierarchy.h5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import org.aszip.saving.Method;
	import org.aszip.zip.ASZip;

	public class ExpH5ByteModel
	{
		private static var instance:ExpH5ByteModel;
		public function ExpH5ByteModel()
		{
			
		}
		public static function getInstance():ExpH5ByteModel{
			if(!instance){
				instance = new ExpH5ByteModel();
			}
			return instance;
		}
		public function clear():void
		{
			_picByte=new ByteArray;
			_basePicBype=new ByteArray;
			_objsByte=new ByteArray;
			_materialByte=new ByteArray;
			_lyfByte=new ByteArray;
			
			useNormalUrlObj=new Object;
			usePbrUrlObj=new Object;
			directLightUrlObj=new Object;
			_picByteNum=0;
			_objsByteNum=0;
			_materialByteNum=0;
			_lyfByteNum=0;
			addInfoStr=""
		}
		private var _picByte:ByteArray;
		private var _objsByte:ByteArray;
		private var _materialByte:ByteArray;
		private var _lyfByte:ByteArray;
		
		private var _picByteNum:int;
		private var _objsByteNum:int;
		private var _materialByteNum:int;
		private var _lyfByteNum:int;
		private var _basePicBype:ByteArray
		public function addPic($file:File,$url:String):void
		{
			if($file.extension=="png"){
				var $jpngName:String=$file.url.replace(".png",".jpng");
				var $jpngFile:File=new File($jpngName)
				if($jpngFile.exists){
					this.addPic($jpngFile,$url.replace(".png",".jpng"));
					return;
	
				}
			}
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				_picByte.writeUTF($url)
				_picByte.writeInt($fs.bytesAvailable)
				_picByteNum++	
				$fs.close();
			}
			addBasePic($file,$url)
		}
		private function addBasePic($file:File,$url:String):void
		{
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				_basePicBype.writeUTF($url)
				_basePicBype.writeInt($fs.bytesAvailable)
				var $byte:ByteArray=new ByteArray;
				$fs.readBytes($byte,0,$fs.bytesAvailable);
				_basePicBype.writeBytes($byte,0,$byte.length)
				$fs.close()
					
			

			}else{
				Alert.show("没有文件",$file.url)
			}
		}
		public function saveMaterialTreeHasNrmOrPbnByUrl($materailUrl:String,$objUrl:String):void
		{
			var file:File = new File(AppData.workSpaceUrl+$materailUrl);
			var fs:FileStream = new FileStream;
			if(file.exists){
				fs.open(file,FileMode.READ);
				var obj:Object = fs.readObject();
				fs.close();
				var materailTree:MaterialTree = new MaterialTree;
				materailTree.setData(obj);
				trace("url",$objUrl)
				trace("materailTree.useNormal",materailTree.useNormal);
				trace("materailTree.usePbr",materailTree.usePbr);
				trace("materailTree.directLight",materailTree.directLight);
				
				if(materailTree.useNormal){
					useNormalUrlObj[AppData.workSpaceUrl+$objUrl]=true
				}
				if(materailTree.usePbr){
					usePbrUrlObj[AppData.workSpaceUrl+$objUrl]=true
				}
				
				if(materailTree.directLight){
					directLightUrlObj[AppData.workSpaceUrl+$objUrl]=true
				}
				
				
			}
		}
		public var useNormalUrlObj:Object;
		public var usePbrUrlObj:Object;
		public var directLightUrlObj:Object;
		
	
		public function addObjs($file:File,$url:String):void
		{
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				_objsByte.writeUTF($url)
				_objsByte.writeInt($fs.bytesAvailable)
				var $byte:ByteArray=new ByteArray;
				$fs.readBytes($byte,0,$fs.bytesAvailable);
				_objsByte.writeBytes($byte,0,$byte.length)
				_objsByteNum++
				$fs.close()
			}else{
				Alert.show("没有文件",$file.url)
			}
		}
	
		public function addMaterial($file:File,$url:String):void
		{
		
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				_materialByte.writeUTF($url)
				_materialByte.writeInt($fs.bytesAvailable)
				var $byte:ByteArray=new ByteArray;
		
				if($fs.bytesAvailable<=4){
				
					Alert.show(decodeURI($file.url),"材质需要重新编译")
				} 
				
				$fs.readBytes($byte,0,$fs.bytesAvailable);
				_materialByte.writeBytes($byte,0,$byte.length)
				_materialByteNum++
				$fs.close()
			}else{
				Alert.show("没有文件",$file.url)
			}
		}
		
		public function addLyf($file:File,$url:String):void
		{
	
			if($file.exists){
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				_lyfByte.writeUTF($url)
				_lyfByte.writeInt($fs.bytesAvailable)
				var $byte:ByteArray=new ByteArray;
				$fs.readBytes($byte,0,$fs.bytesAvailable);
				_lyfByte.writeBytes($byte,0,$byte.length)
				_lyfByteNum++
					
				$fs.close()
			}else{
				Alert.show("没有文件",$file.url)
			}
		}
		public function saveFile($sceneFile:File):void
		{
			saveBaseFile($sceneFile)
	
		
			var $file:File = new File($sceneFile.url.replace(".xml","_base.txt"));
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.WRITE);
			$fs.writeInt(1)
			$fs.writeInt(_picByteNum)
			$fs.writeBytes(_picByte,0,_picByte.length)
				
			$fs.writeInt(2)
			$fs.writeInt(_objsByteNum)
			$fs.writeBytes(_objsByte,0,_objsByte.length)
				
			$fs.writeInt(3)
			$fs.writeInt(_materialByteNum)
			$fs.writeBytes(_materialByte,0,_materialByte.length);
			
			$fs.writeInt(4)
			$fs.writeInt(_lyfByteNum)
			$fs.writeBytes(_lyfByte,0,_lyfByte.length);
			
	
			var $fsScene:FileStream = new FileStream;
			$fsScene.open($sceneFile,FileMode.READ);
			var $byte:ByteArray=new ByteArray;
			$fsScene.readBytes($byte,0,$fsScene.bytesAvailable);
			$fs.writeInt(5)
			$fs.writeInt($byte.length)
			$fs.writeBytes($byte,0,$byte.length);
			
			$fsScene.close()
			$fs.close();
			
		}
		public function saveBaseFile($sceneFile:File):void
		{
			
			
			var $file:File = new File($sceneFile.url.replace(".xml",".txt"));
			var $fs:FileStream = new FileStream;
			$fs.open($file,FileMode.WRITE);
			$fs.writeInt(1)
			$fs.writeInt(_picByteNum)
			$fs.writeBytes(_basePicBype,0,_basePicBype.length)
			
			$fs.writeInt(2)
			$fs.writeInt(_objsByteNum)
			$fs.writeBytes(_objsByte,0,_objsByte.length)
			
			$fs.writeInt(3)
			$fs.writeInt(_materialByteNum)
			$fs.writeBytes(_materialByte,0,_materialByte.length);
			
			$fs.writeInt(4)
			$fs.writeInt(_lyfByteNum)
			$fs.writeBytes(_lyfByte,0,_lyfByte.length);
			
			var $fsScene:FileStream = new FileStream;
			$fsScene.open($sceneFile,FileMode.READ);
			var $byte:ByteArray=new ByteArray;
			$fsScene.readBytes($byte,0,$fsScene.bytesAvailable);
			
			$fs.writeInt(5)
			$fs.writeInt($byte.length)
			$fs.writeBytes($byte,0,$byte.length);
			
			$fsScene.close()
			$fs.close();
			
		}
		public function boneAnimAppWriteByte($fs:ByteArray,$havePic:Boolean):void
		{
			
			$fs.writeInt(1)
			$fs.writeInt(_picByteNum)
			if($havePic){

				$fs.writeBytes(_basePicBype,0,_basePicBype.length)
			}else{
				$fs.writeBytes(_picByte,0,_picByte.length)
			}
			
			$fs.writeInt(2)
			$fs.writeInt(_objsByteNum)
			$fs.writeBytes(_objsByte,0,_objsByte.length)
			
			$fs.writeInt(3)
			$fs.writeInt(_materialByteNum)
			$fs.writeBytes(_materialByte,0,_materialByte.length);
			
			$fs.writeInt(4)
			$fs.writeInt(_lyfByteNum)
			$fs.writeBytes(_lyfByte,0,_lyfByte.length);
		}
		private var tatolInfo:String;
		public var addInfoStr:String;
		public function  WriteByte($fs:ByteArray,$havePic:Boolean,$arr:Array,showalert:Boolean=true):void
		{
			
			tatolInfo=""
			if(needWriteBy($arr,1)){
				$fs.writeInt(1)
				$fs.writeInt(_picByteNum)
				if($havePic){
					$fs.writeBytes(_basePicBype,0,_basePicBype.length)
					tatolInfo+=("\n图片字节:"+_basePicBype.length/1000+"k")
				}else{
					$fs.writeBytes(_picByte,0,_picByte.length)
					tatolInfo+=("\n图片字节:"+_picByte.length/1000+"k")
				}
		
			}
			
			if(needWriteBy($arr,2)){
				$fs.writeInt(2)
				$fs.writeInt(_objsByteNum)
				$fs.writeBytes(_objsByte,0,_objsByte.length)
				tatolInfo+=("\nobj模型:"+_objsByte.length/1000+"k")
				
			}
			if(needWriteBy($arr,6)){ //压缩过后的类型OBJ类型
				$fs.writeInt(6)
			
				var $objsCone:ByteArray=new ByteArray();
				$objsCone.writeInt(_objsByteNum)
				$objsCone.writeBytes(_objsByte,0,_objsByte.length)
				$objsCone.compress()
//				var zip:ASZip = new ASZip();
//				zip.addFile($objsCone,"data");
//				$objsCone = zip.saveZIP(Method.LOCAL);
				$fs.writeInt($objsCone.length)
				$fs.writeBytes($objsCone,0,$objsCone.length)
				tatolInfo+=("\nobjzip模型:"+$objsCone.length/1000+"k")
				
			}
			if(needWriteBy($arr,3)){
				
				$fs.writeInt(3)
				$fs.writeInt(_materialByteNum)
				$fs.writeBytes(_materialByte,0,_materialByte.length);
				tatolInfo+=("\n材质字节:"+_materialByte.length/1000+"k")
			}
			
			if(needWriteBy($arr,4)){
				
				$fs.writeInt(4)
				$fs.writeInt(_lyfByteNum)
				$fs.writeBytes(_lyfByte,0,_lyfByte.length);
				tatolInfo+=("\n特效:"+_lyfByte.length/1000+"k")
				
			}
		
	
			tatolInfo+=("\n统计总:"+$fs.length/1000+"k")
				
			if(addInfoStr){
			
				tatolInfo+=addInfoStr
			}
			if($havePic&&showalert){
				Alert.show(tatolInfo);
			}
			
			
		}
		private function   needWriteBy($arr:Array,$id:uint):Boolean
		{
		   for(var i:uint=0;i<$arr.length;i++)
		   {
			    if($arr[i]==$id){
					return true
				}
		   
		   
		   }
		   return false
		}
	}
}