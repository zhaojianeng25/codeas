package tempest.data.obj
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	public class GuidObjectTable extends SyncEvent
	{
		protected var _objs:Dictionary=new Dictionary;
		
		private var _newEvent:EventDispatcher; 
		
		private var _delEvent:EventDispatcher;
		
		protected var _indexer:StringIndexer;
		//以对象ID的hash希，整型作为key的对象表
		protected var _u_2_guid:Dictionary=new Dictionary();

		public function GuidObjectTable()
		{
			_newEvent = new EventDispatcher(EventDispatcher.KEY_TYPE_STRING);
			_delEvent = new EventDispatcher(EventDispatcher.KEY_TYPE_STRING);
			_indexer=new StringIndexer();
		}

		public function Get(k:String):GuidObject
		{
			return _objs[k];
		}

		public function getByGuid(guid:String):GuidObject
		{
			return Get(_u_2_guid[guid] ? _u_2_guid[guid] : null);
		}

		public function getByUGuid(uguid:uint):GuidObject
		{
			return Get(_u_2_guid[uguid] ? _u_2_guid[uguid] : null);
		}

		/**
		 * 通过应用服guid获取对象
		 * @param 应用服guid
		 * @return
		 *
		 */
		public function GetByAppGuid(k:String):GuidObject
		{
			if (k == "")
			{
				return null;
			}
			var key:String;
			var obj:GuidObject;
			var guid:String;
			for (key in _objs)
			{
				obj=_objs[key];
				guid=obj.guid;
				if (obj.guid == k || guid.indexOf(k) != -1)
				{
					return obj;
				}
			}
			return null;
		}

		/**
		 * 索引器
		 */
		public function get indexer():StringIndexer
		{
			return _indexer;
		}

		/**
		 * 创建对象
		 * @param k
		 * @return
		 */
		public function CreateObject(k:String):GuidObject
		{
			var p:GuidObject=_objs[k];
			if (!p)
			{
				p=new GuidObject();
				p.guid=k;
			}
			AttachObject(p);
			return p;
		}

		/**
		 * 释放对象
		 * @param o
		 */
		public function ReleaseObject(o:GuidObject):void
		{
			var k:String=o.guid;
			var p:GuidObject=_objs[k];
			if (!p)
				return;
			DetachObject(p);
			//对象释放
			p.dispose();
		}

		public function ReleaseKey(k:String):void
		{
			var p:GuidObject=_objs[k];
			if (!p)
				return;
			ReleaseObject(p);
		}

		public function AttachObject(o:GuidObject):void
		{
			if (o == null)
				throw new Error("AttachObject,o==null");
			o.add_ref(1);
			_objs[o.guid]=o;
			//加入对象分类
			_indexer.insert(o);
			//如果hash函数不为空则要维护一个key对照表	
			var u_guid:uint=GuidObject.getGUIDIndex(o.guid);
			if (u_guid != 0)
			{
				_u_2_guid[u_guid]=o.guid;
			}
		}

		public function DetachObject(o:GuidObject):void
		{
			o.add_ref(-1);
			if (o.ref <= 0)
			{
				_indexer.remove(o.guid);
				delete _objs[o.guid];
				//如果hash函数不为空则要维护一个key对照表	
				var u_guid:uint=GuidObject.getGUIDIndex(o.guid);
				if (u_guid != 0)
				{
					delete _u_2_guid[u_guid];
				}
			}
		}
		protected static var applyBlock_tmp_obj:GuidObject=new GuidObject;
		private static var _type:int;
		private static var _sub_type:int;
		private static var _obj:Object;

		/**
		 * 应用对象更新数据包
		 * @param bytes
		 */
		public function ApplyBlock(bytes:ByteArray):Boolean
		{
			while (bytes.bytesAvailable)
			{
				var flags:int=bytes.readUnsignedByte();
				var guid:String; //= bytes.readUTF();	
				//先读出标志，如果是整形guid则转换成字符串
				if (flags & OBJ_OPT_U_GUID)
				{
					var u_guid:uint=bytes.readUnsignedInt();
					guid=_u_2_guid[u_guid] ? _u_2_guid[u_guid] : "";
				}
				else
				{
					guid=bytes.readUTF();
				}
				var cur_obj:GuidObject=Get(guid);
				//如果是删除则触发事件
				if ((flags & OBJ_OPT_DELETE) && cur_obj != null)
				{
					removeObject(guid, cur_obj);
					/*onObjectDelete(cur_obj);
					ReleaseKey(guid);
					cur_obj.dispose();*/
					continue;
				}
				///////////////////////////////////////
				////////创建或者更新对象类型////////////
				///////////////////////////////////////
				//从流中读出对象,如果没有找到该对象则读取后抛弃
				if (!cur_obj)
				{
					if (flags & OBJ_OPT_NEW)
					{
						cur_obj=CreateObject(guid);
					}
					else
					{
						cur_obj=applyBlock_tmp_obj;
					}
				}
				cur_obj.ReadFrom(flags, bytes, cur_obj);
				//如果是新对象则触发下事件
				if (flags & OBJ_OPT_NEW)
				{
					onObjectNew(guid, cur_obj);
				}
			}
			return true;
		}

		/*根据查询定符串返回对象列表*/
		public function SearchObject(s:String, vec:Vector.<String>):void
		{
			//TODO:这里的正则对象性能优化
			var regex:RegExp=new RegExp(s);
			vec.length=0;
			for (var k:String in _objs)
			{
				if (regex.test(k))
					vec.push(k);
			}
		}

		/*提供一种机制用于遍历所有的对象列表 委托格式 f(obj:GuidObject):void*/
		public function ForEachObject(f:Function):void
		{
			for each (var o:GuidObject in _objs)
			{
				f(o);
			}
		}
		
		/**
		 * 调用远程创建对象，成功的时候回调 
		 * @param guid
		 * @param cb function(o:GuidObject):void
		 * 
		 */
		[inline]
		public function RegisterCreateEvent(guid:String,cb:Function):void
		{
			_newEvent.AddListenString(guid,cb);
		}
		
		[inline]
		public function unRegisterCreateEvent(guid:String,cb:Function):void
		{
			_newEvent.removeListenerString(guid,cb);
		}
		
		/**
		 * 调用远程删除对象,成功时回调 
		 * @param guid
		 * @param cb function(o:GuidObject):void
		 * 
		 */
		[inline]
		public function RegisterReleaseEvent(guid:String,cb:Function):void
		{
			_delEvent.AddListenString(guid,cb); 
		}
		
		[inline]
		public function unRegisterReleaseEvent(guid:String,cb:Function):void
		{
			_delEvent.removeListenerString(guid,cb); 
		}
		
		//用于每次发包的缓存 		 
		private var _packet_pool:Vector.<ByteArray>=new Vector.<ByteArray>;

		/**
		 * 从池中分配新的数据包,如果没有包号就不要写入
		 * @param optCode
		 * @return
		 */
		public function newPacket(optCode:int=0):ByteArray
		{
			var pkt:ByteArray=null;
			if (_packet_pool.length == 0)
			{
				pkt=new ByteArray;
				pkt.endian=Endian.LITTLE_ENDIAN;
			}
			else
			{
				pkt=_packet_pool.shift();
				pkt.clear();
			}
			if (optCode)
				pkt.writeShort(optCode);
			return pkt;
		}

		/**
		 * 回收数据包到包池
		 * @param pkt
		 */
		public function freePacket(pkt:ByteArray):void
		{
			pkt.clear();
			_packet_pool.push(pkt);
		}

		/**
		 * 对象创建时调用
		 * @param guidObject
		 *
		 */
		protected function onObjectNew(guid:String, guidObject:GuidObject):void
		{
			_newEvent.DispatchString(guid, guidObject);
		}

		/**
		 * 对象删除时调用
		 * @param guidObject
		 *
		 */
		protected function onObjectDelete(guid:String, guidObject:GuidObject):void
		{
			_delEvent.DispatchString(guid, guidObject);
		}

		/**
		 * 获取所有数据
		 * @return
		 *
		 */
		public function get objs():Dictionary
		{
			return _objs;
		}
		
		/*移除对象*/
		protected function removeObject(guid:String, obj:GuidObject):void{
			onObjectDelete(guid, obj);
			var evFilter:SyncEventFilter = _indexer.matchObject(obj);
			//对象消失了					
			if(evFilter != null){	
				evFilter.beginPush(obj);
				evFilter.pushDelete();
				evFilter.endPush();
			}
			ReleaseKey(guid);
		}

		/**
		 * 清理对象
		 */		
		public function clearObjs():void{
			for (var key:String in _objs){
				if(_objs[key] is GuidObject){
					var obj:GuidObject = _objs[key];
					removeObject(obj.guid, obj);
					obj.dispose();
				}
				delete _objs[key];
			}
		}

		public function dispose():void
		{
			clearObjs();
			_newEvent.Clear();
			_delEvent.Clear();
			_indexer.dispose();
		}
	}
}
