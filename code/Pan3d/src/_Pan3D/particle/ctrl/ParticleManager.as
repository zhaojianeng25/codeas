package _Pan3D.particle.ctrl
{
	
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.Display3DFacetPartilce;
	import _Pan3D.particle.ctrl.utils.ParticleToBitmapUtils;
	import _Pan3D.role.BuffUtil;
	import _Pan3D.ui.UIComponent3D;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.TickTime;
	
	import _me.Scene_data;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */
	public class ParticleManager
	{
		private static var instance:ParticleManager;
		private var _combineParticleAry:Vector.<CombineParticle> = new Vector.<CombineParticle>;
		private var _time:int;
		private var _tempTime:int;
		public var frame:int;
		private var i:int;
		private var _allTime:int;
//		private var _cameraShake:CameraShake = new CameraShake;
		private var _container:Display3DContainer;
		private var _uiContainer:Display3DContainer;
		private var _ui2dContainer:Display3DContainer;
		
		private var _dicPool:Object;
		public function ParticleManager()
		{
			//Tick.addCallback(update);
			_dicPool = new Object;
			TickTime.addCallback(dispose);
			
			Display3DFacetPartilce.initBuffer();
		}
		
		public function get dicPool():Object
		{
			return _dicPool;
		}

		public function set dicPool(value:Object):void
		{
			_dicPool = value;
		}

		public static function getInstance():ParticleManager{
			if(!instance){
				instance = new ParticleManager;
			}
			return instance;
		}
		
		public function initParticle(level:Display3DContainer):void{
			_container = level;
		}
		
		public function initUIParticle(level:Display3DContainer):void{
			_uiContainer = level;
		}
		
		public function initUI2dParticle(level:Display3DContainer):void{
			_ui2dContainer = level;
		}
		
		public function start():void{
			_time = getTimer();
//			_cameraShake.beginShank();
		}
		public function update():void{
			_tempTime = getTimer();
			var t:int = _tempTime - _time
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].update(t);
			}
//			_cameraShake.update(t);
			_time = _tempTime;
			_allTime += t;
			frame = _allTime/(1000/60);
			
		}
		
		public function updateByFrame():void{
			var t:int = 1000/60;
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].update(t);
			}
//			_cameraShake.update(t);
			_allTime += t;
			frame = _allTime/(1000/60);
		}
		
		public function reset():void{
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].reset();
			}
//			_cameraShake.beginShank();
			frame = 0;
			_allTime = 0;
		}
		
		public function gotoAndStop(num:int):void{
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].reset();
			}
//			_cameraShake.beginShank();
			var t:int = 1000/60*num;
			for(var j:int;j<num;j++){
				for(i=0;i<_combineParticleAry.length;i++){
					_combineParticleAry[i].update(1000/60);
				}
			}
