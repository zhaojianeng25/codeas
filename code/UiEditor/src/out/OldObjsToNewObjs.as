package out
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import common.AppData;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import pack.PrefabStaticMesh;

	public class OldObjsToNewObjs
	{
		private static var instance:OldObjsToNewObjs;
		public function OldObjsToNewObjs()
		{
		}
		public static function getInstance():OldObjsToNewObjs{
			if(!instance){
				instance = new OldObjsToNewObjs();
			}
			return instance;
		}
		private function loadOldObj($fileUrl:String):void
		{
			var baseURL:String="file:///G:/newcar/车头02.objs";
			baseURL=$fileUrl
			var _toUrl:String="file:///G:/outnewobjs";
			//_toUrl="file:///E:/art/project/content/finalscens/pan/停车场"
			var  _fileName:String=new File(baseURL).name.replace("."+new File(baseURL).extension,"")
			var loaderinfo : LoadInfo = new LoadInfo(baseURL, LoadInfo.BYTE, onObjByteLoad,10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onObjByteLoad(byte:ByteArray):void{
				var $arr:Array = byte.readObject();
				var $urlArr:Array=new Array
				
				for(var i:uint=0;i<$arr.length;i++)
				{
					var _editPreUrl:String=_toUrl+"/"+_fileName+".objs"
					if($arr.length>1){
						 _editPreUrl=_toUrl+"/"+_fileName+"/"+String(i)+".objs"
					}
					var $obj:Object=$arr[i]
					for(var k:Number=0;k<$obj.vertices.length ;k++){
						$obj.vertices[k]=$obj.vertices[k]*0.1
					}	
					changeFace($obj)
					var fs:FileStream = new FileStream;
					fs.open(new File(_editPreUrl),FileMode.WRITE);
					fs.writeObject($obj);
					fs.close();
					$urlArr.push(_editPreUrl.replace(_toUrl+"/",""))
						
					if($arr.length==1){
						InputDaeToObjsBackFun(new File(_editPreUrl).name.replace("."+new File(_editPreUrl).extension,""))
					}
				}
				
				
			}
			
		}
		private function changeFace($obj:Object):void
		{

	
			for(var i:Number=0;i<$obj.indexs.length/3 ;i++){
				var a:Number=$obj.indexs[i*3+0];
				var b:Number=$obj.indexs[i*3+1];
				var c:Number=$obj.indexs[i*3+2];
				
				
				$obj.indexs[i*3+0]=a
				$obj.indexs[i*3+1]=c
				$obj.indexs[i*3+2]=b

				
			}

			var $m:Matrix3D=new Matrix3D;
			
			$m.appendRotation(-90,Vector3D.X_AXIS);

			for(var j:Number=0;j<$obj.normals.length/3 ;j++){
			
				var norV:Vector3D=new Vector3D($obj.normals[j*3+0],$obj.normals[j*3+1],$obj.normals[j*3+2]);
				norV=$m.transformVector(norV)
					
				$obj.normals[j*3+0]=norV.x;
				$obj.normals[j*3+1]=norV.y;
				$obj.normals[j*3+2]=norV.z;
				

			}


		}
			
		private function InputDaeToObjsBackFun( $fileName:String):void
		{
			var _toUrl:String="file:///G:/outnewobjs/prefab/";

			
			var $folderUrl:String=_toUrl
			var _editPreFab:PrefabStaticMesh=new PrefabStaticMesh;
			_editPreFab.axoFileName=""
			_editPreFab.materialUrl=AppData.defaultMaterialUrl
			_editPreFab.url=$folderUrl+$fileName+".prefab";
			var _prbUrl:String=_editPreFab.url
			
			var fs:FileStream = new FileStream;
			fs.open(new File(_prbUrl),FileMode.WRITE);
			fs.writeObject(_editPreFab.readObject());
			fs.close();

		}
		public function outAll():void
		{
		
//			this.loadOldObj("file:///G:/newcar/集装箱01.objs")
//			return 
			var fileArr:Array=this.getFileDicLyfName();
			for(var j:Number=0;j<fileArr.length;j++){
				trace(fileArr[j]);
				this.loadOldObj(fileArr[j])
			}
			
		
		}
		private function  getFileDicLyfName():Array
		{
			//E:\codets\game\arpg\arpg\res\role
			//var baseURL:String="file:///C:/Users/liuxingsheng/Desktop/stuff/webgl/WebGLEngine/assets/ui/data.h5ui"
			var baseURL:String="file:///G:/newcar/"
			baseURL="file:///G:/卡通场景/"
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
							
							if(sonFile.extension=="objs"){
								$fileArrStr.push(sonFile.url)
							}
							
						}
						
					}
				}
				
	
				
			}
			
			return $fileArrStr
		}
	}
}