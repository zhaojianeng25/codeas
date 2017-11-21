package view.controlCenter
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import _Pan3D.skill.vo.EnumSkillKeyType;
	
	import utils.ai.AIManager;
	
	import view.action.ActionPanel;
	import view.effectSkill.BloodPanel;
	import view.effectSkill.EffectSkillPanel;
	import view.effectSkill.SoundPanel;
	import view.shock.ShockPanle;
	import view.trajectory.TrajectoryPanel;
	
	/**
	 * 技能时间轴显示类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class SkillTimeLineSprite extends Sprite
	{
		/**
		 * 需要控制的菜单选项 
		 */		
		private var _menuFile:NativeMenu;
		/**
		 * 代表动作的事件线显示对象 
		 */		
		private var _action:SkillBgSprite;
		
		private var _shockSp:ShockSprite; 
		
		private var _bloodSp:BloodSprite;
		
		/**
		 * 动作名称 
		 */		
		public var actionName:String;

		/**
		 * 添加动作菜单 
		 */		
		private var _addKey:NativeMenuItem;
		/**
		 * 删除动作菜单 
		 */		
		private var _delKeyFrame:NativeMenuItem;
		/**
		 * 添加弹道菜单 
		 */		
		private var _addParticle:NativeMenuItem;
		
		/**
		 * 添加弹道菜单 
		 */		
		private var _addEffect:NativeMenuItem;
		/**
		 * 编辑粒子菜单 
		 */		
		private var _editParticle:NativeMenuItem;
		/**
		 * 删除粒子菜单 
		 */		
		private var _removeParticle:NativeMenuItem;
		
		/**
		 * 震屏菜单 
		 */		
		private var _shockMenu:NativeMenuItem;
		
		private var _bloodMenu:NativeMenuItem;
		
		private var _targetX:int;
		/**
		 * 存储关键帧的list 
		 */		
		private var keyFrameAry:Vector.<SkillKeyFrameSprite>;
		private var renderAry:Vector.<SkillKeyFrameSprite>;
		
		public var keyFrameNewAry:Vector.<SkillKeyFrameNewSprite>;
		
		
		public var frame:int;
		
		private var _currentEditKeyFrame:SkillKeyFrameSprite;
		private var _currentEditNewKeyFrame:SkillKeyFrameNewSprite;
		private var _keyListPanle:KeyListPanle;
		
		private var _time:Number=0;
		
		public var configSkillData:Object = new Object;
		
		public var shockData:Object;
		
		public var bloodData:Object;
		
		public function SkillTimeLineSprite()
		{
			super();
			draw();
			initMenu();
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
//			keyFrameAry = new Vector.<SkillKeyFrameSprite>;
//			renderAry = new Vector.<SkillKeyFrameSprite>;
			_keyListPanle = new KeyListPanle;
			
			keyFrameNewAry = new Vector.<SkillKeyFrameNewSprite>;
			
		}
		/**
		 * 右键菜单 
		 * @param event
		 * 
		 */		
		protected function onRightClick(event:MouseEvent):void
		{
			if(this._bloodSp){
				this._bloodMenu.label = "移除音效";
			}else{
				this._bloodMenu.label = "添加音效";
			}
			_targetX = this.mouseX;
			if(event.target is SkillBgSprite){
				_addKey.enabled = false;
				_delKeyFrame.enabled = true;
				_addParticle.enabled = true;
				_removeParticle.enabled = _editParticle.enabled = false;
			}else if(event.target is SkillKeyFrameNewSprite){
				_addKey.enabled = false;
				_delKeyFrame.enabled = true;
				_addParticle.enabled = true;
				_removeParticle.enabled = _editParticle.enabled = true;
				_currentEditNewKeyFrame = event.target as SkillKeyFrameNewSprite;
			}else{
				_addKey.enabled = true;
				_delKeyFrame.enabled = false;
				_removeParticle.enabled = _editParticle.enabled = false;
			}
			_menuFile.display(stage,stage.mouseX,stage.mouseY);
		}
		
		/**
		 * 显示默认条
		 * */
		private function draw():void{
			this.graphics.clear();
			if(_action){
				this.graphics.beginFill(0x999999,0.5);
				this.graphics.drawRect(0,2,_action.width,17);
			}else{
				this.graphics.beginFill(0xff0000,0.5);
				this.graphics.drawRect(0,2,700,17);
			}
			this.graphics.endFill();
		}
		/**
		 * 初始化菜单 
		 * 
		 */		
		private function initMenu():void{
			_menuFile = new NativeMenu();
			
			_addKey = new NativeMenuItem("添加关键动作");  
			_addKey.addEventListener(Event.SELECT,onMenuAddTpye);
			
		
			_delKeyFrame = new NativeMenuItem("删除关键动作");  
			_delKeyFrame.addEventListener(Event.SELECT,onMenuDelItem);
			
			var line:NativeMenuItem = new NativeMenuItem("line",true);
			
			_addParticle = new NativeMenuItem("添加弹道");
			_addParticle.addEventListener(Event.SELECT,onAddParticle);
			
			_addEffect = new NativeMenuItem("添加特效");
			_addEffect.addEventListener(Event.SELECT,onEffectParticle);
			
			_editParticle = new NativeMenuItem("编辑粒子");
			_editParticle.addEventListener(Event.SELECT,onEditParticle);
			
			_removeParticle = new NativeMenuItem("删除粒子");
			_removeParticle.addEventListener(Event.SELECT,onRemoveParticle);
			
			_shockMenu = new NativeMenuItem("震屏");
			_shockMenu.addEventListener(Event.SELECT,onShock);
			
			_bloodMenu = new NativeMenuItem("添加音效");
			_bloodMenu.addEventListener(Event.SELECT,onBlood);
			
			_menuFile.items = [_addKey,_delKeyFrame,line,_addParticle,_addEffect,_editParticle,_removeParticle,_bloodMenu];
			
		}
		
		protected function onBlood(event:Event):void{
			if(!_bloodSp){
				
				this.initBloodSp();
			}else{
				this.removeChild(_bloodSp);
				this._bloodSp = null;
				this.bloodData = null;
			}
			
			
		}
		
		private function initBloodSp($data:Object=null):void{
			_bloodSp = new BloodSprite;
			this.addChild(_bloodSp);
			_bloodSp.x = _targetX;
			
			_bloodSp.addEventListener(MouseEvent.CLICK,onBloodClick);
			
			if($data){
				this.bloodData = $data;
				_bloodSp.x = $data.time * 8;
			}else{
				this.bloodData = new Object;
				this.bloodData.time = int(_targetX/8);
				//this.bloodData.pos = new Vector3D();
			}

		}
		
		
		protected function onBloodClick(event:MouseEvent):void
		{
			//BloodPanel.getInstance().showPanel(this.bloodData);
			SoundPanel.getInstance().showPanel(this.bloodData);
		}
		
		/**
		 * 编辑关键帧 
		 * @param event
		 * 
		 */		
		protected function onEditParticle(event:Event):void{
			var ary:Array = getEquList();
			if(ary.length == 1){
				var obj:Object = ary[0];
				if(obj.info.type == EnumSkillKeyType.TRAJECTORY){
					TrajectoryPanel.getInstance().showPanel(obj.info,null,true,this.configSkillData);
				}else if(obj.info.type == EnumSkillKeyType.EFFECT){
					EffectSkillPanel.getInstance().showPanel(obj.info,null,true,this.configSkillData);
				}
			}else{
				_keyListPanle.show(ControlCenterPanle.getInstance().parent,ary,editItem);
			}
		}
		/**
		 * 从多条目中选择要编辑的项目 
		 * @param obj
		 * 
		 */		
		private function editItem(obj:SkillKeyFrameNewSprite):void{
			if(obj.info.type == EnumSkillKeyType.TRAJECTORY){
				TrajectoryPanel.getInstance().showPanel(obj.info,addTrajectory,true,this.configSkillData);
			}else if(obj.info.type == EnumSkillKeyType.EFFECT){
				EffectSkillPanel.getInstance().showPanel(obj.info,addEffectSkill,true,this.configSkillData);
			}
		}
		/**
		 * 获取当前帧上关键帧列表 
		 * @return 
		 * 
		 */		
		private function getEquList():Array{
			var ary:Array = new Array;
			for(var i:int;i<keyFrameNewAry.length;i++){
				if(keyFrameNewAry[i].frameNum == _currentEditNewKeyFrame.frameNum){
					ary.push(keyFrameNewAry[i]);
				}
			}
			
			return ary;
		}
		/**
		 * 移除关键帧 
		 * @param event
		 * 
		 */		
		protected function onRemoveParticle(event:Event):void{
			var ary:Array = getEquList();
			if(ary.length == 1){
				removeKeyFrame(_currentEditNewKeyFrame);
			}else{
				_keyListPanle.show(ControlCenterPanle.getInstance().parent,ary,removeKeyFrame);
			}
			
		}
		/**
		 * 从系统中移除指定的关键帧 
		 * @param targetKeyFrame
		 * 
		 */		
		private function removeKeyFrame(targetKeyFrame:SkillKeyFrameNewSprite):void{
			var index:int = keyFrameNewAry.indexOf(targetKeyFrame);
			if(targetKeyFrame.parent){
				targetKeyFrame.parent.removeChild(targetKeyFrame);
			}
			if(index != -1){
				keyFrameNewAry.splice(index,1);
			}
			_currentEditKeyFrame = null;
		}
		/**
		 * 添加关键帧（弹道）
		 * 如果条件符合则弹出弹道添加面板
		 * @param event
		 * 
		 */		
		protected function onAddParticle(event:Event):void{
			var obj:Object = new Object;
			obj.frameNum = int(_targetX/8);
			
			var allInfo:Object = getAllInfo();
			if(allInfo.infoAry.length){
				var infoData:Object = allInfo.infoAry[0];
				if(infoData.type == EnumSkillKeyType.EFFECT){
					Alert.show("该技能已经添加技能效果，不能添加弹道");
				}else{
					TrajectoryPanel.getInstance().showPanel(obj,addTrajectory,false,this.configSkillData);
				}
			}else{
				TrajectoryPanel.getInstance().showPanel(obj,addTrajectory,false,this.configSkillData);
			}
		}
		/**
		 * 添加弹道到系统 
		 * @param obj
		 * 
		 */		
		private function addTrajectory(obj:Object):void{
			
			var allInfo:Object = getAllInfo();
			if(allInfo.infoAry.length){
				var infoData:Object = allInfo.infoAry[0];
				
				if(infoData.data.type != obj.data.type){
					Alert.show("已经存在的弹道和添加的弹道的类型不一致");
					return;
				}
				
				
			}
			
			var keyFrame:SkillKeyFrameNewSprite = new SkillKeyFrameNewSprite(obj);
			this.addChild(keyFrame);
			keyFrame.x = obj.frameNum * 8;
			keyFrameNewAry.push(keyFrame);
			keyFrameNewAry.sort(sortNew);
			
		}
		/**
		 * 添加关键帧（效果） 
		 * 如果条件符合则弹出效果添加面板
		 * @param event
		 * 
		 */		
		protected function onEffectParticle(event:Event):void{
			var obj:Object = new Object;
			obj.frameNum = int(_targetX/8);
			//EffectSkillPanel.getInstance().show(ControlCenterPanle.getInstance().parent,obj,addEffectSkill);
			
			var allInfo:Object = getAllInfo();
			if(allInfo.infoAry.length){
				var infoData:Object = allInfo.infoAry[0];
				if(infoData.type == EnumSkillKeyType.TRAJECTORY){
					Alert.show("该技能已经添加弹道，不能添加技能效果");
				}else{
					EffectSkillPanel.getInstance().showPanel(obj,addEffectSkill,false,this.configSkillData);
				}
			}else{
				EffectSkillPanel.getInstance().showPanel(obj,addEffectSkill,false,this.configSkillData);
			}
			
		}
		/**
		 * 添加效果到系统中 
		 * @param obj
		 * 
		 */		
		private function addEffectSkill(obj:Object):void{
			
			var allInfo:Object = getAllInfo();
			if(allInfo.infoAry.length){
				var infoData:Object = allInfo.infoAry[0];
				if(infoData.data.type != obj.data.type){
					Alert.show("已经存在的技能效果和添加的技能效果类型不一致");
					return;
				}
			}
			
			var keyFrame:SkillKeyFrameNewSprite = new SkillKeyFrameNewSprite(obj);
			this.addChild(keyFrame);
			keyFrame.x = obj.frameNum * 8;
			keyFrameNewAry.push(keyFrame);
			keyFrameNewAry.sort(sortNew);
			
		}

		/**
		 * 根据数据添加关键帧显示 
		 * @param obj
		 * @return 
		 * 
		 */		
		private function onAddKeySystem(obj:Object):SkillKeyFrameNewSprite{
			var keyFrame:SkillKeyFrameNewSprite = new SkillKeyFrameNewSprite(obj);
			this.addChild(keyFrame);
			keyFrame.x = obj.frameNum * 8;
			keyFrameNewAry.push(keyFrame);
			keyFrameNewAry.sort(sortNew);
			return keyFrame;
		}
		
		/**
		 * 移除动作 
		 * @param event
		 * 
		 */		
		protected function onMenuDelItem(event:Event):void
		{
			this.removeChild(_action);
			_action = null;
			actionName = "";
			draw();
		}
		/**
		 * 添加动作 
		 * @param event
		 * 
		 */		
		protected function onMenuAddTpye(event:Event):void
		{
			//ActionSelPanle.getInstance().show(ControlCenterPanle.getInstance().parent,onAddKey);
			
			var ary:ArrayCollection = ActionPanel.getInstance().dataAry;
			
			var _actionMenuFile:NativeMenu = new NativeMenu();  
			var menuAry:Array = new Array
			for(var i:int;i<ary.length;i++){
				var addType:NativeMenuItem = new NativeMenuItem(ary[i].fileName);  
				addType.addEventListener(Event.SELECT,onActionMenuSel);
				addType.data = ary[i];
				menuAry.push(addType);
			}
			
			_actionMenuFile.items = menuAry;  
			_actionMenuFile.display(stage,stage.mouseX,stage.mouseY);
			
		}
		
		protected function onActionMenuSel(event:Event):void
		{
			var obj:Object = event.target.data;
			onAddKey(obj);
		}
		
		/**
		 * 震屏 
		 * @param event
		 * 
		 */		
		protected function onShock(event:Event):void
		{
			//ActionSelPanle.getInstance().show(ControlCenterPanle.getInstance().parent,onAddKey);
			ShockPanle.getInstance().show(ControlCenterPanle.getInstance().parent,onAddSkock);
		}
		
		private function onAddSkock(obj:Object):void{
			if(!_shockSp){
				_shockSp = new ShockSprite;
			}
			if(obj.isuse){
				if(!_shockSp.parent){
					this.addChildAt(_shockSp,0);
				}
			}else{
				if(_shockSp.parent){
					_shockSp.parent.removeChild(_shockSp);
				}
			}
			
			_shockSp.draw(obj.time);
			
			_shockSp.x = obj.beginTime * 480 / 1000;
			
			if(obj.isuse){
				shockData = obj;
			}else{
				shockData = null;
			}
		}
		/**
		 * 添加关键动作 
		 * @param obj
		 * 
		 */		
		private function onAddKey(obj:Object):void{
			//trace(obj);
			if(!obj){
				return;
			}
			_action = new SkillBgSprite(obj);
			this.addChild(_action);
			_action.x = 0;
			_action.y = 3;
			actionName = _action.info.fileName;
			draw();
		}
