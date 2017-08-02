package common.utils.ui.curves
{
	import flash.display.Bitmap;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.Window;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.check.CheckLabelBox;
	import common.utils.ui.prefab.PicBut;
	
	import curves.Curve;
	import curves.CurveItem;
	import curves.CurveType;
	
	public class CurvesUI extends BaseComponent
	{
		private var _container:UIComponent = new UIComponent;
		private var _bg:Sprite = new Sprite;
		private var _bgSizeLine:Sprite=new Sprite
		private var _frontSp:Sprite = new Sprite;
		private var _headSp:Sprite = new Sprite;
		public var curvesCtrl:CurvesCtrl;
		
		private var _itemList:Vector.<CurvesItemUI>;
		
		private var win:Window; 
		
		private var _callFun:Function;
		
		private var _type:int;

		
		private var _curve:Curve;
		
		private var playhead:Shape;
		
		private static var _instance:CurvesUI;
		private var baseW:int = 8;
		
		private var _visibleVec:Vector.<Boolean> = Vector.<Boolean>([true,true,true,true]);;
		
		public function CurvesUI()
		{
			super();
			this.width = 800;;
			this.height = 300;
			_type = 3;
			
			initView();
			initPlayHead();
			initCheck();
			initCtrl();
			addEvents();
			
			this.horizontalScrollPolicy = "auto";
		}
		
		private function addEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_WHEEL,onCurvesUiMouseWheel)
			_bg.addEventListener(MouseEvent.CLICK,onAddClick);
			
		}		
	
		protected function onCurvesUiMouseWheel(event:MouseEvent):void
		{
			var addNum:Number=event.delta
			setMaxLineHeight(CurvesItemUI.maxLineHeight+CurvesItemUI.maxLineHeight*(0.1*(Math.abs(addNum)/addNum)))
			drawChangeLine()
			
		}

		private function drawChangeLine():void
		{
			_bgSizeLine.graphics.clear()
			_bgSizeLine.graphics.lineStyle(1,0x666666,0.4);

			var $textNum:Number=80/CurvesItemUI.maxLineHeight
				
			if(_curve&&_curve.sideType){
				CurvesItemUI.minLineHeight=-80
				//_lineText0.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" +"-"+num2Str($textNum) + "</font>";
				//_lineText4.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" +"+"+num2Str($textNum)  + "</font>";
				_lineText0.htmlText = getNumToText(-$textNum)
				_lineText1.htmlText = getNumToText(-$textNum/2)
				_lineText2.htmlText = getNumToText(0)
				_lineText3.htmlText = getNumToText(+$textNum/2)
				_lineText4.htmlText = getNumToText(+$textNum)
			}else{
				CurvesItemUI.minLineHeight=0
				//_lineText0.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" +"0" + "</font>";
				//_lineText4.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" +"+"+num2Str($textNum*2)  + "</font>";
				_lineText0.htmlText =  getNumToText(0)
				_lineText1.htmlText =  getNumToText($textNum*2/4*1)
				_lineText2.htmlText =  getNumToText($textNum*2/4*2)
				_lineText3.htmlText =  getNumToText($textNum*2/4*3)
				_lineText4.htmlText =  getNumToText($textNum*2/4*4)
			}
			for(var i:uint=0;_itemList&&i<_itemList.length;i++){
				_itemList[i].pushPosInKey()
				_itemList[i].reDraw();
			}
		}
		private function getNumToText($num:Number):String
		{
			var kkk:String
			if($num>0){
				kkk="+"
			}else if($num<0){
				kkk="-"
			}else{
				kkk="0"
			}
			
			var $str:String= "<font size='10' face='Microsoft Yahei' color='#666666'>"+kkk+num2Str(Math.abs($num)) + "</font>";
			return $str
		}
		
		private function initPlayHead():void{
			_container.addChild(_headSp);
			_headSp.x = 40;
			_headSp.y = 10;
			
			playhead = new Shape();
			playhead.graphics.lineStyle(1,0xCC0000);
			playhead.graphics.beginFill(0xCC0000,0.5);
			playhead.graphics.drawRect(0,0,baseW,20);
			playhead.graphics.endFill();
			playhead.graphics.lineStyle(1,0xCC0000);
			playhead.graphics.moveTo(baseW/2,20);
			playhead.graphics.lineTo(baseW/2,210);
			_headSp.addChild(playhead);
		}
		
		private function initCheck():void{
			var addY:Number=50
			var checkR:CurvesCheckRGB = new CurvesCheckRGB;
			checkR.x = 5;
			checkR.y = 20+addY;
			checkR.color = 0xff0000;
			checkR.type = 0;
			checkR.addEventListener(Event.CHANGE,onCheckChg);
			_container.addChild(checkR);
			
			var checkG:CurvesCheckRGB = new CurvesCheckRGB;
			checkG.x = 5;
			checkG.y = 30+addY;
			checkG.color = 0x00ff00;
			checkG.type = 1;
			checkG.addEventListener(Event.CHANGE,onCheckChg);
			_container.addChild(checkG);
			
			var checkB:CurvesCheckRGB = new CurvesCheckRGB;
			checkB.x = 5;
			checkB.y = 40+addY;
			checkB.color = 0x0000ff;
			checkB.type = 2;
			checkB.addEventListener(Event.CHANGE,onCheckChg);
			_container.addChild(checkB);
			
			var checkA:CurvesCheckRGB = new CurvesCheckRGB;
			checkA.x = 5;
			checkA.y = 50+addY;
			checkA.color = 0x999999;
			checkA.type = 3;
			checkA.addEventListener(Event.CHANGE,onCheckChg);
			_container.addChild(checkA);
		}
		[Embed(source="assets/icon/icon_CurveEditor_Break_20.png")]
		private var breakCls:Class;
		[Embed(source="assets/icon/icon_CurveEditor_hebin_20.png")]
		private var combineCls:Class;
		[Embed(source="assets/icon/icon_CurveEditor_hen_20.png")]
		private var lineCls:Class;
		[Embed(source="assets/icon/icon_CurveEditor_soomsh_20.png")]
		private var curvesCls:Class;
		private var _speedTypeBox:CheckLabelBox;
		private var _sideTypeBox:CheckLabelBox
		private var _lineText0:TextField;
		private var _lineText1:TextField;
		private var _lineText2:TextField;
		private var _lineText3:TextField;
		private var _lineText4:TextField;
		private var _useColorTypeBox:CheckLabelBox;
		private function initCtrl():void{
			curvesCtrl = new CurvesCtrl;
			_container.addChild(curvesCtrl);
			curvesCtrl.x = 0;
			curvesCtrl.y = 20;
			curvesCtrl.visible = false;
			
			var breakCtrlBtn:PicBut = new PicBut;
			breakCtrlBtn.setBitmapdata(Bitmap(new breakCls()).bitmapData);
			breakCtrlBtn.x = 40;
			breakCtrlBtn.y = 230;
			_container.addChild(breakCtrlBtn);
			breakCtrlBtn.addEventListener(MouseEvent.CLICK,onBreakCtrlA);
			
			var combineCtrlBtn:PicBut = new PicBut;
			combineCtrlBtn.setBitmapdata(Bitmap(new combineCls()).bitmapData);
			combineCtrlBtn.x = 70;
			combineCtrlBtn.y = 230;
			_container.addChild(combineCtrlBtn);
			combineCtrlBtn.addEventListener(MouseEvent.CLICK,onBreakCtrlB);
			
			var lineCtrlBtn:PicBut = new PicBut;
			lineCtrlBtn.setBitmapdata(Bitmap(new lineCls()).bitmapData);
			lineCtrlBtn.x = 100;
			lineCtrlBtn.y = 230;
			_container.addChild(lineCtrlBtn);
			lineCtrlBtn.addEventListener(MouseEvent.CLICK,onBreakCtrlC);
			
			var curvesCtrlBtn:PicBut = new PicBut;
			curvesCtrlBtn.setBitmapdata(Bitmap(new curvesCls()).bitmapData);
			curvesCtrlBtn.x = 130;
			curvesCtrlBtn.y = 230;
			//_container.addChild(curvesCtrlBtn);
			curvesCtrlBtn.addEventListener(MouseEvent.CLICK,onBreakCtrlD);
			
			addSort()
			addSiderBox()
			addUseColorBox()
		}
		
		private function addUseColorBox():void
		{
			_useColorTypeBox = new CheckLabelBox;
			_useColorTypeBox.label = "UseColor"
			_useColorTypeBox.width = 100
			_useColorTypeBox.height = 18;
			_useColorTypeBox.x=400
			_useColorTypeBox.y=230
			
			_useColorTypeBox.changFun = setUseColorType
			_useColorTypeBox.getFun = getUseColorType
			_container.addChild(_useColorTypeBox)
				
		}
		public function  getUseColorType():Boolean
		{
			if(_curve){
				return  _curve.useColorType;
			}else{
				return  false
			}
			
		}
		public function  setUseColorType(value:Boolean):void
		{
			if(_curve){
				_curve.useColorType=value
				CurvesItemUI.useColorType=_curve.useColorType
			}
			
		}
		
		private function addSiderBox():void
		{
			// TODO Auto Generated method stub
			_sideTypeBox = new CheckLabelBox;
			_sideTypeBox.label = "SideBox"
			_sideTypeBox.width = 100
			_sideTypeBox.height = 18;
			_sideTypeBox.x=180
			_sideTypeBox.y=230
			
			_sideTypeBox.changFun = getSideType
			_sideTypeBox.getFun = setSideType
			_container.addChild(_sideTypeBox)
			
			
		}

		public function  setSideType():Boolean
		{
			if(_curve){
				return  _curve.sideType;
			}else{
				return  false
			}
			
		}
		public function  getSideType(value:Boolean):void
		{
			if(_curve){
				_curve.sideType=value
				drawChangeLine()
			}
			
		}
		
		
		private function addSort():void
		{
			 _speedTypeBox = new CheckLabelBox;
			 _speedTypeBox.label = "SpeedType"
			 _speedTypeBox.width = 100
			 _speedTypeBox.height = 18;
			 _speedTypeBox.x=300
			 _speedTypeBox.y=230
			 
			 _speedTypeBox.changFun = getSpeedType
			 _speedTypeBox.getFun = setSpeedType
			 _container.addChild(_speedTypeBox)
		}

		public function  setSpeedType():Boolean
		{
			if(_curve){
				return  _curve.speedType;
			}else{
				return  false
			}
		
		}
		public function  getSpeedType(value:Boolean):void
		{
			if(_curve){
				_curve.speedType = value;
				
				if(value){
					setScaleNum(0.001);
				}else{
					setScaleNum(1);
				}
				//trace("_curve.speedType" ,_curve.speedType )
			}
			
		}
		
		public function setScaleNum(num:Number):void{
			for(var i:int = 0;i<_itemList.length;i++){
				_itemList[i].setScaleNum(num);
				_itemList[i].reDraw();
			}
			onItemChange();
		}

		
		protected function onBreakCtrlA(event:MouseEvent):void
		{
			curvesCtrl.setCurvesType(CurveType.A)
			
		}
		protected function onBreakCtrlB(event:MouseEvent):void
		{
			curvesCtrl.setCurvesType(CurveType.B)
			
		}
		protected function onBreakCtrlC(event:MouseEvent):void
		{
			curvesCtrl.setCurvesType(CurveType.C)
			
		}
		protected function onBreakCtrlD(event:MouseEvent):void
		{
		
			
		}
		
		protected function onCheckChg(event:Event):void
		{
			var checkBtn:CurvesCheckRGB = event.target as CurvesCheckRGB;
			
			_visibleVec[checkBtn.type] = checkBtn.check;
			
			setItemVisible();
		}
		
		public function setItemVisible():void{
			for(var i:int = 0;i<_itemList.length;i++){
				_itemList[i].showItemVisible(_visibleVec);
			}
		}
		
		private function initView():void{
			this.addChild(_container);
			_container.addChild(_bg);
			_container.addChild(_bgSizeLine);
		
			_container.width = 2000;
			
			_container.addChild(_frontSp);
			_frontSp.x = 40;
			_frontSp.y = 200;
			
			drawBg();
			
			_curve = new Curve;
			_curve.type = _type;
			
			
			
			_lineText0 =getTextFileld(190)
			_lineText1 =getTextFileld(150)
			_lineText2 =getTextFileld(110)
			_lineText3 =getTextFileld(70)
			_lineText4 =getTextFileld(30)

				

				
	
		}
		private function getTextFileld($y:Number):TextField
		{
			var $temp:TextField = new TextField();
			$temp.autoSize = TextFieldAutoSize.RIGHT;

			$temp.width = 40;
			$temp.height = 20;
			$temp.x = 38
			$temp.y = $y
			$temp.selectable = false;
			$temp.mouseEnabled = false;
			_container.addChild($temp)
			return 	$temp
			
		}
		
		public function getXpos():Point{
			return _frontSp.localToGlobal(new Point);
		}
		
		protected function onAddClick(event:MouseEvent):void
		{
			curvesCtrl.visible = false;
			
			if(!event.ctrlKey){
				return;
			}
			var p:Point = getStandardPos(new Point(_bg.mouseX,_bg.mouseY));
			if(!p){
				return;
			}
			
			var frame:int = getFrame(p.x);
			for(var i:int;i<_itemList.length;i++){
				if(_itemList[i].frame == frame){
					return;
				}
			}
			var ynum:Number=-p.y
			var numValue:Number =  (ynum+CurvesItemUI.minLineHeight)/160*(80/CurvesItemUI.maxLineHeight)*2
			
			var itemui:CurvesItemUI = new CurvesItemUI;
			_itemList.push(itemui);
			_frontSp.addChild(itemui);
			itemui.type = _type;
			itemui.x = p.x;
			itemui.y = 0;
			itemui.frame = frame;
			itemui.curveType=new Vector3D(CurveType.C,CurveType.C,CurveType.C,CurveType.C)
			itemui.curveTypeLeft=new Vector3D(CurveType.C,CurveType.C,CurveType.C,CurveType.C)
				
			itemui.value = new Vector3D(numValue,numValue,numValue,numValue);
			itemui.addEventListener(MouseEvent.CLICK,onItemClick);
			
			resetRelation();
			
			itemui.addEventListener(Event.CHANGE,onItemChange);
			onItemChange()
			setItemVisible();
		}
		
		protected function onItemChange(event:Event = null):void
		{
			_curve.curveList.length = 0;
			for(var i:int;i<_itemList.length;i++){
				_curve.curveList.push(_itemList[i].curvesItem);
			}
			_curve.resetData();
			_callFun();
		}
		
		protected function onItemClick(event:MouseEvent):void
		{
			if(event.altKey){
				var itemui:CurvesItemUI = event.currentTarget as  CurvesItemUI;
				removeItem(itemui);
			}
		}
		
		private function removeItem($itemui:CurvesItemUI):void{
			if($itemui.parent){
				$itemui.parent.removeChild($itemui);
			}
			
			var index:int = _itemList.indexOf($itemui);
			if(index != -1){
				_itemList.splice(index,1);
			}
			$itemui.removeEventListener(MouseEvent.CLICK,onItemClick);
			resetRelation();
		}
		
		public function resetRelation():void{
			_itemList.sort(compare);
			if(!_itemList.length){
				return;
			}
			_itemList[0].parentItem = null;
			if(_itemList.length > 1){
				_itemList[0].nextItem = _itemList[1]
			}else{
				_itemList[0].nextItem = null;
			}
			
			for(var i:int = 1;i<_itemList.length-1;i++){
				_itemList[i].parentItem = _itemList[i-1];
				_itemList[i].nextItem = _itemList[i+1];
			}
			var endIndex:int = _itemList.length-1;
			if(_itemList.length > 1){
				_itemList[endIndex].parentItem =  _itemList[endIndex-1];
			}
			_itemList[endIndex].nextItem = null;
			
		}
		
		private function compare($a:CurvesItemUI,$b:CurvesItemUI):int{
			return $a.frame - $b.frame;
		}
		
		public function getStandardPos($p:Point):Point{
			var posx:int = $p.x % baseW;
			posx = $p.x - posx - 40;
			var posy:int = $p.y - 200;
			
			if($p.x < 40 || $p.y > 200 || $p.y < 40 ){
				return null;
			}
			return new Point(posx,posy);
		}
		
		public function getFrame($ypos:int):int{
			return $ypos/baseW;
		}
		
		public static function getInstance():CurvesUI{
			if(!_instance){
				_instance = new CurvesUI;
			}
			return _instance;
		}
		
		public function show(fun:Function,$curve:Curve):void{
			_callFun = fun;
			removeAllCurve();
			if($curve){
				_curve = $curve;
				this._type = _curve.type;
				CurvesItemUI.useColorType=_curve.useColorType
			}
			_speedTypeBox.refreshViewValue()
			_sideTypeBox.refreshViewValue()
			_useColorTypeBox.refreshViewValue()

			addCurveView();
			getSpeedType(_curve.speedType);
			if(win && !win.closed){
				return;
			}
			win = new Window();
			win.transparent=false;
			win.type=NativeWindowType.UTILITY;
			win.systemChrome=NativeWindowSystemChrome.STANDARD;
			win.height=300;
			win.width=800;
			win.showStatusBar = false;
			win.addElement(this);
			win.alwaysInFront = true;
			win.resizable = true;
			win.setStyle("fontFamily","Microsoft Yahei");
			win.setStyle("fontSize",11); 
			win.open(true);
			win.addEventListener(ResizeEvent.RESIZE,onWinResize)
			
		}
		
		protected function onWinResize(event:ResizeEvent):void
		{
			this.width= Window(  event.target).width
		}
		
		public function removeAllCurve():void{
			while(_frontSp.numChildren){
				_frontSp.removeChildAt(0);
			}
			_itemList = new Vector.<CurvesItemUI>;
		}
		
		
		public function addCurveView():void{
			trace("addCurveView")
			mathInitMaxLineHeight()
			for(var i:int;i<_curve.curveList.length;i++){
				var cureItem:CurveItem = _curve.curveList[i];
				
				var itemui:CurvesItemUI = new CurvesItemUI;
				itemui.setCurveItem(cureItem);
				_frontSp.addChild(itemui);
				itemui.type = _type;
				itemui.x = cureItem.frame * baseW;
				itemui.y = 0;
				itemui.frame = cureItem.frame;
				itemui.rotationVec = cureItem.rotationVec;
				itemui.rotationLeft = cureItem.rotationLeft;
				itemui.curveType = cureItem.curveType;
				itemui.curveTypeLeft = cureItem.curveTypeLeft;
				itemui.value = cureItem.vec3;

				_itemList.push(itemui);
				itemui.addEventListener(Event.CHANGE,onItemChange);
				itemui.addEventListener(MouseEvent.CLICK,onItemClick);
				
			}
			resetRelation();
			drawChangeLine()
		}
		private function mathInitMaxLineHeight():void
		{
			var maxNum:Number
		    var minNum:Number
			for(var i:int=0;i<_curve.curveList.length;i++){
				var cureItem:CurveItem = _curve.curveList[i];
				var vec3:Vector3D=cureItem.vec3
				if(i==0)
				{
					maxNum=Math.max(vec3.x,vec3.y,vec3.z,vec3.w)
					minNum=Math.min(vec3.x,vec3.y,vec3.z,vec3.w)
				}else{
					maxNum=Math.max(maxNum,vec3.x,vec3.y,vec3.z,vec3.w)
					minNum=Math.min(minNum,vec3.x,vec3.y,vec3.z,vec3.w)
				}
			}
			var $scale:Number=Math.max(Math.abs(maxNum),Math.abs(minNum))
			if($scale>0){
				if(_curve&&_curve.sideType){
					$scale=80/$scale
				}else{
					$scale=160/$scale
				}
				
			
			}else{
				$scale=160/1
			}
			setMaxLineHeight($scale)

		}
		private function setMaxLineHeight(value:Number):void
		{
			CurvesItemUI.maxLineHeight=Math.min(value,1600/1)  //最小为2
		}

		
		private function drawBg():void{
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,2000,300);
			_bg.graphics.endFill();
			
			_bg.graphics.lineStyle(1,0x666666);
			
			_bg.graphics.moveTo(40,20);
			_bg.graphics.lineTo(40,200);
			
			_bg.graphics.lineTo(2000,200);
			

			for(var i:int;i<50;i++){
				var txt:TextField = new TextField();
				txt.width = 25;
				txt.height = 20;
				txt.x = 40 * i + 40;
				txt.y = 200;
				txt.selectable = false;
				txt.mouseEnabled = false;
				
				_bg.addChild(txt);
				txt.htmlText = "<font size='10' face='Microsoft Yahei' color='#666666'>" + i * 5 + "</font>";
				_bg.graphics.moveTo(40 * i + 40,200);
				_bg.graphics.lineTo(40 * i + 40,208);
			}

			_bg.graphics.lineStyle(1,0x666666,0.4);

			for(i=0;i<240;i++){
				_bg.graphics.moveTo(baseW * i + 40,40);
				_bg.graphics.lineTo(baseW * i + 40,200);
			}
			for(i=0;i<11;i++){
				_bg.graphics.moveTo(40,200 - i * 16);
				_bg.graphics.lineTo(2000,200 - i * 16);
				if(i%2){
					continue;
				}
			}
			

			
			
		}
		
		private function num2Str(num:Number):String{
			var i:int = int(num);
			var num1:Number = num - i;
			var i1:int = int(num1 * 10);
			return i + "." + i1;
		}
		
		public function showTime($time:int):void{
			playhead.x = $time/(1000/60) * baseW;
		}
		
		
		
		
		
	}
}