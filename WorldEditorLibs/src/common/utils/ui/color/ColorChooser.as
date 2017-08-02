package common.utils.ui.color
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;
	
	import spark.components.Window;
	
	import _Pan3D.core.MathCore;
	
	import common.utils.ui.txt.TextCtrlInput;
	import common.utils.ui.txt.TextLabelInput;
	
	public class ColorChooser extends UIComponent
	{
		private var _bg:Sprite = new Sprite;
		
		private var _colorBgSprite:Sprite;
		private var _colorTopSprite:Sprite;
		
		private var _colorMainSprite:Sprite;
		
		private var _showColorSprite:Sprite;
		
		private var _currentMainPer:Number;
		
		[Embed(source="assets/icon/Zoom_color.png")]
		private var mianImgCls:Class;
		
		[Embed(source="assets/icon/Select_color.png")]
		private var pickImgCls:Class;
		
		[Embed(source="assets/icon/Background_color.png")]
		private var bgImgCls:Class;
		
		private var mianImg:Bitmap;
		private var pickImg:Bitmap;
		private var bgImg:Bitmap;
		
		private var mainColor:Vector3D = new Vector3D(255,0,0);
		private var currentColor:Vector3D;
		
		
		private var maincary:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
		
		private var rTxt:TextCtrlInput;
		private var gTxt:TextCtrlInput;
		private var bTxt:TextCtrlInput;
		private var aTxt:TextCtrlInput;
		
		private var _perX:Number;
		private var _perY:Number;
		
		private var hexTxt:TextLabelInput;
		
		private static var _instance:ColorChooser;
		
		private var win:Window;
		
		private var _callFun:Function;
		
		public function ColorChooser()
		{
			super();
			
			drawBg();
			
			addColor();
			
			addImg();
			
			addTxt();
			
			drawResultColor(0xffffff);
			
		}
		
		public static function getInstance():ColorChooser{
			if(!_instance){
				_instance = new ColorChooser;
			}
			return _instance;
		}
		
		public function show(fun:Function,pos:Point=null,$color:uint = 0xffffffff):void{
			
			_callFun = fun;
			
			initColor($color);
			
			if(win && !win.closed){
				return;
			}
			
			win = new Window();
			win.transparent=false;
			win.type=NativeWindowType.UTILITY;
			win.systemChrome=NativeWindowSystemChrome.STANDARD;
			win.height=200;
			win.width=250;
			win.showStatusBar = false;
			win.addElement(this);
			win.alwaysInFront = true;
			//win.resizable = false;
			win.setStyle("fontFamily","Microsoft Yahei");
			win.setStyle("fontSize",11); 
			
			win.open(true);
		}
		
		private function drawResultColor(rc:Number):void{
			if(!_showColorSprite){
				_showColorSprite = new Sprite;
				_showColorSprite.x = 170;
				_showColorSprite.y = 148;
				this.addChild(_showColorSprite);
			}
			
			_showColorSprite.graphics.clear();
			_showColorSprite.graphics.beginFill(rc,Number(aTxt.text)/100);
			_showColorSprite.graphics.drawRect(0,0,70,40);
			_showColorSprite.graphics.endFill();
			
			var v3d:Vector3D = MathCore.hexToArgb(rc,false);
			var _c:uint = MathCore.argbToHex(Number(aTxt.text)/100 * 255,v3d.x,v3d.y,v3d.z);
			
			if(Boolean(_callFun)){
				_callFun(_c);
			}
		}
		
		private function addTxt():void{
			rTxt = getColorTxt("R:",0,0,255);
			gTxt = getColorTxt("G:",0,20,255);
			bTxt = getColorTxt("B:",0,40,255);
			aTxt = getColorTxt("A:",0,60,255);
			aTxt.maxNum = 100;
			aTxt.text = "100";
			hexTxt = getHexColorTxt("#:",0,80,"FFFFFF");
		}
		
		
		private function addColor():void{
			var bgcary:Array = [0xFFFFFF, 0xFF0000]
			_colorBgSprite = getGradientSprite(150,150,bgcary);
			_colorBgSprite.x = 10;
			_colorBgSprite.y = 40;
			addChild(_colorBgSprite);
			_colorBgSprite.addEventListener(MouseEvent.CLICK,onTopClick);
			_colorBgSprite.addEventListener(MouseEvent.MOUSE_DOWN,onTopDown);
			
			var topcary:Array = [0xFFFFFF, 0x000000]
			_colorTopSprite = getGradientSprite(150,150,topcary);
			_colorTopSprite.mouseEnabled = false;
			_colorTopSprite.mouseChildren = false;
			_colorTopSprite.x = 160;
			_colorTopSprite.y = 40;
			_colorTopSprite.rotation = 90;
			addChild(_colorTopSprite);
			_colorTopSprite.blendMode = BlendMode.MULTIPLY;
			
			
			_colorMainSprite = getGradientSprite(150,15,maincary);
			_colorMainSprite.x = 10;
			_colorMainSprite.y = 18;
			addChild(_colorMainSprite);
			
			_colorMainSprite.addEventListener(MouseEvent.CLICK,onMainClick);
			_colorMainSprite.addEventListener(MouseEvent.MOUSE_DOWN,onMainMouseDown);
		}
		
		protected function onTopDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onTopMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onTopMouseUp);
		}
		
		protected function onTopMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onTopMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTopMouseUp);
		}
		
		protected function onTopMouseMove(event:MouseEvent):void
		{
			var num1:Number = _colorBgSprite.mouseX/150;
			var num2:Number = _colorBgSprite.mouseY/150;
			
			if(num1 < 0){
				num1 = 0;
			}else if(num1 > 1){
				num1 = 1;
			}
			
			if(num2 < 0){
				num2 = 0;
			}else if(num2 > 1){
				num2 = 1;
			}
			
			showColor(num1,num2);
			showColorTxt(num1,num2);
		}
		
		protected function onTopClick(event:MouseEvent):void
		{
			showColor(_colorBgSprite.mouseX/150,_colorBgSprite.mouseY/150);
			showColorTxt(_colorBgSprite.mouseX/150,_colorBgSprite.mouseY/150);
			this.setFocus();
		}
		
		private function showColor($perx:Number,$pery:Number):void{
			pickImg.x = 150 * $perx + 10 - 8;
			pickImg.y = 150 * $pery + 40 - 8;
		}
		
		private function showColorTxt($perx:Number,$pery:Number):void{
			//var color:Vector3D = mainColor.clone();
			_perX = $perx;
			_perY = $pery;
			
			var cx:int = (255 * (1-$perx) + mainColor.x * $perx) * (1-$pery);
			var cy:int = (255 * (1-$perx) + mainColor.y * $perx) * (1-$pery);
			var cz:int = (255 * (1-$perx) + mainColor.z * $perx) * (1-$pery);
			
			rTxt.text = cx.toString();
			gTxt.text = cy.toString();
			bTxt.text = cz.toString();
			hexTxt.text = get16Num(cx) + get16Num(cy) + get16Num(cz);
			
			drawResultColor(MathCore.argbToHex16(cx,cy,cz));
			
		}
		
		private function get16Num(num:int):String{
			var str:String;
			var s:String = num.toString(16);
			if(s.length == 1){
				s = "0" + s;
			}
			s = s.toUpperCase();
			return s;
		}
		
		private function addImg():void{
			mianImg = new mianImgCls();
			mianImg.x = 10 - 7;
			mianImg.y = 6;
			
			pickImg = new pickImgCls();
			pickImg.x = 2;
			pickImg.y = 32;
			
			bgImg = new bgImgCls();
			bgImg.x = 170;
			bgImg.y = 148;
			this.addChild(bgImg);
			
			this.addChild(mianImg);
			this.addChild(pickImg);
		}
		
		protected function onMainMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMainMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMainMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
		}
		
		protected function onMainMouseMove(event:MouseEvent):void
		{
			var num:Number = _colorMainSprite.mouseX/150;
			if(num < 0){
				num = 0;
			}else if(num > 1){
				num = 1;
			}
			
			_currentMainPer = num;
			changePanelColor(_currentMainPer);
			showColorTxt(_perX,_perY);
		}
		
		protected function onMainClick(event:MouseEvent):void
		{
			_currentMainPer = _colorMainSprite.mouseX/150;
			changePanelColor(_currentMainPer);
			showColorTxt(_perX,_perY);
			this.setFocus();
		}
		
		private function changePanelColor($per:Number):void{
			mianImg.x = 3 + 150 * $per;
			
			var per:Number = $per * 6;
			var index:int = int(per);
			per = per - index;
			
			var color1:Vector3D = MathCore.hexToArgb(maincary[index],false);
			var color2:Vector3D = MathCore.hexToArgb(maincary[index+1],false);
			color1.scaleBy(1 - per);
			color2.scaleBy(per);
			color1 = color1.add(color2);
			
			mainColor = color1;
			
			var num:Number = MathCore.argbToHex16(color1.x,color1.y,color1.z);
			drawGradientSprite([0xffffff,num],_colorBgSprite,150,150);
		}
		
		private function drawBg():void{
			this.addChild(_bg);
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x202020,1);
			_bg.graphics.drawRect(0,0,250,200);
			_bg.graphics.endFill();
		}
		
		
		protected function getGradientSprite(w:Number, h:Number, gc:Array):Sprite 
		{
			var gs:Sprite = new Sprite();
			var g:Graphics = gs.graphics;
			var gn:int = gc.length;
			var ga:Array = [];
			var gr:Array = [];
			var gm:Matrix = new Matrix(); gm.createGradientBox(w, h, 0, 0, 0);
			for (var i:int = 0; i < gn; i++) { ga.push(1); gr.push(0x00 + 0xFF / (gn - 1) * i); }
			g.beginGradientFill(GradientType.LINEAR, gc, ga, gr, gm, SpreadMethod.PAD,InterpolationMethod.RGB);
			g.drawRect(0, 0, w, h);
			g.endFill();	
			return(gs);
		}
		
		protected function drawGradientSprite(gc:Array,sp:Sprite,w:Number, h:Number):void 
		{
			var g:Graphics = sp.graphics;
			
			var gn:int = gc.length;
			var ga:Array = [];
			var gr:Array = [];
			var gm:Matrix = new Matrix(); gm.createGradientBox(w, h, 0, 0, 0);
			for (var i:int = 0; i < gn; i++) { ga.push(1); gr.push(0x00 + 0xFF / (gn - 1) * i); }
			g.clear();
			g.beginGradientFill(GradientType.LINEAR, gc, ga, gr, gm, SpreadMethod.PAD,InterpolationMethod.RGB);
			g.drawRect(0, 0,w , h);
			g.endFill();	
			
		}
		
		private function getColorTxt(label:String,xPos:int,yPos:int,str:int):TextCtrlInput{
			var txt:TextCtrlInput = new TextCtrlInput;
			txt.label = label;
			txt.width = 70;
			txt.height = 18;
			txt.text = str.toString();
			txt.x = xPos + 170;
			txt.y = yPos + 40;
			txt.maxNum = 255;
			txt.minNum = 0;
			txt.center = false;
			addChild(txt);
			txt.addEventListener(Event.CHANGE,onInput);
			return txt;
		}
		
		protected function onInput(event:TextEvent=null):void
		{
			hexTxt.text = get16Num(int(rTxt.text)) + get16Num(int(gTxt.text)) + get16Num(int(bTxt.text));
			
			setColorByTxt();

			//this.setFocus();
			
		}
		
		public function initColor($color:int):void{
			
			var showcolor:Vector3D = MathCore.hexToArgb($color,true);
			rTxt.text = showcolor.x.toString();
			gTxt.text = showcolor.y.toString();
			bTxt.text = showcolor.z.toString();
			aTxt.text = String(int(showcolor.w / 255 * 100));
			setColorByTxt();
			
		}
		
		private function setColorByTxt():void{
			var hsb:Vector3D = rgb2hsb(new Vector3D(int(rTxt.text),int(gTxt.text),int(bTxt.text)));
			if(isNaN(hsb.x)){
				hsb.x = 0;
			}
			_currentMainPer = hsb.x/360;
			changePanelColor(_currentMainPer);
			
			_perX = hsb.y;
			_perY = 1 - hsb.z;
			showColor(_perX,_perY);
			
			drawResultColor(MathCore.argbToHex16(int(rTxt.text),int(gTxt.text),int(bTxt.text)));
		}
		
		private function getHexColorTxt(label:String,xPos:int,yPos:int,str:String):TextLabelInput{
			var txt:TextLabelInput = new TextLabelInput;
			txt.label = label;
			txt.width = 70;
			txt.height = 18;
			txt.text = str;
			txt.x = xPos + 170;
			txt.y = yPos + 40;
			addChild(txt);
			txt.addEventListener(Event.CHANGE,onHexInput);
			return txt;
		}
		
		protected function onHexInput(event:Event):void
		{
			var num:int = parseInt(hexTxt.text,16);
			var color:Vector3D = MathCore.hexToArgb(num,false);
			rTxt.text = color.x.toString();
			gTxt.text = color.y.toString();
			bTxt.text = color.z.toString();
			setColorByTxt();
		}
		
		public function rgb2hsb(color:Vector3D):Vector3D{  

			var rgbR:int = color.x; 
			var rgbG:int = color.y; 
			var rgbB:int = color.z;
			
			var rgb:Array = [rgbR, rgbG, rgbB ];  
			rgb.sort(Array.NUMERIC);
			var max:Number = rgb[2];  
			var min:Number = rgb[0];  
			
			var hsbB:Number = max / 255.0;  
			var hsbS:Number = max == 0 ? 0 : (max - min) / max;  
			
			var hsbH:Number = 0;  
			if (max == rgbR && rgbG >= rgbB) {  
				hsbH = (rgbG - rgbB) * 60 / (max - min) + 0;  
			} else if (max == rgbR && rgbG < rgbB) {  
				hsbH = (rgbG - rgbB) * 60 / (max - min) + 360;  
			} else if (max == rgbG) {  
				hsbH = (rgbB - rgbR) * 60 / (max - min) + 120;  
			} else if (max == rgbB) {  
				hsbH = (rgbR - rgbG) * 60 / (max - min) + 240;  
			}
			
			return new Vector3D(hsbH, hsbS, hsbB);  
		}  
		
	}
}