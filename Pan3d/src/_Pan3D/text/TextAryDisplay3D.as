package _Pan3D.text
{
	import flash.geom.Vector3D;

	/**
	 * 数字3d组合容器 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TextAryDisplay3D
	{
		private var vec:Vector.<Text3D>;
		
		private var _x:int;
		private var _y:int;
		
		private var _alpha:Number = 1;
		
		public function TextAryDisplay3D()
		{
			vec = new Vector.<Text3D>;
		}
		
		public function addText($txt:Text3D):void{
			vec.push($txt);
		}

		public function get x():int
		{
			return _x;
		}

		/**
		 * x坐标（相对于整个场景 ）
		 * @param value
		 * 
		 */		
		public function set x(value:int):void
		{
			_x = value;
			
			for(var i:int;i<vec.length;i++){
				vec[i].x = value;
			}
			
		}

		public function get y():int
		{
			return _y;
		}

		/**
		 * y坐标（相对于整个场景 ） 
		 * @param value
		 * 
		 */		
		public function set y(value:int):void
		{
			_y = value;
			
			for(var i:int;i<vec.length;i++){
				vec[i].y = value;
			}
			
		}
		/**
		 * 添加到舞台 
		 * 
		 */		
		public function add():void{
			for(var i:int;i<vec.length;i++){
				vec[i].add();
			}
		}
		/**
		 * 移除到舞台 
		 * 
		 */		
		public function remove():void{
			for(var i:int;i<vec.length;i++){
				vec[i].remove();
			}
		}
		/**
		 * 彻底释放该对象，如不使用必须执行 
		 * 
		 */		
		public function dispose():void{
			for(var i:int;i<vec.length;i++){
				vec[i].dispose();
			}
			vec = null;
		}
		/**
		 * 纠正高度问题 
		 * @param maxHeight
		 * 
		 */		
		public function correctOffestY(maxHeight:int):void{
			for(var i:int;i<vec.length;i++){
				vec[i].offsetY = (maxHeight - vec[i].height)/2;
			}
		}

		public function get alpha():Number
		{
			return _alpha;
		}
		/**
		 * 透明度 
		 * @param value
		 * 
		 */		
		public function set alpha(value:Number):void
		{
			_alpha = value;
			for(var i:int;i<vec.length;i++){
				vec[i].aplha = _alpha;
			}
		}
		
		
		
		
	}
}