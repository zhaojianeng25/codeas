package tempest.manager
{
	import flash.system.ApplicationDomain;
	import tempest.common.pool.Pool;
	import tempest.utils.ClassUtil;

	/**
	 *池管理
	 * 所有方法均为静态
	 * @author zhangyong
	 *
	 */
	public class PoolManager
	{
		private static var _poolArr:Array = [];

		/**
		 *池的所有操作为静态方法无需NEW
		 *
		 */
		public function PoolManager()
		{
			throw(new Error("Can not New!"));
		}

		/**
		 *是否存在指定的池
		 * @param pool
		 * @return
		 *
		 */
		public static function hasPool(pool:Pool):Boolean
		{
			return (!((_poolArr.indexOf(pool) == -1)));
		}

		/**
		 *是否存在指定名字的池
		 * @param poolName
		 * @return
		 *
		 */
		public static function hasNamedPool(poolName:String):Boolean
		{
			var _pool:Pool;
			for each (_pool in _poolArr)
			{
				if (_pool.name == poolName)
					return true;
			}
			return false;
		}

		/**
		 *通过池名字获取池
		 * @param poolName
		 * @return
		 *
		 */
		public static function getPool(poolName:String):Pool
		{
			var _pool:Pool;
			for each (_pool in _poolArr)
			{
				if (_pool.name == poolName)
					return _pool;
			}
			return null;
		}

		/**
		 *创建指定名称的池
		 * @param poolName
		 * @param maxSize
		 * @return 创建的新池
		 *
		 */
		public static function creatPool(poolName:String = "", maxSize:int = 2147483647):Pool
		{
			var _pool:Pool;
			if (!hasNamedPool(poolName)) //如果不存在则创建
				_pool = _poolArr[_poolArr.length] = new Pool(poolName, maxSize);
			else //存在则获取原来的池  并重置大小
			{
				_pool = getPool(poolName);
				_pool.resize(maxSize);
			}
			return _pool;
		}

		/**
		 *删除指定的池
		 * @param pool
		 *
		 */
		public static function deletePool(pool:Pool):void
		{
			if (!pool)
				return;
			var _poolIndex:int = _poolArr.indexOf(pool); //获取池在池数组中的索引
			if (_poolIndex != -1)
				_poolArr.splice(_poolIndex, 1);
			pool.removeAllObjs();
		}

		/**
		 * 删除指定名字的池
		 * @param poolName
		 *
		 */
		public static function deletePoolByName(poolName:String):void
		{
			var _pool:Pool;
			for each (_pool in _poolArr)
			{
				if (_pool.name == poolName)
				{
					_poolArr.splice(_poolArr.indexOf(_pool), 1);
					_pool.removeAllObjs();
					break;
				}
			}
		}

		/**
		 *删除所有池
		 *
		 */
		public static function deleteAllPools():void
		{
			var _pool:Pool;
			for each (_pool in _poolArr)
				_pool.removeAllObjs();
			_poolArr = [];
		}

		/**
		 *获取当前池的数量
		 * @return
		 *
		 */
		public static function getPoolsNum():int
		{
			return (_poolArr.length);
		}

		/**
		 *通过字符串名称获取类
		 * @param cls 类字符串
		 * @return
		 *
		 */
		public static function getClass(cls:String):Class
		{
			if ((cls == null) || (cls == ""))
				return null;
			if (((ApplicationDomain.currentDomain.hasDefinition(cls))))
				return ((ApplicationDomain.currentDomain.getDefinition(cls) as Class));
			return null;
		}

		/**
		 *通过字符串类名称和属性数组获取对象
		 * @param cls  类名
		 * @param _args  属性数组
		 * @return
		 *
		 */
		public static function getInstance(cls:String, ... args):*
		{
			var _cls:Class = getClass(cls);
			var _obj:* = ClassUtil.getInstanceByClass(_cls, args);
			return _obj;
		}
	}
}
