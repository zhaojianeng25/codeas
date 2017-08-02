package com.zcp.pool
{	
	import com.zcp.loader.loader.DobjLoader;

	/**
	 * 池
	 * @author zcp
	 * 说明：要求：
	 * 1.目标类必须由reSet($parameters:Array)重置方法，且该方法参数为构造函数所有参数的一个数组
	 * 2.目标类必须应提供dispose()释放方法
	 */	
	public class Pool extends Object
	{
		private var _name:String;
		private var _maxSize:int;
		private var _objArr:Array;
		/**
		 * Pool
		 * @param $name 池的名字
		 * @param $mSize 容量
		 */
		public function Pool($name:String="",$mSize:int = 2147483647)
		{
			if ($mSize < 0)
			{
				throw new Error("Pool:数量不能小于0");
			}
			_name = $name;     

			_maxSize = $mSize;
			_objArr = [];
			return;
		}
		
		/**
		 * 创建对象实例
		 * @param $class
		 * @param ... str 英文逗号相隔的参数，现在最多支持15个参数的类
		 * @return 
		 *  
		 */		
		public function createObj($class:Class,... str:*):IPoolClass {
			var obj:IPoolClass;
			if(_objArr.length == 0) {
				obj = DobjLoader.getInstanceByClass($class,str);
			}else{
				obj = _objArr.shift();
				obj.reSet(str);//执行重置
			}
			return obj;
		}
		
		/**
		 * 回收对象
		 * @param $obj
 		 * 
		 */		
		public function disposeObj($obj:IPoolClass):void {
			if($obj==null)return;
			$obj.dispose();//执行释放
			if(_objArr.indexOf($obj)==-1)
			{
				_objArr[_objArr.length] = $obj;
				//执行一次resize
				resize(_maxSize);
			}
		}
		
		
		/**
		 * 获取存储起来的处于休眠状态的对象数量
		 * return
		 * 
		 */	
		public function get length():int
		{
			return _objArr.length;
		}
		
		/**
		 * 重置最大存储数量
		 * @param $size
		 * 
		 */		
		public function resize($size:int):void
		{
			if($size<0)return;
			_maxSize = $size;
			
			while(_objArr.length>_maxSize)
			{
				//_objArr[0].dispose();//_objArr数组内存放的都是已经释放完毕的，所以此处无需再次释放
				_objArr.shift();
			}
			return;
		}
		/**
		 * 删除某个对象
		 * @param $obj
		 * 
		 */	
		public function removeObj($obj:IPoolClass):void
		{
			//销毁元素
			$obj.dispose();
			//从数组中删除
			var i:int = _objArr.indexOf($obj);
			if(i!=-1)
			{
				_objArr.splice(i,1);
			}
			return;
		}
		/**
		 * 删除所有对象
		 * 
		 */	
		public function removeAllObjs():void
		{
			//销毁所有元素
			var item:IPoolClass;
			for each(item in _objArr)
			{
				item.dispose();
			}
			
			//清空数组
			_objArr.length=0;
			return;
		}

		public function get name():String
		{
			return _name;
		}
	}
}