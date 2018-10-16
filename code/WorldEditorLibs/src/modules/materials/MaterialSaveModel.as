package modules.materials
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	import _me.Scene_data;
	
	import common.AppData;
	
	import materials.MaterialTree;

	public class MaterialSaveModel
	{
		private static var instance:MaterialSaveModel;
		public function MaterialSaveModel()
		{
		}
		
		public static function getInstance():MaterialSaveModel{
			if(!instance){
				instance = new MaterialSaveModel();
			}
			return instance;
		}
		private var urlDis:Dictionary=new Dictionary
		public function buildMaterialByUrl(value:String):void
		{
			if(!urlDis.hasOwnProperty(value)){
				urlDis[value]=true;

				Alert.show(decodeURI(value),"无地址提示_byte.txt")
	
					
				var $file:File=new File(AppData.workSpaceUrl+value.replace(".material",".txt"))
				if($file.exists){
					var $fs:FileStream = new FileStream;
					$fs.open($file,FileMode.READ);
					var $str:String = $fs.readUTFBytes($fs.bytesAvailable)
						
					saveByteMaterial(JSON.parse($str),$file.url)
					
					
				
				}	
					
					
			}
			
		
		}

	
		public function saveByteMaterial(_compileData:Object,$url:String):String
		{
			/*
			public hasTime: boolean;
			public timeSpeed: number;
			public blendMode: number;
			public backCull: boolean;
			public killNum: number = 0;
			public hasVertexColor: boolean;
			public usePbr: boolean;
			public useNormal: boolean;
			public roughness: number;
			public program: WebGLProgram;
			public writeZbuffer: boolean = true;
			public hasFresnel: boolean;
			public useDynamicIBL: boolean;
			public normalScale: number;
			public lightProbe: boolean;
			public useKill: boolean;
			public directLight: boolean;
			public noLight: boolean;
			public scaleLightMap: boolean;
			public hasParticleColor: boolean;
			
			
			this.shaderStr = _compileData.shaderStr;
			this.hasTime = _compileData.hasTime;
			this.timeSpeed = _compileData.timeSpeed;
			this.blendMode = _compileData.blendMode
			this.backCull = _compileData.backCull;
			this.killNum = _compileData.killNum;
			this.hasVertexColor = _compileData.hasVertexColor;
			this.usePbr = _compileData.usePbr;
			this.useNormal = _compileData.useNormal;
			this.roughness = _compileData.roughness;
			this.writeZbuffer = _compileData.writeZbuffer;
			this.hasFresnel = _compileData.hasFresnel;
			this.useDynamicIBL = _compileData.useDynamicIBL;
			this.normalScale = _compileData.normalScale;
			this.lightProbe = _compileData.lightProbe;
			this.useKill = _compileData.useKill;
			this.directLight = _compileData.directLight;
			this.noLight = _compileData.noLight;
			this.scaleLightMap = _compileData.scaleLightMap;
			
			*/
	
			var tempurl:String=$url.replace(".txt","_byte.txt")
			
			var file:File = new File(tempurl);
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.WRITE);
			
			fs.writeInt(Scene_data.version)
			
			fs.writeUTF(_compileData.shaderStr)
			fs.writeBoolean(_compileData.hasTime);
			fs.writeFloat( _compileData.timeSpeed);
			fs.writeFloat( _compileData.blendMode);
			fs.writeBoolean(_compileData.backCull);
			fs.writeFloat(_compileData.killNum);
			fs.writeBoolean(_compileData.hasVertexColor);
			fs.writeBoolean(_compileData.usePbr);
			fs.writeBoolean( _compileData.useNormal);
			fs.writeFloat(_compileData.roughness);
			fs.writeBoolean( _compileData.writeZbuffer);
			fs.writeBoolean(_compileData.hasFresnel);
			fs.writeBoolean(_compileData.useDynamicIBL);
			fs.writeFloat( _compileData.normalScale);
			fs.writeBoolean( _compileData.lightProbe);
			fs.writeBoolean(_compileData.useKill);
			fs.writeBoolean( _compileData.directLight);
			fs.writeBoolean( _compileData.noLight);
			//fs.writeInt(_compileData.fogMode);
			fs.writeBoolean( _compileData.scaleLightMap);
			fs.writeInt(_compileData.fogMode);
			fs.writeByte(_compileData.fcNum);
			writeByteAry(fs,_compileData.fcIDAry);
			
			
			writeTextListArr(fs,_compileData.texList)
			writeConstListArr(fs,_compileData.constList)
			
			
			fs.close();
			return tempurl
			
		}
		
		private function writeByteAry(fs:FileStream,ary:Array):void{
			fs.writeByte(ary.length);
			for(var i:int=0;i<ary.length;i++){
				fs.writeByte(ary[i]);
			}
		}
		
		private function writeConstListArr(fs:FileStream,constList:Array):void
		{
			if(constList){
				fs.writeInt(constList.length)
				for(var i:uint=0;i<constList.length;i++)
				{
					var obj:Object=constList[i]
					
					
					fs.writeFloat(obj.id)//this.id = obj.id;
					fs.writeFloat(obj.value.x)//this.value = obj.value;
					fs.writeFloat(obj.value.y)//this.value = obj.value;
					fs.writeFloat(obj.value.z)//this.value = obj.value;
					fs.writeFloat(obj.value.w)//this.value = obj.value;
					
					//this.value = new Vector3D(obj.value.x, obj.value.y, obj.value.z, obj.value.w);
					
					if(obj.paramName0==null){
						obj.paramName0=""
					}	
					if(obj.paramName1==null){
						obj.paramName1=""
					}	
					if(obj.paramName2==null){
						obj.paramName2=""
					}	
					if(obj.paramName3==null){
						obj.paramName3=""
					}	
					
					
					
					fs.writeUTF(obj.paramName0)//this.paramName0 = obj.paramName0;
					fs.writeFloat(obj.param0Type)//this.param0Type = obj.param0Type;
					fs.writeFloat(obj.param0Index)//this.param0Index = obj.param0Index;
					
					
					fs.writeUTF(obj.paramName1)//this.paramName1 = obj.paramName1;
					fs.writeFloat(obj.param1Type)//this.param1Type = obj.param1Type;
					fs.writeFloat(obj.param1Index)//this.param1Index = obj.param1Index;
					
					fs.writeUTF(obj.paramName2)//this.paramName2 = obj.paramName2;
					fs.writeFloat(obj.param2Type)//this.param2Type = obj.param2Type;
					fs.writeFloat(obj.param2Index)//this.param2Index = obj.param2Index;
					
					fs.writeUTF(obj.paramName3)//this.paramName3 = obj.paramName3;
					fs.writeFloat(obj.param3Type)//this.param3Type = obj.param3Type;
					fs.writeFloat(obj.param3Index)//this.param3Index = obj.param3Index;
					
				}
				
				
			}else{
				fs.writeInt(0)
			}
			
		}
		private function writeTextListArr(fs:FileStream,texList:Array):void
		{
			if(texList){
				fs.writeInt(texList.length)
				for(var i:uint=0;i<texList.length;i++)
				{
					if(texList[i].url==null){
						texList[i].url="";
					}
					if(texList[i].paramName==null){
						texList[i].paramName="";
					}
					
					fs.writeFloat(texList[i].id );
					fs.writeUTF(texList[i].url );
					fs.writeBoolean(texList[i].isDynamic  );
					fs.writeUTF(texList[i].paramName );
					fs.writeBoolean(texList[i].isMain );
					fs.writeBoolean(texList[i].isParticleColor );
					fs.writeFloat(texList[i].type  );
					fs.writeFloat(texList[i].wrap  );
					fs.writeFloat(texList[i].filter );
					fs.writeFloat(texList[i].mipmap  );
				}
				
				
			}else{
				fs.writeInt(0)
			}
			
		}
		
	}
}