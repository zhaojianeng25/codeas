package exph5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.utils.Cn2en;
	import _Pan3D.utils.editorutils.Display3DEditorMovie;
	import _Pan3D.vo.anim.BoneSocketData;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import exph5.exprole.AnimFileToByteUtils;
	import exph5.exprole.ExpActionModel;
	
	import materials.MaterialTree;
	
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.h5.ExpH5ByteModel;
	import modules.hierarchy.h5.ExpResourcesModel;
	import modules.hierarchy.h5.MakeResFileList;
	
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.FrameModel;
	
	import proxy.pan3d.roles.ProxyPan3DRole;
	

	public class ExpFrameRoleH5Model
	{
		private static var instance:ExpFrameRoleH5Model;

		public function ExpFrameRoleH5Model()
		{
		}
		public static function getInstance():ExpFrameRoleH5Model{
			if(!instance){
				instance = new ExpFrameRoleH5Model();
			}
			return instance;
		}
		private var roleSprite:Display3DEditorMovie;
		private var bFun:Function;
		public function expRole($node:FrameFileNode,$bfun:Function):void
		{
			this.bFun=$bfun;
			MakeResFileList.getInstance().clear();
			ExpH5ByteModel.getInstance().clear();


		

			this._outputfileName =Cn2en.toPinyin(new File(AppData.workSpaceUrl+$node.url).name);
			this._outputfileName="role/"+this._outputfileName.replace(".zzw",".txt")
				
			if($node&&$node.iModel as ProxyPan3DRole){
				Scene_data.md5Root=AppData.workSpaceUrl;
				this.roleSprite=ProxyPan3DRole($node.iModel).sprite
				this.selectRoleFile($node.url)
			}else{
			
				Alert.show("请选角色对象")
			}
		}
		private var onebyoneItem:Vector.<FrameFileNode>;
		private var nameStrItem:Array;
		private var finishFun:Function
		public function expAllRoleNode($finishFun:Function):void
		{
			this.finishFun=$finishFun
			this.nameStrItem=new Array;
			var $listArr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>;
			var arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<arr.length;i++){
				if(arr[i].type==FrameFileNode.build1){
					if(arr[i].url.search(".zzw")!=-1){
						$listArr.push(arr[i])
					}
				}
			}
			this.onebyoneItem=mathOnlyUrlArr($listArr);
	
			this.meshOneByOne();
		}
		private function meshOneByOne(str:String=null):void
		{
			if(str){
				this.nameStrItem.push(str)
			}
			if(this.onebyoneItem.length>0){
			    var $node:FrameFileNode=	this.onebyoneItem.pop();
				expRole($node,meshOneByOne);
			}else{
				this.finishFun(this.nameStrItem)
			}
		
		}
		private function mathOnlyUrlArr(arr:Vector.<FrameFileNode>):Vector.<FrameFileNode>
		{
			var tempArr:Vector.<FrameFileNode>=new Vector.<FrameFileNode>
			for(var i:uint=0;i<arr.length;i++){
				var $needAdd:Boolean=true
				for(var j:uint=0;j<tempArr.length;j++){
					if(tempArr[j]==arr[i]){
						$needAdd=false
					}
				}
				if($needAdd){
					tempArr.push(arr[i])
				}
			}
			return tempArr;
		}
		private var treeAry:ArrayCollection;
		private var _outputfileName:String;
		private function selectRoleFile ($url:String):void
		{
			
			var fs:FileStream = new FileStream;
			fs.open(new File(AppData.workSpaceUrl+$url),FileMode.READ);
			var $obj:Object = fs.readObject();
			fs.close();
			
			ExpActionModel.getInstance().setAllInfo($obj.bone);
			var meshAry:Array = meshFilter($obj.mesh);
			var meshDic:Object = this.roleSprite.getMeshDic();
			var objDic:Dictionary = this.roleSprite.getObjDic();
			var particleDic:Object = this.roleSprite.getParticleDic();
			var socketDic:Object = this.roleSprite.getSocketDic();
			this.writeBytetoFile(meshAry,meshDic,objDic,particleDic,socketDic);
	
		}
		private function meshFilter(sourceAry:ArrayCollection):Array{
			var ary:Array = new Array;
			for(var i:int;i<sourceAry.length;i++){
				var children:ArrayCollection = sourceAry[i].children;
				for(var j:int=0;j<children.length;j++){
					if(children[j].check){
						ary.push(children[j]);
					}
				}
			}
			return ary;
		}
		private function popEmptyBone($arr:Array):Array    //非常之需要优化的部分。在导出角色时的新骨骼I，为0时就不存了，需要抽空注意。保持通用
		{
			var $backArr:Array=new Array();
			for(var i:Number=0;i<$arr.length;i++){
				if($arr[i]>0){
					$backArr.push($arr[i])
				}
			}	
			return $backArr
		
		}
		private var _rootUrl:String="file:///E:/codets/game/arpg/arpg/res/"
			
		private function writeBytetoFile(meshAry:Array,meshDic:Object,objDic:Dictionary,particleDic:Object,socketDic:Object):void
		{
		
			
			ExpResourcesModel.getInstance().initData(_rootUrl,returnFun)
			var byte:ByteArray = new ByteArray;
			byte.writeInt(Scene_data.version)

			byte.writeUTF(this._outputfileName);
		
			this.writeAmbientSunLight(byte)
			byte.writeFloat(1);  // byte.writeFloat(AppDataBone.fileScale);
			byte.writeFloat(10); // byte.writeFloat(AppDataBone.tittleHeight);
			byte.writeFloat(10); // byte.writeFloat(AppDataBone.hitBoxPoint.x);
			byte.writeFloat(10); //	 byte.writeFloat(AppDataBone.hitBoxPoint.y);
			
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
				

				
				writeByteIntAry(byte,popEmptyBone(meshData.boneNewIDAry));  //这里特殊的骨骼位置。
	
				
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
				var actionByte:ByteArray = getAction();
				actionByte.compress();
				byte.writeInt(actionByte.length);
				byte.writeBytes(actionByte,0,actionByte.length);
				ExpH5ByteModel.getInstance().WriteByte(byte,true,[1,3,4],false);
				wrtieToRoleFile(byte);
				
				bFun(_outputfileName) //回调整
			}
		}
		private function wrtieToRoleFile($byte:ByteArray):void
		{
			var fs:FileStream = new FileStream;
			
			var file1Url:String=_rootUrl+this._outputfileName
			var file:File = new File(file1Url);
			fs.open(file,FileMode.WRITE);
			fs.writeBytes($byte);
			fs.close();
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
		/*
		private function readTestByte():ByteArray
		{
			var fs:FileStream = new FileStream;
			var file1Url:String="file:///E:/codets/game/arpg/arpg/res/test.txt"
			var file:File = new File(file1Url);
			fs.open(file,FileMode.READ);
			var $byte:ByteArray=new ByteArray;


			var obj:Object= fs.readObject()
			fs.close();
			return obj.byte
			
		}
		*/
		private function getAction():ByteArray{
			var ary:Array = ExpActionModel.getInstance().dataAry.source;
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
		private function processBoneIDAry(numAry:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<numAry.length;i++){
				var num:Number = (numAry[i] - 20) / 4;
				ary.push(num);
			}
			
			return ary;
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
		private function writeByteNumVec(byte:ByteArray,numAry:Vector.<Number>):void{
			ExpResourcesModel.getInstance().writeVecFloatToInt(numAry,byte)
			
		}
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
	}
}