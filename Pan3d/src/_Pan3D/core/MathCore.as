package _Pan3D.core
{
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MathCore
	{
		public static function getSourcePro(vSourceXml:XML):Array
		{
			// 将XML转为数组对象
			var tempArray:Array=new Array;
			for (var i:int=0; i < vSourceXml.children().length(); i++)
			{
				var z:Object=new Object;
				for (var j:int=0; j < vSourceXml.child(i).children().length(); j++)
				{
					var vT:String=String(vSourceXml.child(i).child(j).name());
					z[vT]=vSourceXml.child(i).child(j);
				}
				tempArray[i]=z;
			}
			return tempArray;
		}
		public static function argbToHex16( r:uint, g:uint, b:uint):uint
		{
			// 转换颜色
			var color:uint= r << 16 | g << 8 | b;
			return color;
		}
		public static function vecToHex(color:Vector3D, is32:Boolean = true):uint
		{
			return argbToHex(is32?color.w * 0xFF:0, color.x * 0xFF, color.y * 0xFF, color.z * 0xFF);
		}
		public static function hexToArgbNum(expColor:uint,is32:Boolean=true,color:Vector3D = null):Vector3D
		{
			color = hexToArgb(expColor, is32, color);
			color.scaleBy(1/0xFF);
			return color;
		}


		public static function argbToHex(a:uint, r:uint, g:uint, b:uint):uint
		{
			// 转换颜色
			var color:uint=a << 24 | r << 16 | g << 8 | b;
			return color;
		}
		public static function hexToArgb(expColor:uint,is32:Boolean=true,color:Vector3D = null):Vector3D
		{
			if(!color)
			{
				color = new Vector3D();
			}
			color.w =is32? (expColor>>24) & 0xFF:0;
			color.x= (expColor>>16) & 0xFF;
			color.y = (expColor>>8) & 0xFF;
			color.z = (expColor) & 0xFF;
			return color;
		}
		
		public static function hsb2rgb(hsbColor:Vector3D):Vector3D{
			var maincary:Array = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
			
			var per:Number = (1-hsbColor.x/360) * 6;
			var index:int = int(per);
			per = per - index;
			
			var color1:Vector3D = MathCore.hexToArgb(maincary[index],false);
			var color2:Vector3D = MathCore.hexToArgb(maincary[index+1],false);
			color1.scaleBy(1 - per);
			color2.scaleBy(per);
			color1 = color1.add(color2);
			
			var mainColor:Vector3D = color1;
			
			var $perx:Number = hsbColor.y;
			var $pery:Number = 1 - hsbColor.z;
			
			var cx:int = (255 * (1-$perx) + mainColor.x * $perx) * (1-$pery);
			var cy:int = (255 * (1-$perx) + mainColor.y * $perx) * (1-$pery);
			var cz:int = (255 * (1-$perx) + mainColor.z * $perx) * (1-$pery);
			
			return new Vector3D(cx,cz,cy);
		}
		
		public static function rgb2hsb(color:Vector3D):Vector3D{  
			
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
			
			if(isNaN(hsbH)){
				hsbH = 0;
			}
			if(isNaN(hsbS)){
				hsbS = 0;
			}
			if(isNaN(hsbB)){
				hsbB = 0;
			}
			
			return new Vector3D(hsbH, hsbS, hsbB);  
		}
		
		public static function getHeightByColor(expColor:uint):Number{
			//trace((expColor>>16) & 0xFF, (expColor>>8) & 0xFF);
			return ((expColor>>16) & 0xFF) * 0xFF + ((expColor>>8) & 0xFF) -1000;
		}
		
		public static function _catch_cam(_Cam:Camera3D, _focus_3d:Focus3D,shake:Vector3D=null):void
		{
			if(!shake){
				shake = new Vector3D;
			}
			// 根据捆定点，及距离算出镜头的坐标及角度。
			
//			var view_angle_x:Number=_focus_3d.angle_x;
//			var view_angle_y:Number=_focus_3d.angle_y;
//			var rx:Number=0;
//			var ry:Number=0;
//			var rz:Number=-_Cam.distance;
//			
//			var sin_y:Number=Math.sin(view_angle_y * Math.PI / 180);
//			var cos_y:Number=Math.cos(view_angle_y * Math.PI / 180);
//			var sin_x:Number=Math.sin(view_angle_x * Math.PI / 180);
//			var cos_x:Number=Math.cos(view_angle_x * Math.PI / 180);
			
			
			//	var tmp_rx = this.rx;
			//	this.rx = int(Math.cos(tmp_angle)*tmp_rx-Math.sin(tmp_angle)*this.rz);
			//	this.rz = int(Math.sin(tmp_angle)*tmp_rx+Math.cos(tmp_angle)*this.rz);
			
//			var tmp_rz:Number=rz;
//			rz=cos_x * tmp_rz - sin_x * ry;
//			ry=sin_x * tmp_rz + cos_x * ry;
//			
//			var tmp_rx:Number=rx;
//			rx=cos_y * tmp_rx - sin_y * rz;
//			rz=sin_y * tmp_rx + cos_y * rz;
//			
//			_Cam.x=rx + _focus_3d.x + shake.x;
//			_Cam.y=ry + _focus_3d.y + shake.y;
//			_Cam.z=rz + _focus_3d.z + shake.z;
			
			var  $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-_Cam.angle_x, Vector3D.X_AXIS);
			$m.appendRotation(-_Cam.angle_y, Vector3D.Y_AXIS);
			$m.appendTranslation( _focus_3d.x, _focus_3d.y, _focus_3d.z)
	
			var $p:Vector3D=$m.transformVector(new Vector3D(0,0,-_Cam.distance))
			_Cam.x=$p.x
			_Cam.y=$p.y
			_Cam.z=$p.z
			
			_Cam.angle_x=_focus_3d.angle_x;
			_Cam.angle_y=_Cam.angle_y + (_focus_3d.angle_y - _Cam.angle_y) / 1;
			
			_Cam.sin_y=Math.sin((_Cam.angle_y) * Math.PI / 180);
			_Cam.cos_y=Math.cos((_Cam.angle_y) * Math.PI / 180);
			
			_Cam.sin_x=Math.sin((_Cam.angle_x) * Math.PI / 180);
			_Cam.cos_x=Math.cos((_Cam.angle_x) * Math.PI / 180);
			
			_Cam.cameraMatrix.identity();
			_Cam.cameraMatrix.prependScale(1*(Scene_data.sceneViewHW/_Cam.fovw*2), _Cam.fovw / _Cam.fovh*(Scene_data.sceneViewHW/_Cam.fovw*2), 1);
			_Cam.cameraMatrix.prependTranslation(0, 0, _Cam.distance);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_x, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_y, Vector3D.Y_AXIS);
			

			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);
			
			_Cam.camera3dMatrix=_Cam.cameraMatrix;
			_Cam.camera2dMatrix.identity();
			_Cam.camera2dMatrix.prependScale(1*(1000/Scene_data.cam3D.fovw*2), Scene_data.cam3D.fovw / Scene_data.cam3D.fovh*(1000/Scene_data.cam3D.fovw*2), 1);
			_Cam.camera2dMatrix.prependTranslation(0, 0, 500);
			_Cam.camera2dMatrix.prependRotation(Scene_data.uiCamAngle, Vector3D.X_AXIS);
			
			
			//var P:Vector3D=math2Dto3Dwolrd(200,200)
			//trace(math3Dto2Dwolrd(P.x,P.y,P.z))
		}
		public static function catch_shadow_cam(_Cam:Camera3D, _focus_3d:Focus3D):void
		{
			
			_Cam.angle_x=_focus_3d.angle_x;
			_Cam.angle_y=_focus_3d.angle_y;
			_Cam.cameraMatrix.identity();
			_Cam.cameraMatrix.prependTranslation(0, 0, 2000);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_x, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_y, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);
			
		}
		
		public static function  math2Dto3Dwolrd(_x:Number,_y:Number):Vector3D
		{
			var vec:Vector3D=new Vector3D;
			vec.x=Scene_data.cam3D.cos_y * _x - Scene_data.cam3D.sin_y * (_y/Math.sin(Scene_data.focus3D.angle_x*Math.PI/180));
			vec.z=Scene_data.cam3D.sin_y * _x + Scene_data.cam3D.cos_y * (_y/Math.sin(Scene_data.focus3D.angle_x*Math.PI/180));
			return vec;
		}
		public static function getFillBitmapData(w:uint,h:uint,colorInfo:Object=null):BitmapData
		{
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, h, 0, 0, 0);
			var shape:Shape = new Shape;
			if(colorInfo==null){
				shape.graphics.beginGradientFill(GradientType.LINEAR, [0xffff00,0xffff00,0xffff00],[0.1,1,0.1],[1,150,230], matr, SpreadMethod.PAD);  
			}else{
				
				shape.graphics.beginGradientFill(GradientType.LINEAR, colorInfo.color, colorInfo.alpha, colorInfo.pos, matr, SpreadMethod.PAD);
			}
			shape.graphics.drawRect(0,0,w,h);
			var bitmapdata:BitmapData = new BitmapData(w,h,true,0);
			bitmapdata.draw(shape);
			return bitmapdata
		}
		
		public static function math3Dto2Dwolrd(_x:Number,_y:Number,_z:Number):Point
		{
			var p:Point=new Point;
			var _vet:Vector3D = new Vector3D(_x,_y,_z);
			var a:Vector3D=Scene_data.cam3D.camera3dMatrix.transformVector(_vet)
			p.x=Scene_data.stageWidth/2+(a.x/a.z*(Scene_data.sceneViewHW*2)/(Scene_data.sceneViewHW/Scene_data.cam3D.fovw*2))
			p.y=Scene_data.stageHeight/2-(a.y/a.z*(Scene_data.sceneViewHW*2)/( Scene_data.cam3D.fovw / Scene_data.cam3D.fovh*(Scene_data.sceneViewHW/Scene_data.cam3D.fovw*2)))
			
			p.x = p.x - (Scene_data.stageWidth/2 - Scene_data.focus2D.x);
			p.y = p.y - (Scene_data.stageHeight/2 + Scene_data.focus2D.z);
			
			return p;
		}
		/**
		 * 
		 * @param _vet 传入3D场景的坐标
		 * @return 返回屏幕的XY做坐标
		 * 
		 */		
		public static  function scene3Dto2D(_vet:Vector3D):Point  
		{
			var p:Point=new Point
			var a:Vector3D=Scene_data.cam3D.camera3dMatrix.transformVector(_vet)
			p.x=Scene_data.stageWidth/2+(a.x/a.z*(Scene_data.sceneViewHW*2)/(Scene_data.sceneViewHW/Scene_data.cam3D.fovw*2))
			p.y=Scene_data.stageHeight/2-(a.y/a.z*(Scene_data.sceneViewHW*2)/( Scene_data.cam3D.fovw / Scene_data.cam3D.fovh*(Scene_data.sceneViewHW/Scene_data.cam3D.fovw*2)))
			
			return p;
		}
		
	
		
		
		/**
		 * 
		 * @param $v3d 传入一个世界坐标，
		 * @return  返回一个屏幕顶点坐标
		 * 
		 */
		public static function mathWorld3DPosto2DView($v3d:Vector3D):Point{
			if(!Scene_data.viewMatrx3D){
				throw new Error("Scene_data.viewMatrx3D.还没设置")
			}
			var _posMatrix:Matrix3D=new Matrix3D
			_posMatrix.appendTranslation($v3d.x,$v3d.y,$v3d.z);
			_posMatrix.append(Scene_data.cam3D.cameraMatrix);
			_posMatrix.append(Scene_data.viewMatrx3D);
			var v3d:Vector3D = _posMatrix.transformVector(new Vector3D);
			v3d.x = v3d.x/v3d.w;
			v3d.y = v3d.y/v3d.w;
			v3d.x = (1 + v3d.x) * Scene_data.stage3DVO.width / 2;
			v3d.y = (1 - v3d.y) * Scene_data.stage3DVO.height / 2;
			return new Point(v3d.x,v3d.y);
		}

	}
}
