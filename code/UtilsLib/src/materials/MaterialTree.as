package materials
{
	import flash.display3D.Program3D;

	public class MaterialTree extends Material
	{
		private var _data:Object;
		private var _compileData:Object;
		private var _url:String;
		
		public var shaderStr:String;
		public var texList:Vector.<TexItem> = new Vector.<TexItem>;
		public var constList:Vector.<ConstItem> = new Vector.<ConstItem>;
		public var hasTime:Boolean;
		public var timeSpeed:Number;
		public var blendMode:int;
		public var backCull:Boolean;
		public var killNum:Number = 0;
		public var hasVertexColor:Boolean;
		public var usePbr:Boolean;
		public var useNormal:Boolean;
		public var roughness:Number;
		private var _program:Program3D;
		public var writeZbuffer:Boolean = true;
		public var hasFresnel:Boolean;
		public var useDynamicIBL:Boolean;
		public var normalScale:Number;
		public var lightProbe:Boolean;
		public var directLight:Boolean;
		public var scaleLightMap:Boolean;
		public var noLight:Boolean;
		public var fogMode:int;
		public var useKill:Boolean;
		public var hasAlpha:Boolean;
		public var hdr:Boolean;
		public var materialBaseData:MaterialBaseData;
		public var fcNum:int;
		public var fcIDAry:Array = new Array;//[]
		
		public function MaterialTree()
		{
			
		}
		
		public function get program():Program3D
		{
			return _program;
		}

		public function set program(value:Program3D):void
		{
			_program = value;
		}

		public function getMainTexUrl():String{
			
			for(var i:int;i<texList.length;i++){
				if(texList[i].isMain){
					return texList[i].url;
				}
			}
			
			return null;
		}
		
		public function getTxtList():Array{
			var ary:Array = new Array;
			for(var i:int;i<texList.length;i++){
				if(!texList[i].isDynamic && texList[i].type == 0){
					ary.push(texList[i].url);
				}
			}
			return ary;
		}
		
		
		public function hasMainTex():Boolean{
			for(var i:int;i<texList.length;i++){
				if(texList[i].isMain){
					return true;
				}
			}
			
			return false;
		}
		
		public function getBackCull():Boolean{
			return false;
		}
		
		override public function getName():String
		{
			if(url){
				var ee:Array=url.split("/")
				return ee[ee.length-1];
			}
			return ""
		}

		public function get data():Object
		{ 
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		public function isHaveMaterialInfoArr():Boolean
		{
			for(var i:uint=0;i<this._data.length;i++){
				if(this._data[i].data.isDynamic){  //是动态
					return true
				}
			}
		
			return false
		}
		
		public function hasDynamicParam($key:String):Boolean{
			for(var i:uint=0;i<this.data.length;i++){
				if(this.data[i].data.isDynamic){  //是动态
					if(this.data[i].data.paramName == $key){
						return true;
					}
				}
			}
			return false
		}

		public function get compileData():Object
		{
			var resultObj:Object = new Object;
			resultObj.shaderStr = shaderStr;
			if(texList){
				var texAry:Array = new Array;
				for(var i:int=0;i<texList.length;i++){
					var obj:Object = new Object;
					obj.id = texList[i].id;
					obj.url = texList[i].url;
					obj.isDynamic = texList[i].isDynamic;
					obj.paramName = texList[i].paramName;
					obj.isMain = texList[i].isMain;
					obj.type = texList[i].type;
					obj.wrap = texList[i].wrap;
					obj.filter = texList[i].filter;
					obj.mipmap = texList[i].mipmap;
					obj.permul = texList[i].permul;
					obj.isParticleColor = texList[i].isParticleColor;
					texAry.push(obj);
				}
				resultObj.texList = texAry;
			}
			if(constList){
				var constAry:Array = new Array;
				for(i=0;i<constList.length;i++){
					obj = constList[i].getData();
					constAry.push(obj);
				}
				resultObj.constList = constAry;
			}
			
			resultObj.hasTime = hasTime;
			resultObj.timeSpeed = timeSpeed;
			resultObj.blendMode = this.blendMode;
			resultObj.backCull = this.backCull;
			resultObj.killNum = this.killNum;
			resultObj.hasVertexColor = this.hasVertexColor;
			resultObj.usePbr = usePbr;
			resultObj.useNormal = useNormal;
			resultObj.roughness = this.roughness;
			resultObj.writeZbuffer = this.writeZbuffer
			resultObj.hasFresnel = this.hasFresnel;
			resultObj.useDynamicIBL = useDynamicIBL;
			resultObj.normalScale = normalScale;
			resultObj.lightProbe = lightProbe;
			resultObj.hasAlpha = hasAlpha;
			resultObj.directLight = directLight;
			resultObj.noLight = noLight;
			resultObj.fogMode = fogMode;
			resultObj.scaleLightMap = scaleLightMap;
			resultObj.useKill = useKill;
			resultObj.fcNum = fcNum;
			resultObj.fcIDAry = fcIDAry;
			resultObj.hdr = hdr;
			if(this.materialBaseData){
				resultObj.materialBaseData = this.materialBaseData.getData();
			}

			return resultObj;
		}

		public function set compileData(value:Object):void
		{
			if(!value){
				return;
			}
			_compileData = value;
			this.shaderStr = _compileData.shaderStr;
			
			hasTime = _compileData.hasTime;
			timeSpeed = _compileData.timeSpeed;
			blendMode = _compileData.blendMode
			backCull = _compileData.backCull;
			killNum = _compileData.killNum;
			hasVertexColor = _compileData.hasVertexColor;
			usePbr = _compileData.usePbr;
			useNormal = _compileData.useNormal;
			roughness = _compileData.roughness;
			writeZbuffer = _compileData.writeZbuffer;
			hasFresnel = _compileData.hasFresnel;
			useDynamicIBL = _compileData.useDynamicIBL;
			normalScale = _compileData.normalScale;
			lightProbe = _compileData.lightProbe;
			directLight = _compileData.directLight;
			noLight = _compileData.noLight;
			fogMode = _compileData.fogMode;
			scaleLightMap = _compileData.scaleLightMap;
			useKill = _compileData.useKill;
			fcNum = _compileData.fcNum;
			fcIDAry = _compileData.fcIDAry;
			hasAlpha = _compileData.hasAlpha;
			hdr = _compileData.hdr;
			this.materialBaseData = new MaterialBaseData;
			this.materialBaseData.setData(_compileData.materialBaseData);
			
			if(_compileData.texList){
				var ary:Array = _compileData.texList;
				texList = new Vector.<TexItem>;
				for(var i:int=0;i<ary.length;i++){
					var texItem:TexItem = new TexItem;
					texItem.id = ary[i].id;
					texItem.url = ary[i].url;
					texItem.isDynamic = ary[i].isDynamic;
					texItem.paramName = ary[i].paramName;
					texItem.isMain = ary[i].isMain;
					texItem.wrap = ary[i].wrap;
					texItem.filter = ary[i].filter;
					texItem.mipmap = ary[i].mipmap;
					texItem.permul = ary[i].permul;
					texItem.isParticleColor = ary[i].isParticleColor;
					texItem.type = ary[i].type;
					texList.push(texItem);
				}
			}
			
			if(_compileData.constList){
				ary = _compileData.constList;
				constList = new Vector.<ConstItem>;
				for(i=0;i<ary.length;i++){
					var constItem:ConstItem = new ConstItem;
					constItem.setData(ary[i]);
					constList.push(constItem);
				}
			}
			
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.data = _data;
			obj.compileData = compileData;
			return obj;
		}
		
		public function setData(value:Object):void{
			this.data = value.data;
			this.compileData = value.compileData;
		}
		
		public function hasDynamic():Boolean{
			for(var i:int=0;i<texList.length;i++){
				if(texList[i].isDynamic){
					return true;
				}
			}
			
			for(i=0;i<constList.length;i++){
				if(constList[i].isDynamic){
					return true;
				}
			}
			
			return false;
		}
		
		public function hasParticleColor():Boolean{
			for(var i:int=0;i<texList.length;i++){
				if(texList[i].isParticleColor){
					return true;
				}
			}
			
			return false;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		


	}
}