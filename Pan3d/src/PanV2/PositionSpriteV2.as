package  PanV2
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Object3D;
	
	import _me.Scene_data;
	
	public class PositionSpriteV2 extends Sprite
	{
		private var _pointItem:Array=new Array();
		private var _lineSprite:Sprite;
		private var _lineColor:uint=0xff0000
		private var _xTest:TextField
		private var _yTest:TextField
		private var _zTest:TextField
		

		public function PositionSpriteV2():void
		{
	
			//addBack();
			addLine();
			addTexts();
			addPoints(0,0,0);
			addPoints(100,0,0);
			addPoints(0,100,0);
			addPoints(0,0,-100);
			this.mouseChildren=false;
			this.mouseEnabled=false;

			this.addEventListener(Event.ENTER_FRAME,onEnterFarme)
		}
		
		private function addTexts():void
		{
			_zTest=new TextField;
			addChild(_zTest);
			_zTest.htmlText="<font color='#ffffff' face='宋体'>z</font>";
			_zTest.filters = [new GlowFilter(0x000000, 1, 2, 2, 17, 1, false, false)];
			
			_xTest=new TextField;
			addChild(_xTest);
			_xTest.htmlText="<font color='#ffffff' face='宋体'>x</font>";
			_xTest.filters = [new GlowFilter(0x000000, 1, 2, 2, 17, 1, false, false)];
			
			_yTest=new TextField;
			addChild(_yTest);
			_yTest.htmlText="<font color='#ffffff' face='宋体'>y</font>";
			_yTest.filters = [new GlowFilter(0x000000, 1, 2, 2, 17, 1, false, false)];
			

		}
		
		private function addLine():void
		{
			_lineSprite=new Sprite;
			this.addChild(_lineSprite);
			_lineSprite.x=100;
			_lineSprite.y=100;
		}
		
		private function onEnterFarme(event:Event):void
		{
			if(!Scene_data.cam3D){
				throw new Error("还没有镜头，PositionSprite")
			}
			
			var cam3D:Camera3D=Scene_data.cam3D;
		  
			sin_x=Math.sin(cam3D.rotationX*Math.PI/180)
			cos_x=Math.cos(cam3D.rotationX*Math.PI/180)
				
			sin_y=Math.sin(cam3D.rotationY*Math.PI/180)
			cos_y=Math.cos(cam3D.rotationY*Math.PI/180)
				
			for(var i:uint=0;i<_pointItem.length;i++)
			{
				var object3D:Object3D= _pointItem[i]
				math_change_point(object3D);
			}
			_lineSprite.graphics.clear();
			
			//return;
			drawLine(_pointItem[0],_pointItem[1],0xff0000)
		
			drawLine(_pointItem[0],_pointItem[3],0x0000ff)
			drawLine(_pointItem[0],_pointItem[2],0x00ff00)
			
			
			_xTest.x=_pointItem[1].rotationX+100-5
			_xTest.y=-_pointItem[1].rotationY+100-10
				
			_yTest.x=_pointItem[2].rotationX+100-5
			_yTest.y=-_pointItem[2].rotationY+100-10
				
			_zTest.x=_pointItem[3].rotationX+100-5
			_zTest.y=-_pointItem[3].rotationY+100-10

		}
		private function drawLine(a:Object3D,b:Object3D,_color:uint=0xff0000):void
		{
			_lineColor=_color;
			_lineSprite.graphics.lineStyle(2,_lineColor);
			_lineSprite.graphics.moveTo(a.rotationX,-a.rotationY);
			_lineSprite.graphics.lineTo(b.rotationX,-b.rotationY);
			
			
			
		}
		
		
		private var sin_x:Number
		private var cos_x:Number
		private var sin_y:Number
		private var cos_y:Number

		private  function math_change_point(_3dpoint : Object3D) : void {
			//对坐标系里的原始点，跟据镜头角度算出新的从坐标
			var rx : Number = _3dpoint.x 
			var ry : Number = _3dpoint.y
			var rz : Number = _3dpoint.z 
			
			//	var tmp_rx = this.rx;
			//	this.rx = int(Math.cos(tmp_angle)*tmp_rx-Math.sin(tmp_angle)*this.rz);
			//	this.rz = int(Math.sin(tmp_angle)*tmp_rx+Math.cos(tmp_angle)*this.rz);
			
			var tmp_rx : Number = rx;
			rx = cos_y * tmp_rx - sin_y * rz;
			rz = sin_y * tmp_rx + cos_y * rz;
			
			var tmp_rz : Number = rz;
			rz = cos_x * tmp_rz - sin_x * ry;
			ry = sin_x * tmp_rz + cos_x * ry;
			
			_3dpoint.rx = int(rx);
			_3dpoint.ry = int(ry);
			_3dpoint.rz = int(rz);
			
			var br:Number=1024;
			var scal:Number = br/(br+rz); 
			
			_3dpoint.rotationX=rx*scal
			_3dpoint.rotationY=ry*scal

			
		}
		
		private function addPoints(_x:Number,_y:Number,_z:Number):void
		{
		    var object3D:Object3D=new Object3D(_x,_y,_z);	 
			_pointItem.push(object3D);
		}
		private function addBack():void
		{
			var tempBox:Sprite=new Sprite;
			this.addChild(tempBox);
			tempBox.graphics.beginFill(0xffffff,1)
			tempBox.graphics.drawRect(0,0,200,200)
			tempBox.graphics.endFill();
		}
	}
}