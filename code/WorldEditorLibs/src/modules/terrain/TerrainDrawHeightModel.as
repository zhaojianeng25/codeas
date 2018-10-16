package modules.terrain
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundMath;


	public class TerrainDrawHeightModel
	{
		private static var instance:TerrainDrawHeightModel;
		
		public static var TAI_QI:uint=0;
		public static var XIA_XIAN:uint=1;
		public static var PING_HUA:uint=2;
		public static var ZHENG_PING:uint=3;
		public static var XIE_PO:uint=4;
		
		
		private static var _shap:Shape = new Shape();//画刷
		private static var _liuShape:Shape = new Shape();//画刷
		
		public static var brushSize:int = 10;//笔刷大小
		public static var brushPow:Number = 0.2;//笔刷力度
		public static var brushBluer:Number = 0.5;//笔刷力度
		
		private var _isCanDraw:Boolean=false
			
			
		public static var drawType:uint=0
		public function TerrainDrawHeightModel()
		{
			
		}
		public static function getInstance():TerrainDrawHeightModel
		{
			
			if(!instance){
				instance=new TerrainDrawHeightModel()
			}
			return instance;
		}
		public function mouseDown($pos:Vector3D):void
		{
			if(mouseInStage3D){
				_isCanDraw=true
				_fristPos=$pos;
				_isDrawPass=false
	
			}
		}
		private var _isDrawPass:Boolean=false
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		private var _fristPos:Vector3D;
		public function mouseMove($pos:Vector3D,shiftKey:Boolean):void
		{
			_isDrawPass=true
			if($pos&&_isCanDraw){
				if(!Boolean(_fristPos)){
					_fristPos=$pos
				}
				if(drawType==TerrainDrawHeightModel.TAI_QI||drawType==TerrainDrawHeightModel.XIA_XIAN||drawType==TerrainDrawHeightModel.PING_HUA||drawType==TerrainDrawHeightModel.ZHENG_PING){
					drawUpHight($pos,shiftKey)
				}
			}
			
		}
		private function changePinghuaHightBitMap2($tempBmp:BitmapData, $rect:Rectangle):void
		{
			
			var $bigHeightBmp:BitmapData=TerrainEditorData.bigHeightBmp
			var $allh:Number=0
		    var $allId:Number=0
			var i:uint,j:uint;
			var p:Point
			var h:Number
			for( i=0;i<$rect.width;i++)
			{
				for( j=0;j<$rect.height;j++)
				{
				
					p=new Point($rect.x+i,$rect.y+j);
					h=MathCore.hexToArgb($tempBmp.getPixel(p.x, p.y),false).x/250
					h=Math.min(1,Math.max(h,0))	
                    if(h>0.5){
						$allId=$allId+1
						$allh=$allh+GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,p.x,p.y)
					}
				}
			}
			for( i=0;i<$rect.width;i++)
			{
				for( j=0;j<$rect.height;j++)
				{
					p=new Point($rect.x+i,$rect.y+j);
					h=MathCore.hexToArgb(lingshiBitmap.getPixel(p.x, p.y),false).x/250
					h=Math.min(1,Math.max(h,0))	
					if(h>0){
						var $baseH:Number=GroundMath.getInstance().getBitmapDataHight(TerrainEditorData.bigHeightBmp,p.x,p.y)
						var $roundH:Number=getRoundH(p.x,p.y)
			
						var $toH:Number=$baseH+($roundH-$baseH)*h*0.5
						if($allId>0){
							$toH=$toH+(($allh/$allId)-$toH)*h*0.2
						}
						GroundMath.getInstance().setBitmapDataHight(TerrainEditorData.bigHeightBmp,p.x,p.y,$toH)
				
					}
					
					
				}
			}
			
			function getRoundH(tx:int,ty:int):Number
			{
				
				var a:Number=getBmpHight(tx+1,ty+0)
				var b:Number=getBmpHight(tx-0,ty+0)
				var c:Number=getBmpHight(tx+0,ty+1)
				var d:Number=getBmpHight(tx+0,ty-1)
				
				var e:Number=getBmpHight(tx+1,ty+1)
				var f:Number=getBmpHight(tx-1,ty+1)
				var g:Number=getBmpHight(tx-1,ty-1)
				var h:Number=getBmpHight(tx+1,ty-1)
					
				var o:Number=getBmpHight(tx+0,ty+0)
				
				return (a+b+c+d+e+f+g+h+o)/9;
			}
			function getBmpHight(ax:int,ay:int):Number
			{
				if(ax<0){
					ax=0
				}
				if(ay<0){
					ay=0
				}
				if(ax>($bigHeightBmp.width-1)){
					ax=$bigHeightBmp.width-1
				}
				if(ay>($bigHeightBmp.height-1)){
					ay=$bigHeightBmp.height-1
				}
				return GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,ax,ay)
			}
	
		}
		public function draw():void{
			_liuShape.graphics.clear();
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF0000, 0xff0000];
			var alphas:Array = [1, 0];
			var ratios:Array = [TerrainDrawHeightModel.brushBluer * 255, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(300* TerrainDrawHeightModel.brushSize/20, 300* TerrainDrawHeightModel.brushSize/20, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			_liuShape.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod,InterpolationMethod.LINEAR_RGB,0);  
			_liuShape.graphics.drawRect(0,0,300 * TerrainDrawHeightModel.brushSize/20,300*TerrainDrawHeightModel.brushSize/20);
			
			_liuShape.graphics.endFill();
		}
		private function drawUpHight($pos:Vector3D,shiftKey:Boolean):void
		{
			

			
			var Area_Size:uint=GroundMath.getInstance().Area_Size;
			var Area_Cell_Num:uint=GroundMath.getInstance().Area_Cell_Num;
			var $tempScale:Number=Area_Size/Area_Cell_Num


			
			var p1:Point=new Point($pos.x/$tempScale,$pos.z/$tempScale)

			
			_shap.graphics.clear();
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF0000, 0xff0000];
			var alphas:Array = [TerrainDrawHeightModel.brushPow, 0];
			var ratios:Array = [(1-TerrainDrawHeightModel.brushBluer )* 255, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox( TerrainDrawHeightModel.brushSize,  TerrainDrawHeightModel.brushSize, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			_shap.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod,InterpolationMethod.LINEAR_RGB,0);  
			_shap.graphics.drawRect(0,0, TerrainDrawHeightModel.brushSize,TerrainDrawHeightModel.brushSize);
			_shap.graphics.endFill();

			
			var $bigHeightBmp:BitmapData=TerrainEditorData.bigHeightBmp
			lingshiBitmap=new BitmapData($bigHeightBmp.width,$bigHeightBmp.height,false,0x000000);
			var $m:Matrix=new Matrix;
			$m.tx=p1.x-TerrainDrawHeightModel.brushSize/2
			$m.ty=p1.y-TerrainDrawHeightModel.brushSize/2
			lingshiBitmap.draw(_shap,$m)
				

			var $rect:Rectangle = lingshiBitmap.getColorBoundsRect(0xffffff, 0x000000, false);
			
			if(drawType==TerrainDrawHeightModel.TAI_QI||drawType==TerrainDrawHeightModel.XIA_XIAN){
				changeHightBitMap(lingshiBitmap,$rect,shiftKey)
			}
			if(drawType==TerrainDrawHeightModel.PING_HUA)
			{
				changePinghuaHightBitMap2(lingshiBitmap,$rect)
			}
			if(drawType==TerrainDrawHeightModel.ZHENG_PING)
			{
				changeZhengPingHightBitMap(lingshiBitmap,$rect)
			}
			GroundManager.getInstance().refreshHightMap($rect)
			

		}
		private static var lingshiBitmap:BitmapData
		private function changeZhengPingHightBitMap($tempBmp:BitmapData,$rect:Rectangle):void
		{	
			var Area_Size:uint=GroundMath.getInstance().Area_Size;
			var Area_Cell_Num:uint=GroundMath.getInstance().Area_Cell_Num;
			var $tempScale:Number=Area_Size/Area_Cell_Num
			var $p:Point=new Point(_fristPos.x/$tempScale,_fristPos.z/$tempScale)
			var $bigHeightBmp:BitmapData=TerrainEditorData.bigHeightBmp
			var baseh:Number=GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,$p.x,$p.y)
			for(var i:uint=0;i<$rect.width;i++)
			{
				for(var j:uint=0;j<$rect.height;j++)
				{
					var p:Point=new Point($rect.x+i,$rect.y+j);
					GroundMath.getInstance().setBitmapDataHight($bigHeightBmp,p.x,p.y,baseh)
				}
			}
		}
		private function changeHightBitMap($tempBmp:BitmapData,$rect:Rectangle,shiftKey:Boolean):void
		{

			var $bigHeightBmp:BitmapData=TerrainEditorData.bigHeightBmp
			for(var i:uint=0;i<$rect.width;i++)
			{
				for(var j:uint=0;j<$rect.height;j++)
				{
					var p:Point=new Point($rect.x+i,$rect.y+j);
					var h:Number=MathCore.hexToArgb($tempBmp.getPixel(p.x, p.y),false).x/25    //这个25将会和以后的地地形场景比例有关系 
					if(h>0)
					{
						var baseh:Number=GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,p.x,p.y)
						if(drawType==TerrainDrawHeightModel.TAI_QI){
							h=h*+1
						}
						if(drawType==TerrainDrawHeightModel.XIA_XIAN){
							h=h*-1
						}
						h=h*(shiftKey?-1:1);
						var toH:Number=baseh+h
						GroundMath.getInstance().setBitmapDataHight($bigHeightBmp,p.x,p.y,toH)
						
					}

				}
			}

		}

		public function mouseUp($pos:Vector3D,shiftKey:Boolean):void
		{
			if(!_isDrawPass){
				mouseMove($pos,shiftKey);
			}
			if(drawType==TerrainDrawHeightModel.XIE_PO){
				drawXiePo($pos);
			}
			_isCanDraw=false
			_fristPos=null
			_isDrawPass=false
		}
		
		private function drawXiePo($pos:Vector3D):void
		{
			if(!Boolean(_fristPos)||!Boolean($pos)){
				return;
			}
			if(_fristPos.x==$pos.x&&_fristPos.z==$pos.z){
				return ;
			}
			
			
			var Area_Size:uint=GroundMath.getInstance().Area_Size;
			var Area_Cell_Num:uint=GroundMath.getInstance().Area_Cell_Num;
			var $tempScale:Number=Area_Size/Area_Cell_Num
			
			_shap.graphics.clear();
			_shap.graphics.lineStyle(brushSize , 0xff0000, brushPow);
			var p0:Point=new Point(_fristPos.x/$tempScale,_fristPos.z/$tempScale)
			_shap.graphics.moveTo(_fristPos.x/$tempScale,_fristPos.z/$tempScale);
			
			var p1:Point=new Point($pos.x/$tempScale,$pos.z/$tempScale)
			_shap.graphics.lineTo(p1.x, p1.y);
			
			
			var $bigHeightBmp:BitmapData=TerrainEditorData.bigHeightBmp
			lingshiBitmap=new BitmapData($bigHeightBmp.width,$bigHeightBmp.height,false,0x000000);
			lingshiBitmap.draw(_shap)
				
				
			var fristH:Number=GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,p0.x,p0.y)
			var endH:Number=GroundMath.getInstance().getBitmapDataHight($bigHeightBmp,p1.x,p1.y)
			
			var $rect:Rectangle = lingshiBitmap.getColorBoundsRect(0xffffff, 0x000000, false);
			
			var $m:Matrix3D=new Matrix3D;
			$m.pointAt(new Vector3D(p1.x-p0.x,0,p1.y-p0.y),Vector3D.X_AXIS, Vector3D.Y_AXIS);
			$m.invert();
			
			var $fristV:Vector3D=$m.transformVector(new Vector3D(p0.x,0,p0.y))	
			var $endV:Vector3D=$m.transformVector(new Vector3D(p1.x,0,p1.y))	

			for(var i:uint=0;i<$rect.width;i++)
			{
				for(var j:uint=0;j<$rect.height;j++)
				{
					var p:Point=new Point($rect.x+i,$rect.y+j);
					var h:Number=MathCore.hexToArgb(lingshiBitmap.getPixel(p.x, p.y),false).x/10
					if(h>1){
						var $kp:Vector3D=$m.transformVector(new Vector3D(p.x,0,p.y));
						var $h:Number=($kp.x-$fristV.x)/($endV.x-$fristV.x)
						$h=Math.min(1,Math.max($h,0))
						GroundMath.getInstance().setBitmapDataHight($bigHeightBmp,p.x,p.y,fristH+$h*(endH-fristH))
					}
					
				}
			}
			
			GroundManager.getInstance().refreshHightMap($rect)
			
		}
	}
}