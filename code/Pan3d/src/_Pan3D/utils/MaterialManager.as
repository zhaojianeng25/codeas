package _Pan3D.utils
{
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import materials.DynamicTexItem;
	import materials.MaterialTree;
	import materials.MaterialTreeParam;
	import materials.TexItem;

	public class MaterialManager
	{
		private var _loadFunDic:Object;
		private var _materialDic:Object;
		public function MaterialManager()
		{
			_loadFunDic = new Object;
			_materialDic = new Object;
		}
		
		private static var _instance:MaterialManager;
		public static function getInstance():MaterialManager{
			if(!_instance){
				_instance = new MaterialManager;
			}
			return _instance;
		}
		
		public function getMaterial(url:String,fun:Function,info:Object,autoReg:Boolean=false,regName:String = null,regCls:Class=null):void{
			

			if(_materialDic[url]){
				fun(_materialDic[url],info);
			}else{
				if(!_loadFunDic.hasOwnProperty(url)){
					_loadFunDic[url] = new Array;
					var loaderinfo:LoadInfo = new LoadInfo(url,LoadInfo.BYTE,onMatrialLoad,0,{"url":url,"autoreg":autoReg,"regname":regName,"regcls":regCls});
					LoadManager.getInstance().addSingleLoad(loaderinfo);
				}
				_loadFunDic[url].push({"fun":fun,"info":info});
			}
			
		}
		
		public function clearCache(url:String):void{
			delete _materialDic[url];
		}
		
		private function onMatrialLoad(byte:ByteArray,info:Object):void
		{
			var url:String = info.url;
			var autoReg:Boolean = info.autoreg;
			var cls:Class = info.regcls;
			var regName:String = info.regname;
			
			var materialObj:Object = byte.readObject();
			
			var material:MaterialTree = new MaterialTree;
			material.url = url;
			material.setData(materialObj);
			loadMaterial(material);
			
			if(autoReg){
				material.program = Program3DManager.getInstance().getMaterialProgram(regName,cls,material,null,true);
			}
			
			var ary:Array = _loadFunDic[url];
			for each(var obj:Object in ary){
				obj.fun(material,obj.info);
			}
			
			delete _loadFunDic[url];
			
			_materialDic[url] = material;
			
		}
		
		private function loadMaterial(material:MaterialTree):void{
			var texVec:Vector.<TexItem> = material.texList;
			for(var i:int;i<texVec.length;i++){
				if(texVec[i].isParticleColor){
					continue;
				}
				var isMipmap:Boolean = texVec[i].mipmap == 0 ? false : true;
				
				TextureManager.getInstance().addTexture(Scene_data.fileRoot + texVec[i].url,onTextureLoad,texVec[i],0,isMipmap);
			}
		}
		
		private function onTextureLoad($textureVo:TextureVo ,$texItem:TexItem):void{
			$texItem.texture = $textureVo.texture;
			$texItem.textureVo = $textureVo;
		}
		
		public function loadDynamicTexUtil(material:MaterialTreeParam):void{
			var dynamicTexList:Vector.<DynamicTexItem> = material.dynamicTexList;
			for(var i:int;i<dynamicTexList.length;i++){
				if(dynamicTexList[i].isParticleColor){
					dynamicTexList[i].creatTextureByCurve(Scene_data.context3D,Scene_data.stage);
				}else{
					TextureManager.getInstance().addTexture(Scene_data.fileRoot + dynamicTexList[i].url,onDynamicTextureLoad,dynamicTexList[i]);
				}
			}
			
		}
		
		private function onDynamicTextureLoad($textureVo:TextureVo ,$texDynamicItem:DynamicTexItem):void{
			$texDynamicItem.texture = $textureVo.texture;
			$texDynamicItem.textureVo = $textureVo;
		}
		
	}
}