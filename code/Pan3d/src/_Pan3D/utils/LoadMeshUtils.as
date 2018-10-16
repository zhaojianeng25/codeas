package _Pan3D.utils
{
	import flash.display.Bitmap;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.vo.mesh.MeshVo;
	import _Pan3D.vo.pos.PosVo;
	
	import _me.Scene_data;

	/**
	 * 装备预加载（多个Mesh）加载工具类
	 * 负责加载mesh相关的模型数据，贴图，粒子信息 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class LoadMeshUtils
	{
		/**
		 * 加载完成后的回调函数 
		 */		
		private var _fun:Function;
		private var _errorFun:Function;
		/**
		 * 加载的多mesh信息 
		 */		
		private var _data:Object;
		
		/**
		 * 唯一标示（加载路径） 
		 */		
		private var _key:String;
		
		private var _loadNum:int;
		private var _allLoadNum:int;
		private var _priority:int;
		public function LoadMeshUtils()
		{
		}
		/**
		 * 加载一个mesh 
		 * @param url 路径
		 * @param fun 成功回调
		 * @param errorFun 失败回调
		 * 
		 */			
		public function addEquip(url:String,fun:Function,errorFun:Function,$priority:int=0):void{
			_key = url;
			_fun = fun;
			_errorFun = errorFun;
			_priority = $priority;
			var loaderinfo : LoadInfo = new LoadInfo(url + "equ.zzw", LoadInfo.BYTE, onInfoCom,_priority,null,loadError);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		private function loadError(info:Object=null):void{
			_errorFun();
		}
		/**
		 * zzw信息加载完成 
		 * @param byte 加载的二进制数据
		 * 
		 */		
		private function onInfoCom(byte:ByteArray):void{
			byte.position = 0;
			_data = byte.readObject();
			var arr:Vector.<MeshVo> = objToVo(_data as Array);
			_allLoadNum = arr.length;
			for(var j:int;j<arr.length;j++){
				var loaderinfo:LoadInfo;
				if(Scene_data.fileByteMode){
					loaderinfo = new LoadInfo(_key + "mesh/" + arr[j].meshUrl,LoadInfo.BYTE,onMeshCom,_priority,arr[j],loadError);
				}else{
					loaderinfo = new LoadInfo(_key + "mesh/" + arr[j].meshUrl,LoadInfo.XML,onMeshCom,_priority,arr[j],loadError);
				}
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}
		}
		
		/**
		 * 把读取的obj装化成vo模型
		 * @param ary 原始数据
		 * @return vo数据
		 * 
		 */		
		private function objToVo(ary:Array):Vector.<MeshVo>{
			var meshVec:Vector.<MeshVo> = new Vector.<MeshVo>;
			for(var i:int;i<ary.length;i++){
				var meshVo:MeshVo = MeshVo.getVo(ary[i])
				meshVo.renderPriority = i;
				meshVec.push(meshVo);
			}
			return meshVec;
		}
		/**
		 * 把读取的位置obj转化成vo模型 
		 * @param ary 原始数据
		 * @return vo数据
		 * 
		 */		
		private function posObjToVo(ary:Array):Vector.<PosVo>{
			var posVec:Vector.<PosVo> = new Vector.<PosVo>;
			for(var i:int;i<ary.length;i++){
				posVec.push(PosVo.getVo(ary[i]));
			}
			return posVec;
		}
		
		private function onMeshCom(str:*,info:Object):void{
			var loaderinfo:LoadInfo = new LoadInfo(_key + "texture/" + info.textureUrl,LoadInfo.BITMAP,onTextureCom,_priority,null,loadError);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		private function onTextureCom(bitmap:Bitmap):void{
			_loadNum++;
			if(_loadNum == _allLoadNum){
				_fun();
			}
		}
		
		private function objToV3d(obj:Object):Vector3D{
			return new Vector3D(obj.x,obj.y,obj.z)
		}

		
	}
}