package tempest.data.obj
{
	import flash.utils.Dictionary;

	/**
	 * 事件分发器,由于本身事件数量肯定不会多
	 * 所以没有必要使用二分查找算法,直接遍历
	 * 事件ID与事件回调处于不同的数组，通过相同的数组下标关联
	 * @author zhangyong
	 *
	 */
	public class EventDispatcher
	{
		//事件分发器,事件句柄为整形
		public static const KEY_TYPE_INT:int=0;
		//事件分发器的事件句柄为字符串
		public static const KEY_TYPE_STRING:int=1;
		/**/
		public static var SAME_ERROR:Boolean;
		/**/
		protected var _event_id_int:Dictionary;
		/**/
		protected var _event_id_str:Dictionary;

		public function EventDispatcher(type:int=0)
		{
			if (type == KEY_TYPE_INT)
				_event_id_int=new Dictionary(true);
			else if (type == KEY_TYPE_STRING)
				_event_id_str=new Dictionary(true);
		}

		/**
		 * 抛出字符串类型
		 * @param key
		 * @param param
		 *
		 */
		public function DispatchString(key:String, param:Object):void
		{
			var dic:Dictionary=_event_id_str[key];
			if (!dic)
			{
				return;
			}
			var fuc:Function;
			for each (fuc in dic)
			{
				fuc(param);
			}
		}

		/**
		 * 抛出数值类型
		 * @param key
		 * @param param
		 *
		 */
		public function DispatchInt(key:int, param:Object):void
		{
			var dic:Dictionary=_event_id_int[key];
			if (!dic)
			{
				return;
			}
			var fuc:Function;
			for each (fuc in dic)
			{
				fuc(param);
			}
		}

		/**
		 * 添加回调监听,监听ID手工指定
		 * @param key	下标
		 * @param fuc		回调函数
		 * @param  check
		 */
		public function AddListenInt(key:int, fuc:Function):void
		{
			var dic:Dictionary=_event_id_int[key];
			if (!dic)
			{
				dic=new Dictionary(true);
				_event_id_int[key]=dic;
			}
			if (!dic[fuc])
			{
				dic[fuc]=fuc;
			}
			else if (SAME_ERROR)
			{
				throw new Error("has listened same fuc");
			}
		}

		/**
		 * 监听字符串下标
		 * @param key 下标
		 * @param fuc 回调
		 *
		 */
		public function AddListenString(key:String, fuc:Function):void
		{
			var dic:Dictionary=_event_id_str[key];
			if (!dic)
			{
				dic=new Dictionary(true);
				_event_id_str[key]=dic;
			}
			if (!dic[fuc])
			{
				dic[fuc]=fuc;
			}
			else if (SAME_ERROR)
			{
				throw new Error("has listened same fuc");
			}
		}

		/**
		 * 移除整型类的回调监听
		 * @param key 	事件ID
		 * @param f		回调函数闭包,可以支持一个参数(Object)，如果f为空，则移除所有
		 */
		public function removeListenerInt(key:int, f:Function=null):void
		{
			var dic:Dictionary=_event_id_int[key];
			if (!dic)
			{
				return;
			}
			if (f != null)
			{
				dic[f]=null;
				delete dic[f];
			}
			else
			{
				_event_id_int[key]=null;
				delete _event_id_int[key];
			}
		}

		/**
		 * 移除字符串类型的回调监听
		 * @param key 	事件ID
		 * @param f 回调函数闭包,可以支持一个参数(Object)，如果f为空，则移除所有
		 */
		public function removeListenerString(key:String, f:Function=null):void
		{
			var dic:Dictionary=_event_id_str[key];
			if (!dic)
			{
				return;
			}
			if (f != null)
			{
				dic[f]=null;
				delete dic[f];
			}
			else
			{
				_event_id_str[key]=null;
				delete _event_id_str[key];
			}
		}

		/**
		 * 清空所有已经注册的事件监听
		 */
		public function Clear():void
		{
			var key:String;
			if (_event_id_int)
			{
				for each (key in _event_id_int)
				{
					_event_id_int[key]=null;
					delete _event_id_int[key];
				}
			}
			if (_event_id_str)
			{
				for each (key in _event_id_str)
				{
					_event_id_str[key]=null;
					delete _event_id_str[key];
				}
			}
		}

		/**
		 * 是否存在下标监听
		 * @param key
		 * @return
		 *
		 */
		public function hasListenInt(key:int):Boolean
		{
			return _event_id_int[key];
		}
	}
}
