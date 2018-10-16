package modules.hierarchy.h5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.core.Quaternion;
	import _Pan3D.display3D.analysis.ObjByteAnalysis;
	import _Pan3D.vo.anim.AnimVo;
	
	import _me.Scene_data;
	
	import common.AppData;

	public class ExpLyfTxtToByteFile
	{
		private static var instance:ExpLyfTxtToByteFile;
		private var urlDis:Dictionary=new Dictionary
		public function ExpLyfTxtToByteFile()
		{
		}
		public static function getInstance():ExpLyfTxtToByteFile{
			if(!instance){
				instance = new ExpLyfTxtToByteFile();
			}
			return instance;
		}
		public function buildLyfByUrl(value:String):void
		{
			value=value.replace(AppData.workSpaceUrl,"")
			
			
			if(!urlDis.hasOwnProperty(value)){
				urlDis[value]=true;
				
				Alert.show(decodeURI(value),"无地址提示_byte.txt")
				
				var $baseFile:File=new File(AppData.workSpaceUrl+value.replace(".lyf",".txt"))
					
	
				if($baseFile.exists){
					var $fs:FileStream = new FileStream;
					$fs.open($baseFile,FileMode.READ);
					var $str:String = $fs.readUTFBytes($fs.bytesAvailable)
	
					saveParticleByte($baseFile,JSON.parse($str))
					
					
					
				}	
				
				
			}
			
		}
		public function saveParticleByte($baseFile:File,infoArr:Object):void
		{

			
			
			
			
			var newUrl:String = $baseFile.url.replace($baseFile.type,"_byte.txt");
			//var file:File = new File("file:///C:/Users/pan/Desktop/workspace/webgl/WebGLEngine/res/dele/hd_pan.txt");
			
			var file:File = new File(newUrl);
			
			
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			var version:Number=Scene_data.version
			fs.writeInt(version);
			
			var len:uint=infoArr.length
				
				
			fs.writeInt(len)
			
			
			
			var k:Number=0
			
			for(var i:uint=0;i<len;i++ ){
				
				var $obj:Object=infoArr[i]
				var $allObjStr:String = JSON.stringify($obj);
				
				var particleType:Number=$obj.display.particleType
				fs.writeInt(particleType);
				//	fs.writeUTF($allObjStr);
				
				var vLen:Number
				var uLen:Number
				var iLen:Number
				var nLen:Number
				trace("=>",particleType)
				switch(particleType)
				{
					
					case 8:
					{
						
						writeDisplay3DBallPartilce(fs,$obj)
						break;
					}
					case 14:
					{
						
						fs.writeFloat( $obj.display.tangentSpeed)
						fs.writeUTF(JSON.stringify($obj.display.vecData.pos))
						fs.writeUTF(JSON.stringify($obj.display.vecData.angle))
						fs.writeUTF(JSON.stringify($obj.display.vecData.tangent))
	
						
						
						writeDisplay3DBallPartilce(fs,$obj)
						break;
					}
					case 18:
					{
						writeDisplay3DBallPartilce(fs,$obj)
						break;
					}
					case 4:
					case 7:
					case 9:
					{
						
						fs.writeFloat( $obj.display.maxAnimTime)
						vLen=$obj.display.vecData.ves.length
						uLen=$obj.display.vecData.uvs.length
						iLen=$obj.display.vecData.indexs.length
						fs.writeInt(vLen)
						for(k=0;k<vLen;k++){
							fs.writeFloat($obj.display.vecData.ves[k])
						}
						fs.writeInt(uLen)
						for(k=0;k<uLen;k++){
							fs.writeFloat($obj.display.vecData.uvs[k])
						}
						fs.writeInt(iLen)
						for(k=0;k<iLen;k++){
							fs.writeInt($obj.display.vecData.indexs[k])
						}
						
						fs.writeInt(Number($obj.display.depthMode));  //模型特效加入深度测试关系
					
			
						break;
					}
						
					case 1:
					{
						fs.writeFloat($obj.display.maxAnimTime);//f
						fs.writeBoolean($obj.display.isCycle);//b
						fs.writeBoolean( $obj.display.lockx);//b
						fs.writeBoolean($obj.display.locky);//b
						
						
						break;
						
						
						
					}
					case 12:
					{
						fs.writeFloat($obj.display.fenduanshu);//f
						break;
					}
					case 22:
					{
						fs.writeFloat($obj.display.itemNum);//f
						fs.writeFloat($obj.display.fenduanshu);//f
						break;
					}
					case 3:
					{
						
						
						fs.writeBoolean($obj.display.isLoop);  //b
						fs.writeFloat($obj.display.speed); //f
						fs.writeFloat($obj.display.density); //f
						fs.writeBoolean($obj.display.isEnd); //b
						
						
						
						vLen=$obj.display.vecData.vec.length
						nLen=$obj.display.vecData.normals.length
						uLen=$obj.display.vecData.uvs.length
						iLen=$obj.display.vecData.index.length
						fs.writeInt(vLen)
						for(k=0;k<vLen;k++){
							fs.writeFloat($obj.display.vecData.vec[k])
						}
						fs.writeInt(nLen)
						for(k=0;k<nLen;k++){
							fs.writeFloat($obj.display.vecData.normals[k])
						}
						fs.writeInt(uLen)
						for(k=0;k<uLen;k++){
							fs.writeFloat($obj.display.vecData.uvs[k])
						}
						fs.writeInt(iLen)
						for(k=0;k<iLen;k++){
							fs.writeInt($obj.display.vecData.index[k])
						}
						
						
						
						
						break;
						
					}
					case 13:   //骨骼粒子
					{
				
						writeBoneParticleData(fs,$obj.display)
						break;
					}
						
						
					default:
					{
						break;
					}
				}
				
				var timelineStr:String=JSON.stringify($obj.timeline);
				//fs.writeUTF(timelineStr)
				
				writeTimeline(fs,$obj.timeline)	

				fs.writeFloat($obj.display.delayedTime);//延时
				fs.writeFloat($obj.display.width);//f
				fs.writeFloat( $obj.display.height);//f
				fs.writeBoolean( $obj.display.widthFixed);//b
				fs.writeBoolean($obj.display.heightFixed);//b
				fs.writeFloat( $obj.display.originWidthScale);//f
				fs.writeFloat( $obj.display.originHeightScale);//f
				fs.writeFloat( $obj.display.eyeDistance);//f
				fs.writeFloat( $obj.display.alphaMode);//f
				fs.writeFloat( $obj.display.uSpeed);//f
				fs.writeFloat($obj.display.vSpeed);//f
				
				
				
				fs.writeFloat( $obj.display.animLine == 0 ? 1 : $obj.display.animLine);//f
				fs.writeFloat($obj.display.animRow == 0 ? 1 : $obj.display.animRow);//f
				fs.writeFloat( $obj.display.animInterval == 0 ? 1 : $obj.display.animInterval);//f
				fs.writeFloat( $obj.display.renderPriority);//f
				
				fs.writeBoolean( $obj.display.distortion);//b
				fs.writeBoolean($obj.display.isUV);//b
				fs.writeBoolean($obj.display.isU);//b
				fs.writeBoolean( $obj.display.isV);//b
				
				
				fs.writeFloat( $obj.display.life);//f
				fs.writeBoolean($obj.display.watchEye);//b
				if($obj.display.ziZhuanAngly==null){
					$obj.display.ziZhuanAngly=new Vector3D();
				}
				fs.writeFloat( $obj.display.ziZhuanAngly.x);//v
				fs.writeFloat( $obj.display.ziZhuanAngly.y);//v
				fs.writeFloat( $obj.display.ziZhuanAngly.z);//v
				fs.writeFloat( $obj.display.ziZhuanAngly.w);//v
				
				
				
				fs.writeFloat( $obj.display.rotationX);//v
				fs.writeFloat( $obj.display.rotationY);//v
				fs.writeFloat( $obj.display.rotationZ);//v
				
				fs.writeFloat( $obj.display.center.x);//v
				fs.writeFloat( $obj.display.center.y);//v
				fs.writeFloat( $obj.display.center.z);//v
				fs.writeFloat( $obj.display.center.w);//v
				
				fs.writeFloat( $obj.display.overAllScale);//f
				
				
				
				//var materialParamStr:String = JSON.stringify($obj.display.materialParam);
				//fs.writeUTF(materialParamStr);
				
				this.writeMaterialParam(fs,$obj.display.materialParam)
				
				fs.writeUTF($obj.display.materialUrl);
				
				
				
				
			}
			
			fs.close();
			
			
		}
		private function writeByteNumVec(byte:FileStream,numAry:Vector.<Number>):void{
			ExpResourcesModel.getInstance().writeVecFloatToInt(numAry,byte)
			
		}

		//写入谷歌ID
		private function writeBoneID(byte:FileStream,numAry:Array):void
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
		private function writeByteNumAry(byte:FileStream,numAry:Array):void{
			byte.writeInt(numAry.length);
			
			for(var i:int;i<numAry.length;i++){
				var num:int=numAry[i]*255-128;
				if(num<-128||num>127){
					Alert.show("联系管理员，writeByteNumAry出错")
				}
				byte.writeByte(num);
				
			}	
			
		}
		private function processBoneIDAry(numAry:Array):Array{
			var ary:Array = new Array;
			for(var i:int;i<numAry.length;i++){
				var num:uint =Math.floor( (numAry[i] - 20) / 4);
				ary.push(num);
			}
			return ary;
		}
		private function writeByteIntAry(byte:FileStream,numAry:Array):void{
			var arr:Vector.<uint>=new Vector.<uint>
			for(var i:int;i<numAry.length;i++){
				if(numAry[i]<0||int(numAry[i])!=numAry[i]){
					Alert.show("联系管理员，writeByteIntAry出错")
				}
				arr.push(numAry[i])
			}
			ExpResourcesModel.getInstance().writeIndexToByte(arr,byte)
			
			
			
		}
		//放大顶点
		private function processVertices(numAry:Vector.<Number>,$scale:Number):Vector.<Number>
		{
			var $arr:Vector.<Number>=new Vector.<Number>
			for(var i:int;i<numAry.length;i++){
				$arr.push(numAry[i]*$scale)
			}
			return $arr
		
		}
		private function writeBoneParticleData(fs:FileStream,display:Object):void
		{
			
            fs.writeFloat(display.objScale)	
			var meshData:MeshData=display.vecData.meshData;
			var boneObjData:ObjData=display.vecData.boneObjData;
			
	
			var byte:FileStream=fs;
		
			writeByteNumVec(byte,processVertices(boneObjData.vertices,display.objScale));
  		    writeByteNumVec(byte,boneObjData.uvs);
 			writeByteIntAry(byte,meshData.indexAry);
	    	writeBoneID(byte,processBoneIDAry(meshData.bonetIDAry));
			writeByteNumAry(byte,meshData.boneWeightAry);

			
			var frames:Vector.<Vector.<Matrix3D>>=display.vecData.boneAnimMatrxItem
			this.wirteBoneAnimQuaternion(fs,frames,display.objScale,meshData.boneNewIDAry)

			
		}
		
		private function wirteBoneAnimQuaternion(fs:FileStream,frames:Vector.<Vector.<Matrix3D>>,objScale:Number,boneNewIDAry:Array):void
		{
		
			var $tempArr:Vector.<Number>=new Vector.<Number>
			var baseM:Matrix3D;
			var q:Quaternion;
			var p:Vector3D;

			for(var i:Number=0;i<frames.length;i++){
				for(var j:Number=0;j<frames[i].length;j++){
					baseM=frames[i][j].clone()
					baseM.appendScale(-1,1,1)
					q=new Quaternion();
					q.fromMatrix(baseM);
					p=baseM.position;
					$tempArr.push(p.x,p.y,p.z);
				}
			}
			var temp:Number=0
			for(var k:Number=0;k<$tempArr.length;k++)
			{
				if(Math.abs(temp)<Math.abs($tempArr[k])){
					temp=$tempArr[k]
				}
			}
			temp=temp*objScale
			var rgb32767:Number=32767
			var $scaleNum:Number=rgb32767/temp;
			fs.writeFloat(temp)//比例
			fs.writeInt(frames.length)
			for( i=0;i<frames.length;i++){
				fs.writeInt(boneNewIDAry.length)
				for( j=0;j<boneNewIDAry.length;j++){
					//baseM=frames[i][j].clone()
					//trace(frames[i].length,boneNewIDAry.length)
					baseM=frames[i][boneNewIDAry[j]].clone()
					baseM.appendScale(-1,1,1)
						
					q=new Quaternion();
					q.fromMatrix(baseM);
					p=baseM.position;
					
					fs.writeShort(int(q.x*rgb32767))
					fs.writeShort(int(q.y*rgb32767))
					fs.writeShort(int(q.z*rgb32767))
					fs.writeShort(int(q.w*rgb32767))
					
					fs.writeShort(int(p.x*$scaleNum*objScale))
					fs.writeShort(int(p.y*$scaleNum*objScale))
					fs.writeShort(int(p.z*$scaleNum*objScale))
			
				}
			}
			
			
	
		}
		

		private function writeMaterialParam(fs:FileStream,materialParam:Object):void
		{
			var byte:ByteArray=new ByteArray;
			
			fs.writeUTF(materialParam.materialUrl)
			var texAryLen:uint=materialParam.texAry.length;
			fs.writeInt(texAryLen)
			for(var i:uint =0;i<texAryLen;i++)
			{
				fs.writeBoolean(materialParam.texAry[i].isParticleColor)
				fs.writeUTF(materialParam.texAry[i].paramName)
				if(materialParam.texAry[i].url==null){
					materialParam.texAry[i].url=""
				}
				fs.writeUTF(materialParam.texAry[i].url)
				
				if(materialParam.texAry[i].isParticleColor){
					
					
					writeCurve(fs,materialParam.texAry[i].curve)
				}	
			}
			
			//fs.writeUTF(JSON.stringify(materialParam.conAry));
			
			writeMaterialParamCurve(fs,materialParam.conAry)
			
			
		
			
		}
	
		private function writeMaterialParamCurve(fs:FileStream,conAry:Array):void
		{
			
			var conAryLen:uint=conAry.length;
			fs.writeInt(conAryLen)
			for(var i:uint=0;i<conAryLen;i++){
				
				fs.writeFloat(conAry[i].type);
				fs.writeFloat(conAry[i].indexID);
				fs.writeUTF(conAry[i].paramName);
		
				this.writeCurve(fs,conAry[i].curve)
				
			}
			
		}
		private function wrtieCurveValues(fs:FileStream,curve:Object):void
		{
			var $len:int=curve.values.length

			fs.writeInt($len)
			if($len){
		
				var temp:Number=0;
				for(var a:uint=0;a<$len;a++)
				{
					for(var b:uint=0;b<curve.values[i].length;b++)
					{
						if(Math.abs(temp)<Math.abs(curve.values[a][b])){
							temp=curve.values[a][b]
						}
					}
				}
				fs.writeFloat(temp)
				for(var i:uint=0;i<$len;i++)
				{
					var rgbLen:int=curve.values[i].length;
					fs.writeInt(rgbLen)
					for(var j:uint=0;j<rgbLen;j++)
					{
						var  knum:Number=curve.values[i][j];
						fs.writeByte(int(knum/temp*127))	
					}
				}
			}
		}
		private function writeCurve(fs:FileStream,curve:Object):void
		{
			
			if(true){   //第一个版本
				this.wrtieCurveValues(fs,curve)
			
			}

			fs.writeFloat(curve.type);
			fs.writeFloat(curve.maxFrame);
			fs.writeBoolean(curve.sideType);
			fs.writeBoolean(curve.speedType);
			fs.writeBoolean(curve.useColorType);
			
			this.writeCurveItems(fs,curve.items)
			
		}
		
		private function writeCurveItems(fs:FileStream,items:Array):void
		{
			
			var itemsLen:uint=items.length;
			fs.writeInt(itemsLen);
			for(var i:uint=0;i<itemsLen;i++){
			
				var  $obj:Object=new Object
				$obj.frame=items[i].frame;
				$obj.vec3=items[i].vec3
				$obj.rotation=items[i].rotation
				$obj.rotationLeft=items[i].rotationLeft

				fs.writeInt($obj.frame);
				fsWriteVec3D(fs,$obj.vec3);
				fsWriteVec3D(fs,$obj.rotation);
				fsWriteVec3D(fs,$obj.rotationLeft);

				
			}
			
			
		}
		private function fsWriteVec3D(fs:FileStream,vec:Object):void
		{
			fs.writeFloat(vec.x)
			fs.writeFloat(vec.y)
			fs.writeFloat(vec.z)
			fs.writeFloat(vec.w)
		}
		
		private function writeTimeline(fs:FileStream,timeline:Object):void
		{
			
			var len:Number=timeline.length;
			fs.writeFloat(len)
			for(var i:uint=0;i<len;i++)
			{
				var temp:Object=timeline[i];
				fs.writeFloat(temp.frameNum);
				for(var j:uint=0;j<10;j++){
					if(temp.baseValue){
						fs.writeFloat(temp.baseValue[j])
					}else{
						fs.writeFloat(0)
					}
				}
				if(temp.animdata){
					var animLen:Number=temp.animdata.length;
					fs.writeFloat(animLen);
					for(var k:uint=0;k<animLen;k++)
					{
						var animObj:Object=temp.animdata[k];
						writeAnimDataType(fs,animObj)
						//fs.writeUTF(JSON.stringify(animObj))
						
					}
				}else{
					fs.writeFloat(0);
				}
				
				
			}
			
		}
		private function writeAnimDataType(fs:FileStream,animObj:Object):void
		{
			fs.writeInt(animObj.type)
			var len:Number=animObj.data.length;
			fs.writeInt(len);
			for(var i:uint=0;i<len;i++)
			{
				var typeNum:Number=animObj.data[i].type;
				fs.writeInt(typeNum);
				//fs.writeUTF(animObj.data[i].value);
				if(typeNum==1){
					fs.writeFloat(animObj.data[i].value)
				}
				if(typeNum==2){
					var arrStr:Array=animObj.data[i].value.split("|")
					fs.writeFloat(arrStr[0]);
					fs.writeFloat(arrStr[1]);
					fs.writeFloat(arrStr[2]);
				}
				
			}
			
			
			
		}
		private function writeDisplay3DBallPartilce(fs:FileStream,$obj:Object):void
		{
			fs.writeFloat($obj.display.totalNum);	//this._totalNum = obj.totalNum;
			fs.writeFloat($obj.display.acceleration);		//this._acceleration = obj.acceleration;
			fs.writeFloat($obj.display.toscale);	//this._toscale = obj.toscale;
			fs.writeFloat($obj.display.shootSpeed);	//this._shootSpeed = obj.shootSpeed;
			fs.writeBoolean($obj.display.isRandom);	//this._isRandom = obj.isRandom;
			fs.writeBoolean($obj.display.isSendRandom);	//this._isSendRandom = obj.isSendRandom;
			fs.writeFloat($obj.display.round.x);	//this._round = this.getVector3DByObject(obj.round);
			fs.writeFloat($obj.display.round.y);	//this._round = this.getVector3DByObject(obj.round);
			fs.writeFloat($obj.display.round.z);	//this._round = this.getVector3DByObject(obj.round);
			fs.writeFloat($obj.display.round.w);	//this._round = this.getVector3DByObject(obj.round);
			fs.writeBoolean($obj.display.is3Dlizi);	//this._is3Dlizi = obj.is3Dlizi;
			fs.writeBoolean($obj.display.halfCircle);	//this._halfCircle = obj.halfCircle;
			if($obj.display.shootAngly==null){
				$obj.display.shootAngly=new Vector3D();
			}
			fs.writeFloat($obj.display.shootAngly.x);	//this._shootAngly = this.getVector3DByObject(obj.shootAngly);
			fs.writeFloat($obj.display.shootAngly.y);	//this._shootAngly = this.getVector3DByObject(obj.shootAngly);
			fs.writeFloat($obj.display.shootAngly.z);	//this._shootAngly = this.getVector3DByObject(obj.shootAngly);
			fs.writeFloat($obj.display.shootAngly.w);	//this._shootAngly = this.getVector3DByObject(obj.shootAngly);
			fs.writeFloat($obj.display.speed);	//this._speed = obj.speed;
			fs.writeBoolean($obj.display.isLoop);	//this._isLoop = obj.isLoop;
			fs.writeBoolean($obj.display.isSendAngleRandom);	//this._isSendAngleRandom = obj.isSendAngleRandom;
			fs.writeFloat($obj.display.waveform.x);	//this._waveform = this.getVector3DByObject(obj.waveform);
			fs.writeFloat($obj.display.waveform.y);	//this._waveform = this.getVector3DByObject(obj.waveform);
			fs.writeFloat($obj.display.waveform.z);	//this._waveform = this.getVector3DByObject(obj.waveform);
			fs.writeFloat($obj.display.waveform.w);	//this._waveform = this.getVector3DByObject(obj.waveform);
			fs.writeBoolean($obj.display.closeSurface);	//this._closeSurface = obj.closeSurface;
			fs.writeBoolean($obj.display.isEven);	//this._isEven = obj.isEven;
			fs.writeFloat($obj.display.paticleMaxScale);	//this._paticleMaxScale = obj.paticleMaxScale;
			fs.writeFloat($obj.display.paticleMinScale);	//this._paticleMinScale = obj.paticleMinScale;
			fs.writeFloat($obj.display.basePositon.x);	//this._basePositon = this.getVector3DByObject(obj.basePositon);
			fs.writeFloat($obj.display.basePositon.y);	//this._basePositon = this.getVector3DByObject(obj.basePositon);
			fs.writeFloat($obj.display.basePositon.z);	//this._basePositon = this.getVector3DByObject(obj.basePositon);
			fs.writeFloat($obj.display.basePositon.w);	//this._basePositon = this.getVector3DByObject(obj.basePositon);
			fs.writeFloat($obj.display.baseRandomAngle);	//this._baseRandomAngle = obj.baseRandomAngle;
			fs.writeFloat($obj.display.shapeType);	//this._shapeType = obj.shapeType;
			
			fs.writeBoolean($obj.display.lockX);	//this._lockX = obj.lockX;
			fs.writeBoolean($obj.display.lockY);	//this._lockY = obj.lockY;
			
			//	fs.writeFloat($obj.display.totalNum);	//this._textureRandomColorInfo = obj.randomColor;
			
			fs.writeFloat($obj.display.addforce.x);	//this._addforce = this.getVector3DByObject(obj.addforce);
			fs.writeFloat($obj.display.addforce.y);	//this._addforce = this.getVector3DByObject(obj.addforce);
			fs.writeFloat($obj.display.addforce.z);	//this._addforce = this.getVector3DByObject(obj.addforce);
			fs.writeFloat($obj.display.addforce.w);	//this._addforce = this.getVector3DByObject(obj.addforce);
			
			
			fs.writeFloat($obj.display.lixinForce.x);	//this._lixinForce = this.getVector3DByObject(obj.lixinForce);
			fs.writeFloat($obj.display.lixinForce.y);	//this._lixinForce = this.getVector3DByObject(obj.lixinForce);
			fs.writeFloat($obj.display.lixinForce.z);	//this._lixinForce = this.getVector3DByObject(obj.lixinForce);
			fs.writeFloat($obj.display.lixinForce.w);	//this._lixinForce = this.getVector3DByObject(obj.lixinForce);
			
			
			
			
			fs.writeBoolean($obj.display.islixinAngly);	//this._islixinAngly = obj.islixinAngly;
			fs.writeFloat($obj.display.particleRandomScale.x);	//this._particleRandomScale = this.getVector3DByObject(obj.particleRandomScale);
			fs.writeFloat($obj.display.particleRandomScale.y);	//this._particleRandomScale = this.getVector3DByObject(obj.particleRandomScale);
			fs.writeFloat($obj.display.particleRandomScale.z);	//this._particleRandomScale = this.getVector3DByObject(obj.particleRandomScale);
			fs.writeFloat($obj.display.particleRandomScale.w);	//this._particleRandomScale = this.getVector3DByObject(obj.particleRandomScale);
			fs.writeFloat($obj.display.playSpeed);	//this._playSpeed = obj.playSpeed;
			
			fs.writeBoolean($obj.display.facez);	//this.facez = obj.facez;
			fs.writeFloat($obj.display.beginScale);	//this._beginScale = obj.beginScale;
			
			
			fs.writeBoolean($obj.display.widthFixed);
			fs.writeBoolean( $obj.display.heightFixed);
			
			
			writeRandomColor(fs,$obj.display.randomColor)
			
			
			
		}
		private function writeRandomColor(fs:FileStream,randomColor:Object):void
		{
			
			

			fs.writeInt(0)
		
			
		}
		
	}
}