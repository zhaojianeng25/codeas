package mvc.rendercook
{
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import _Pan3D.texture.TextureManager;
	
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	
	import mvc.frame.FrameModel;
	import mvc.frame.view.FrameFileNode;
	import mvc.frame.view.FramePanel;
	
	import proxy.pan3d.model.ProxyPan3dModel;
	
	import terrain.GroundData;

	public class RayTraceModel
	{
		public function RayTraceModel()
		{
		}
		public var  framePanel:FramePanel
		public static function getInstance():RayTraceModel{
			if(!instance){
				instance = new RayTraceModel();
			}
			return instance;
		}
		
		private static var instance:RayTraceModel;
		private var RayTraceCUDA:NativeProcess;
		private var ConsoleRender:NativeProcess;
		public function openRadiosity():void
		{

			NativeApplication.nativeApplication.autoExit=true;
			this.openRayTraceCUDA();
			this.openConsoleRender();

		}
		private function openRayTraceCUDA():void
		{
			var file:File=new File("C:/Program Files (x86)/haiyi/haiyirender/RayTraceCUDA.exe")
			var nativeProcessStartupInfo:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable=file;
			RayTraceCUDA=new NativeProcess();
			RayTraceCUDA.start(nativeProcessStartupInfo);
		}
		private function openConsoleRender():void
		{
			var file:File=new File("C:/Program Files (x86)/haiyi/haiyirender/ConsoleRender.exe")
			var nativeProcessStartupInfo:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable=file;
			ConsoleRender=new NativeProcess();
			ConsoleRender.start(nativeProcessStartupInfo);
 

		}
		
		public function exitAll():void
		{
			this.exitRayTraceCUDA();
			this.exitConsoleRender();
		}
		private function exitRayTraceCUDA():void
		{
			RayTraceCUDA.exit(true)
		}
		private function exitConsoleRender():void
		{
			ConsoleRender.exit(true)
		}

		public function renderCtrl():void{
		
			GroundData.showTerrain=false;
			var disConnect:Boolean = CookNetManager.getInstance().connectCtrl(function():void{
				readyRender();
			});

		}
		private function readyRender():void{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeUTF("begin");
			CookNetManager.getInstance().sendCtrlMsg(byte,0);
		}
		public function renderCplusScene():void{
			
			var disConnect:Boolean = CookNetManager.getInstance().connect(function():void{
				getCdata();
			},2);
			if(!disConnect){
				getCdata();
			}
		}
		
		private function getCdata():void
		{
			RayTraceModel.getInstance().makeFrameNodeByteToRender()
			
		}
		
		private function makeFrameNodeByteToRender():void
		{
			var $arr:Vector.<FileNode>=this.getRenderByFrameNum()

		    var $byte:ByteArray= FrameSceneByeModel.getInstance().makeRenderByteArrayData($arr)
		   CookNetManager.getInstance().sendMsg($byte,1);
			  
		
		}
		private function getRenderByFrameNum():Vector.<FileNode>
		{
			var $barckArr:Vector.<FileNode>=new Vector.<FileNode>
			var $arr:Vector.<FileNode>=FileNodeManage.getListAllFileNode(FrameModel.getInstance().ary);
			var $frameNum:uint=Math.floor(AppDataFrame.frameNum)
			for(var i:Number=0;i<$arr.length;i++){
				var $framefilenode:FrameFileNode=$arr[i] as FrameFileNode;
				if($framefilenode.isVisible($frameNum)){
					$barckArr.push($framefilenode)
				}

			}
			return $barckArr
		}
		
		public  function resetTexture(uid:String, $bmp:BitmapData):void
		{
			trace("更新灯光图1",uid,$bmp)
			var arr:Vector.<FrameFileNode>=	FrameModel.getInstance().getAllFrameFileNode();
			for(var i:Number=0;i<arr.length;i++){
				if(arr[i].id==Number(uid)){
					ProxyPan3dModel(arr[i].iModel).sprite.lightMapTexture=TextureManager.getInstance().bitmapToTexture($bmp)
				}
			}
		}
	}
}