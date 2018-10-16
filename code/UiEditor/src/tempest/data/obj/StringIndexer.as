package tempest.data.obj
{

	public class StringIndexer
	{
		//这4个数据与下标索引组成一个完成结构体
		protected var _indexerExp:Vector.<RegExp>;
		protected var _objs:Vector.<Vector.<GuidObject>>;

		protected var _evFilter:Vector.<SyncEventFilter>;

		public function StringIndexer()
		{
			_indexerExp=new Vector.<RegExp>();
			_objs=new Vector.<Vector.<GuidObject>>();
			_evFilter=new Vector.<SyncEventFilter>();
		}

		/**
		 * 根据正则表达式返回加入的索引，并返回索引编号 如: create("^i\d+") 代表所有的物品
		 * @param exp
		 * @return
		 */
		public function createIndex(exp:String):int
		{
			var index:int=getIndex(exp);
			if (index == -1)
			{
				index=_indexerExp.length;
				_indexerExp[index]=new RegExp(exp, "g");
				_objs[index]=new Vector.<GuidObject>();
				_evFilter[index]=null;
			}
			return index;
		}

		/**
		 * 根据正则表达式返回索引
		 * @param exp 正则表达式
		 * @return 返回索引,如果返回-1就是没找到
		 */
		public function getIndex(exp:String):int
		{
			var idx:int=-1;
			for each (var reg:RegExp in _indexerExp)
			{
				idx++;
				if (reg.source == exp)
					return idx;
			}
			return -1;
		}

		/**
		 * 释放正则表达式的索引的内容
		 * 暂时不支持运行过程中增加和删除索引
		 * @param exp
		 */
		public function releaseIndex(exp:String):void
		{
			var index:int=getIndex(exp);
			if (index != -1)
			{
				_indexerExp.splice(index, 1);
				_objs.splice(index, 1);
				_evFilter.splice(index, 1);
			}
		}

		/**
		 * 根据传入的字符串，验证符合哪个索引
		 * @param obj
		 * @return
		 */
		private function test(k:String):int
		{
			for (var i:int=0; i < _indexerExp.length; i++)
			{
				_indexerExp[i].lastIndex=0;
				if (_indexerExp[i].test(k))
					return i;
			}
			return -1;
		}

		/**
		 * 插入对象，遍历所有的正则表达式，如果符合则会插入
		 * @param obj
		 */
		public function insert(obj:GuidObject):void
		{
			var i:int=test(obj.guid);
			if (i >= 0 && _objs[i] && _objs[i].indexOf(obj) == -1)
			{
				//对象符合索引，插入到相应的数组中
				_objs[i][_objs[i].length]=obj;
			}
		}

		/**
		 * 根据对象的GUID移除所在的索引
		 * @param guid
		 */
		public function remove(guid:String):void
		{
			var i:int=test(guid);
			if (i == -1)
				return;
			for (var j:int=0; j < _objs[i].length; j++)
			{
				if (_objs[i][j].guid == guid)
				{
					_objs[i].splice(j, 1);
					return;
				}
			}
		}

		/**
		 * 根据正则表达式查询对象集合
		 * @param exp
		 * @return
		 */
		public function query(exp:String):Vector.<GuidObject>
		{
			var index:int=getIndex(exp);
			if (index == -1)
				return null;
			return _objs[index];
		}

		/**
		 * 根据索引编号返回所有的对象集合
		 * @param indexTyp
		 * @return
		 */
		public function get(indexTyp:int):Vector.<GuidObject>
		{
			if (indexTyp < 0 || indexTyp >= _objs.length)
				return null;
			return _objs[indexTyp];
		}

		/**
		 * 传入对象去匹索引器
		 * @param obj
		 * @return
		 */
		public function matchObject(obj:GuidObject):SyncEventFilter
		{
			if (!obj)
				return null;
			var i:int=test(obj.guid);
			if (i >= 0)
			{
				return _evFilter[i];
			}
			return null;
		}

		/**
		 * 根据对象筛选的集合触发相应的事件
		 * @param exp
		 * @param f
		 */
		public function filter(exp:String, f:SyncEventFilter):void
		{
			var indexTyp:int=getIndex(exp);
			if (indexTyp < 0 || indexTyp >= _objs.length)
				throw new Error("indexTyp < 0 || indexTyp >= _objs.length");
			if (indexTyp >= _evFilter.length)
				throw new Error("indexTyp >= _evFilter.length");
			_evFilter[indexTyp]=f;
		}

		public function Clear():void
		{
//			if (_indexerExp)
//			{
//				_indexerExp.length=0;
//			}
			if (_objs)
			{
				_objs.length=0;
			}
			if (_evFilter)
			{
				while (_evFilter.length)
				{
					var syncEventFilter:SyncEventFilter=_evFilter.shift();
					if (syncEventFilter)
						syncEventFilter.Clear()
				}
			}
		}
		
		/**
		 * 释放内存
		 */		
		public function dispose():void{
			Clear();
			_indexerExp = null;
			_objs = null;
			_evFilter = null;
		}
	}
}
