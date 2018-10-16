package utils
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.role.MeshUtils;
	import _Pan3D.utils.MeshToObjUtils;
	
	import _me.Scene_data;
	
	import view.byteFile.MeshFileToByteUtils;

	/**
	 * 装备mesh打包导出工具类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class PackageEquipUtils
	{
		private var data:Object;
		private var particleNum:int;
		private var allParticleNum:uint;
		private var resultByte:ByteArray;
		private var expObj:Object;
		private var _sqlId:int;
		
		private static var SPACE:String = " ";
		private static var LEFT:String = "(";
		private static var RIGHT:String = ")";
		
		public function PackageEquipUtils()
		{
			resultByte = new ByteArray;
		}
		public function packageData(obj:Object,id:int=0):Object{
			_sqlId = id;
			data = obj;
			return objExp();
//			var loaderinfo : LoadInfo = new LoadInfo(Scene_data.md5Root + obj.url, LoadInfo.BYTE, onMeshCom);
//			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		public function packageMesh(obj:Object):void{
			data = obj;
			copyMd5Mesh(File.desktopDirectory.url + "/equ/" + data.fileName + ".md5mesh");
		}
		
		public function objExp():Object{
			var obj:Object = new Object;
			
//			var file:File = new File(Scene_data.md5Root + data.url);
//			var newFile:File = new File(File.desktopDirectory.url + "/equ/zid" + _sqlId + "/mesh/" + data.fileName + ".md5mesh");
//			file.copyTo(newFile,true);
			copyMd5Mesh(File.desktopDirectory.url + "/equ/zid" + _sqlId + "/mesh/" + data.fileName + ".md5mesh");
			obj.meshUrl = data.fileName + ".md5mesh";
			
			var file:File = new File(Scene_data.md5Root + data.textureUrl);
			var newFile:File = new File(File.desktopDirectory.url + "/equ/zid" + _sqlId + "/texture/" + data.textureName);
			file.copyTo(newFile,true);
			obj.textureUrl = data.textureName;
			
			if(AppDataBone.version == 2){
				var lightFile:File = new File(Scene_data.md5Root + data.textureLightUrl);
				var lightnewFile:File = new File(File.desktopDirectory.url + "/equ/zid" + _sqlId + "/texture/" + data.textureLightName);
				lightFile.copyTo(lightnewFile,true);
				obj.textureLightUrl = data.textureLightName;
			}
			
			
//			var ary:Array = data.particleList;
//			var newAry:Array = new Array;
			
			if(data.particleList){
				obj.particleList = filterBindParticle(data.particleList);
			}
			
			if(data.particleList2){
				obj.particleList2 = filterBindParticle(data.particleList2);
			}
			
			expObj = obj;
			return expObj;
//			var expFile:File = new File;
//			expFile.browseForSave("导出装备文件");
//			expFile.addEventListener(Event.SELECT,onSel2);
			
		}
		
		private function filterBindParticle(ary:Array):Array{
			var newAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				var info:Object = ary[i];
				
				var newObj:Object = new Object;
				
				if(info.bindIndex){
					newObj.bindIndex = info.bindIndex;
				}
				
				if(info.bindOffset){
					newObj.bindOffset = info.bindOffset;
				}
				
				if(info.bindRatation){
					newObj.bindRatation = info.bindRatation;
				}
				
				newObj.url = info.particleName;
				newObj.id = info.id;
				
				if(info.isList){
					newObj.isList = true;
					newObj.nextList = new Array;
					
					var arr:Array = info.nextList;
					
					for(var j:int=0;j<arr.length;j++){
						var nextInfoObj:Object = arr[j];
						
						var nextObj:Object = new Object;
						
						if(nextInfoObj.bindIndex){
							nextObj.bindIndex = nextInfoObj.bindIndex;
						}
						
						if(nextInfoObj.bindOffset){
							nextObj.bindOffset = nextInfoObj.bindOffset;
						}
						
						if(nextInfoObj.bindRatation){
							nextObj.bindRatation = nextInfoObj.bindRatation;
						}
						
						nextObj.url = nextInfoObj.particleName;
						nextObj.id = nextInfoObj.id;
						
						newObj.nextList.push(nextObj);
					}
					
				}
				
				newAry.push(newObj);
			}
			return newAry;
		}
		
		
		/**
		 * mesh保存导出 
		 * @param fileUrl 文件的保存路径
		 * 
		 */		
		private function copyMd5Mesh(fileUrl:String):void{
			var meshStr:String = getMeshDataStr(data.data);
			var newFile:File = new File(fileUrl);
			var fs:FileStream = new FileStream;
			fs.open(newFile,FileMode.WRITE);
			fs.writeUTFBytes(meshStr);
			fs.close();
			new MeshFileToByteUtils().process(newFile);
		}
		/**
		 * 通过meshData组装最终的md5格式的字符串 
		 * @param meshData
		 * @return 
		 * 
		 */		
		private function getMeshDataStr(meshData:MeshData):String{
			
			var resultStr:String = new String;
			var vertStr:String = new String;
			var triStr:String = new String;
			var weightStr:String = new String;
			var jointStr:String = new String;
			
			var vertAry:Vector.<ObjectUv> = meshData.uvItem;
			var triAry:Vector.<ObjectTri> = meshData.triItem;
			var weightAry:Vector.<ObjectWeight> = meshData.weightItem;
			var boneAry:Vector.<ObjectBone> = processBoneNew(meshData.boneItem);
			
			
			for(var i:int=0;i<vertAry.length;i++){
				vertStr += "\tvert" + SPACE + vertAry[i].id + SPACE 
					+ LEFT + SPACE + vertAry[i].x + SPACE + vertAry[i].y + SPACE + RIGHT + SPACE + vertAry[i].a + SPACE + vertAry[i].b + "\r\n";//vert 0 ( 1.0 1.0 ) 0 1
			}
			
			for(i=0;i<triAry.length;i++){
				triStr += "\ttri" + SPACE + triAry[i].id + SPACE + triAry[i].t0 + SPACE + triAry[i].t1 + SPACE + triAry[i].t2 + "\r\n";//tri 0 0 2 1
			}
			
			for(i=0;i<weightAry.length;i++){
				weightStr += "\tweight" + SPACE + weightAry[i].id + SPACE + weightAry[i].boneId + SPACE + weightAry[i].w 
					+ SPACE + LEFT + SPACE + weightAry[i].x + SPACE + weightAry[i].y + SPACE + weightAry[i].z + SPACE + RIGHT + "\r\n"//weight 0 0 1.0 ( 16.4771 -8.70046 8.20959 )
			}
			
			for(i=0;i<boneAry.length;i++){
				jointStr += "\t" + boneAry[i].name + "\t" + boneAry[i].father + SPACE + LEFT + SPACE + boneAry[i].tx + SPACE + boneAry[i].ty + SPACE + boneAry[i].tz +
					SPACE + RIGHT + SPACE + LEFT + SPACE + boneAry[i].qx + SPACE + boneAry[i].qy + SPACE + boneAry[i].qz + SPACE + RIGHT  + "\r\n";// "Bip001"	-1 ( -0.00101398 -2.31972 58.4158 ) ( -0.0233963 -0.0233963 0.706719 )
			}
			resultStr = "joints {\r\n";
			resultStr += jointStr + "}\r\n";
			resultStr += "mesh {\r\n"; 
			resultStr += "\tnumverts " + vertAry.length + "\r\n" + vertStr + "\r\n" ;
			resultStr += "\tnumtris " + triAry.length + "\r\n" + triStr + "\r\n";
			resultStr += "\tnumweights " + weightAry.length + "\r\n" +  weightStr + "}";
			resultStr = "resort 1\r\n" + resultStr;
			
			return resultStr;
		}
		
		public function processBoneNew(targetAry:Vector.<ObjectBone>):Vector.<ObjectBone>{
			

			var newTargetAry:Vector.<ObjectBone> = MeshToObjUtils.getStorNewTargerArr(targetAry);
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(var i:int = 0;i<targetAry.length;i++){
				var index:int = newTargetAry.indexOf(targetAry[i]);
				mapkeyAry.push(index);
			}
			//trace(mapkeyAry);
			
			var resultAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;//最终更新的数据
			for(i = 0;i<newTargetAry.length;i++){//数据复制
				resultAry.push(newTargetAry[i].clone());
			}
			
			for(i=0;i<resultAry.length;i++){//从映射关系更新父级id
				index = resultAry[i].father;
				if(index != -1){
					resultAry[i].father = mapkeyAry[index];
				}
			}
			
			return resultAry;
			
		}
		
		
		
		
