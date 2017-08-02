package view.mesh
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.utils.Cn2en;
	import _Pan3D.vo.anim.BoneSocketData;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.h5.ExpH5ByteModel;
	import modules.hierarchy.h5.ExpResourcesModel;
	
	import view.action.ActionPanel;
	import view.byteFile.AnimFileToByteUtils;

	public class RoleExpNew
	{
		public function RoleExpNew()
		{
		}
		
		private var  _rootUrl:String;

		private var _outputfileName:String;
		
		private function writeVaDataItem($byte:ByteArray,$objData:ObjData,$materialTree:MaterialTree):void
		{
			var $verLen:Number=$objData.vertices.length/3;
			$byte.writeInt($verLen)
			var $item:Array=new Array;
			$item.push(true)
			$item.push(true)
			
	
			if(	$materialTree.usePbr||$materialTree.directLight){  //normals
				$item.push(true)
			}else{
				$item.push(false)
			}
			if($materialTree.useNormal){
				$item.push(true)
				$item.push(true)
			}else{
				$item.push(false)
				$item.push(false)
			}
			for(var i:Number=0;i<$item.length;i++)
			{
				$byte.writeBoolean($item[i])
			}
			trace($objData.vertices.length);
			trace($objData.uvs.length);
			
		
			
			trace($objData.normals.length);
			trace($objData.tangents.length);
			trace($objData.bitangents.length);

	
			trace($item)
			trace($verLen)
			trace("-----------------------------")
			
		}
		
			
		
		public function exp(isUi:Boolean,meshAry:Array,meshDic:Object,objDic:Dictionary,particleDic:Object,socketDic:Object,$tragetUrl:String,fileName:String,includeImg:Boolean,$bfun:Function):void{
			

			this._outputfileName = fileName;
		

			_rootUrl = $tragetUrl + "/";
			
			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
				

			var byte:ByteArray = new ByteArray;
			byte.writeInt(Scene_data.version)
			if(isUi){
				byte.writeUTF("role/ui/" + fileName + ".txt");
			}else{
				byte.writeUTF("role/" + fileName + ".txt");
			}
			this.writeAmbientSunLight(byte)
			byte.writeFloat(AppDataBone.fileScale);
			byte.writeFloat(AppDataBone.tittleHeight);
			byte.writeFloat(AppDataBone.hitBoxPoint.x);
			byte.writeFloat(AppDataBone.hitBoxPoint.y);
			
			if(AppDataBone.tittleHeight==0){
				Alert.show("确定是否名字高度为0")
			}
			
			byte.writeInt(meshAry.length);
			for(var i:int=0;i<meshAry.length;i++){
				var key:String = meshAry[i].fileName;
				var meshData:MeshData = meshDic[key];
				var objData:ObjData = objDic[meshData];
				
				this.writeVaDataItem(byte,objData,meshData.material)
				writeByteNumVec(byte,objData.vertices);
				writeByteNumVec(byte,objData.uvs);

				if(	meshData.material.usePbr||meshData.material.directLight){  //normals
					writeByteNumVec(byte,getV4ToV3(objData.normals)); 
				}else{
					byte.writeFloat(0)
				}
				if(	meshData.material.useNormal){  //normals
					writeByteNumVec(byte,getV4ToV3(objData.tangents));
					writeByteNumVec(byte,getV4ToV3(objData.bitangents));
				}else{
					byte.writeFloat(0)
					byte.writeFloat(0)
				}

				writeBoneID(byte,processBoneIDAry(meshData.bonetIDAry));
				
				writeByteNumAry(byte,meshData.boneWeightAry);
				writeByteIntAry(byte,meshData.indexAry);
				writeByteIntAry(byte,meshData.boneNewIDAry);
				
				var materilaUrl:String = ExpResourcesModel.getInstance().expMaterialTreeToH5(meshData.material,this._rootUrl);
				
				
				ExpResourcesModel.getInstance().expMaterialInfoArr(meshAry[i].materialInfoArr,this._rootUrl);
				
				byte.writeUTF(materilaUrl);
				
				this.writeMaterialParam(byte,meshAry[i].materialInfoArr);
				
				if(meshAry[i].particleList){
					processParticle(byte,meshAry[i].particleList,particleDic[key]);
				}else{
					byte.writeInt(0);
				}
			}
	
		
			ExpResourcesModel.getInstance().run()
			
			function returnFun():void{
				writeBindPos(byte,objData);
				writeSocketList(byte,socketDic);
				ExpH5ByteModel.getInstance().addInfoStr="\n----------------\nmesh数据 :"+byte.length/1000+"k";
				var actionByte:ByteArray = getAction();
				byte.writeBytes(actionByte,0,actionByte.length);
				
	
				
				ExpH5ByteModel.getInstance().WriteByte(byte,includeImg,[1,3,4])
				
				$bfun(byte)
				
				
			}
			
	
		}
		//法线只需要3位
		private function getV4ToV3(a:Vector.<Number>):Vector.<Number>
		{
			var temp:Vector.<Number>=new Vector.<Number>;
			for(var i:Number=0;i<a.length/4;i++){
				temp.push(a[i*4+0])
				temp.push(a[i*4+1])
				temp.push(a[i*4+2])
			}
			
			return temp
		}
		private function writeAmbientSunLight(byte:ByteArray):void
		{
			Scene_data.light.AmbientLight.color // Ambient颜色
			Scene_data.light.AmbientLight.intensity  //Ambient强度
			Scene_data.light.SunLigth.color   //sun光颜色
			Scene_data.light.SunLigth.intensity //sun强度
			Scene_data.light.SunLigth.dircet	//sun方向
				
				
				
			byte.writeFloat(Scene_data.light.AmbientLight.color.x/255)
			byte.writeFloat(Scene_data.light.AmbientLight.color.y/255)
			byte.writeFloat(Scene_data.light.AmbientLight.color.z/255)

			byte.writeFloat(Scene_data.light.AmbientLight.intensity)
				
			byte.writeFloat(Scene_data.light.SunLigth.color.x/255)
			byte.writeFloat(Scene_data.light.SunLigth.color.y/255)
			byte.writeFloat(Scene_data.light.SunLigth.color.z/255)

			byte.writeFloat(Scene_data.light.SunLigth.intensity)
				
			byte.writeFloat(Scene_data.light.SunLigth.dircet.x)
			byte.writeFloat(Scene_data.light.SunLigth.dircet.y)
			byte.writeFloat(Scene_data.light.SunLigth.dircet.z)

				
		}
			
		
		private function writeMaterialParam(byte:ByteArray,ary:Array):void{
			if(!ary){
				byte.writeInt(0);
				return;
			}
			
			byte.writeInt(ary.length);
			for(var i:int=0;i<ary.length;i++){
				byte.writeUTF(ary[i].name);
				byte.writeByte(ary[i].type);
				if(ary[i].type == 0){
					var url:String = Cn2en.toPinyin(decodeURI(ary[i].url));
					byte.writeUTF(url);
				}else if(ary[i].type == 1){
					byte.writeFloat(ary[i].x);
				}else if(ary[i].type == 2){
					byte.writeFloat(ary[i].x);
					byte.writeFloat(ary[i].y);
				}else if(ary[i].type == 3){
					byte.writeFloat(ary[i].x);
					byte.writeFloat(ary[i].y);
					byte.writeFloat(ary[i].z);
				}
			}
			
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
				var url:String =ExpResourcesModel.getInstance().expParticleToH5(p,this._rootUrl);
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
			
			var str:String =ExpResourcesModel.getInstance().expMaterialTreeToH5($matrial,this._rootUrl);
			
			return Cn2en.toPinyin(decodeURI(url));
			
		}
		
		private function writeByteNumVec(byte:ByteArray,numAry:Vector.<Number>):void{
			ExpResourcesModel.getInstance().writeVecFloatToInt(numAry,byte)
	
		}
		//写入谷歌ID
		private function writeBoneID(byte:ByteArray,numAry:Array):void
		{
			byte.writeInt(numAry.length);
			for(var i:int;i<numAry.length;i++){
				if(numAry[i]<0||numAry[i]>=127||numAry[i]!=int(numAry[i])){
				   Alert.show("联系管理员，writeBoneID出错")
				}
				byte.writeByte(numAry[i]);  //在这保留了负数。最多骨骼为127个
			}
	
		}
		//写入权重 
		private function writeByteNumAry(byte:ByteArray,numAry:Array):void{
			byte.writeInt(numAry.length);
			
			for(var i:int;i<numAry.length;i++){
				var num:int=numAry[i]*255-128;
				if(num<-128||num>127){
					Alert.show("联系管理员，writeByteNumAry出错")
				}
				byte.writeByte(num);

			}	

		}
		
		private function writeByteIntAry(byte:ByteArray,numAry:Array):void{
			var arr:Vector.<uint>=new Vector.<uint>
			for(var i:int;i<numAry.length;i++){
				if(numAry[i]<0||int(numAry[i])!=numAry[i]){
					Alert.show("联系管理员，writeByteIntAry出错")
				}
				arr.push(numAry[i])
			}
			ExpResourcesModel.getInstance().writeIndexToByte(arr,byte)
			
			
		
		}
		
		private function getAction():ByteArray{
			var ary:Array = ActionPanel.getInstance().dataAry.source;
			var byte:ByteArray = new ByteArray;
			byte.writeInt(ary.length);
			var infoStr:String="\n-----------------"
			for(var i:int=0;i<ary.length;i++){
				var itemByte:ByteArray = getActionFileByte(ary[i]);
				byte.writeUTF(ary[i].fileName);
				byte.writeBytes(itemByte,0,itemByte.length);
				
				infoStr+="\n"+(ary[i].fileName+" "+itemByte.length/1000+"k")
			}
			infoStr+="\n 所有动作=>"+byte.length/1000+"k"
			ExpH5ByteModel.getInstance().addInfoStr+=infoStr;
			return byte;
			
		}
		
		public function getActionFileByte(action:Object):ByteArray{
			var allStr:String = action.str;
			if(action.nameHeight){
				allStr = "nameheight " + action.nameHeight  + "\r\n" + allStr;
			}
			
			if(action.bound){//写入盒子信息
				var boundstr:String = new String;
				for(var i:int=0;i<action.bound.length;i++){
					boundstr += action.bound[i].x + "," + action.bound[i].y + "," + action.bound[i].z + ","
				}
				allStr = "mybounds " + boundstr  + "\r\n" + allStr;
			}
			
			if(action.interAry ){//写入插帧值信息
				var interStr:String = new String;
				for(i=0;i<action.interAry.length;i++){
					interStr += action.interAry[i]+",";
				}
				allStr = "inter " + interStr + "\r\n" + allStr;
			}
			
			if(action.inLoop){//写入循环帧信息
				allStr = "inLoop " + action.inLoop  + "\r\n" + allStr;
			}
			
			if(action.pos){
				var posStr:String = new String;
				for(i=0;i<action.pos.length;i++){
					posStr += action.pos[i].x + "," + action.pos[i].y + "," + action.pos[i].z + ","
				}
				
				allStr = "pos " + posStr  + "\r\n" + allStr;
			}
			
			
			var anfil:AnimFileToByteUtils = new AnimFileToByteUtils();
			return anfil.processStr2Byte(allStr,action.fileName);
		}
		
	}
}