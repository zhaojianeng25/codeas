package tempest.common.pool
{
	import tempest.core.IPoolClient;
	import tempest.utils.ClassUtil;

	public class Pool
	{
		private var _name:String
		private var _maxSize:int
		private var _objArr:Array

		/**
		 * 创建池
		 * @param name 池名称
		 * @param maxSize 池的最大容量
		 *
		 */
		public function Pool(name:String = "", maxSize:int = int.MAX_VALUE)
		{
			if (maxSize < 0)
			{
				throw(new Error("Pool constructor error , wrong params!"));
			}
			this._name = name;
			this._maxSize = maxSize;
			this._objArr = [];
		}

		/**
		 *从池中获取对象
		 * @param className 类
		 * @param args 参数
		 * @return
		 *
		 */
		public function createObj(objClass:Class, ... args):IPoolClient
		{
			var obj:IPoolClient;
			if (this._objArr.length == 0) //如果当前池对象个数为零则新建对象
				obj = ClassUtil.getInstanceByClass(objClass, args);
			else
			{
				obj = this._objArr.shift();
				//obj = this._objArr.pop();  性能提升？
				obj.reset(args);
			}
			return obj;
		}

		/**
		 *对象回收
		 * @param _arg1
		 *
		 */
		public function disposeObj(obj:IPoolClient):void
		{
			if (obj == null)
				return;
			obj.dispose();
			if (this._objArr.indexOf(obj) == -1) //如果不是池内的对象且池内对象未饱和，则添加到池中
			{
				//	this._objArr.push(obj);
				this._objArr[this._objArr.length] = obj;
				this.resize(this._maxSize);
			}
		}

		/**
		 *获取当前池中对象的个数
		 * @return
		 *
		 */
		public function get length():int
		{
			return (this._objArr.length);
		}

		/**
		 *重置池的对象上限数
		 * @param num
		 *
		 */
		public function resize(maxNum:int):void
		{
			if (maxNum < 0)
				return;
			this._maxSize = maxNum;
			while (this._objArr.length > this._maxSize) //如果新的上限数小于当前上限则丢弃池中的对象
			{
				this._objArr.shift();
			}
		}

		/**
		 *移除池中的指定对象
		 * @param _arg1
		 *
		 */
		public function removeObj(obj:IPoolClient):void
		{
			obj.dispose();
			var _index:int = this._objArr.indexOf(obj);
			if (_index != -1)
				this._objArr.splice(_index, 1);
		}

		/**
		 *移除池中所有对象
		 *
		 */
		public function removeAllObjs():void
		{
			var _obj:IPoolClient;
			for each (_obj in this._objArr)
			{
				_obj.dispose();
			}
			this._objArr = [];
		}

		/**
		 *获取当前池的名称
		 * @return
		 *
		 */
		public function get name():String
		{
			return (this._name);
		}
	}
}
