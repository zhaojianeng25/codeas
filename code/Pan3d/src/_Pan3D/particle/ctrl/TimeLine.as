package _Pan3D.particle.ctrl
{
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ctrl.utils.FrameTimeLineUtils;
	
	import _me.Scene_data;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * 
	 * 时间轴核心控制类
	 */	
	public class TimeLine extends EventDispatcher
	{
		private var _keyFrameAry:Array;
		private var _display3D:Display3DParticle;
		private var showVisible:Boolean = true;
		public var maxFrameNum:int;
		private var _currentKeyFrame:KeyFrame;//当前操作的关键帧
		private var _currentFrameNum:int;//当前帧数
		private var _time:Number=0;//播放时间
		//public var beginTime:Number=0;
		public function TimeLine()
		{
			super();
			_keyFrameAry = new Array;
		}
		
		/**
		 * 初始化起始帧 和结束帧
		 * 
		 */		
//		public function initKeyFrame():void{
//			addKeyFrame(0).isBegin = true;
//			addKeyFrame(60).isEnd = true;
//			resetKeyFramRelation();
//		}

		/**
		 * 
		 * @param num：帧数
		 * @return 关键帧对象
		 * 
		 */		
		public function addKeyFrame(num:int):KeyFrame{
			var keyframe:KeyFrame = new KeyFrame();
			keyframe.frameNum = num;
			_keyFrameAry.push(keyframe);
			
			//keyframe.addEventListener(Event.CHANGE,onFrameChg);
			return keyframe;
		}
		/**
		 * 删除关键帧 
		 * @param value 要删除的关键帧
		 * 
		 */		
		public function removeKeyFrame(value:KeyFrame):void{
			_keyFrameAry.splice(_keyFrameAry.indexOf(value),1);
			resetKeyFramRelation();
		}
		
		/**
		 * 重新分配所有关键的对应关系 
		 * 按照关键帧的数值进行排序
		 */		
		public function resetKeyFramRelation():void{
			_keyFrameAry.sortOn("frameNum",Array.CASEINSENSITIVE | Array.NUMERIC); 
			
			for(var i:int;i<_keyFrameAry.length;i++){
				if(i!=0){
					KeyFrame(_keyFrameAry[i]).preKeyFrame = _keyFrameAry[i-1];
				}

				if(i!=_keyFrameAry.length-1){
					KeyFrame(_keyFrameAry[i]).nextKeyFrame = _keyFrameAry[i+1];
				}
			}
			_currentKeyFrame = _keyFrameAry[0];
			if(_display3D)
				_display3D.beginTime = _keyFrameAry[0].frameNum*Scene_data.frameTime;
		}
		/**
		 * 当关键帧改变的时候，重新绘制时间轴，并向外分发事件
		 * @param event
		 * 
		 */		
		private function onFrameChg(event:Event):void{
			this.dispatchEvent(new Event(Event.CHANGE))
		}
		
		/**
		 * 设置时间轴的最大时间 
		 * @param num 如果==-1则表示不限时间
		 * 
		 */		
		public function setLastTime(num:int):void{
			if(num == -1){
				num = 100000000;
			}
			num = num/(1000/60);
			
			var keyframe:KeyFrame = _keyFrameAry[_keyFrameAry.length-1];
			keyframe.frameNum = num;
		}
		
		public function update(t:Number):void{
			if(!_currentKeyFrame){
				return;
			}
			_time = t;
			getTarget();
			_display3D.updateTime(_time);
		}
		public var targetFlag:int = -1;
		private function getTarget():void{
			var flag:int = -1;
			for(var i:int;i<_keyFrameAry.length;i++){
				if(_keyFrameAry[i].frameNum*Scene_data.frameTime < _time){
					flag = i;
				}else{
					break;
				}
			}
			if(flag != targetFlag){
				_currentKeyFrame = _keyFrameAry[flag];
				targetFlag = flag;
				
				_display3D.enterKeyFrame(_currentKeyFrame.animData,_currentKeyFrame.frameNum*Scene_data.frameTime,_currentKeyFrame.baseValue);
				_currentKeyFrame = _currentKeyFrame.nextKeyFrame;
				_display3D.visible = true;
				if(!_currentKeyFrame){
					_display3D.visible = false;
				}
				
			}
		}

		public function initAnim():void{
			if(_display3D){
				_display3D.initAnim(_keyFrameAry);
			}
		}
		
		public function startTime():void{
			
		}
		
		/**
		 * 重置状态 
		 * 
		 */		
		public function reset():void{
			_time = 0;
			_currentKeyFrame = _keyFrameAry[0];
			_display3D.clearAllAnim();
			_display3D.initAnim(_keyFrameAry);
			_display3D.updateTime(0);
			_display3D.visible = false;
			targetFlag = -1;
		}
		/**
		 * 获取所有的信息
		 * @return 信息数据对象
		 * 
		 */		
		public function getAllInfo():Object{
			var ary:Array = new Array;
			for(var i:int;i<_keyFrameAry.length;i++){
				ary.push(KeyFrame(_keyFrameAry[i]).getAllInfo());
			}
			var obj:Object = new Object;
			obj.timeline = ary;
			obj.display = _display3D.getAllInfo();
			return obj;
		}
		/**
		 * 设置信息 从信息中设置当前对象
		 * @param obj
		 * 
		 */		
		public function setAllInfo(obj:Object):void{
			var ary:Array = obj as Array;
			for(var i:int;i<ary.length;i++){
				var key:KeyFrame = addKeyFrame(ary[i].frameNum);
				ary[i].key = key;
			}
			resetKeyFramRelation();
			for(i=0;i<ary.length;i++){
				if(ary[i].animdata)
					KeyFrame(ary[i].key).animData = ary[i].animdata;
			}
			maxFrameNum = ary[ary.length-1].frameNum;
			FrameTimeLineUtils.getInstance().process(_keyFrameAry);
		}
		
		/**
		 * 获取最大的帧数 
		 * @return 最大帧数
		 * 
		 */		
		public function getMaxFrame():int{
			return KeyFrame(_keyFrameAry[_keyFrameAry.length-1]).frameNum;
		}

		public function get display3D():Display3DParticle
		{
			return _display3D;
		}

		public function set display3D(value:Display3DParticle):void
		{
			_display3D = value;
			_display3D.beginTime = _keyFrameAry[0].frameNum*Scene_data.frameTime;
			_display3D.initAnim(_keyFrameAry);
		}
		
		public function clone():TimeLine{
			var timeLine:TimeLine = new TimeLine();
			timeLine.keyFrameAry = _keyFrameAry;
			timeLine.display3D = _display3D.clone();
			timeLine.maxFrameNum = maxFrameNum;
			return timeLine;
		}
		
		public function set keyFrameAry(value:Array):void
		{
			_keyFrameAry = value;
			resetKeyFramRelation();
		}
		
		public function dispose():void{
			_keyFrameAry = null;
			_display3D.clear();
			_display3D = null;
			_currentKeyFrame = null;
		}
		
	}
}