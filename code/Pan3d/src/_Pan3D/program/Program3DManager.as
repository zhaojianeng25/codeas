package _Pan3D.program
{
	import com.adobe.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import _Pan3D.program.shaders.MaterialShader;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.StatShader;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;

	public class Program3DManager
	{
		private static var instance:Program3DManager;
		private var _context3D:Context3D;
		private var _programDic:Object;
		private var _classDic:Object;
		private var _shaderAssembler:AGALMiniAssembler;
		public function Program3DManager()
		{
			this._context3D = Scene_data.context3D;
			_programDic = new Object;
			_classDic = new Object;
			_shaderAssembler = new AGALMiniAssembler();
		}
		public static function getInstance():Program3DManager{
			if(!instance){
				instance = new Program3DManager();
			}
			return instance;
		}
		
		public function initReg():void{
			//注册着色器
			registe(Md5Shader.MD5SHADER,Md5Shader);
			registe(StatShader.STATSHADER,StatShader);
		}
		public function getProgram(key:String):Program3D{
			if(_programDic[key]){
				return _programDic[key];
			}else{
				if(_classDic[key]){
					var cls:Class = _classDic[key];
					var shader:IShader3D = new cls();
					shader.encode(_shaderAssembler);
					try{
						var program:Program3D = _context3D.createProgram();
						program.upload(shader.vertexShaderByte,shader.fragmentShaderByte);
					} catch(error:Error) {
						trace(error)
					}
					_programDic[key] = program;
					return program;
				}else{
					throw new Error("未注册的着色器:" + key)
				}
			}
			return null;
		}
		
		public function registe(key:String,shaderCls:Class):void{
			_classDic[key] = shaderCls;
		}
		
		
		
		public function reload():void{
			this._context3D = Scene_data.context3D;
			
			for(var key:String in _classDic){
				var cls:Class = _classDic[key];
				var shader:IShader3D = new cls();
				shader.encode(_shaderAssembler);
				var program:Program3D = _context3D.createProgram();
				program.upload(shader.vertexShaderByte,shader.fragmentShaderByte);
				_programDic[key] = program;
			}
		}
		
		public function clearCache(url:String):void{
			var keyAry:Array = new Array;
			for(var key:String in _programDic){
				if(key.indexOf(url) != -1){
					keyAry.push(key);
				}
			}
			for(var i:int;i<keyAry.length;i++){
				delete _programDic[keyAry[i]];
			}
		}
		
		public function getMaterialProgram(key:String,cls:Class,$material:MaterialTree,paramAry:Array = null,parmaByFragmet:Boolean = false):Program3D{
			var keyStr:String = key + "_" + $material.url;
			
			if(paramAry){
				for(var i:int;i<paramAry.length;i++){
					keyStr += "_" + paramAry[i];
				}
				keyStr += parmaByFragmet;
			}
			
			if(_programDic[keyStr]){
				return _programDic[keyStr];
			}
			
			if(parmaByFragmet){
				paramAry = [$material.usePbr,$material.useNormal,$material.hasFresnel,$material.useDynamicIBL,$material.lightProbe,$material.directLight,$material.noLight,$material.fogMode];
			}
			
			var shader:Shader3D = new cls();
			shader.paramAry = paramAry;
			shader.fragment = $material.shaderStr;
			shader.encode(_shaderAssembler);
			var program:Program3D = _context3D.createProgram();
			program.upload(shader.vertexShaderByte,shader.fragmentShaderByte);
			_programDic[keyStr] = program;
			return program;
		}
		
		public function getProgramByParam(key:String,paramAry:Array):Program3D{
			var keyStr:String = key;
			
			if(paramAry){
				for(var i:int;i<paramAry.length;i++){
					keyStr += "_" + paramAry[i];
				}
			}
			
			if(_programDic[keyStr]){
				return _programDic[keyStr];
			}
			
			var cls:Class = _classDic[key];
			
			var shader:Shader3D = new cls();
			shader.paramAry = paramAry;
			shader.encode(_shaderAssembler);
			var program:Program3D = _context3D.createProgram();
			program.upload(shader.vertexShaderByte,shader.fragmentShaderByte);
			_programDic[keyStr] = program;
			return program;
		}
		
		
		public function compileMaterialShader($material:MaterialTree):void{
			if(!$material){
				return;
			}
			var materialShader3D:MaterialShader = new MaterialShader;
			materialShader3D.paramAry = [$material.usePbr,$material.useNormal,$material.hasFresnel,$material.useDynamicIBL,$material.lightProbe,$material.directLight,$material.noLight,$material.fogMode];
			materialShader3D.fragment = $material.shaderStr;
			materialShader3D.encode(_shaderAssembler);
			try{
				var program:Program3D = _context3D.createProgram();
				program.upload(materialShader3D.vertexShaderByte,materialShader3D.fragmentShaderByte);
			} catch(error:Error) {
				trace(error)
			}
			
			$material.program = program;
		}
		
		private var _materialList:Vector.<MaterialTree> = new Vector.<MaterialTree>;
		public function regMaterial($material:MaterialTree):void{
			if(_materialList.indexOf($material) == -1){
				_materialList.push($material);
				compileMaterialShader($material);
				if(Scene_data.isDevelop){
					$material.addEventListener(Event.CHANGE,onMaterialChg);
				}
			}
		}
		
		protected function onMaterialChg(event:Event):void
		{
			var material:MaterialTree = event.target as MaterialTree;
			compileMaterialShader(material);
		}
		
	}
}