//		protected function onSel2(event:Event):void{
//			var file:File = event.target as File;
//			if(!(file.extension == "zzw")){
//				file = new File(file.nativePath + ".zzw");
//			}
//			
//			var fs:FileStream = new FileStream;
//			fs.open(file,FileMode.WRITE);
//			fs.writeObject(expObj);
//			fs.close();
//		}
		
//		private function onMeshLoad(mesh:MeshData):void{
//			trace(mesh)
//		}
		
//		private function copyLyf(url:String,name:String):void{
//			var file:File = new File(url);
//			var fs:FileStream = new FileStream;
//			fs.open(file,FileMode.READ);
//			var obj:Object = fs.readObject();
//			fs.close();
//			
//			var ary:Array = obj as Array;
//			for(var i:int;i<ary.length;i++){
//				var p:Object = ary[i].display;
//				
//				file = new File(Scene_data.md5Root + p.textureUrl);
//				if(file.exists){
//					if(file.isDirectory){
//						continue;
//					}
//					var newFile:File = new File(Scene_data.md5Root + "exp/particle/texture/" + file.name);
//					file.copyTo(newFile,true);
//					p.textureUrl = newFile.name;
//				}
//				
//				file = new File(Scene_data.md5Root + p.objUrl);
//				if(file.exists){
//					if(file.isDirectory){
//						continue;
//					}
//					newFile = new File(Scene_data.md5Root + "exp/particle/model/" + file.name);
//					file.copyTo(newFile,true);
//					p.objUrl = newFile.name;
//				}
//				
//			}
//			
//			file = new File(Scene_data.md5Root + "exp/particle/" + name);
//			fs = new FileStream;
//			fs.open(file,FileMode.WRITE);
//			fs.writeObject(obj);
//			fs.close();
//			
//		}
		