//			_cameraShake.update(t);
			_allTime = t;
			frame = num;
		}
		
		/**
		 * 仅限于工具使用 
		 * @param url
		 * @param info
		 * 
		 */		
		public function addParticleByUrl(url:String,info:Object):void{
			var loaderinfo : LoadInfo = new LoadInfo(Scene_data.particleRoot + url, LoadInfo.BYTE, onParticleLoadByUrl,0,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		/**
		 * 工具使用 
		 * @param byte
		 * @param info
		 * 
		 */		
		private function onParticleLoadByUrl(byte:ByteArray,info:Object):void{
			var obj:Object = byte.readObject();
			
			var combineParticle:CombineParticle = new CombineParticle(_container);
			combineParticle.data = obj as Array;
			
			_combineParticleAry.push(combineParticle);
			
			info.particle = combineParticle;
			
			if(info.bindTarget){
				combineParticle.bindTarget = info.bindTarget;
			}else{
				//combineParticle.bindTarget = AppData.role;
			}
			combineParticle.bindIndex = info.bindIndex;
			if(info.bindOffset){
				combineParticle.bindOffset = objToV3d(info.bindOffset);
			}
			if(info.bindRatation){
				combineParticle.bindRatation = objToV3d(info.bindRatation);
			}
			combineParticle.addToRender();
			combineParticle.reset();
			combineParticle.visible = info.visible;
		}
		
		public function getParticle(url:String,$priority:int=0):CombineParticle{
			var combineParticle:CombineParticle;
			
			if(!Scene_data.isDevelop){
				if(	_dicPool[url]){
					
					combineParticle = CombineParticle(_dicPool[url]).clone(_container);
					combineParticle.reset();
					combineParticle.url = url;
					combineParticle.resetCam();
					
					return combineParticle;
				}
			}
			
			combineParticle = new CombineParticle(_container);
			
			var info:Object = new Object;
			info.particle = combineParticle;
			
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onParticleLoadNew, $priority,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
			_dicPool[url] = combineParticle;
			
			combineParticle.url = url;
			
			combineParticle.resetCam();
			
			return combineParticle;
		}
		
		
		/**
		 * 获取一个特效 
		 * @param url 特效路径
		 * @param info 特效信息
		 * @param isInUI 特效是否是在UI中
		 * @return 特效对象
		 * 
		 */		
		public function loadParticle(url:String,info:Object,$priority:int=0,isInUI:Boolean=false,assignContainer:Display3DContainer=null):CombineParticle{
			var combineParticle:CombineParticle;
			
			if(!Scene_data.isDevelop){
				if(	_dicPool[url]){
					if(isInUI){
						if(assignContainer){
							combineParticle = CombineParticle(_dicPool[url]).clone(assignContainer);
						}else{
							combineParticle = CombineParticle(_dicPool[url]).clone(_uiContainer);
						}
					}else{
						combineParticle = CombineParticle(_dicPool[url]).clone(_container);
					}
					
					info.particle = combineParticle;
					
					if(info.bindTarget){
						combineParticle.bindTarget = info.bindTarget;
					}
					
					combineParticle.bindIndex = info.bindIndex;
					if(info.bindOffset){
						combineParticle.bindOffset = objToV3d(info.bindOffset);
					}
					if(info.bindRatation){
						combineParticle.bindRatation = objToV3d(info.bindRatation);
					}
					
					combineParticle.reset();
					combineParticle.url = url;
					combineParticle.isInUI = isInUI;
					combineParticle.resetCam();
					return combineParticle;
				}
			}
			
			if(isInUI){
				if(assignContainer){
					combineParticle = new CombineParticle(assignContainer);
				}else{
					combineParticle = new CombineParticle(_uiContainer);
				}
			}else{
				combineParticle = new CombineParticle(_container);
			}
			
			combineParticle.priority = $priority;
			
			info.key = url;
			info.particle = combineParticle;
			
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onParticleLoad, $priority,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
			_dicPool[url] = combineParticle;
			
			combineParticle.url = url;
			
			combineParticle.isInUI = isInUI;
			
			combineParticle.resetCam();
			
			return combineParticle;
		}
		
		private function onParticleLoadNew(byte:ByteArray,info:Object):void{
			var obj:Object = byte.readObject();
			
			var combineParticle:CombineParticle = info.particle;
			combineParticle.setData(obj as Array);
			
		}
		
		private function onParticleLoad(byte:ByteArray,info:Object):void{
			var obj:Object = byte.readObject();
			
			var combineParticle:CombineParticle = info.particle;
			combineParticle.data = obj as Array;
			
			//_combineParticleAry.push(combineParticle);
			
			info.particle = combineParticle;
			
			if(info.bindTarget){
				combineParticle.bindTarget = info.bindTarget;
			}
			
			if(info.hasOwnProperty("bindIndex")){
				combineParticle.bindIndex = info.bindIndex;
			}
			
			if(info.bindOffset){
				combineParticle.bindOffset = objToV3d(info.bindOffset);
			}
			if(info.bindRatation){
				combineParticle.bindRatation = objToV3d(info.bindRatation);
			}
//			if(info.target && info.target==3 && info.fly){
//				FlyCombineParticle(combineParticle).setFlyConfig(info.fly);
//			}
			
			combineParticle.reset();
			
			//_dicPool[info.key] = combineParticle;
		}
		
		/**
		 * 加载场景特效 
		 * @param url				完整地址
		 * @param $priority			加载级别
		 * @param $onCom			回调函数,  回调参数为 url
		 * @return 
		 * 
		 */		
		public function addSceneParticle(url:String,$priority:int=0, $onCom:Function=null):CombineParticle{
			
			var combineParticle:CombineParticle;
			
			if(url.indexOf("lid0.lyf") != -1){
				if(BuffUtil.isDebug){
					throw new Error("lid0错误");
				}
				combineParticle = new CombineParticle(_container);
				return combineParticle;
			}
			
			
			var info:Object = new Object;
			info.key = url;
			if(	_dicPool[url]){
				combineParticle = CombineParticle(_dicPool[url]).clone(_container);
				combineParticle.url = url;
				info.particle = combineParticle;
				combineParticle.reset();
				return combineParticle;
			}
			
			combineParticle = new CombineParticle(_container);
			combineParticle.priority = $priority;
			
			info.particle = combineParticle;
			
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onCom, $priority,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
			_dicPool[url] = combineParticle;
			
			combineParticle.url = url;
			
			return combineParticle;
			
			//封装一层com函数
			function onCom(byte:ByteArray,info:Object):void
			{
				if($onCom!=null)
				{
					$onCom(url);
				}
				
				onSceneParticleLoad(byte, info);
			}
		}
		
		private function onSceneParticleLoad(byte:ByteArray,info:Object):void{
			try
			{
				var pos:int = byte.position;
				byte.position = 0;
				var obj:Object = byte.readObject();
			} 
			catch(error:Error) 
			{
				throw new Error(info.key + ",pos:" + pos + ",length:" + byte.length + "**************" + error.toString())
			}
			
			var combineParticle:CombineParticle = info.particle as CombineParticle;
			combineParticle.data = obj as Array;
			
			combineParticle.reset();
//			combineParticle.visible = true;
			
		}
		
//		public function addUIParticle(url:String,ui:UIComponent3D,$priority:int):CombineParticle{
//			var combineParticle:CombineParticle = new CombineParticle(ui.particleContainer);
//			combineParticle.priority = $priority;
//			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onSceneParticleLoad, $priority,combineParticle);
//			LoadManager.getInstance().addSingleLoad(loaderinfo);
//			
//			return combineParticle;
//		}
		
		
//		public function getParticle():CombineParticle{
//			return _combineParticleAry[0];
//		}
		
		public function objToV3d(obj:Object):Vector3D{
			return new Vector3D(obj.x,obj.y,obj.z);
		}
		
		public function addParticle(particle:CombineParticle):void{
			var index:int = _combineParticleAry.indexOf(particle);
			if(index == -1){
				_combineParticleAry.push(particle);
				particle.addToRender(); 
			}
		}
		
		public function removeParticle(particle:CombineParticle):void{
			//_container.removeChild(particle);
			if(!particle){
				return;
			}
			particle.destory();
			var index:int = _combineParticleAry.indexOf(particle);
			if(index != -1){
				_combineParticleAry.splice(index,1);
			}
		}
		
		public function removeAllParticle():void{
			for(var i:int;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].destory();
			}
			_combineParticleAry = new Vector.<CombineParticle>;
		}
		/**
		 * 粒子转序列帧bitmapdata  
		 * @param url 粒子路径
		 * @param fun 回调函数（回调函数须接受 ParticleBitmapVo类型参数）
		 * 
		 */		
		public function particleToBitmapdata(url:String,fun:Function,$priority:int=0):void{
			new ParticleToBitmapUtils().setParticle(url,fun,$priority);
		}
		/**
		 * 重新装载粒子系统 
		 * 
		 */		
		public function reload():void{
			Display3DFacetPartilce.initBuffer();
			
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].reload();
			}
			for each (var obj:CombineParticle in _dicPool){
				obj.reload();
			}
			
		}
		/**
		 * 刷新ui中面向视点的距离 
		 * 
		 */		
		public function resetCam():void{
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].resetCam();
			}
		}
		/**
		 * 刷新场景中面向视点的距离 
		 * 
		 */		
		public function refreshCam():void{
			for(i=0;i<_combineParticleAry.length;i++){
				_combineParticleAry[i].refreshCam();
			}
		}
		
		private var flag:int;
		public var allBuffNum:int;
		private var allPaticleNum:int;
		public function dispose():void{
			//return;
			allPaticleNum = 0;
			for(var key:String in _dicPool){
				var particle:CombineParticle = _dicPool[key];
				if(particle.useTime <= 0){
					particle.idleTime ++;
					if(particle.idleTime >= Scene_data.cacheSkillTime){
						delete _dicPool[key];
						particle.realDispose();
						//trace("清理&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
					}
				}else{
					particle.idleTime = 0;
				}
				allPaticleNum ++;
			}
			
			if(allPaticleNum > 50){
				Scene_data.cacheSkillTime = 500;
			}else{
				Scene_data.cacheSkillTime = 1000;
			}
			
			if(flag == Log.logTime){
				flag = 0;
				var num:int;
				var allNum:int;
				allBuffNum = 0;
				for(key in _dicPool){
					particle = _dicPool[key];
					
					allBuffNum += particle.getBufferNum();
					if(particle.useTime > 0){
						Log.add(key + "  使用次数：" +particle.useTime,5);
						//trace(key);
						num++;
					}
					allNum++;
				}
				Log.add("————————————————————————————————particle分割线————————————————————————————————使用数量" +　num +　" 总数：" + allNum + "空闲个数：" + (allNum-num) + "总层数Buffer数：" + allBuffNum);
//				Log.add("———————————————&&&&&————————————分割线—————————&&&—————————————————角色剩余数量" +　Display3dGameMovie.allNum)
				
			}
			flag++;
			
		}
		
		public function applyBufferNum():void{
			allBuffNum = 0;
			for(var key:String in _dicPool){
				var particle:CombineParticle = _dicPool[key];
				
				allBuffNum += particle.getBufferNum();
			}
		}
		
		public function disposeUrl(url:String):void{
			var particle:CombineParticle = _dicPool[url];
			if(particle){
				particle.removeUse();
			}else{
				//trace("333")
			}
		}
		
		public function isSourceParticle(particle:CombineParticle):Boolean{
			var source:CombineParticle = _dicPool[particle.url]
			return Boolean(source == particle);
		}
		
		public function unloadParticleByUrl(strVec:Vector.<String>):void{
			for(var i:int;i<strVec.length;i++){
				var particle:CombineParticle = _dicPool[strVec[i]];
				if(particle){
					particle.unloadBuffer();
				}
			}
		}
		
		public function uploadParticleByUrl(strVec:Vector.<String>):void{
			if(!strVec){
				return;
			}
			for(var i:int;i<strVec.length;i++){
				var particle:CombineParticle = _dicPool[strVec[i]];
				if(particle){
					particle.uploadBuffer();
				}
			}
			
		}
		
		
	}
}