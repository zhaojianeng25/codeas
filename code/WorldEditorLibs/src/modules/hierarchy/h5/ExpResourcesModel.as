package modules.hierarchy.h5
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.analysis.TBNUtils;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.utils.Cn2en;
	
	import _me.Scene_data;
	
	import collision.CollisionType;
	
	import common.AppData;
	
	import materials.MaterialTree;
	
	import modules.materials.MaterialSaveModel;

	public class ExpResourcesModel
	{
		private var _picItem:Array
		private var _objsItem:Array
		private var _materialItem:Array
		private var _lyfItem:Array
		private var _rootUrl:String
		private var _particleUrlDic:Dictionary
		private static var instance:ExpResourcesModel;
		

		public function get objsItem():Array
		{
			return _objsItem;
		}

		public function set objsItem(value:Array):void
		{
			_objsItem = value;
		}

		public function get picItem():Array
		{
			return _picItem;
		}

		public static function getInstance():ExpResourcesModel{
			if(!instance){
				instance = new ExpResourcesModel();
			}
			return instance;
		}	
		
		public function ExpResourcesModel()
		{
		}
		private var _bFun:Function
		/**
		 * 
		 * @param $url  路径
		 * @param $fun  加载都完成后回调
		 * 
		 */
		public function initData($url:String,$fun:Function):void{
			_rootUrl = $url;
			_bFun=$fun
			clear();
		}
		private  function clear():void	
		{
			_picItem=new Array
			_objsItem=new Array
			_materialItem=new Array
			_lyfItem=new Array
			_particleUrlDic=new Dictionary
				
			 myTimer = new Timer(1000, 0);
			 myTimer.addEventListener(TimerEvent.TIMER, timerHandler);

		}
		
		protected function timerHandler(event:Event):void
		{
			var $canWirte:Boolean=true
			for(var temp:* in _particleUrlDic){
				$canWirte=false;
			}
			if($canWirte){
				myTimer.stop();
				//将图片转的bitmapdata加载进来，做为图像优化
				ExpH5ByteModel.getInstance().addMinBitmapByItem(_picItem,minBmpFinish)
			}
		}
		private function minBmpFinish():void
		{
			if(Boolean(_bFun)){
				var tempFun:Function=_bFun;
				_bFun=null;
				countData();
				tempFun();	
			}
		}
		private var myTimer:Timer;
		public function run():void
		{
			if(Boolean(myTimer)&&Boolean(_bFun)){
				myTimer.start();
			}

		}
		public function expPicByUrl($picUrl:String,$root:String):String
		{
			$picUrl=$picUrl.replace(AppData.workSpaceUrl,"")
			var picFile:File=new File(AppData.workSpaceUrl+$picUrl);
			if(picFile.exists){
				var toPicUrl:String=decodeURI($root)+this.Cn2enFun($picUrl);
				_picItem.push(toPicUrl);
				this.moveFile(picFile,toPicUrl);
				return toPicUrl.replace(decodeURI($root),"");
			}else{
				Alert.show("错误文件"+$picUrl);
				return "";
			}
		
		
		}
		
		public function expMaterialInfoArr(arr:Array,$root:String):void
		{
			for(var i:Number=0;arr&&i<arr.length;i++){
				if(arr[i].type==0){
					var picUrl:String=arr[i].url
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI($root)+this.Cn2enFun(picUrl)
					this.moveFile(picFile,toPicUrl)	
					_picItem.push(toPicUrl);
				}
			}
		}
		//材质材质参数中的图片地址改为非中文
		public function changeUrlByMaterialInfoArr($arr:Array):Array
		{
			var $backArr:Array=new Array;
			for(var i:Number=0;$arr&&i<$arr.length;i++)
			{
				if($arr[i].type==0){
					var tempObj:Object=new Object;
					tempObj.name=$arr[i].name;
					tempObj.type=$arr[i].type;
					tempObj.url=this.Cn2enFun($arr[i].url);
					$backArr.push(tempObj);
				}else{
					$backArr.push($arr[i]);
				}
			}
			return $backArr
	
		}
		public function wirtieMaterialInfoTobyte(arr:Array,$byte:ByteArray):void
		{
		
			if(arr){
				$byte.writeInt(arr.length)
				for(var i:Number=0;arr&&i<arr.length;i++){
					$byte.writeInt(arr[i].type)
					$byte.writeUTF(arr[i].name);
					if(arr[i].type==0){
						$byte.writeUTF(this.Cn2enFun(arr[i].url));
					}
					if(arr[i].type==1){
						$byte.writeFloat(arr[i].x);
					}
					if(arr[i].type==2){
						$byte.writeFloat(arr[i].x);
						$byte.writeFloat(arr[i].y);
					}
					if(arr[i].type==3){
						$byte.writeFloat(arr[i].x);
						$byte.writeFloat(arr[i].y);
						$byte.writeFloat(arr[i].z);
					}
					
				}
			}else{
				$byte.writeInt(0)
			}
		
		}
			
	
		public function expObjsByUrl($objsUrl:String,$root:String):String
		{
			$objsUrl=$objsUrl.replace(AppData.workSpaceUrl,"")
			var objsFile:File=new File(AppData.workSpaceUrl+$objsUrl)
			var toXmlUrl:String=decodeURI($root)+Cn2enFun($objsUrl.replace(".objs",".xml"))
			setObjsToxml(objsFile,toXmlUrl)
			_objsItem.push(toXmlUrl)

			return toXmlUrl.replace(decodeURI($root),"");
		}
		public function expObjData(objdata:ObjData,toXmlUrl:String):String
		{
			writeFile(objdata,toXmlUrl,true,true);
			_objsItem.push(toXmlUrl);
			return toXmlUrl
		}
		public function expObjsOnlyXmlByUrl($objsTxtUrl:String,$root:String):String
		{
			
			$objsTxtUrl=$objsTxtUrl.replace(AppData.workSpaceUrl,"")
			var txtFile:File=new File(AppData.workSpaceUrl+$objsTxtUrl);
			if(txtFile.exists){
				var toXmlUrl:String=decodeURI($root)+this.Cn2enFun($objsTxtUrl);
				_objsItem.push(toXmlUrl);
				this.moveFile(txtFile,toXmlUrl);
				return toXmlUrl.replace(decodeURI($root),"");;
			}else{
				Alert.show("错误文件"+$objsTxtUrl);
				return "";
			}
		

		}
		private function setObjsToxml($file:File,$toFileUrl:String):void
		{
			if($file.extension=="objs"){
				var $fs:FileStream = new FileStream;
				if($file.exists){
					$fs.open($file,FileMode.READ);
					var $objList:Object = $fs.readObject();
					var $fileUrlUrl:String=decodeURI($file.url);
					var $hasPbr:Boolean=ExpH5ByteModel.getInstance().usePbrUrlObj[$fileUrlUrl]
					var $hasNormal:Boolean=ExpH5ByteModel.getInstance().useNormalUrlObj[$fileUrlUrl]
					var $hasDirectLight:Boolean=ExpH5ByteModel.getInstance().directLightUrlObj[$fileUrlUrl]
					writeFile($objList,$toFileUrl,$hasNormal,$hasPbr,$hasDirectLight)
				}
			}
		}
	
		private function witerLightUvToBye(arr:Vector.<Number>,fs:Object):void
		{
		
			var rgb128:Number=128
			var intNum:int;
			fs.writeInt(arr.length)
			for( var i:Number=0;i<arr.length;i++){
				intNum=Math.floor(arr[i]*256)-rgb128;
				if(arr[i]==1){//特殊在H5那边无法读
					intNum=intNum-1;
				}
				fs.writeByte(intNum);
			}
		}
		public function writeVecFloatToInt(arr:Vector.<Number>,fs:Object):void
		{
			var rgb32767:Number=32767
			//var rgb127:Number=127
			var temp:Number=0;
		    var intNum:int;
			var a:int;
			var b:int;
			for( var $kt:Number=0;$kt<arr.length;$kt++)
			{
			
				if(Math.abs(temp)<Math.abs(arr[$kt])){
					temp=arr[$kt]
				}
				
			}
			var $scaleNum:Number=rgb32767/temp;  //比例
			if(Math.abs($scaleNum)<1){
				$scaleNum=rgb32767/10000;
				Alert.show("联系管理员，writeVecFloatToInt出错")
			}
		
			fs.writeInt(arr.length)
			if(arr.length>0){
				fs.writeFloat($scaleNum)
			}
			for( var i:Number=0;i<arr.length;i++){
			
				intNum=int(arr[i]*$scaleNum);
				fs.writeShort(intNum)
//				a=intNum/rgb127
//				b=intNum%rgb127
//				fs.writeByte(a);
//				fs.writeByte(b);

			}
			
		}
		public function writeIndexToByte($indexs:Vector.<uint>,fs:Object):void
		{
			var a:int;
			var b:int;
			var rgb128:Number=128
			var rgb256:Number=256
			var intNum:int
			fs.writeInt($indexs.length)
			for(var i:Number=0;i<$indexs.length;i++)
			{
				intNum=$indexs[i];
				
				a=intNum/rgb256;
				b=intNum%rgb256;
			
				
				fs.writeShort(intNum)
				//fs.writeByte(a-rgb128);
				//fs.writeByte(b-rgb128);

			}
	
		}
		public  function writeFile($obj:Object, $url:String,$hasNormal:Boolean=true,$hasPbr:Boolean=true,$hasDirectLight:Boolean=false):void
		{
		
			$hasNormal=true;
			$hasPbr=true
			$hasDirectLight=false;
			
			
			var $num:Number;
			var $bigNum:Number
			var $objData:ObjData=new ObjData;
			$objData.vertices=$obj.vertices
			$objData.uvs=$obj.uvs
			$objData.lightUvs=$obj.lightUvs
			$objData.normals=$obj.normals
			$objData.indexs=$obj.indexs
			TBNUtils.processTBN($objData)
			
			var i:uint=0
			var file:File=new File($url);
			var fs:FileStream=new FileStream;
			fs.open(file,FileMode.WRITE)
			fs.writeInt(Scene_data.version)
			fs.writeUTF($url);
			
			this.writeDataVectType(fs,$hasNormal,$hasPbr,$hasDirectLight);
			fs.writeFloat($objData.vertices.length/3)  //长度
			
			this.writeVecFloatToInt($objData.vertices,fs);	//顶点
			this.writeVecFloatToInt($objData.uvs,fs);	//uv
			if($hasDirectLight){
				fs.writeInt(0)//数量
			}else{
				this.witerLightUvToBye($objData.lightUvs,fs);	//uv
			}
			//特殊因为法线没转换正确的问题
			if($hasPbr || $hasDirectLight){
				var $normalsNew:Vector.<Number>=new Vector.<Number>;
				for(i=0;i<$objData.normals.length/3;i++)
				{
					$normalsNew.push($objData.normals[i*3+0]*+1)
					$normalsNew.push($objData.normals[i*3+1]*+1)
					$normalsNew.push($objData.normals[i*3+2]*+1)
				}
				this.writeVecFloatToInt($normalsNew,fs)
			}else{
				fs.writeInt(0)//数量
			}
			if($hasNormal){
				this.writeVecFloatToInt($objData.tangents,fs);	//顶点
				this.writeVecFloatToInt($objData.bitangents,fs);	//顶点
				
			}else{
				fs.writeInt(0);
				fs.writeInt(0);
			}
			this.writeIndexToByte($objData.indexs,fs);
		
			this.writecollisionItem(fs,$obj.item)
			
			
			fs.close();
		}
		private function writecollisionItem(fs:FileStream,item:Array):void
		{
			if(item){
				fs.writeInt(item.length);
				for(var i:Number=0;i<item.length;i++){
					var $str:String=JSON.stringify(item[i])
					fs.writeUTF($str)
				}
			}else{
				fs.writeInt(0);
			}
			

		}
		//写入包含字段内容
		private function writeDataVectType($fs:FileStream,$hasNormal:Boolean=true,$hasPbr:Boolean=true,$hasDirectLight:Boolean=false):void
		{
			var $ktemp:Array=new Array()
			$ktemp.push(true)
			$ktemp.push(true)
			if($hasDirectLight){
				$ktemp.push(false)
			}else{
				$ktemp.push(true)
			}
			if($hasPbr || $hasDirectLight){
				$ktemp.push(true)
			}else{
				$ktemp.push(false)
			}
			if($hasNormal){
				$ktemp.push(true)
				$ktemp.push(true)
			}else{
				$ktemp.push(false)
				$ktemp.push(false)
			}
			for(var i:Number=0;i<$ktemp.length;i++)
			{
				$fs.writeBoolean($ktemp[i])
			}
		
		}
	
		private function witerCollisionItemToByte($fs:FileStream,$item:Array):void
		{
			if($item){
				$fs.writeInt($item.length);
				for(var i:uint=0;i<$item.length;i++)
				{
					var $obj:Object=$item[i];
					var $collisionVo:CollisionVo=new CollisionVo;
					$collisionVo.type=$obj.type
					$collisionVo.x=$obj.x
					$collisionVo.y=$obj.y
					$collisionVo.z=$obj.z
					
					$collisionVo.rotationX=$obj.rotationX
					$collisionVo.rotationY=$obj.rotationY
					$collisionVo.rotationZ=$obj.rotationZ
					
					$collisionVo.scale_x=$obj.scale_x;
					$collisionVo.scale_y=$obj.scale_y;
					$collisionVo.scale_z=$obj.scale_z;
					$collisionVo.radius=$obj.radius;
					$collisionVo.data=$obj.data;
					
					$collisionVo.name=$obj.name;
					
					
					$collisionVo.colorInt=$obj.colorInt;
					
					$fs.writeUTF($collisionVo.name)
					$fs.writeInt($collisionVo.type);
					$fs.writeFloat($collisionVo.x)
					$fs.writeFloat($collisionVo.y)
					$fs.writeFloat($collisionVo.z)
					$fs.writeFloat($collisionVo.rotationX)
					$fs.writeFloat($collisionVo.rotationY)
					$fs.writeFloat($collisionVo.rotationZ)
					
					switch($collisionVo.type)
					{
						case CollisionType.Polygon:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_x)
							
							if($collisionVo.data){
								$fs.writeBoolean(true);
								$fs.writeInt($collisionVo.data.vertices.length)
								for(var j:uint=0;j<$collisionVo.data.vertices.length;j++)
								{
									$fs.writeFloat($collisionVo.data.vertices[j])
								}
								$fs.writeInt($collisionVo.data.indexs.length)
								for(var k:uint=0;k<$collisionVo.data.indexs.length;k++)
								{
									$fs.writeInt($collisionVo.data.indexs[k])
								}
								
							}else{
								$fs.writeBoolean(false)
							}
							
							break;
						}
						case CollisionType.BOX:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							break;
						}
						case CollisionType.BALL:
						{
							$fs.writeFloat($collisionVo.radius)
							
							break;
						}
						case CollisionType.Cylinder:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							
							break;
						}
						case CollisionType.Cone:
						{
							$fs.writeFloat($collisionVo.scale_x)
							$fs.writeFloat($collisionVo.scale_y)
							$fs.writeFloat($collisionVo.scale_z)
							
							break;
						}
						default:
						{
							Alert.show("还没有的CollisionType")
							break;
						}
					}
					
					
					
				}
			}
		}
		
		public function expParticleByUrl($particleUrl:String,$root:String):String
		{
			var url:String = AppData.workSpaceUrl + $particleUrl;
			var $particle:CombineParticle = ParticleManager.getInstance().getParticle(url);
			_particleUrlDic[$particle] = $root;
			$particle.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onParticleCom);
			
			
		
			
			var lyfFile:File=new File(decodeURI(url.replace(".lyf","_byte.txt")))
			if(lyfFile.exists){
				
		
				return this.Cn2enFun(lyfFile.url.replace(AppData.workSpaceUrl,""))
			}else{
				Alert.show(decodeURI(lyfFile.url),"无地址提示1")
				return null
			}
		}
		private function onParticleCom(e:LoadCompleteEvent):void{
			var $particle:CombineParticle = e.target as CombineParticle;
			var rootUrl:String = _particleUrlDic[$particle];
			delete _particleUrlDic[$particle];
			this.expParticleToH5($particle,rootUrl);
		}
		public function expParticleToH5($CombineParticle:CombineParticle,$root:String):String
		{
			var $picArr:Array=new Array;
			var a:Array=$CombineParticle.getMaterialTexUrlAry()
			$picArr=$picArr.concat(a)
			var b:Array=$CombineParticle.getMaterialAry();
			for(var materialTreeId:uint=0;materialTreeId<b.length;materialTreeId++){
				
				
				$picArr=$picArr.concat(MaterialTree(b[materialTreeId]).getTxtList())
				
				var  lyfUrl:String=MaterialTree(b[materialTreeId]).url;
				var $MaterialTreestr:String =expMaterialTreeToH5(MaterialTree(b[materialTreeId]),this._rootUrl);

			}
			for(var i:uint=0;i<$picArr.length;i++){
				var picUrl:String=$picArr[i];
				if(picUrl){
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI($root)+this.Cn2enFun(picUrl)
					_picItem.push(toPicUrl)
					this.moveFile(picFile,toPicUrl)	
				}
			}
			
			if(expByteInfo){
				var lyfByteFile:File=new File($CombineParticle.url.replace(".lyf","_byte.txt"))
				if(lyfByteFile.exists){
					var toXmlByteUrl:String=decodeURI($root)+this.Cn2enFun(lyfByteFile.url.replace(AppData.workSpaceUrl,""));
					this.moveFile(lyfByteFile,toXmlByteUrl)
					_lyfItem.push(toXmlByteUrl)
				}else{
					//Alert.show(decodeURI(lyfByteFile.url),"无地址_byte.txt");
					ExpLyfTxtToByteFile.getInstance().buildLyfByUrl($CombineParticle.url)
				}
			}
			
			var lyfFile:File=new File(decodeURI($CombineParticle.url.replace(".lyf","_byte.txt")))
			if(lyfFile.exists){
				var toXmlUrl:String=decodeURI($root)+this.Cn2enFun(lyfFile.url.replace(AppData.workSpaceUrl,""));
				return this.Cn2enFun(lyfFile.url.replace(AppData.workSpaceUrl,""))
			}else{
				Alert.show(decodeURI(lyfFile.url),"无地址提示2")
				return null
			}
			
			
		}
		//可删除
		private function expMaterialTreeToH5OnlyTxtByUrl(materialTxtUrl:String,$root:String):String
		{
			materialTxtUrl=materialTxtUrl.replace(AppData.workSpaceUrl,"")
				
			var materialFile:File=new File(AppData.workSpaceUrl+materialTxtUrl);
			
			if(expByteInfo){
				var $fs:FileStream = new FileStream;
				$fs.open(materialFile,FileMode.READ);
				var $str:String = $fs.readUTFBytes($fs.bytesAvailable)
				$fs.close()
				var toByteUrl:String=MaterialSaveModel.getInstance().saveByteMaterial(JSON.parse($str),materialFile.url)
				var aa:String=toByteUrl.replace(AppData.workSpaceUrl,"")
				var bb:String=decodeURI($root)+this.Cn2enFun(aa);
				this.moveFile(new File(toByteUrl),bb);
				_materialItem.push(bb);
				
			}
			
			if(materialFile.exists){
				var toMaterialUrl:String=decodeURI($root)+this.Cn2enFun(materialTxtUrl);
				//this.moveFile(materialFile,toMaterialUrl);
				//_materialItem.push(toMaterialUrl);
				toMaterialUrl=toMaterialUrl.replace(decodeURI($root),"");;
				return toMaterialUrl;
			}else{
				Alert.show("错误文件"+materialTxtUrl);
				return "";
			}

		}
		
		private var expByteInfo:Boolean=true
		public function expMaterialTreeToH5(material:MaterialTree,$root:String):String
		{
			var $picArr:Array=material.getTxtList()
			for(var i:uint=0;i<$picArr.length;i++){
				var picUrl:String=$picArr[i];
				if(picUrl){
					var picFile:File=new File(AppData.workSpaceUrl+picUrl)
					var toPicUrl:String=decodeURI($root)+this.Cn2enFun(picUrl)
					this.moveFile(picFile,toPicUrl)	
					
					_picItem.push(toPicUrl);
				}
			}
			if(expByteInfo){
				var materialByteUrl:String=material.url.replace(".material","_byte.txt");
				materialByteUrl=materialByteUrl.replace(AppData.workSpaceUrl,"");
				var materialByteFile:File=new File(AppData.workSpaceUrl+materialByteUrl)
				if(materialByteFile.exists){
					var toXmlByteUrl:String=decodeURI($root)+this.Cn2enFun(materialByteUrl);
					this.moveFile(materialByteFile,toXmlByteUrl)
					_materialItem.push(toXmlByteUrl);
			
				}else{
					MaterialSaveModel.getInstance().buildMaterialByUrl(material.url)
				}
			
			}
			var materialUrl:String=material.url.replace(".material",".txt");
			materialUrl=materialUrl.replace(AppData.workSpaceUrl,"");
			var materialFile:File=new File(AppData.workSpaceUrl+materialUrl)
			if(materialFile.exists){
				var toXmlUrl:String=decodeURI($root)+this.Cn2enFun(materialUrl);
				
				//this.moveFile(materialFile,toXmlUrl)
				//_materialItem.push(toXmlUrl);
				
				
				return this.Cn2enFun(materialUrl);
			}else{
				Alert.show(decodeURI(material.url),"无地址提示3")
				return null
			}
			
			
		}
		

		public function mathOnlyUrlArr(arr:Array):Array
		{
			var tempArr:Array=new Array
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
		private var _willdeleFileItem:Vector.<String>
		public static var expAllPic:Boolean=true;
		private function countData():void
		{
			trace("-----------------")
			ExpH5ByteModel.getInstance().clear();
			MakeResFileList.getInstance().clear();
			_willdeleFileItem=new Vector.<String>
			var i:uint=0
			_picItem=mathOnlyUrlArr(_picItem)
			_objsItem=mathOnlyUrlArr(_objsItem)
			_materialItem=mathOnlyUrlArr(_materialItem)
			_lyfItem=mathOnlyUrlArr(_lyfItem)
			var fileName:String=""
			for(i=0;i<_picItem.length;i++)
			{
				
				fileName=String(_picItem[i]).replace(this._rootUrl,"")
				//trace("pic:",fileName)
				MakeResFileList.getInstance().pushUrl(fileName);
				
				if(new File(_picItem[i]).exists){
					ExpH5ByteModel.getInstance().addPic(new File(_picItem[i]),fileName)
				}else{
					Alert.show("没有文件",fileName)
				}
				//if(ExpResourcesModel.expAllPic==false){
				_willdeleFileItem.push(_picItem[i]);
				
			}
			for(i=0;i<_objsItem.length;i++)
			{
				fileName=String(_objsItem[i]).replace(this._rootUrl,"")
				trace("objs:",fileName)
		
				if(new File(_objsItem[i]).exists){
					ExpH5ByteModel.getInstance().addObjs(new File(_objsItem[i]),fileName)
				}else{
					Alert.show("没有文件",fileName)
				}
				_willdeleFileItem.push(_objsItem[i])
			}
			for(i=0;i<_materialItem.length;i++)
			{
				
				fileName=String(_materialItem[i]).replace(this._rootUrl,"")
				trace("material:",fileName)
				if(new File(_materialItem[i]).exists){
					ExpH5ByteModel.getInstance().addMaterial(new File(_materialItem[i]),fileName)
				}else{
					Alert.show("没有文件",fileName)
				}
				
				_willdeleFileItem.push(_materialItem[i])
			}
			for(i=0;i<_lyfItem.length;i++)
			{
				fileName=String(_lyfItem[i]).replace(this._rootUrl,"")
				trace("lyf:",fileName)
				if(new File(_lyfItem[i]).exists){
					ExpH5ByteModel.getInstance().addLyf(new File(_lyfItem[i]),fileName)
				}else{
					Alert.show("没有文件",fileName)
				}
				_willdeleFileItem.push(_lyfItem[i])
				
			}
			
		
			
		//	clearFiles();
			
			
			
			trace("-----------------")
			
		}
		
		private function clearFiles():void
		{
			for(var i:uint=0;i<_willdeleFileItem.length;i++)
			{
				var $file:File=new File(_willdeleFileItem[i])
				if($file.exists)
				{
					trace("删除文件",decodeURI($file.url));
					$file.deleteFile();
				}
			}
	
			while(clearEmptyDirectory(new File(this._rootUrl))){
				
			}
			
		}
		private function clearEmptyDirectory($file:File):Boolean
		{
			var isHave:Boolean=false
			var allFileItem:Vector.<File>=getEmpFolderFile($file)
			for each(var $tempFile:File in allFileItem){
				if($tempFile.isDirectory){
					
					if($tempFile.exists&&$tempFile.url.search(".svn")==-1){
			
						trace("删除空文件夹",decodeURI($tempFile.url));
						
						$tempFile.deleteDirectory()
						isHave=true
						
					}
				}
				
			}
			return isHave
			
		}
		private function getEmpFolderFile($sonFile:File):Vector.<File>
		{
			
			var $fileItem:Vector.<File>=new Vector.<File>
			
			if($sonFile.exists && $sonFile.isDirectory)
			{
				var arr:Array=$sonFile.getDirectoryListing();
				for each(var $tempFile:File in arr)
				{
					if($tempFile.isDirectory){
						
						var barr:Array=$tempFile.getDirectoryListing();
						if(barr.length>0){
							$fileItem=$fileItem.concat(getEmpFolderFile($tempFile))
						}else{
							$fileItem.push($tempFile)
						}
					}
					
				}
			}
			
			return $fileItem
		}

		

		public function Cn2enFun($str:String):String
		{
			
			return Cn2en.toPinyin(decodeURI($str))
		}

		public function moveFile($file:File,$toUrl:String):void
		{
			if($file.exists){
				if($file.extension=="png"){
					var $jpngName:String=$file.url.replace(".png",".jpng");
					var $jpngFile:File=new File($jpngName)
				    if($jpngFile.exists){
						this.moveFile($jpngFile,$toUrl.replace(".png",".jpng"))
					}
				}
				var destination:File = File.documentsDirectory;
				destination = destination.resolvePath($toUrl);
				$file.copyTo(destination, true);
			}

		}

	}
}