package utils
{
	import _Pan3D.particle.ctrl.utils.CameraShake;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import renderLevel.levels.Particle3DFacet;
	
	import view.TimeLineSprite;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */
	public class ParticleManagerTool
	{
		private static var instance:ParticleManagerTool;
		public var timeLine:TimeLineSprite;
		public var _timeLineAry:Vector.<TimeLineSprite> = new Vector.<TimeLineSprite>;
		private var _time:int;
		private var _tempTime:int;
		public var frame:int;
		private var i:int;
		private var _allTime:int;
		private var _cameraShake:CameraShake = new CameraShake;
		public function ParticleManagerTool()
		{
		}
		
		public static function getInstance():ParticleManagerTool{
			if(!instance){
				instance = new ParticleManagerTool;
			}
			return instance;
		}
		public function start():void{
			_time = getTimer();
			//reset();
			_cameraShake.beginShank();
		}
		public function update():void{
			_tempTime = getTimer();
			var t:int = _tempTime - _time
//			for(i=0;i<_timeLineAry.length;i++){
//				_timeLineAry[i].update(t);
//			}
			_cameraShake.update(t);
			_time = _tempTime;
			_allTime += t;
			frame = _allTime/(1000/60);
			
			for(i=0;i<_timeLineAry.length;i++){
				_timeLineAry[i].update(_allTime);
			}
			
		}
		
		public function updateByFrame():void{
			var t:int = 1000/60;
//			for(i=0;i<_timeLineAry.length;i++){
//				_timeLineAry[i].update(t);
//			}
			_cameraShake.update(t);
			_allTime += t;
			frame = _allTime/(1000/60);
			for(i=0;i<_timeLineAry.length;i++){
				_timeLineAry[i].update(_allTime);
			}
		}
		
		public function reset():void{
			for(i=0;i<_timeLineAry.length;i++){
				_timeLineAry[i].reset();
			}
			_cameraShake.beginShank();
			frame = 0;
			_allTime = 0;
		}
		
		public function gotoAndStop(num:int):void{
			for(i=0;i<_timeLineAry.length;i++){
				_timeLineAry[i].reset();
				//_timeLineAry[i].targetFlag = -2;
			}
			_cameraShake.beginShank();
			var t:int = 1000/60*num;
//			for(var j:int;j<num;j++){
//				for(i=0;i<_timeLineAry.length;i++){
//					_timeLineAry[i].update(1000/60);
//				}
//			}
			for(i=0;i<_timeLineAry.length;i++){
				_timeLineAry[i].update(t);
			}
			_cameraShake.update(t);
			_allTime = t;
			frame = num;
		}
		
		public function addTimeLine(timeline:TimeLineSprite):void{
			_timeLineAry.push(timeline);
			timeline.addEventListener(Event.CHANGE,onChange);
			setMaxTime();
		}
		
		public function hasTimeLine(timeline:TimeLineSprite):Boolean{
			var index:int = _timeLineAry.indexOf(timeline);
			if(index != -1){
				return true;
			}else{
				return false;
			}
		}
		
		public function getCountInfo():String{
			var particleNum:int = _timeLineAry.length;
			var buffNum:int;
			
			var dicObj:Object = new Object;
			for(var i:int;i<_timeLineAry.length;i++){
				buffNum += _timeLineAry[i].particleItem.display3D.getBufferNum();
				dicObj[_timeLineAry[i].particleItem.display3D.textureUrl] = true;
			}
			
			
			var textureNum:int;
			for(var key:String in dicObj){
				textureNum++;
			}
			
			var str:String = "共" + particleNum + "层，buffer" + buffNum + "个,贴图" + textureNum + "个,";
			
			
			return str;
		}
		
		public function getTextureInfo():String{
			var dicObj:Object = new Object;
			
			var num512:int;
			var num256:int;
			var num128:int;
			
			for(var i:int;i<_timeLineAry.length;i++){
				var bmp:BitmapData;
				if(_timeLineAry[i].particleItem.display3D.particleData && _timeLineAry[i].particleItem.display3D.particleData.textureVo){
					bmp = _timeLineAry[i].particleItem.display3D.particleData.textureVo.bitmapdata;
				}
				
				if(!bmp){
					continue;
				}
				
				var key:String = _timeLineAry[i].particleItem.display3D.textureUrl;
				
				if(dicObj.hasOwnProperty(key)){
					continue;
				}
				
				if(bmp.width >= 512 || bmp.width >= 512){
					dicObj[key] = 512;
					num512++;
				}else if(bmp.width >= 256 || bmp.width >= 256){
					dicObj[key] = 256;
					num256++;
				}else{
					dicObj[key] = 128;
					num128++;
				}
			}
			var str:String = new String;
			if(num512 > 0){
				str += "<font color='#ff0000'>大于512的贴图"+ num512 + "个,</font>";
			}
			
			if(num256 > 0){
				str += "<font color='#ffff00'>大于256的贴图"+ num256 + "个,</font>";
			}
			
			if(num128 > 0){
				str += "<font color='#000000'>小于128的贴图" + num128 + "个</font>";
			}
				
				
			
			return str;
			
		}
		
		/**
		 * 设置粒子整体比例
		 * */
		public function setAllScale(value:Number = 1):void{
			for(var i:int;i<_timeLineAry.length;i++){
				_timeLineAry[i].particleItem.display3D.overAllScale = value;
			}
		}
		public function removeTimeLine(timeline:TimeLineSprite):void{
			var index:int = _timeLineAry.indexOf(timeline);
			_timeLineAry.splice(index,1);
			if(timeline.parent){
				timeline.parent.removeChild(timeline);
			}
			setMaxTime();
		}
		
		private function onChange(event:Event):void{
			setMaxTime();
		}
		
		public function setMaxTime():void{
			var maxNum:int;
			for(i=0;i<_timeLineAry.length;i++){
				var frame:int = _timeLineAry[i].getMaxFrame();
				if(frame > maxNum){
					maxNum = frame;
				}
			}
			//trace("maxNum " + maxNum)
		}
		
		public function setShake(obj:Object):void{
			//_cameraShake.setAllInfo(obj);
		}
		
		public function getShake():Object{
			return _cameraShake.getAllInfo();
		}
		
		
		
		
		
		
		
		
		
	}
}