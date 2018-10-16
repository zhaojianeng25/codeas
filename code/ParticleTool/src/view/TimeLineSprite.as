package view
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	
	import spark.components.mediaClasses.VolumeBar;
	
	import _Pan3D.particle.ctrl.utils.FrameTimeLineUtils;
	
	import _me.Scene_data;
	
	import common.utils.frame.MetaDataView;
	
	import manager.LayerManager;
	
	import pack.BuildMesh;
	
	import view.materials.MaterialParamView;
	import view.scene.ScenePropView;
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * </p>
	 * 时间轴核心控制类
	 */	
	public class TimeLineSprite extends Sprite
	{
		public var keyFrameAry:Array;
		private var _menuFile:NativeMenu;
		private var _particleItem:ParticleItem;
		private var _showVisible:Boolean = true;
		//public var beginTime:Number=0;
		public function TimeLineSprite(isnull:Boolean=true)
		{
			super();
			keyFrameAry = new Array;
			if(isnull){
				initKeyFrame();
			}
			configMenu();
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
		}

		public function get showVisible():Boolean
		{
			return _showVisible;
		}

		public function set showVisible(value:Boolean):void
		{
			_showVisible = value;
			if(_particleItem&&_particleItem.display3D){
				_particleItem.display3D.visible =_showVisible
			}

		
		}

		/**
		 *帧数变化时刷新背景 
		 * 
		 */		
		public function refreshDraw():void{
			var beginX:int = keyFrameAry[0].x;
			var endX:int = keyFrameAry[keyFrameAry.length-1].x;
			
			this.graphics.clear();
			this.graphics.beginFill(0x808080,0.8);
			this.graphics.drawRect(beginX,2,endX-beginX,17);
			this.graphics.endFill();
			this.graphics.lineStyle(0.8,0x00ff00);
			this.graphics.moveTo(beginX,10);
			this.graphics.lineTo(endX,10);
			
		}
		/**
		 * 初始化起始帧 和结束帧
		 * 
		 */		
		public function initKeyFrame():void{
			addKeyFrame(0).isBegin = true;
			addKeyFrame(60).isEnd = true;
			resetKeyFramRelation();
			refreshDraw();
		}
		/**
		 * 
		 * @param num：帧数
		 * @return 关键帧对象
		 * 
		 */		
		public function addKeyFrame(num:int):MyKeyFrame{
			var keyframe:MyKeyFrame = new MyKeyFrame();
			keyframe.frameNum = num;
			keyFrameAry.push(keyframe);
			this.addChild(keyframe);
			
			keyframe.addEventListener(Event.CHANGE,onFrameChg);
			return keyframe;
			
		}
		/**
		 * 删除关键帧 
		 * @param value 要删除的关键帧
		 * 
		 */		
		public function removeKeyFrame(value:MyKeyFrame):void{
			keyFrameAry.splice(keyFrameAry.indexOf(value),1);
			value.parent.removeChild(value);
			resetKeyFramRelation();
			refreshDraw();
		}
		
		/**
		 * 重新分配所有关键的对应关系 
		 * 按照关键帧的数值进行排序
		 */		
		private function resetKeyFramRelation():void{
			keyFrameAry.sortOn("frameNum",Array.CASEINSENSITIVE | Array.NUMERIC); 
			
			for(var i:int;i<keyFrameAry.length;i++){
				if(i!=0){
					MyKeyFrame(keyFrameAry[i]).preKeyFrame = keyFrameAry[i-1];
				}

				if(i!=keyFrameAry.length-1){
					MyKeyFrame(keyFrameAry[i]).nextKeyFrame = keyFrameAry[i+1];
				}
			}
			_currentKeyFrame = keyFrameAry[0];
			if(_particleItem)
				_particleItem.display3D.beginTime = keyFrameAry[0].frameNum*Scene_data.frameTime;
		}
		/**
		 * 当关键帧改变的时候，重新绘制时间轴，并向外分发事件
		 * @param event
		 * 
		 */		
		private function onFrameChg(event:Event):void{
			refreshDraw();
			FrameTimeLineUtils.getInstance().process(keyFrameAry);
			this.dispatchEvent(new Event(Event.CHANGE));
			if(_particleItem)
				_particleItem.display3D.beginTime = keyFrameAry[0].frameNum*Scene_data.frameTime;
		}
		/**
		 * 配置右键菜单 
		 * 
		 */		
		private function configMenu():void{
			_menuFile = new NativeMenu();  
			var add:NativeMenuItem = new NativeMenuItem("插入关键帧");  
			add.addEventListener(Event.SELECT,onMenuAddKey);
			var del:NativeMenuItem = new NativeMenuItem("删除关键帧");  
			del.addEventListener(Event.SELECT,onMenuDelKey);
			var edit:NativeMenuItem = new NativeMenuItem("编辑基本帧属性");  
			edit.addEventListener(Event.SELECT,onMenuEditKey);
			var editAnim:NativeMenuItem = new NativeMenuItem("编辑关键帧运动");  
			editAnim.addEventListener(Event.SELECT,onMenuAnimKey);
			_menuFile.items = [add,del,edit,editAnim];  
		}
		/**
		 * 如果是关键帧上右键 设置菜单的可选项 
		 * 
		 */		
		private function setKeyMenu():void{
			_menuFile.items[0].enabled = false;
			_menuFile.items[1].enabled = true;
			_menuFile.items[2].enabled = true;
			_menuFile.items[3].enabled = true;
		}
		/**
		 * 如果是普通帧上右键 设置相应的菜单可选项 
		 * 
		 */		
		private function setNullMenu():void{
			_menuFile.items[0].enabled = true;
			_menuFile.items[1].enabled = false;
			_menuFile.items[2].enabled = false;
			_menuFile.items[3].enabled = false;
		}
		private var targetKey:MyKeyFrame;//当前目标关键帧
		private var targetAddX:int;
		/**
		 * 右键点击 
		 * @param event
		 */		
		private function onRightClick(event:MouseEvent):void{
			if(event.target is MyKeyFrame){
				setKeyMenu();
				targetKey = event.target as MyKeyFrame;
			}else{
				setNullMenu();
				targetAddX = this.mouseX;
				targetKey = null;
			}
			_menuFile.display(stage,stage.mouseX,stage.mouseY);
		}
		/**
		 * 添加关键帧 
		 * @param event
		 * 
		 */		
		private function onMenuAddKey(event:Event):void{
			addKeyFrame(int(targetAddX/8));
			resetKeyFramRelation();
			FrameTimeLineUtils.getInstance().process(keyFrameAry);
		}
		/**
		 * 删除关键帧 
		 * @param event
		 * 
		 */		
		private function onMenuDelKey(event:Event):void{
			if(keyFrameAry.length == 2){
				Alert.show("关键帧剩余2，不能删除");
				return;
			}
			removeKeyFrame(targetKey);
		}
		/**
		 * 编辑基本关键帧 
		 * @param event
		 * 
		 */		
		private function onMenuEditKey(event:Event):void{
			

	
			if(!_keyAttributView){
				_keyAttributView = new KeyAttributView(); 
				_keyAttributView.init(null,"粒子帧参数",2);
			}
			_keyAttributView.setData(this._particleItem)
			LayerManager.getInstance().addPanel(_keyAttributView);
			_keyAttributView.refreshView()
				
			return ;
			KeyAttributPanle.getInstance().show(this._particleItem);
		}

		/**
		 * 编辑关键帧运动 
		 * @param event
		 * 
		 */		
		private function onMenuAnimKey(event:Event):void{
			KeyAnimPanle.getInstance().show(targetKey);
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
			
			var keyframe:MyKeyFrame = keyFrameAry[keyFrameAry.length-1];
			keyframe.frameNum = num;
			refreshDraw();
			
	
			
		
		}
		public function getLastTime():int
		{
			var keyframe:MyKeyFrame = keyFrameAry[keyFrameAry.length-1];
			return keyframe.frameNum *(1000/60)
		}
		
		private var _currentKeyFrame:MyKeyFrame;//当前操作的关键帧
		private var _currentFrameNum:int;//当前帧数
		private var _time:Number;//播放时间
		
		/**
		 * 循环时间的更新
		 * @param t 更新的时间
		 * 
		 */		
		public function update(t:Number):void{
			if(!_currentKeyFrame){
				return;
			}
//			trace(_currentKeyFrame.frameNum)
			_time = t;
//			if(_currentKeyFrame.frameNum*Scene_data.frameTime <= _time ){
//				particleItem.display3D.enterKeyFrame(_currentKeyFrame.animData,_currentKeyFrame.frameNum*Scene_data.frameTime,_currentKeyFrame.baseValue);
//				_currentKeyFrame = _currentKeyFrame.nextKeyFrame;
//				if(showVisible)
//					particleItem.display3D.visible = true;
//				if(!_currentKeyFrame){
//					particleItem.display3D.visible = false;
//				}
//			}
			getTarget();
			_particleItem.display3D.updateTime(_time);
		}
		
		public function getBeginFrame():int{
			return keyFrameAry[0].frameNum;
		}
		
		public var targetFlag:int = -1;
		private var _keyAttributView:KeyAttributView;
		private function getTarget():void{
			var flag:int = -1;
			for(var i:int;i<keyFrameAry.length;i++){
				if(keyFrameAry[i].frameNum*Scene_data.frameTime < _time){
					flag = i;
				}else{
					break;
				}
			}
			if(flag != targetFlag){
				_currentKeyFrame = keyFrameAry[flag];
				targetFlag = flag;
				
				trace("keyFrame");
				_particleItem.display3D.enterKeyFrame(_currentKeyFrame.animData,_currentKeyFrame.frameNum*Scene_data.frameTime,_currentKeyFrame.baseValue);
				_currentKeyFrame = _currentKeyFrame.nextKeyFrame;
				if(showVisible)
					_particleItem.display3D.visible = true;
				if(!_currentKeyFrame){
					_particleItem.display3D.visible = false;
				}
				
			}
		}
		
		
		/**
		 * 重置状态 
		 * 
		 */		
		public function reset():void{
			_time = 0;
			_currentKeyFrame = keyFrameAry[0];
			_particleItem.display3D.clearAllAnim();
			_particleItem.display3D.initAnim(keyFrameAry);
			_particleItem.display3D.updateTime(0);
			_particleItem.display3D.visible = false;
			targetFlag = -1;
		}
		/**
		 * 获取所有的信息
		 * @return 信息数据对象
		 * 
		 */		
		public function getAllInfo():Object{
			var ary:Array = new Array;
			for(var i:int;i<keyFrameAry.length;i++){
				ary.push(MyKeyFrame(keyFrameAry[i]).getAllInfo());
			}
			var obj:Object = new Object;
			obj.timeline = ary;
			obj.display = _particleItem.display3D.getAllInfo();
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
				var key:MyKeyFrame = addKeyFrame(ary[i].frameNum);
				ary[i].key = key;
				//keyFrameAry.push(key);
			}
			resetKeyFramRelation();
			for(i=0;i<ary.length;i++){
				if(ary[i].animdata)
					MyKeyFrame(ary[i].key).animData = ary[i].animdata;
			}
			refreshDraw();
			//preProcessData();
			FrameTimeLineUtils.getInstance().process(keyFrameAry);
		}
		
		
		/**
		 * 获取最大的帧数 
		 * @return 最大帧数
		 * 
		 */		
		public function getMaxFrame():int{ 
			return MyKeyFrame(keyFrameAry[keyFrameAry.length-1]).frameNum;
		}

		public function get particleItem():ParticleItem
		{
			return _particleItem;
		}

		public function set particleItem(value:ParticleItem):void
		{
			_particleItem = value;
			_particleItem.display3D.beginTime = keyFrameAry[0].frameNum*Scene_data.frameTime;
			
			_particleItem.display3D.initAnim(keyFrameAry);
		}
		
		
		
	}
}