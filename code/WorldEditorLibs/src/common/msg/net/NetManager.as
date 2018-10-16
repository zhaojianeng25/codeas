package common.msg.net
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Alert;
	
	import _Pan3D.core.MathCore;
	
	import modules.brower.fileTip.RadiostiyInfoWindow;
	import modules.brower.fileTip.RayTraceImageWindow;
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.RenderModel;
	import modules.hierarchy.radiosity.RadiosityModel;
	import modules.lightProbe.LightProbeEditorManager;
	import modules.menu.MenuReadyEvent;
	
	import proxy.top.render.Render;
	

	public class NetManager
	{
		private static var instance:NetManager;
		private var _tSocket:TSocket;
		private var _ctrlSocket:TSocket;
		
		public static function getInstance():NetManager{
			if(!instance){
				instance = new NetManager();
			}
			return instance;
		}
		
		
		public function connectCtrl($fun:Function):Boolean{
			if(!_ctrlSocket){
				_ctrlSocket = new TSocket;
				_ctrlSocket.initSocket(Endian.LITTLE_ENDIAN);
			}
			
			return _ctrlSocket.connect($fun,3);
		}
		
		public function connect($fun:Function = null,$type:int = 1):Boolean{
			_tSocket=new TSocket();
			if($type == 1){
				_tSocket.initSocket();
			}else if($type == 2){
				_tSocket.initSocket(Endian.LITTLE_ENDIAN);
			}
			
			return _tSocket.connect($fun,$type);
		}
		
		public function NetManager()
		{
		}
	
		public function returnMsg($id:uint,$data:ByteArray):void
		{
			var $url:String
			switch($id)
			{
				case 20:
				{
					var $uid:String=$data.readUTF()
					var $w:uint=$data.readInt()
					var $h:uint=$data.readInt()
					var $bmp:BitmapData = new BitmapData($w,$h,true,0);
					$bmp.setPixels(new Rectangle(0,0,$w,$h),$data);
					$url=Render.lightUvRoot+$uid+".jpg"

					if($bmp){
						FileSaveModel.getInstance().useWorkerSaveBmp($bmp.clone(),$url,"jpg")
					}
					
					RenderModel.getInstance().resetTexture($uid,$bmp)

					break;
				}
				case 21:
				case 22:
				case 23:
				{
					RadiostiyInfoWindow.getInstance().setInfo($id,$data)
					break;
				}
				case 24:
				{
					RadiostiyInfoWindow.getInstance().close()
					Alert.show("烘培结束...");
					break;
				}
				case 25:
				{
					var $probeuid:String=$data.readUTF();
					var $nodeid:int = $data.readInt();
					var aryStr:Array = $probeuid.split(",");
					
					var probeObj:Object = $data.readObject();
					var arr:Vector.<Vector3D> = new Vector.<Vector3D>;
					for(var i:int;i<probeObj.length;i++){
						arr.push(new Vector3D(probeObj[i].x,probeObj[i].y,probeObj[i].z));
					}
		
					LightProbeEditorManager.getInstance().changeLightProbItemTempVec($nodeid,new Vector3D(aryStr[0],aryStr[1],aryStr[2]),arr)
					$nodeid
					break;
				}
				case 50:
				{
					var uid:String = $data.readUTF();
					var mapsize:int = $data.readInt();
					
					var wh:int = $data.readInt();
					var lenght:int = wh*wh;
					var cbmp:BitmapData = new BitmapData(wh,wh);
					for(i = 0 ;i < lenght;i++){
						var xi:int = i%wh;
						var yi:int = i/wh;
						var r:int = $data.readUnsignedByte();
						var g:int = $data.readUnsignedByte();
						var b:int = $data.readUnsignedByte();
						var a:int = $data.readUnsignedByte();
						cbmp.setPixel32(xi,yi,MathCore.argbToHex(a,r,g,b));
					}
					
					var newBmp:BitmapData = new BitmapData(mapsize,mapsize);
					var ma:Matrix = new Matrix();
					ma.scale(mapsize/wh,mapsize/wh);
					newBmp.draw(cbmp,ma,null,null,null,true);
					
					wh = $data.readInt();
					lenght = wh*wh;
					cbmp = new BitmapData(wh,wh);
					for(i = 0 ;i < lenght;i++){
						xi = i%wh;
						yi = i/wh;
						r = $data.readUnsignedByte();
						g = $data.readUnsignedByte();
						b = $data.readUnsignedByte();
						a = $data.readUnsignedByte();
						cbmp.setPixel32(xi,yi,MathCore.argbToHex(a,r,g,b));
					}
					
					ma.identity();
					ma.scale(mapsize/wh,mapsize/wh);
					newBmp.draw(cbmp,ma,null,BlendMode.ADD,null,true);
					
					$url=Render.lightUvRoot+uid+".jpg";
					FileSaveModel.getInstance().useWorkerSaveBmp(newBmp.clone(),$url,"jpg");
					
					
					RadiosityModel.getInstance().resetTexture(uid,newBmp);
					break;
				}
				case 51:{
					ModuleEventManager.dispatchEvent(new MenuReadyEvent(MenuReadyEvent.MENU_READY_EVENT));
					break;
				}
				case 52:{
					uid = $data.readUTF();
					wh = $data.readInt();
					var mscale:Number = $data.readFloat();
					lenght = wh*wh;
					cbmp = new BitmapData(wh,wh);
					for(i = 0 ;i < lenght;i++){
						xi = i%wh;
						yi = i/wh; 
						r = $data.readUnsignedByte();
						g = $data.readUnsignedByte();
						b = $data.readUnsignedByte();
						cbmp.setPixel32(yi,xi,MathCore.argbToHex(0xff,r,g,b));
					}

					newBmp = new BitmapData(wh/mscale,wh/mscale);
					ma = new Matrix();
					ma.scale(1.0/mscale,1.0/mscale);
					newBmp.draw(cbmp,ma,null,null,null,true);
					
					$url=Render.lightUvRoot+uid+".jpg";
					FileSaveModel.getInstance().useWorkerSaveBmp(newBmp.clone(),$url,"jpg");

					RadiosityModel.getInstance().resetTexture(uid,newBmp);
					break;
				}
				case 53:{
					wh = $data.readInt();
					lenght = wh*wh;
					cbmp = new BitmapData(wh,wh);
					for(i = 0 ;i < lenght;i++){
						yi = i%wh;
						xi = wh - i/wh - 1; 
						r = $data.readUnsignedByte();
						g = $data.readUnsignedByte();
						b = $data.readUnsignedByte();
						cbmp.setPixel32(yi,xi,MathCore.argbToHex(0xff,r,g,b));
					}
					
					//Scene_data.stage.addChild(new Bitmap(cbmp));
					
					var raywin:RayTraceImageWindow = new RayTraceImageWindow();
					raywin.add(cbmp);
					
					break;
				}
				case 54:{
					uid = $data.readUTF();
					wh = $data.readInt();
					mscale = $data.readFloat();
					lenght = wh*wh;
					cbmp = new BitmapData(wh,wh);
					for(i = 0 ;i < lenght;i++){
						xi = i%wh;
						yi = i/wh; 
//						var tr:Number = $data.readFloat();
//						var tg:Number = $data.readFloat();
//						var tb:Number = $data.readFloat();
//						
//						cbmp.setPixel32(yi,xi,MathCore.vecToHex(new Vector3D(tr,tg,tb,1.0)));
						
						r = $data.readUnsignedByte(); 
						g = $data.readUnsignedByte();
						b = $data.readUnsignedByte();
						a = $data.readUnsignedByte();
						
						cbmp.setPixel32(yi,xi,MathCore.argbToHex(a,r,g,b));
						
//						var e:Number = a - 128;
//						e = Math.pow(2,e);
//						var tr:Number = r * e;
//						var tg:Number = g * e;
//						var tb:Number = b * e;
//						cbmp.setPixel32(yi,xi,MathCore.vecToHex(new Vector3D(tr,tg,tb,1.0)));	
					}
					
					newBmp = new BitmapData(wh/mscale,wh/mscale,true);
					ma = new Matrix();
					ma.scale(1.0/mscale,1.0/mscale);
					newBmp.draw(cbmp,ma,null,null,null,true);
					
					$url=Render.lightUvRoot+uid+".jpg";
					FileSaveModel.getInstance().useWorkerSaveBmp(cbmp.clone(),$url,"png");
					
					RadiosityModel.getInstance().resetTexture(uid,cbmp);
					break;
				}
				default:
				{
					break;
				}
			}
			
			if($url){
				var $urlByte:ByteArray=new ByteArray();
				$urlByte.writeUTF($url.replace($url=Render.lightUvRoot,""))
				$urlByte.position=0
				RadiostiyInfoWindow.getInstance().setInfo(23,$urlByte)
	
			}
			
		}
	
		public function setMsg($data:ByteArray):void{
			_tSocket.setByte($data)
		}
		
		public function sendMsg(msgByte:ByteArray,msgId:uint):void
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN; 
			var length:int = msgByte.length + 4;
			byte.writeInt(length);
			byte.writeInt(msgId);
			byte.writeBytes(msgByte);

			setMsg(byte)
		}
		
		public function sendCtrlMsg(msgByte:ByteArray,msgId:uint):void
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN; 
			var length:int = msgByte.length + 4;
			byte.writeInt(length);
			byte.writeInt(msgId);
			byte.writeBytes(msgByte);
			
			//setMsg(byte)
			if(_ctrlSocket){
				_ctrlSocket.setByte(byte);
			}
			
		}
		
	}
}