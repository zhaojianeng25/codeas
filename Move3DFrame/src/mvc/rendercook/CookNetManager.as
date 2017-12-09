
package  mvc.rendercook
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _Pan3D.core.MathCore;
	
	import _me.FpsView;
	import _me.Scene_data;
	
	import modules.brower.fileTip.RadiostiyInfoWindow;
	import modules.brower.fileTip.RayTraceImageWindow;
	import modules.hierarchy.FileSaveModel;
	import modules.hierarchy.RenderModel;
	import modules.lightProbe.LightProbeEditorManager;
	
	import proxy.top.render.Render;
	
	
	public class CookNetManager
	{
		private static var instance:CookNetManager;
		private var _tSocket:FrameTSocket;
		private var _ctrlSocket:FrameTSocket;
		
		public static function getInstance():CookNetManager{
			if(!instance){
				instance = new CookNetManager();
			}
			return instance;
		}
		
		
		public function connectCtrl($fun:Function):Boolean{
			if(!_ctrlSocket){
				_ctrlSocket = new FrameTSocket;
				_ctrlSocket.initSocket(Endian.LITTLE_ENDIAN);
			}
			
			return _ctrlSocket.connect($fun,3);
		}
		
		public function connect($fun:Function = null,$type:int = 1):Boolean{
			_tSocket=new FrameTSocket();
			if($type == 1){
				_tSocket.initSocket();
			}else if($type == 2){
				_tSocket.initSocket(Endian.LITTLE_ENDIAN);
			}
			
			return _tSocket.connect($fun,$type);
		}
		
		public function CookNetManager()
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
				case 24:
				{
					setInfo($id,$data)
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
					saveBmpToFloadForBmpId(newBmp,uid)
					break;
				}
				case 51:{
					RayTraceModel.getInstance().renderCplusScene()
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

					saveBmpToFloadForBmpId(newBmp,uid)
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
				default:
				{
					break;
				}
			}
			
			if($url){
				var $urlByte:ByteArray=new ByteArray();
				$urlByte.writeUTF($url.replace($url=Render.lightUvRoot,""))
				$urlByte.position=0
				setInfo(23,$urlByte)
			}
			
		}

		private var astr:String="0%"
		private var bstr:String="0%"

		
		public function setInfo($idType:uint,$byte:ByteArray):void
		{
			
			switch($idType)
			{
				case 21:
				{
					var resultNum:Number=$byte.readInt();
					var lenght:Number=$byte.readInt();
					trace("次",int((resultNum)/lenght*100),"%");
					astr=String(int((resultNum)/lenght*100))+"%";
					break;
				}
				case 22:
				{
					var rodiosityNum:Number=$byte.readInt();
					var allNum:Number=$byte.readInt();
					trace("总",int((rodiosityNum)/allNum*100),"%");
					bstr=String(int((rodiosityNum)/allNum*100))+"%"
					break;
				}
				case 23:
				{
					var str:String=$byte.readUTF()
					print("提示", [str], 0xAAAAAA);
					break;
				}
				case 24:
				{
					var num:int = $byte.readInt();
					trace("end");
					break;
				}
				default:
				{
					break;
				}
			}
			this.traceInfoToFpsTip()
		}
		private var _psView:FpsView;
		private function traceInfoToFpsTip():void
		{
			if(!_psView){
				_psView=new FpsView(Scene_data.stage,250,40)
			}
			if(CookAllFrameModel.getInstance().needCookItem){
				FpsView.strNotice="分"+astr+"总"+bstr+"=>帧比"+(CookAllFrameModel.getInstance().cookSkipNum+1)+"/"+CookAllFrameModel.getInstance().needCookItem.length
			}else{
				FpsView.strNotice="分"+astr+"总"+bstr;
			}

		}
		public var cookEndFun:Function
		private function print(type:String, args:Array, color:uint):void {
			//var msg:String = "<font color='#" + color.toString(16) + "'><b>[" + type + "]</b>" + args.join(" ") + "</font>\n";
			var msg:String = "<font color='#" + color.toString(16) + "'><b></b>" + args.join(" ") + "</font>\n";
			if(msg.search("render complete!")!=-1){
	
				astr="0%"
				bstr="0%"
				traceInfoToFpsTip()
				setTimeout(function ():void{
				//	CookAllFrameModel.getInstance().close();
					cookEndFun()
					
				},5000)
			}

			trace(msg)
			
		}
		
		private function saveBmpToFloadForBmpId(newBmp:BitmapData,uid:String):void
		{
			var $url:String=Render.lightUvRoot+uid+".jpg";
			FileSaveModel.getInstance().useWorkerSaveBmp(newBmp.clone(),$url,"jpg");
			
			var $frameUrl:String=Render.lightUvRoot+"/"+Math.floor(AppDataFrame.frameNum)+"/"+uid+".jpg";
			FileSaveModel.getInstance().useWorkerSaveBmp(newBmp.clone(),$frameUrl,"jpg");
			
			RayTraceModel.getInstance().resetTexture(uid,newBmp);
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


