package view.mesh
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.utils.Cn2en;
	import _Pan3D.vo.anim.BoneSocketData;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.h5.ExpToH5;

	public class MeshExpNew
	{
		public function MeshExpNew()
		{
		}
		
		private var  _targetUrl:String;
		
		public function exp(meshAry:Array,meshDic:Object,objDic:Dictionary,particleDic:Object,socketDic:Object,$tragetUrl:String):ByteArray{
			_targetUrl = $tragetUrl + "/";
			var byte:ByteArray = new ByteArray;
			byte.writeFloat(AppDataBone.fileScale);
			byte.writeInt(meshAry.length);
			for(var i:int=0;i<meshAry.length;i++){
				var key:String = meshAry[i].fileName;
				var meshData:MeshData = meshDic[key];
				var objData:ObjData = objDic[meshData];
				writeByteNumVec(byte,objData.vertices);
				writeByteNumVec(byte,objData.tangents);
				writeByteNumVec(byte,objData.bitangents);
				writeByteNumVec(byte,objData.normals); 
				writeByteNumVec(byte,objData.uvs);
				writeByteNumAry(byte,processBoneIDAry(meshData.bonetIDAry));
				writeByteNumAry(byte,meshData.boneWeightAry);
				writeByteIntAry(byte,meshData.indexAry);
				writeByteIntAry(byte,meshData.boneNewIDAry);
				
				var materilaUrl:String = ExpToH5.getInstance().expMaterialTreeToH5(meshData.material,this._targetUrl);
				
				byte.writeUTF(materilaUrl);
				
				if(meshAry[i].particleList){
					processParticle(byte,meshAry[i].particleList,particleDic[key]);
				}else{
					byte.writeInt(0);
				}
				
			}
			
			writeBindPos(byte,objData);
			writeSocketList(byte,socketDic);
			
			return byte;
		}
		
		private function writeSocketList(byte:ByteArray,dic:Object):void{
			var i:int;
			for(var key:String in dic){
				i++;
			}
			byte.writeInt(i);
			
			for(key in dic){
				var boneSocket:BoneSocketData = dic[key];
				byte.writeUTF(boneSocket.name);
				byte.writeUTF(boneSocket.boneName);
				byte.writeInt(boneSocket.index);
				byte.writeFloat(boneSocket.x);
				byte.writeFloat(boneSocket.y);
				byte.writeFloat(boneSocket.z);
				byte.writeFloat(boneSocket.rotationX);
				byte.writeFloat(boneSocket.rotationY);
				byte.writeFloat(boneSocket.rotationZ);
			}
			
			
		}
		
		private function processBoneIDAry(numAry:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<numAry.length;i++){
				var num:Number = (numAry[i] - 20) / 4;
				ary.push(num);
			}
			
			return ary;
		}
		
		private function processTBN(numAry:Vector.<Number>):Vector.<Number>{
			var ary:Vector.<Number> = new Vector.<Number>;
			
			for(var i:int;i<numAry.length/4;i++){
				ary.push(numAry[i * 4]);
				ary.push(numAry[i * 4 + 1]);
				ary.push(numAry[i * 4 + 2]);
			}
			
			//trace(numAry.length / 4,ary.length/3);
			return ary;
		}
		
		private function writeBindPos(byte:ByteArray,obj:ObjData):void{
			byte.writeInt(obj.bindPosBoneItems.length);
			for(var i:int;i<obj.bindPosBoneItems.length;i++){
				var ob:ObjectBone = obj.bindPosBoneItems[i];
				
				byte.writeFloat(ob.qx);
				byte.writeFloat(ob.qy);
				byte.writeFloat(ob.qz);
				
				byte.writeFloat(ob.tx);
				byte.writeFloat(ob.ty);
				byte.writeFloat(ob.tz);
				
			}
		}
		
		private function processParticle(byte:ByteArray,ary:Array,particleList:Array):void{
			byte.writeInt(ary.length);
			
			for(var i:int;i<ary.length;i++){
				var p:CombineParticle = getParticle(ary[i].url,particleList);
				var url:String = ExpToH5.getInstance().expParticleToH5(p,this._targetUrl);
				byte.writeUTF(url);
				byte.writeUTF(ary[i].name);
				
			}
		}
		
		private function getParticle(url:String,$particleList:Array):CombineParticle{
			for(var i:int;i<$particleList.length;i++){
				if($particleList[i].url == Scene_data.fileRoot + url){
					return $particleList[i];
				}
			}
			return null;
		}
		

		private function proceeMaterial($matrial:MaterialTree,$url:String):String{
			var url:String = $url.replace(".material",".txt");
//			var file:File = new File(Scene_data.fileRoot + url);
//			
//			var tempFile:File = new File(this._targetUrl);
//			tempFile = tempFile.parent;
//			var targetFileUrl:String = tempFile.url + "/" + url;
//			targetFileUrl = Cn2en.toPinyin(decodeURI(targetFileUrl));
//			
//			file.copyTo(new File(targetFileUrl),true);
			
			var str:String = ExpToH5.getInstance().expMaterialTreeToH5($matrial,this._targetUrl);
			
			return Cn2en.toPinyin(decodeURI(url));
			
		}
		
		public function writeByteNumVec(byte:ByteArray,numAry:Vector.<Number>):void{
			byte.writeInt(numAry.length);
			for(var i:int;i<numAry.length;i++){
				byte.writeFloat(numAry[i]);
			}
		}
		
		public function writeByteNumAry(byte:ByteArray,numAry:Array):void{
			byte.writeInt(numAry.length);
			for(var i:int;i<numAry.length;i++){
				byte.writeFloat(numAry[i]);
			}
		}
		
		public function writeByteIntAry(byte:ByteArray,numAry:Array):void{
			byte.writeInt(numAry.length);
			for(var i:int;i<numAry.length;i++){
				byte.writeInt(numAry[i]);
			}
		}
		
	}
}