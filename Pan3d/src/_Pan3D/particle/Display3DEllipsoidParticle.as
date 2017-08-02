package _Pan3D.particle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.texture.TextureCount;
	
	import _me.Scene_data;
	
	public class Display3DEllipsoidParticle extends Display3DParticle
	{
		protected var _startTimer:uint=0;  //开始时间
		protected var _endTimer:uint=0;    //结束时间
		//protected var _timer:uint=0;   //时间
		protected var _totalNum:Number=50 //   粒子配额
		protected var _beginColor:Vector3D=new Vector3D(1,1,1,1)  //初始颜色
		protected var _endColor:Vector3D=new Vector3D(0,0,0,0)   //结束颜色  =》包含透明
		protected var _acceleration:Number=0.2      //加数度
		protected var _toscale:Number=0.00  // 大小变化
		protected var _gezhi:Boolean=true;            //是否等格子排列所有组合
		protected var _shootAngly:Vector3D=new Vector3D(1,0,0);// 发射角度
		protected var _shootSpeed:Number=0;          //发射速率
		//protected var _lizhishenming:Number=40;   //粒子生命  
		protected var _shootInterval:Number=1;   //间隔时间
		protected var _isRandom:Boolean=false;   //是否随机  起点随机
		protected var _isSendRandom:Boolean=false;   //是否随机发射速度
		protected var _isSendAngleRandom:Boolean = false;//是否随机发射角度
		protected var _timeRandom:Boolean=false;   //是否随机  发射随机
		protected var _isOnlyAngly:Boolean=false   //可以以向一个方向  固定的方向
		protected var _toOut:Boolean=false   //是否固定向外发射
		protected var _paticleMaxScale:Number = 1;
		protected var _paticleMinScale:Number = 1;
			
		protected var _addforce:Vector3D=new Vector3D(0,0,0);
		protected var _lixinForce:Vector3D=new Vector3D(0,0,0);
		protected var _revolution:Vector3D=new Vector3D(0,0,0);
		protected var _waveform:Vector3D = new Vector3D(0,0,0,0);
//		protected var _yinlishuzhi
		
		protected var _round:Vector3D=new Vector3D()//初始位置
		protected var _is3Dlizi:Boolean=false;  //
		protected var _qishijuli:Number=0;
		protected var _gezhiDuanshu:Number=1;
		protected var _speed:Number=1;   //粒子运动数字
		protected var _isLoop:Boolean=false;  //是否循环
		protected var _nextLoopTime:uint=100; //时间循环时间  也可以当做间隔时间
		
//		protected var _anglyBuffer:VertexBuffer3D;
//		protected var _startBuffer:VertexBuffer3D;
//		protected var _timeBuffer:VertexBuffer3D;
		//protected var _rotationMatrix:Matrix3D;
		
		protected var _randomBaseSize:Boolean;
		protected var _closeSurface:Boolean;
		protected var _halfCircle:Boolean;
		protected var _isEven:Boolean;
		protected var _basePositon:Vector3D = new Vector3D(0,0,0);
		protected var _baseRandomAngle:Number = 0; 
		protected var _shapeType:int = 0; 
		protected var _fasanJiaodu:int = 0; 
		
		protected var _lockX:Boolean;
		protected var _lockY:Boolean;
		
		//protected var _textureRandomColor:Texture;
		protected var _textureRandomColorInfo:Object;
		
		
		public function Display3DEllipsoidParticle(context:Context3D)
		{
			super(context);
			_particleType = 2;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			if(obj.color){
				//初始和结束两颜色
				_beginColor=obj.color.begin;
				_endColor=obj.color.endColor;
			}
			
			_totalNum=obj.totalNum;
			
			_acceleration=obj.acceleration;
			
			_toscale=obj.toscale;
			
			_shootSpeed=obj.shootSpeed;
			
			_isRandom=obj.isRandom;
			
			_isSendRandom=obj.isSendRandom;
			
			_round=getVector3DByObject(obj.round);
			
			_is3Dlizi=obj.is3Dlizi;
			
			_halfCircle = obj.halfCircle;
			
			_shootAngly=getVector3DByObject(obj.shootAngly);
			
			_qishijuli=obj.qishijuli;
			
			_gezhiDuanshu=obj.gezhiDuanshu;
			
			_speed=obj.speed;
			
			_isLoop=obj.isLoop;
			
			_nextLoopTime=obj.nextLoopTime;
			
			_startTimer=obj.startTimer;
			
			_endTimer=obj.endTimer;
			
			_isOnlyAngly=obj.isOnlyAngly;
			
			_toOut=obj.toOut;
			
			_isSendAngleRandom = obj.isSendAngleRandom;
			
			_waveform = getVector3DByObject(obj.waveform);
			
			_closeSurface = obj.closeSurface;
			
			_isEven = Boolean(obj.isEven);
			
			_paticleMaxScale = obj.paticleMaxScale;
			
			_paticleMinScale = obj.paticleMinScale;
			
			_basePositon = getVector3DByObject(obj.basePositon);
			
			_baseRandomAngle = obj.baseRandomAngle;
			_shapeType = obj.shapeType;
			_fasanJiaodu = obj.fasanJiaodu;
			
			_lockX = obj.lockX;
			_lockY = obj.lockY;
			
			//if(!isClone){
				//this.textureRandomColor = obj.randomColor;
				this._textureRandomColorInfo = obj.randomColor;
			//}
			
			if(obj.addforce)
				_addforce=getVector3DByObject(obj.addforce);
			
			if(obj.lixinForce)
				_lixinForce=getVector3DByObject(obj.lixinForce);
			
			if(obj.revolution)
				_revolution=getVector3DByObject(obj.revolution);
			
			super.setAllInfo(obj,isClone);
			
			if(!isClone){
				try{
					uplodToGpu();
				} 
				catch(error:Error) {
					if(!Scene_data.disposed){
						throw error;
					}
				}
			}
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			
			obj.totalNum = _totalNum;
			obj.acceleration = _acceleration;
			obj.toscale = _toscale;
			obj.shootSpeed = _shootSpeed;
			obj.isRandom = _isRandom;
			obj.isSendRandom = _isSendRandom;
			obj.round = _round;
			obj.is3Dlizi = _is3Dlizi;
			obj.halfCircle = _halfCircle;
			obj.shootAngly = _shootAngly;
			obj.qishijuli = _qishijuli;
			obj.gezhiDuanshu = _gezhiDuanshu;
			obj.speed = _speed;
			obj.isLoop = _isLoop;
			obj.nextLoopTime = _nextLoopTime;
			obj.startTimer = _startTimer;
			obj.endTimer = _endTimer;
			obj.isOnlyAngly = _isOnlyAngly;
			obj.toOut = _toOut;
			obj.isSendAngleRandom = _isSendAngleRandom;
			obj.addforce = _addforce;
			obj.lixinForce = _lixinForce;
			obj.revolution = _revolution;
			obj.ziZhuanAngly = _ziZhuanAngly;
			obj.waveform = _waveform;
			obj.closeSurface = _closeSurface;
			obj.isEven = _isEven;
			obj.paticleMaxScale = _paticleMaxScale;
			obj.paticleMinScale = _paticleMinScale;
			obj.basePositon = _basePositon;
			obj.baseRandomAngle = _baseRandomAngle;
			
			obj.randomColor = _textureRandomColorInfo;
			
			obj.particleType = _particleType;
			obj.shapeType = _shapeType;
			obj.fasanJiaodu = _fasanJiaodu;
			
			obj.lockX = _lockX;
			obj.lockY = _lockY;
			
			return obj;
		}
		
//		private function set textureRandomColor(colorInfo:Object):void{
//			if(!colorInfo){
//				return;
//			}
//			_textureRandomColorInfo = colorInfo;
			
//			var num:int = 2;
//			for(var i:int=1;i<10;i++){
//				num = num*2;
//				if(_totalNum < num){
//					break;
//				}
//			}
//			
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(num, 20, 0, 0, 0);
//			
//			var shape:Shape = new Shape;
//			shape.graphics.clear();
//			shape.graphics.beginGradientFill(GradientType.LINEAR, colorInfo.color, colorInfo.alpha, colorInfo.pos, matr, SpreadMethod.PAD);  
//			shape.graphics.drawRect(0,0,num,1);
//			
//			var bitmapdata:BitmapData = new BitmapData(num,1,true,0);
//			bitmapdata.draw(shape);
//			
//			var newBitmapdata:BitmapData = new BitmapData(num,1,true,0);
//			for(i = 0 ;i<num;i++){
//				newBitmapdata.setPixel32(i,0,bitmapdata.getPixel32(int(num*Math.random()),0));
//			}
//			try{
//				_textureRandomColor = _context3D.createTexture(num,1,Context3DTextureFormat.BGRA,true);
//				_textureRandomColor.uploadFromBitmapData(newBitmapdata);
//			} 
//			catch(error:Error) {
//				if(!Scene_data.disposed){
//					throw error;
//				}
//			}
//			_randomColorWidth = num;
//			TextureCount.getInstance().countParticleColor(num);
//		}
		
		private var _randomColorWidth:int;
		
		private function sortF(a:int,b:int):int {
			return Math.floor(Math.random()*3-1);
		}
		
		override public function reload():void{
			super.reload();
			//textureRandomColor = _textureRandomColorInfo;
		}
		
		override public function dispose():void{
			super.dispose();
			TextureCount.getInstance().countParticleColor(-_randomColorWidth);
		}
		
		override public function clear():void{
			super.clear();
			_beginColor = null;
			_endColor = null;
			_shootAngly = null;
			
			_addforce = null;
			_lixinForce = null;
			_revolution = null;
			_waveform = null
			
			_round = null;
			
			_basePositon = null
			//_textureRandomColor = null;
			_textureRandomColorInfo = null;
		}
		
	}
}