package _Pan3D.utils
{
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.role.AnimDataManager;
	import _Pan3D.role.MeshDataManager;
	import _Pan3D.role.MeshUtils;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.mesh.MeshByteVo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * 基础角色文件解析类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class BaseRolePreLoad
	{
		private var _baseUrl:String;// = "../../res/data/res3d";
		
		private var _byte:ByteArray;
		private var _comFun:Function;
		private var _progressFun:Function;
		
		private var loader:Loader;
		private var loaderPath:String;
		
		private var flag:int;
		
		private var t:int;
		public function BaseRolePreLoad()
		{
//			var loaderinfo : LoadInfo = new LoadInfo("../../res/data/res3d/baseRole.cfg", LoadInfo.BYTE, onInfoCom,0);
//			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
			loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onPngCom);
		}
		
		private function onInfoCom(byte:ByteArray):void{
			_byte = byte;
			t = getTimer();
			process();
		}
		/**
		 * @param $byte 加载好的二进制文件
		 * @param $comFun 解析完成回调
		 * @param _progressFun 解析进度回调  _progressFunb(Number)
		 * @param $baseUrl 基础路径 指向res3d的路径 如../../res/data/res3d
		 * 
		 */		
		public function addByte($byte:ByteArray,$comFun:Function,$progressFun:Function,$baseUrl:String):void{
			_byte = $byte;
			_comFun = $comFun;
			_progressFun = $progressFun;
			_baseUrl = $baseUrl;
			
			process();
		}
		
		private function process():void{
			if(!_byte.bytesAvailable){
				_comFun();
				return;
			}
			
			var type:int = _byte.readByte();
			var path:String = _baseUrl + _byte.readUTF();
			var dataLength:int = _byte.readInt();
			var data:ByteArray = new ByteArray;
			_byte.readBytes(data,0,dataLength);
			
			flag++;
			
			_progressFun(flag/24)
			
			if(type == 0){
				processZZW(path,data);
			}else if(type == 1){
				processMB(path,data);
			}else if(type == 2){
				processPNG(path,data);
			}else if(type == 3){
				processAB(path,data);
			}
			
		}
		
		private function processZZW(path:String,dataByte:ByteArray):void{
			
			path = path.replace("equ.zzw","");
			
			MeshUtils.writeDataByte(dataByte,path);
			
			process();
		}
		
		private function processAB(path:String,dataByte:ByteArray):void{
			AnimDataManager.getInstance().onAnimLoad(dataByte,path);
			process();
		}
		
		private function processMB(path:String,dataByte:ByteArray):void{
			MeshDataManager.getInstance().onMeshLoad(dataByte,path);
			process();
		}
		
		private function processPNG(path:String,dataByte:ByteArray):void{
			loaderPath = path;
			loader.loadBytes(dataByte);
		}
		
		protected function onPngCom(event:Event):void{
			var bitmap:Bitmap = event.target.content as Bitmap;
			TextureManager.getInstance().onTextureLoad(bitmap,loaderPath);
			//trace(loaderPath)
			process();
		}
		
	}
}