//		private function sort(a:SkillKeyFrameSprite,b:SkillKeyFrameSprite):int{
//			if(a.frameNum > b.frameNum){
//				return 1;
//			}else if(a.frameNum < b.frameNum){
//				return -1;
//			}else{
//				return 0;
//			}
//		}
		/**
		 * 重新排序关键帧（对比函数） 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sortNew(a:SkillKeyFrameNewSprite,b:SkillKeyFrameNewSprite):int{
			if(a.frameNum > b.frameNum){
				return 1;
			}else if(a.frameNum < b.frameNum){
				return -1;
			}else{
				return 0;
			}
		}
		
//		public function update(t:Number):void{
//			_time += t;
//			getTarget();
////			for(var i:int;i<targetFlag;i++){
////				keyFrameAry[i].particle.update(_time - keyFrameAry[i].frameTime);
////			}
//			frame = _time/Scene_data.frameTime;
//			AppData.role.updataFrame(_time);
//		}
		
//		public var targetFlag:int;
//		private function getTarget():void{
//			for(var i:int = targetFlag;i<keyFrameAry.length;){
//				if(keyFrameAry[i].frameNum*Scene_data.frameTime < _time){
//					if(!keyFrameAry[i].bindFly){
//						keyFrameAry[i].addToRender(_time);
//					                                         }
//					i++;
//					targetFlag = i;
//				}else{
//					break;
//				}
//			}
//		}
		
//		public function reset():void{
//			_time = 0;
//			for(var i:int;i<keyFrameAry.length;i++){
//				keyFrameAry[i].reset();
//			}
//			frame = 0;
//			targetFlag = 0;
//		}
		
		public function play():void{
			
		}

		public function get action():SkillBgSprite
		{
			return _action;
		}

		public function set action(value:SkillBgSprite):void
		{
			_action = value;
		}
		/**
		 * 获取所有数据 
		 * @return 
		 * 
		 */		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.action = actionName;
			var infoAry:Array = new Array;
			for(var i:int;i<keyFrameNewAry.length;i++){
				infoAry.push(keyFrameNewAry[i].info)
			}
			obj.infoAry = infoAry;
			obj.config = configSkillData;
			obj.shock = shockData;
			if(this.bloodData){
				this.bloodData.time = int(this._bloodSp.x/8);
				obj.sound = this.bloodData;
			}
			return obj;
		}
		/**
		 * 设置所有数据 
		 * @param obj
		 * 
		 */		
		public function setAllInfo(obj:Object):void{
			actionName = obj.action;
			var actionAry:ArrayCollection = ActionPanel.getInstance().dataAry;
			var actionObj:Object;
			for(var i:int;i<actionAry.length;i++){
				if(actionAry[i].fileName == actionName){
					actionObj = actionAry[i];
					onAddKey(actionObj);
					break;
				}
			}
			
			for(i=0;i<obj.infoAry.length;i++){
				onAddKeySystem(obj.infoAry[i]);
			}
			
			if(obj.blood){
				this.initBloodSp(obj.blood);
				//_bloodSp = new BloodSprite;
				//this.addChild(_bloodSp);
				//_bloodSp.x = obj.blood * 8;
				//_bloodSp.addEventListener(MouseEvent.CLICK,onBloodClick);
			}
			if(obj.sound){
				this.initBloodSp(obj.sound);
			}
			converConfig(obj.config.ary);
			
			configSkillData = obj.config;
			
			if(obj.shock){
				onAddSkock(obj.shock);
			}
			
		}
		
		private function converConfig(ary:Array):void{
			if(!ary){
				return;
			}
			for(var i:int;i<ary.length;i++){
				var v3d:Vector3D = new Vector3D(ary[i].x,ary[i].y,ary[i].z);
				ary[i] = v3d;
			}
		}
		
//		private function getFlyBykey(str:String):SkillKeyFrameSprite{
//			for(var i:int;i<keyFrameAry.length;i++){
//				if(keyFrameAry[i].info.fly && keyFrameAry[i].info.fly.idStr == str){
//					return keyFrameAry[i];
//				}
//			}
//			return null;
//		}
		/**
		 * 建立配置
		 * 如果是动态目标类型，将动态目标生成，并添加到舞台 
		 * 
		 */		
		public function buildConfig():void{
			if(!configSkillData){
				return;
			}
			AIManager.getInstance().clear();
			if(configSkillData.type == 0){
				AIManager.getInstance().addRole(configSkillData.roleUrl);
			}
		}
		
		
	}
}