package _Pan3D.skill.custom
{
	import _Pan3D.display3D.interfaces.IAbsolute3D;
	import _Pan3D.skill.interfaces.IPath;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	/**
	 * 自定义路径基础类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Path implements IPath
	{
		protected var rotationMartix:Matrix3D = new Matrix3D;
		protected var isStart:Boolean;
		protected var starTime:uint;
		protected var time:uint;
		protected var allTime:uint;
		
		protected var active:IAbsolute3D;
		protected var target:IAbsolute3D;
		
		public var targetParam:Object;
		
		protected var onComFun:Function;
		
		protected var startFun:Function;
		
		public var id:int;
		
		public var alpha:Number = 1;
		
		public function Path()
		{
			
		}
		
		public function start():void{
			isStart = true;
			starTime = getTimer();
		}
		
		public function update(t:int):void
		{
			time = t;
			allTime += t;
		}
		
//		public function getPosV3d(outVec:Vector3D):void
//		{
//			
//		}
		
//		public function getPosMatrix():Matrix3D
//		{
//			return rotationMartix;
//		}
		
		public function getSocket(socketName:String,resultMatrix:Matrix3D):void{
			
		}
		
		
		public function getPosV3d(index:int,out:Vector3D):void{
			
		}
			
		public function getRotation():Number{
			return 0;
		}
		
		public function getPosMatrix(index:int):Matrix3D{
			return rotationMartix;
		}
		public function getOffsetPos(v3d:Vector3D,index:int):Vector3D{
			return null;
		}
		
		
		/**
		 * 设置弹道信息 
		 * @param $active 发起者
		 * @param $target 目标者
		 * @param $onComFun 完成回调
		 * @param $startFun 开始回调
		 * 
		 */		
		public function setInfo($active:IAbsolute3D,$target:IAbsolute3D,$onComFun:Function=null,$startFun:Function=null):void{
			active = $active;
			target = $target;
			
			onComFun = $onComFun;
			startFun = $startFun;
		}
		/**
		 * 重置路径 
		 * 
		 */		
		public function reset():void{
			isStart = false;
			starTime = 0;
			time = 0;
			allTime = 0;
			alpha = 1;
			
			active = null;
			target = null;
			targetParam = null;
			
			
			onComFun = null;
		}
		/**
		 * 弹道数量 
		 * @return 数量
		 * 
		 */		
		public function get num():uint{
			return 1;
		}
		/**
		 * 绑定弹道粒子的透明度 
		 * @return 
		 * 
		 */		
		public function getBindAlpha():Number{
			return alpha;
		}
		/**
		 * 技能起始的高度 
		 * @return 
		 * 
		 */		
		public function get baseHeight():int{
			return 0;
		}
		
		public function dispose():void{
			rotationMartix = null;
			
			active = null;
			target = null;
			targetParam = null;
			
			onComFun = null;
			startFun = null;
			
		}
		
	}
}