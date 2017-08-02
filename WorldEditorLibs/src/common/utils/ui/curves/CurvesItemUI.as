package common.utils.ui.curves
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import common.GameUIInstance;
	import common.utils.ui.color.ColorChooser;
	
	import curves.CurveItem;
	
	public class CurvesItemUI extends Sprite
	{
		private var _parentItem:CurvesItemUI;
		private var _nextItem:CurvesItemUI;
		private var _type:int;
		
		private var _keyList:Vector.<CurvesKeyUI>;
		
		private var _value:Vector3D;
		
		public var frame:int;
		private var _rotationVec:Vector3D;
		private var _rotationLeft:Vector3D;
		private var _curveType:Vector3D;
		private var _curveTypeLeft:Vector3D;
		private var _currentKey:CurvesKeyUI;
	
		
		public const maxY:int = 200;
		public const minY:int = 40;
		public static var  maxLineHeight:Number = 1
		public static var  minLineHeight:Number = -80
		
		private var baseW:int = 8;
		
		private var _colorPick:Sprite;
		
		public var curvesItem:CurveItem;
		
		public function CurvesItemUI()
		{
			super();
			_value = new Vector3D;
			initKey();
			
			curvesItem = new CurveItem;
			
			
		}
		
		public function get curveType():Vector3D
		{
			return _curveType;
		}

		public function set curveType(value:Vector3D):void
		{
			_curveType = value;
			
			if(_keyList&&_curveType){
				_keyList[0].ctrlCurveType=_curveType.x
				_keyList[1].ctrlCurveType=_curveType.y
				_keyList[2].ctrlCurveType=_curveType.z
				_keyList[3].ctrlCurveType=_curveType.w
			}
		}
		public function set curveTypeLeft(value:Vector3D):void
		{
			_curveTypeLeft = value;
			
			if(_keyList&&_curveType){
				_keyList[0].ctrlCurveTypeLeft=_curveTypeLeft.x
				_keyList[1].ctrlCurveTypeLeft=_curveTypeLeft.y
				_keyList[2].ctrlCurveTypeLeft=_curveTypeLeft.z
				_keyList[3].ctrlCurveTypeLeft=_curveTypeLeft.w
			}
		}

		public function get rotationLeft():Vector3D
		{
			return _rotationLeft;
		}

		public function set rotationLeft(value:Vector3D):void
		{
			_rotationLeft = value;
			if(_keyList&&_rotationLeft){
				_keyList[0].ctrlRotationLeft=_rotationLeft.x
				_keyList[1].ctrlRotationLeft=_rotationLeft.y
				_keyList[2].ctrlRotationLeft=_rotationLeft.z
				_keyList[3].ctrlRotationLeft=_rotationLeft.w
			}
     
			
		}

		public function get rotationVec():Vector3D
		{
			return _rotationVec;
		}

		public function set rotationVec(value:Vector3D):void
		{
			_rotationVec = value;
			
			if(_keyList){
				_keyList[0].ctrlRotation=_rotationVec.x
				_keyList[1].ctrlRotation=_rotationVec.y
				_keyList[2].ctrlRotation=_rotationVec.z
				_keyList[3].ctrlRotation=_rotationVec.w
			}
		}

		public function setCurveItem($curvesItem:CurveItem):void{
			curvesItem = $curvesItem;
		}
		
		private function initKey():void{
			_keyList = new Vector.<CurvesKeyUI>;
			for(var i:int;i<4;i++){
				var key:CurvesKeyUI = new CurvesKeyUI;
				key.id = i;
				key.parentCurveItem = this;
				

					
					
					
				_keyList.push(key);
				this.addChild(key);
				key.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				key.addEventListener(MouseEvent.MIDDLE_CLICK,onKeClick);
			}
			
			_colorPick = new Sprite;
			this.addChild(_colorPick);
			
			_colorPick.addEventListener(MouseEvent.CLICK,onColorClick);
			
			
			this.addEventListener(MouseEvent.RIGHT_CLICK,onColorClick);
			
		}
		
		public function showItemVisible(visibleVec:Vector.<Boolean>):void{
			for(var i:int;i<_keyList.length;i++){
				_keyList[i].visible = visibleVec[i];
			}
		}
		
		protected function onKeClick(event:MouseEvent):void
		{
			var ctrlKey:CurvesKeyUI = event.target as CurvesKeyUI;
			var p:Point = this.localToGlobal(new Point(ctrlKey.x,ctrlKey.y));
			CurvesUI.getInstance().curvesCtrl.show(p,ctrlKey);
		}
		
		public static var useColorType:Boolean
		protected function onColorClick(event:MouseEvent):void
		{
			if(useColorType){
				var point:Point = new Point(100,30);
				point = this.localToGlobal(point);
				point.x += GameUIInstance.application.x;
				point.y += GameUIInstance.application.y;
				ColorChooser.getInstance().show(setColor,point,MathCore.vecToHex(_value));
			}
		
		}
		
		private function setColor($value:uint):void{
			MathCore.hexToArgbNum($value,true,_value);
			_value.w = _value.w/0xff;
			this.value = _value;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(this.mouseX > 10){
				return;
			}
			_currentKey = event.target as CurvesKeyUI;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			var p:Point = new Point(stage.mouseX,stage.mouseY);
			if(p.y > maxY){
				p.y = maxY;
			}
			if(p.y < minY){
				p.y = minY;
			}
			p = this.globalToLocal(p);
			_currentKey.y = p.y;
			setAllX();
			
			if(_currentKey.id == 0){
				_value.x = Math.abs(_currentKey.y / maxLineHeight+minLineHeight);
			}else if(_currentKey.id == 1){
				_value.y = Math.abs(_currentKey.y / maxLineHeight+minLineHeight);
			}else if(_currentKey.id == 2){
				_value.z = Math.abs(_currentKey.y / maxLineHeight+minLineHeight);
			}else if(_currentKey.id == 3){
				_value.w = Math.abs(_currentKey.y / maxLineHeight+minLineHeight);
			}
			
			if(this.parentItem){
				this.parentItem.draw();
			}
			this.draw();
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function setScaleNum(num:Number):void{
			for(var i:int;i<_keyList.length;i++){
				_keyList[i].scaleNum = num;
			}
		}
		
		private function setAllX():void{
			var p:Point = new Point(stage.mouseX,stage.mouseY);
			p = this.parent.globalToLocal(p);
			
			if(p.x < 0){
				return;
			}
			
			p.x = p.x - p.x % baseW;
			
			this.frame = CurvesUI.getInstance().getFrame(p.x);
			this.x = p.x;
			CurvesUI.getInstance().resetRelation();
		}
		
		public function getKey($id:int):CurvesKeyUI{
			return _keyList[$id];
		}
		
		public function reDraw():void{
			if(this.parentItem){
				this.parentItem.draw();
			}
			this.draw();
		}
		

		public function get parentItem():CurvesItemUI
		{
			return _parentItem;
		}

		public function set parentItem(value:CurvesItemUI):void
		{
			if(_parentItem == value){
				return;
			}
			_parentItem = value;
			draw();
		}

		public function get nextItem():CurvesItemUI
		{
			return _nextItem;
		}

		public function set nextItem(value:CurvesItemUI):void
		{
			if(_nextItem == value){
				return;
			}
			_nextItem = value;
			draw();
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
			if(_type == 1){
				removeID(1);
				removeID(2);
				removeID(3);
				_colorPick.visible = false;
			}else if(_type == 2){
				removeID(2);
				removeID(3);
				_colorPick.visible = false;
			}else if(_type == 3){
				removeID(3);
			}
			
			for(var i:int;i<_keyList.length;i++){
				_keyList[i].draw();
			}
			
		}
		
		public function removeID($id:int):void{
			if(_keyList[$id].parent){
				_keyList[$id].parent.removeChild(_keyList[$id]);
			}
			
		}
		
		public function draw():void{
			for(var i:int;i<_keyList.length;i++){
				_keyList[i].draw();
			}
			
			_colorPick.graphics.clear();
			_colorPick.graphics.beginFill(MathCore.vecToHex(_value,false));
			_colorPick.graphics.drawRect(0,0,5,5);
			_colorPick.graphics.endFill();
			
			_value.x = (_keyList[0].y-minLineHeight) / maxLineHeight*-1;
			_value.y = (_keyList[1].y-minLineHeight) / maxLineHeight*-1;
			_value.z = (_keyList[2].y-minLineHeight) / maxLineHeight*-1;
			_value.w = (_keyList[3].y-minLineHeight) / maxLineHeight*-1;
			
			

			
			curvesItem.frame = this.frame;
			curvesItem.vec3 = _value;
			curvesItem.rotationVec=new Vector3D( _keyList[0].ctrlRotation, _keyList[1].ctrlRotation, _keyList[2].ctrlRotation, _keyList[3].ctrlRotation)
			curvesItem.rotationLeft=new Vector3D( _keyList[0].ctrlRotationLeft, _keyList[1].ctrlRotationLeft, _keyList[2].ctrlRotationLeft, _keyList[3].ctrlRotationLeft)
			curvesItem.curveType=new Vector3D( _keyList[0].ctrlCurveType, _keyList[1].ctrlCurveType, _keyList[2].ctrlCurveType, _keyList[3].ctrlCurveType)
			curvesItem.curveTypeLeft=new Vector3D( _keyList[0].ctrlCurveTypeLeft, _keyList[1].ctrlCurveTypeLeft, _keyList[2].ctrlCurveTypeLeft, _keyList[3].ctrlCurveTypeLeft)
			curvesItem.valueVec0 = _keyList[0].valueVec;
			curvesItem.valueVec1 = _keyList[1].valueVec;
			curvesItem.valueVec2 = _keyList[2].valueVec;
			curvesItem.valueVec3 = _keyList[3].valueVec;
			
			//this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():Vector3D
		{
			return _value;
		}

		public function set value($value:Vector3D):void
		{
			_value = $value;
			
			pushPosInKey()
			
			if(this.parentItem){
				this.parentItem.draw();
			}
			this.draw();
			
		}
		public function pushPosInKey():void
		{
			_keyList[0].y = - maxLineHeight * _value.x+minLineHeight
			_keyList[1].y = - maxLineHeight * _value.y+minLineHeight
			_keyList[2].y = - maxLineHeight * _value.z+minLineHeight
			_keyList[3].y = - maxLineHeight * _value.w+minLineHeight
				
				
				
			
		}
		
		
			
		
		
	}
}