//		protected function onMeshCom(meshByte:ByteArray):void{
//			meshByte.compress();
//			resultByte.writeInt(meshByte.length);
//			resultByte.writeBytes(meshByte,0,meshByte.length);
//			
//			
//			var loaderinfo : LoadInfo = new LoadInfo(Scene_data.md5Root + data.textureUrl, LoadInfo.BYTE, onTextureCom);
//			LoadManager.getInstance().addSingleLoad(loaderinfo);
//		}
		
//		protected function onTextureCom(textureByte:ByteArray):void{
//			resultByte.writeInt(textureByte.length);
//			resultByte.writeBytes(textureByte,0,textureByte.length);
//			
//			var ary:Array = data.particleList;
//			if(ary){
//				particleNum = 0;
//				allParticleNum = ary.length;
//				for(var i:int;i<ary.length;i++){
//					var loaderinfo : LoadInfo = new LoadInfo(Scene_data.md5Root + ary[i].particleUrl, LoadInfo.BYTE, onParticleCom,false,ary[i]);
//					LoadManager.getInstance().addSingleLoad(loaderinfo);
//				}
//			}else{
//				loadCom();
//			}
//			
//		}
//		
//		private function onParticleCom(particleByte:ByteArray,info:Object):void{
//			var particle:Object = particleByte.readObject();
//			var newObj:Object = new Object;
//			if(info.bindIndex){
//				newObj.bindIndex = info.bindIndex;
//			}
//			
//			if(info.bindOffset){
//				newObj.bindOffset = info.bindOffset;
//			}
//			
//			if(info.bindRatation){
//				newObj.bindRatation = info.bindRatation;
//			}
//			
//			newObj.particle = particle;
//			
//			resultByte.writeObject(newObj);
//			
//			particleNum++
//			
//			if(particleNum == allParticleNum){
//				loadCom();
//			}
//		}	
//		
//		private function loadCom():void{
//			trace(resultByte.length);
//			
//			resultByte.position = 0;
//			var meshLength:int = resultByte.readInt();
//			var meshbyte:ByteArray = new ByteArray;
//			meshbyte.readBytes(resultByte,0,meshLength);
//			
//			var file:File = new File;
//			file.browseForSave("导出装备文件");
//			file.addEventListener(Event.SELECT,onSel);
//			
//		}
//		
//		protected function onSel(event:Event):void{
//			// TODO Auto-generated method stub
//			var file:File = event.target as File;
//			if(!(file.extension == "zzw")){
//				file = new File(file.nativePath + ".zzw");
//			}
//			
//			var fs:FileStream = new FileStream;
//			fs.open(file,FileMode.WRITE);
//			fs.writeBytes(resultByte,0,resultByte.length);
//			fs.close();
//		}
		
	}
}