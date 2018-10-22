package view
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	
	import guiji.GuijiLevel;
	
	import renderLevel.quxian.QuxianLevel;
	
	import utils.ParticleManagerTool;
	
	import view.component.ParticleItemBtn;
	import view.countView.CountPanle;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;
	
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 * 粒子条目容器，控制和管理粒子条目
	 */	
	public class MyList extends Canvas
	{
		private var _dataProvider:ArrayCollection;
		private var maxNum:int = 8;
		private var ui:UIComponent;
		private var columHeight:int = 20;
		public var ypos:int;
		public function MyList()
		{
			super();
			ui = new UIComponent;
			this.addChild(ui);
			this.horizontalScrollPolicy = "off"
			this.verticalScrollPolicy = "off";
			this.width = 130;
			_dataProvider = new ArrayCollection;
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRight);
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.addEventListener(MouseEvent.CLICK,onAllClick);
		}
		
		protected function onAllClick(event:MouseEvent):void
		{
			this.setFocus();
		}
		
		[Bindable]
		public function get dataProvider():ArrayCollection
		{
			return _dataProvider;
		}
		public function get _ui():UIComponent{
			return this.ui;
		}
		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,onCtrls);
		}
		/**
		 * 设置数据源
		 * */
		public function set dataProvider(value:ArrayCollection):void
		{
			_dataProvider = value;
			while(ui.numChildren){
				ui.removeChildAt(0);
			}
//			for(var i:int;i<value.length;i++){
//				var btn:Button = new Button;
//				btn.width = 100;
//				btn.height = columHeight;
//				btn.y = columHeight*i;
//				btn.label = value[i].name;
//				ui.addChild(btn);
//			}
//			ui.height = columHeight * value.length;
		}
		/**
		 * 添加粒子条目
		 * @param value 粒子条目
 		 * 
		 */		
		public function addItem(value:ParticleItem):void{
			ui.addChild(value);
			value.y = _dataProvider.length * 20;
			ui.height = columHeight * _dataProvider.length;
			_dataProvider.addItem(value);
			value.addEventListener(MouseEvent.CLICK,onClick);
			value.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			
			//if(AppData.display3dParticle == null){
				AppParticleData.display3dParticle = value.display3D;
				value.selected = true;
				AppParticleData.currentParticleItem = value;
			//}
		}
		/**
		 * 滚动控制
		 * */
		public function scollNum(value:int,upScroll:Boolean=false):void{
			if(_dataProvider.length <= maxNum&&upScroll){
				return;
			}
			ui.y = -(value*columHeight);
			ypos = ui.y;
		}
		/**
		 * 鼠标点击粒子条目
		 * */
		private var selectContainer:Array=[];
		private function onClick(event:Event):void{
			//黏贴和删除选项的时候
			
			if(ctrlKey)
			{
				if(currentTarget!=null)
				{
					selectContainer.push(currentTarget);
					currentTarget=null;
				}
				if(selectContainer.indexOf(event.currentTarget as ParticleItem)==-1)
				{
					selectContainer.push(event.currentTarget as ParticleItem);
					((event.currentTarget as ParticleItem).getChildAt(0) as ParticleItemBtn).selected=true;
				}
				else
				{
					var index:int=selectContainer.indexOf(event.currentTarget as ParticleItem);
					((event.currentTarget as ParticleItem).getChildAt(0) as ParticleItemBtn).selected=false;
					selectContainer.splice(index,1);
				}
				
		
				showXyz();
				return;
			}
			while(selectContainer.length>0)
			{
				selectContainer.pop();
			}
			currentTarget = event.currentTarget as ParticleItem;
			for(var i:int;i<_dataProvider.length;i++){//被点击对象标记为可选
				if(_dataProvider[i] == event.currentTarget){
					ParticleItem(_dataProvider[i]).selected = true;
				}else{
					ParticleItem(_dataProvider[i]).selected = false;
				}
			}
			//将当前的粒子置入appdata
			AppParticleData.display3dParticle = ParticleItem(event.currentTarget).display3D;
			AppParticleData.currentParticleItem = ParticleItem(event.currentTarget);
			//显示面板，将粒子数值刷入面板
			var dynamicpanle:DynamicAttributePanle = AllAttributePanle.getInstance().showParticle(ParticleItem(event.currentTarget).type);
			
			dynamicpanle.setData(AppParticleData.display3dParticle);
			
			
			
			// 如果当前粒子为轨迹 显示/隐藏轨迹控制线
			if(AppParticleData.display3dParticle is Display3DLocusPartilce){
				GuijiLevel.Instance().setGuijiLizhiVO (Display3DLocusPartilce(AppParticleData.display3dParticle))
			}else{
				GuijiLevel.Instance().hide();
			}
			if(AppParticleData.display3dParticle is Display3DLocusBallPartilce){
				QuxianLevel.getInstance().setGuijiLizhiVO( Display3DLocusBallPartilce(AppParticleData.display3dParticle))
			}else{
				QuxianLevel.getInstance().hide();
			}

			//showXyz();
		}
		
		
		private function showXyz():void{
			
	
			var _tooXyzMoveData:TooXyzMoveData=new TooXyzMoveData
			if(selectContainer.length){
				_tooXyzMoveData.dataItem=new Vector.<TooXyzPosData>;
				_tooXyzMoveData.modelItem=new Array
				for (var i:uint=0;i<selectContainer.length;i++)
				{
					
					
					var k:TooXyzPosData=new TooXyzPosData;
					var display3d:Display3DParticle=selectContainer[i].display3D
	
					k.x=display3d.center.x
					k.y=display3d.center.y
					k.z=display3d.center.z
					k.scale_x=display3d.scale_x
					k.scale_y=display3d.scale_y
					k.scale_z=display3d.scale_z
					k.angle_x=display3d.rotationX
					k.angle_y=display3d.rotationY
					k.angle_z=display3d.rotationZ
					_tooXyzMoveData.dataItem.push(k)
					_tooXyzMoveData.modelItem.push(display3d)
					
				}
				_tooXyzMoveData.fun=xyzBfun
				MoveScaleRotationLevel.getInstance().xyzMoveData=_tooXyzMoveData
				
			}else{
				MoveScaleRotationLevel.getInstance().xyzMoveData=null
			}
	
			
		}
		private static function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
				var $iModel:Display3DParticle=Display3DParticle($XyzMoveData.modelItem[i])
				var $dataPos:TooXyzPosData=$XyzMoveData.dataItem[i]
				
				$iModel.x=$dataPos.x
				$iModel.y=$dataPos.y
				$iModel.z=$dataPos.z
				
				$iModel.center.x=$iModel.x
				$iModel.center.y=$iModel.y
				$iModel.center.z=$iModel.z
					
				$iModel.rotationX=$dataPos.angle_x
				$iModel.rotationY=$dataPos.angle_y
				$iModel.rotationZ=$dataPos.angle_z
				
		
				
			}
		}
		
		
		
		private var currentTarget:ParticleItem;//当前的目标粒子条目对象
		/**
		 * 鼠标右键单击，弹出选项菜单
		 * */
		private function onRightClick(event:Event):void{
			currentTarget = event.currentTarget as ParticleItem;
			var _menuFile:NativeMenu = new NativeMenu();  
			var copy:NativeMenuItem = new NativeMenuItem("复制对象");  
			copy.addEventListener(Event.SELECT,onMenuCopyKey);
			var del:NativeMenuItem = new NativeMenuItem("删除对象");  
			del.addEventListener(Event.SELECT,onMenuDelKey);
			var rename:NativeMenuItem = new NativeMenuItem("重命名");  
			rename.addEventListener(Event.SELECT,onRenameKey);
			_menuFile.items = [copy,del];  
			_menuFile.display(stage,stage.mouseX,stage.mouseY);
		}
		/**
		 * 删除粒子条目
		 * */
		private function onMenuDelKey(event:Event):void{
			
			if(selectContainer.length>0)
			{
				var len:int=selectContainer.length;
				for(var a:int=0;a<len;a++)
				{
					var _index:int=_dataProvider.getItemIndex(selectContainer[a]);
					if(_index==-1)return;
					if(selectContainer[a] is Display3DLocusPartilce){
						GuijiLevel.Instance().hide();
					}
					_dataProvider.removeItemAt(_index);
					(selectContainer[i] as ParticleItem).destory();
					if(selectContainer[a].parent)
					{
						selectContainer[a].parent.removeChild(selectContainer[a]);
					}
					for(var j:int=0;j<_dataProvider.length;j++)
					{
						_dataProvider[j].y = j * 20;
						_dataProvider[j].timeline.y = 30 + j*20;
					}
					ParticleManagerTool.getInstance().removeTimeLine(selectContainer[a].timeline);
				}
				selectContainer.length=0;
				return;
			}
			
			
			if(currentTarget is Display3DLocusPartilce){//如果是轨迹粒子，隐藏掉轨迹控制线
				GuijiLevel.Instance().hide();
			}
			
			var index:int = _dataProvider.getItemIndex(currentTarget);
			_dataProvider.removeItemAt(index);
			currentTarget.destory();
			if(currentTarget.parent){
				currentTarget.parent.removeChild(currentTarget);
			}
			for(var i:int;i<_dataProvider.length;i++){
				_dataProvider[i].y = i * 20;
				_dataProvider[i].timeline.y = 30 + i*20;
			}
			ParticleManagerTool.getInstance().removeTimeLine(currentTarget.timeline);
			
		
			if(CountPanle.instance){
				CountPanle.instance.refreshInfo();
			}
		}
		
		private function onRenameKey(event:Event):void{
			
		}
		/**
		 * 删除全部
		 * 
		 * */
		public function delAll():void{
			for(var i:int = _dataProvider.length-1;i>=0;i--){
				var item:ParticleItem = _dataProvider[i];
				item.destory();
				if(item.parent){
					item.parent.removeChild(item);
				}
				ParticleManagerTool.getInstance().removeTimeLine(item.timeline);
				_dataProvider.removeItemAt(i);
			}
		}
		/**
		 * 交换粒子条目位置，移动层级
		 * @param target 目标粒子条目
		 * @param updown 标记向上或向下移动
		 * */
		public function exchage(target:ParticleItem,updown:Boolean):void{
			var index:int = _dataProvider.getItemIndex(target);
			if(updown){
				if(index == 0){
					return;
				}
				_dataProvider[index] = _dataProvider[index-1];
				_dataProvider[index-1] = target;
				AppParticleData.particleLevel.exchage(_dataProvider[index].display3D,_dataProvider[index-1].display3D);
			}else{
				if(index == (_dataProvider.length-1)){
					return;
				}
				_dataProvider[index] = _dataProvider[index+1];
				_dataProvider[index+1] = target;
				AppParticleData.particleLevel.exchage(_dataProvider[index].display3D,_dataProvider[index+1].display3D);
			}
			
			for(var i:int;i<_dataProvider.length;i++){
				_dataProvider[i].y = i * 20;
				_dataProvider[i].timeline.y = 30 + i*20;
			}
			
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			ctrlKey=false;
		}
		private var ctrlKey:Boolean=false;
		/**
		 * 键盘控制向上或向下移动
		 * */
		private function onKey(event:KeyboardEvent):void{
			if(event.keyCode == 40){//down
				exchage(currentTarget,false);
			}else if(event.keyCode == 38){//up
				exchage(currentTarget,true);
			}else if(event.keyCode == 113){
				currentTarget.showRename();
			}
			
		}
		private function onCtrls(e:KeyboardEvent):void
		{
			ctrlKey=e.ctrlKey;
		}
		
		private function onMenuCopyKey(event:Event):void{
			
		}
		/**
		 * 鼠标右键显示 粘贴对象
		 * */
		private function onRight(event:Event):void{
			var _menuFile:NativeMenu = new NativeMenu();  
			var paste:NativeMenuItem = new NativeMenuItem("粘贴对象");  
			paste.addEventListener(Event.SELECT,onMenuPasteKey);
			_menuFile.items = [paste];  
			_menuFile.display(stage,stage.mouseX,stage.mouseY);
		}
		/**
		 * 复制并粘贴对象
		 * */
		private function onMenuPasteKey(event:Event):void{
			if(selectContainer.length>0)
			{
				var len:int=selectContainer.length;
				for(var i:int=0;i<len;i++)
				{
					var objc:Object=selectContainer[i].timeline.getAllInfo();
					objc=depthCopy(objc);
					ControlCenterView.getInstance().addParticleByObj(objc);
				}
				selectContainer.length=0;
				return;
			}
			var obj:Object = currentTarget.timeline.getAllInfo();
			obj = depthCopy(obj);
			//ControlCenterView(this.parent).addParticleByObj(obj);
			ControlCenterView.getInstance().addParticleByObj(obj);
		}
		/**
		 * 对象的深度拷贝
		 * @param source 源对象
		 * @return Object 新对象
		 * */
		private function depthCopy(source:Object):Object{
			var byte:ByteArray = new ByteArray();
			byte.writeObject(source);
			byte.position = 0;
			return byte.readObject();
		}
		/**
		 * 返回当前的所有粒子信息数据
		 * 
		 * @return Array 粒子信息数组
		 * */
		public function getAllInfo():Array{
			var ary:Array = new Array;
			for(var i:int;i<_dataProvider.length;i++){
				ary.push(ParticleItem(_dataProvider[i]).timeline.getAllInfo());
			}
			return ary;
		}
		

	}
}