package tempest.core
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * 对象池
	 * @author wy
	 */
	public class ObjectPools
	{
		/**
		 * 调试时的严格模式
		 */
		public static const MOLD_DEBUG_STRICT:uint = 0;
		/**
		 * 发布时的防错模式
		 */
		public static const MOLD_RELEASE_FAIL_SAFE:uint = 1;
		
		private static var _mold:uint = MOLD_DEBUG_STRICT;
		
		/**
		 * 模式
		 */
		public static function get mold():uint
		{
			return _mold;
		}
		
		public static function set mold(value:uint):void
		{
			_mold = value;
		}
		
		
		/** 对象池*/
		private static const _pools:Dictionary = new Dictionary();
		
		/**
		 * 申请
		 * @param def				对象类名
		 * @param params			新对象构造函数的参数（最多支持10个）
		 * @param arg				outPool初始化的参数
		 * @return 
		 * 
		 */
		public static function malloc(def:Class, params:Array = null, ...arg):IPoolsObject{
			var obj:IPoolsObject;
			var pool:Pool = _pools[getQualifiedClassName(def)];
			if(pool){
				obj = pool.pull();
			}
			if(!obj){
				if(!params){
					obj = new def();
				}
				else{
					switch(params.length){
						case 0:
							obj = new def();
							break;
						case 1:
							obj = new def(params[0]);
							break;
						case 2:
							obj = new def(params[0], params[1]);
							break;
						case 3:
							obj = new def(params[0], params[1], params[2]);
							break;
						case 4:
							obj = new def(params[0], params[1], params[2], params[3]);
							break;
						case 5:
							obj = new def(params[0], params[1], params[2], params[3], params[4]);
							break;
						case 6:
							obj = new def(params[0], params[1], params[2], params[3], params[4], params[5]);
							break;
						case 7:
							obj = new def(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
							break;
						case 8:
							obj = new def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
							break;
						case 9:
							obj = new def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
							break;
						case 10:
							obj = new def(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
							break;
					}
				}
			}
			obj.outPool.apply(null, arg);
			return obj;
		}
		
		/**
		 * 释放
		 * @param obj	对象
		 */
		public static function free(obj:IPoolsObject):void{
			var poolKey:String = getQualifiedClassName(obj);
			var pool:Pool = _pools[poolKey];
			if(!pool){
				pool = new Pool(poolKey);
				_pools[poolKey] = pool;
			}
			pool.push(obj);
		}
		
		/**距离下次检查的时间*/
		private static var _nextUpdateTime:int = 0;
		/**心跳驱动*/
		public static function update(diff:int):void{
			if(_nextUpdateTime > 0){
				_nextUpdateTime -= diff;
				return;
			}
			_nextUpdateTime = 20000; //20秒检查一下池
			for each(var pool:Pool in _pools){
				pool.adaptSize();
			}
		}
	}
}

import tempest.core.IPoolsObject;
import tempest.core.ObjectPools;

/**
 * 池
 * @author wy
 */
class Pool{
	/**标识 （类名）*/
	private var _key:String;
	/**池*/
	public var list:Vector.<IPoolsObject> = new Vector.<IPoolsObject>();
	/**过去一段时间池内最小对象数 （用来清理池内暂不使用的对象）*/
	private var _minSize:uint;
	private var _maxSize:uint;
	
	public function Pool(key:String)
	{
		_key = key;
	}
	
	/**进池*/
	public function push(obj:IPoolsObject):void{
		obj.intoPool();
		var len:uint = list.length;
		var idx:int = list.indexOf(obj);
		if(idx != -1){
			if(ObjectPools.mold == ObjectPools.MOLD_DEBUG_STRICT){
				throw("error: free IPoolsObject in pool");
			}
			else if(ObjectPools.mold == ObjectPools.MOLD_RELEASE_FAIL_SAFE){
				return
			}
		}
		list[len] = obj;
		//trace(_key, " _pool.length", len);
	}
	
	/**出池*/
	public function pull():IPoolsObject{
		var obj:IPoolsObject;
		var idx:int = list.length - 1;
		if(idx >= 0){
			obj = list[idx];
			list.length = idx;
			_minSize = Math.min(_minSize, idx);
			_maxSize = Math.max(_maxSize, idx);
		}
		return obj;
	}
	
	/**池大小根据使用情况适应*/
	public function adaptSize():void{
		//评估的使用池大小
		var useSize:uint = _maxSize - _minSize;
		if(list.length > useSize)
			list.length = useSize;
		_minSize = _maxSize = 0;
	}
}