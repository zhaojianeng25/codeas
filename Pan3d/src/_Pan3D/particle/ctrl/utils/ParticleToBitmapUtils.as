package _Pan3D.particle.ctrl.utils
{
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.core.MathCore;
	import _Pan3D.event.LoadCompleteEvent;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.vo.particle.ParticleBitmapVo;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	/**
	 * 粒子转序列图转换工具类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParticleToBitmapUtils
	{
		/**
		 * 资源路径 
		 */		
		private var _url:String;
		/**
		 * 回调函数 
		 */		
		private var _callBackFun:Function;
		/**
		 * 转换的参数 
		 */		
		private var _converInfo:Object;
		
		/**
		 * 转换的宽 
		 */		 
		private var _wNum:int;
		/**
		 * 转换的高度 
		 */		
		private var _hNum:int;
		/**
		 * 帧数 
		 */		
		private var _frameNum:int;
		/**
		 * 帧率 
		 */		
		private var _frameRate:int;
		
		/**
		 * 临时存储舞台的宽 
		 */		
		private var _stageWidth:int;
		/**
		 *  临时存储舞台的高
		 */		
		private var _stageHeight:int;

		private var _priority:int;
		//private var context3D:Context3D;
		/**
		 * 粒子对象 
		 */		
		private var combineParticle:CombineParticle;
		public function ParticleToBitmapUtils()
		{
		}
		/**
		 * 设置粒子 
		 * @param url 路径
		 * @param fun 回调
		 * 
		 */		
		public function setParticle(url:String,fun:Function,$priority:int):void{
			_url = url;
			_callBackFun = fun;
			_priority = $priority;
			var obj:Object = new Object;
			obj.url = url;
			loadParticle(url,obj);
		}
		/**
		 * 加载粒子 
		 * @param url
		 * @param info
		 * @return 
		 * 
		 */		
		public function loadParticle(url:String,info:Object):CombineParticle{
			
			combineParticle = new CombineParticle(null);
			
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onParticleLoad, _priority,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
			return combineParticle;
		}
		/**
		 * 粒子加载完成 
		 * @param byte
		 * @param info
		 * 
		 */		
		private function onParticleLoad(byte:ByteArray,info:Object):void{
			var obj:Object = byte.readObject();
			if(byte.bytesAvailable){
				_converInfo = byte.readObject();
			}else{
				trace("当前粒子无转换信息！！！！");
				return;
			}
			
			_wNum = _converInfo.width;
			_hNum = _converInfo.height;
			
			_frameNum = _converInfo.frameNum;
			_frameRate = _converInfo.frameRate;
			combineParticle.url = _url;
			combineParticle.data = obj as Array;
			combineParticle.addEventListener(LoadCompleteEvent.LOAD_COMPLETE,onSourceCom);//监听资源加载完成
			combineParticle.reset();
//			combineParticle.visible = true;
			
			if(combineParticle.getHasLoadCom()){//如果已经完成则直接执行回调函数（如果缓存中有 事件在监听前已经分发）
				onSourceCom();
			}
		}
		/**
		 * 资源加载完成后 回调函数 
		 * @param event
		 * 
		 */		
		private function onSourceCom(event:Event=null):void{
			ParticleToBitmapUtils.addToList(this);
			return;
			var context3D:Context3D=Scene_data.context3D;
			preSetContext();
			var bitmapAry:Vector.<BitmapData> = new Vector.<BitmapData>;
			for(var i:int;i<_frameNum/_frameRate;i++){//循环进行刷入图片
				context3D.clear(0,0,0,0);
				combineParticle.update(Scene_data.frameTime*_frameRate);//事件驱动
				combineParticle.renderUpdate();//强制更新渲染
				var bmp:BitmapData = render();
				bitmapAry.push(bmp);
			}
			reSetContext();
			
			var particleBitmapVo:ParticleBitmapVo = new ParticleBitmapVo;
			particleBitmapVo.width = _wNum;
			particleBitmapVo.height = _hNum;
			particleBitmapVo.frameNum = _frameNum/_frameRate;
			particleBitmapVo.frameTime = Scene_data.frameTime*_frameRate;
			particleBitmapVo.bitmapdataAry = bitmapAry;
			particleBitmapVo.url = _url;
			
			_callBackFun(particleBitmapVo);
			
			combineParticle.realDispose();
		}
		
		private var flag:int;
		private var resultBitmapAry:Vector.<BitmapData> = new Vector.<BitmapData>;
		public function renderDelay():Boolean{
			var context3D:Context3D=Scene_data.context3D;
			preSetContext();
			var isComplete:Boolean = false;
			
			var tempScale:Number = Scene_data.mainScale;
			
			Scene_data.mainScale = Scene_data.default_mainScale;
			for(var i:int;i<2;i++){//循环进行刷入图片
				flag++;
				if(flag >= _frameNum/_frameRate){
					isComplete = true;
					continue;
				}
				context3D.clear(0,0,0,0);
				combineParticle.update(Scene_data.frameTime*_frameRate);//事件驱动
				combineParticle.renderUpdate();//强制更新渲染
				var bmp:BitmapData = render();
				resultBitmapAry.push(bmp);
			}
			Scene_data.mainScale = tempScale;
			reSetContext();
			
			if(isComplete){
				var particleBitmapVo:ParticleBitmapVo = new ParticleBitmapVo;
				particleBitmapVo.width = _wNum;
				particleBitmapVo.height = _hNum;
				particleBitmapVo.frameNum = _frameNum/_frameRate;
				particleBitmapVo.frameTime = Scene_data.frameTime*_frameRate;
				particleBitmapVo.bitmapdataAry = resultBitmapAry;
				particleBitmapVo.url = _url;
				
				_callBackFun(particleBitmapVo);
				
				combineParticle.realDispose();
				
				return true;
			}
			return false;
		}
		
		/**
		 * 渲染前的准备 
		 * 设置镜头 舞台宽高 混合模式
		 */		
		private function preSetContext():void{
			var context3D:Context3D=Scene_data.context3D;
			_stageWidth = Scene_data.stageWidth;
			_stageHeight = Scene_data.stageHeight;
			try{
				onStageResize(_wNum,_hNum);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			context3D=Scene_data.context3D;
			var cam3D:Camera3D=new Camera3D({})
			cam3D.distance = Scene_data.cam3D.distance;
			cam3D.fovw = _wNum;
			cam3D.fovh = _hNum;
			var focus3D:Focus3D=new Focus3D
			focus3D.angle_x=Scene_data.cam3D.angle_x
			focus3D.angle_y=Scene_data.cam3D.angle_y
			
			
			MathCore._catch_cam(cam3D, focus3D,Scene_data.shake3D);
			Scene_data.cam3D.cameraMatrix = cam3D.cameraMatrix;
			context3D.clear(0, 0, 0, 1);
			
			var _projMatrixNew:Matrix3D = new  Matrix3D;
			_projMatrixNew.appendScale(0.001,0.001,0.0001);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _projMatrixNew, true);
			
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setDepthTest(false,Context3DCompareMode.LESS);
		}
		/**
		 * 渲染完成 回置模式 
		 * 
		 */		
		private function reSetContext():void{
			try{
				onStageResize(_stageWidth,_stageHeight);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		/**
		 * 渲染 把渲染目标写入bitmapdata 
		 * @return 
		 * 
		 */		
		private function render():BitmapData{
			var context3D:Context3D=Scene_data.context3D;
			var bitmapdata:BitmapData = new BitmapData(_wNum,_hNum,true,0);
			try
			{
				context3D.drawToBitmapData(bitmapdata);
			} 
			catch(error:Error) 
			{
				if(!Scene_data.disposed){
					throw error;
				}
			}
			//context3D.present();
			return bitmapdata;
		}
		/**
		 * 设置舞台宽高 
		 * @param w
		 * @param h
		 * 
		 */		
		private function onStageResize(w:int,h:int):void{
			Scene_data.stageWidth = w;
			Scene_data.stageHeight = h;
			
			Scene_data.cam3D.fovw=Scene_data.stageWidth;
			Scene_data.cam3D.fovh=Scene_data.stageHeight;
			
			var context3D:Context3D=Scene_data.context3D;
			try
			{
				context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,Scene_data.antiAlias, true);
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		public static var renderList:Vector.<ParticleToBitmapUtils> = new Vector.<ParticleToBitmapUtils>;
		public static function addToList($pmUtils:ParticleToBitmapUtils):void{
			renderList.push($pmUtils);
		}
		/**
		 * 3d粒子转2d的处理 
		 * 
		 */		
		public static function update():void{
			if(renderList.length == 0){
				return;
			}
			var l:int = renderList.length - 1;
			for(var i:int = l;i>=0;i--){
				var tf:Boolean = renderList[i].renderDelay();
				if(tf){
					renderList.splice(i,1);
				}
			}
		}
		
		
		
		
	}
}