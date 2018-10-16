package modules.hierarchy
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import _Pan3D.base.ObjData;
	
	import common.AppData;
	
	import modules.brower.fileTip.RenderSocketType;

	public class SaveToHtmlScene
	{
		private static var instance:SaveToHtmlScene;
		public function SaveToHtmlScene()
		{
		}
		public static function getInstance():SaveToHtmlScene{
			if(!instance){
				instance = new SaveToHtmlScene();
			}
			return instance;
		}
		public function setBye($data:ByteArray):void
		{
			$data.position=0
			var msgLen:int = $data.readInt();
			var dataBuf:ByteArray = new ByteArray();
	
			$data.readBytes(dataBuf, 0, msgLen);
			var msg:int = dataBuf.readInt();
			receiveMsg(msg,dataBuf)
			
		}
		private function receiveMsg(msgNum:int,byte:ByteArray):void{

			switch(msgNum)
			{
				case RenderSocketType.MAKEOBJDATA:
				{
					setSceneImodeList(byte);
					break;
				}
			
				default:
				{
					break;
				}
			}
		}
		
		private function setSceneImodeList(byte:ByteArray):void
		{
			_modeItem=new Array
			var _num:int=byte.readInt()
			
			for(var i:uint=0;i<_num;i++){
				var type:int=byte.readInt()
				
				switch(type)
				{
					case 1:
					{
						makePrefab(byte)
						break;
					}
					default:
					{
						break;
					}
				}
				
				
			}
			
			saveSceneToXml();
			
		}
		
		private function saveSceneToXml():void
		{
			var $data:Array=new Array
			pushStrToArr($data,"<?xml version=\"1.0\" encoding=\"utf-8\"?>")
			pushStrToArr($data,"<list>")
			for(var i:uint=0;i<_modeItem.length;i++){
				var $dis:Object=_modeItem[i];
				pushStrToArr($data,"<td")
				pushStrToArr($data," id=\""+$dis.uid+"\"");
				pushStrToArr($data," objUrl=\""+$dis.objUrl+"\"");
				pushStrToArr($data," picUrl=\""+$dis.picUrl+"\"");
				pushStrToArr($data," x=\""+$dis.x+"\"");
				pushStrToArr($data," y=\""+$dis.y+"\"");
				pushStrToArr($data," z=\""+$dis.z+"\"");
				pushStrToArr($data," rotationX=\""+$dis.rotationX+"\"");
				pushStrToArr($data," rotationY=\""+$dis.rotationY+"\"");
				pushStrToArr($data," rotationZ=\""+$dis.rotationZ+"\"");
				pushStrToArr($data," scale_x=\""+$dis.scale_x+"\"");
				pushStrToArr($data," scale_y=\""+$dis.scale_y+"\"");
				pushStrToArr($data," scale_z=\""+$dis.scale_z+"\"");
				pushStrToArr($data,"></td>")
				
				var objsFile:File=new File(AppData.workSpaceUrl+$dis.objUrl)
				var toXmlUrl:String=decodeURI(File.desktopDirectory.nativePath)+"/filehtml/"+$dis.objUrl
				setObjsToxml(objsFile,toXmlUrl)
				
				var picFile:File=new File(AppData.workSpaceUrl+$dis.picUrl)
				var toPicUrl:String=decodeURI(File.desktopDirectory.nativePath)+"/filehtml/"+$dis.picUrl
				moveFile(picFile,toPicUrl)
				
			}
			pushStrToArr($data,"</list>")
			var $file:File = new File(decodeURI(File.desktopDirectory.nativePath+"/filehtml/sceneXml.xml"));
			writeToXml($file,$data)
			
		}
		private function moveFile($file:File,$toUrl:String):void
		{
			var destination:File = File.documentsDirectory;
			destination = destination.resolvePath($toUrl);
			$file.copyTo(destination, true);

		}
		public function setObjsToxml($file:File,$toFileUrl:String):void
		{
			if($file.extension=="objs"){
				
				var $fs:FileStream = new FileStream;
				if($file.exists){
					$fs.open($file,FileMode.READ);
					var $objList:Object = $fs.readObject();
					$fs.close()
					$file.copyTo(new File($toFileUrl), true);
				}
				//objDataToXmlFile($objList,$toFileUrl)
			}
		}
		private function objDataToXmlFile($objList:Object,$toFileUrl:String):void
		{
			
			var $data:Array=new Array
			pushStrToArr($data,"<?xml version=\"1.0\" encoding=\"utf-8\"?>")
			pushStrToArr($data,"<menu>")
			pushStrToArr($data,"<data")
			
			var i:uint=0
			
			//	var objList:ObjData
			pushStrToArr($data," v=\"");
			for( i=0;i<$objList.vertices.length;i++ ){
				if(i!=0){
					$data.push(",")
				}
				$data.push($objList.vertices[i])
			}
			pushStrToArr($data,"\"");
			
			pushStrToArr($data," u=\"");
			for( i=0;i<$objList.uvs.length;i++ ){
				if(i!=0){
					$data.push(",")
				}
				$data.push($objList.uvs[i])
			}
			pushStrToArr($data,"\"");
			
			pushStrToArr($data," i=\"");
			for( i=0;i<$objList.indexs.length;i++ ){
				if(i!=0){
					$data.push(",")
				}
				$data.push($objList.indexs[i])
			}
			pushStrToArr($data,"\"");
			pushStrToArr($data," lightUvs=\"");
			for( i=0;i<$objList.lightUvs.length;i++ ){
				if(i!=0){
					$data.push(",")
				}
				$data.push($objList.lightUvs[i])
			}
			
			pushStrToArr($data,"\"");
			
			pushStrToArr($data,"></data>")
			
			pushStrToArr($data,"</menu>")
			
			writeToXml(new File($toFileUrl.replace(".objs",".xml")),$data)
		}
		
		private function pushStrToArr($arr:Array,$str:String):void
		{
			for(var i:uint=0;i<$str.length;i++){
				$arr.push($str.substr(i,1))
			}
		}
		
		private  function writeToXml($file:File,$dataArr:Array):void
		{
			var fs:FileStream = new FileStream();
			fs.open($file, FileMode.WRITE);
			var len:int = $dataArr.length;
			for(var i:int = 0; i < len; i++)
			{
				fs.writeMultiByte($dataArr[i],"utf-8");
			}
			fs.close();
		}
		private var _modeItem:Array
		private function makePrefab(byte:ByteArray):void
		{
			var $dis:Object = new Object
			$dis.id = byte.readInt();
			var $uid:String = byte.readUTF();
			$dis.uid = $uid;
			$dis.lightMapSize=byte.readInt();
			$dis.lightBlur=byte.readInt();
			
			
			var $objUrl:String=byte.readUTF()
			var $picUrl:String=byte.readUTF()
			$dis.killNum=byte.readFloat();
			$dis.objUrl = $objUrl;
			$dis.picUrl = $picUrl;

			$dis.backCull = byte.readBoolean();;
			var $lightProbe:Boolean = byte.readBoolean();;

			$dis.lightProbe = $lightProbe;
			
			$dis.isGround=byte.readBoolean();
			if($dis.isGround){
				$dis.groundX=byte.readInt();
				$dis.groundZ=byte.readInt();
			}

			$dis.x=byte.readFloat();
			$dis.y=byte.readFloat();
			$dis.z=byte.readFloat();
			$dis.rotationX=byte.readFloat();
			$dis.rotationY=byte.readFloat();
			$dis.rotationZ=byte.readFloat();
			$dis.scale_x=byte.readFloat();
			$dis.scale_y=byte.readFloat();
			$dis.scale_z=byte.readFloat();
			

			
			var $lightInfo:Object=byte.readObject()

			var $data:Object=byte.readObject()
			if($dis.isGround){
				$dis.objUrl=String($dis.picUrl).replace(".jpg",".objs")  //将模型也存到和图片对应该的位置
				var toXmlUrl:String=decodeURI(File.desktopDirectory.nativePath)+"/filehtml/"+$dis.objUrl
				//objDataToXmlFile($data,toXmlUrl)  //存为xml
				var file:File=new File(toXmlUrl)
				var fs:FileStream = new FileStream;
				fs.open(file,FileMode.WRITE);
				var $obj:Object=new Object;
				$obj.vertices=$data.vertices;
				$obj.uvs=$data.uvs;
				$obj.lightUvs=$data.lightUvs;
				$obj.normals=$data.normals;
				$obj.indexs=$data.indexs;
				fs.writeObject($obj)
				fs.close();
				
			}
			_modeItem.push($dis)
			
		}
	}
}