package tempest.data.obj
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import tempest.common.obj.ISyncEventRecorder;

	/**
	 * 这个类主要包含以下功能
	 * 1)下标的容器(_uint32_values)
	 * 2)事件(下标监听/原子操作)添加监听及响应
	 * @author zhangyong
	 *
	 */
	public class SyncEventRecorder extends SyncEvent implements ISyncEventRecorder
	{
		/**用于监听下标变化*/
		private var _events_value:EventDispatcher=new EventDispatcher();
		/**用于监听字符下标变化*/
		private var _events_str_values:EventDispatcher=new EventDispatcher();
		/**用于事件回调*/
		private var _events_callback:EventDispatcher=new EventDispatcher();
		/*整形下标长度*/
		protected var _uint32_values_len:uint=0;
		//将所有
		protected var _uint32_values:Vector.<uint>=new Vector.<uint>();
		/*字符串下标长度*/
		protected var _str_values_len:uint=0;
		//字符串下标值
		protected var _str_values:Vector.<String>=new Vector.<String>();
		//对象的唯一ID
		protected var _guid:String="";

		public function get guid():String
		{
			if (_guid == "")
			{
				_guid=GetStr(0) || "";
				_uguid=GuidObject.getGUIDIndex(_guid);
			}
			return _guid;
		}

		public function set guid(s:String):void
		{
			_guid=s;
			_uguid=GuidObject.getGUIDIndex(s);
		}
		private var _uguid:uint;

		public function get uguid():uint
		{
			return _uguid;
		}

		public function SyncEventRecorder()
		{
			super();
		}

		/**
		 * 重置整个对象,下标清零
		 */
		public function Reset():void
		{
			_events_value.Clear();
			_events_str_values.Clear();
			_events_callback.Clear();
			clearValues();
		}

		/*清理下标*/
		[inline]
		private function clearValues():void
		{
			_uint32_values_len=0;
			_uint32_values.length=_uint32_values_len;
			_str_values_len=0;
			_str_values.length=_str_values_len;
		}

		[inline]
		protected function checkIntSize(index:int):void
		{
			while (index >= _uint32_values_len)
			{
				//以8的倍数扩张
				_uint32_values_len+=8;
			}
			_uint32_values.length=_uint32_values_len;
		}

		[inline]
		protected function checkStrSize(index:int):void
		{
			while (index >= _str_values_len)
			{
				//以8的倍数扩张
				_str_values_len+=8;
			}
			_str_values.length=_str_values_len;
		}

		private function OnEventSyncBinLog(binlog:BinLogStru):void
		{
			if (binlog.typ == TYPE_STRING)
				tmpStrMask.SetBit(binlog.index);
			else
				tmpIntMask.SetBit(binlog.index);
			//如果是从模式的原子操作则触发回调
			if (binlog.atomic_opt)
			{
				_events_callback.DispatchInt(binlog.callback_idx, binlog);
			}
			else if (binlog.typ == TYPE_STRING)
			{
				_events_str_values.DispatchInt(binlog.index, binlog);
			}
			else
			{
				_events_value.DispatchInt(binlog.index, binlog);
			}
		}

		protected function dispatchSyncEvent(binlog:BinLogStru):void
		{
			if (binlog.typ == TYPE_STRING)
			{
				_events_str_values.DispatchInt(binlog.index, binlog);
			}
			else
			{
				_events_value.DispatchInt(binlog.index, binlog);
			}
		}

		/**
		 * 监听对象在下标变化
		 * @param index 下标值
		 * @param callback 回调格式function(binlog:BinLogStru):void
		 * @param isExecute 是否马上执行 马上执行时的参数是null
		 */
		public function AddListen(index:int, callback:Function, isExecute:Boolean=false):void
		{
			_events_value.AddListenInt(index, callback);
			isExecute && (callback(null));
		}

		public function AddListenLen(startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				AddListen(index, callback, false);
			}
			isExecute && (callback(null));
		}

		/**
		 * 移除监听对象在下标变化
		 * @param index 下标值
		 * @param callback 回调格式function(binlog:BinLogStru):void
		 */
		public function removeListene(index:int, callback:Function=null):void
		{
			_events_value.removeListenerInt(index, callback);
		}

		public function removeListeneLen(startIndex:int, endIndex:int, callback:Function=null):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				removeListene(index, callback);
			}
		}

		/**
		 * 监听对象在下标变化
		 * @param index 下标值
		 * @param callback 回调格式function(binlog:BinLogStru):void
		 * @param isExecute 是否马上执行 马上执行时的参数是null
		 */
		public function AddListenString(index:int, callback:Function, isExecute:Boolean=false):void
		{
			_events_str_values.AddListenInt(index, callback);
			isExecute && callback(null);
		}

		public function AddListenStringLen(startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				AddListenString(index, callback, false);
			}
			isExecute && callback(null);
		}

		/**
		 * 移除监听对象在下标变化
		 * @param index 下标值
		 * @param callback 回调格式function(binlog:BinLogStru):void
		 */
		public function removeListeneString(index:int, callback:Function=null):void
		{
			_events_str_values.removeListenerInt(index, callback);
		}

		public function removeListeneStringLen(startIndex:int, endIndex:int, callback:Function=null):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				removeListeneString(index, callback);
			}
		}

		[inline]
		public function GetDouble(index:int):Number
		{
			if (index + 1 < _uint32_values_len)
				return GetDoubleValue(_uint32_values, index);
			return 0;
		}

		[inline]
		public function GetUInt32(index:int):uint
		{
			if (index < _uint32_values_len)
				return _uint32_values[index];
			return 0;
		}

		[inline]
		public function GetUint32ByBegin(beginIndex:int, offset:int):uint
		{
			var index:int=beginIndex + offset;
			return GetUInt32(index);
		}

		[inline]
		public function GetInt32(index:int):int
		{
			if (index < _uint32_values_len)
				return int(_uint32_values[index] - 0xFFFFFFFF) - 1;
			return 0;
		}

		[inline]
		public function GetInt32ByBegin(beginIndex:int, offset:int):int
		{
			var index:int=beginIndex + offset;
			return GetInt32(index);
		}

		[inline]
		public function GetUInt16(index:int, offset:int):uint
		{
			if (index < _uint32_values_len)
				return GetUInt16Value(_uint32_values[index], offset);
			return 0;
		}

		[inline]
		public function GetUint16ByBegin(beginIndex:int, offset:int):uint
		{
			var index:int=beginIndex + (Math.floor((offset + 1)) / 2);
			var $offset:int=offset % 2;
			return GetUInt16(index, $offset);
		}

		[inline]
		public function GetInt16(index:int, offset:int):int
		{
			if (index < _uint32_values_len)
				return GetInt16Value(_uint32_values[index], offset);
			return 0;
		}

		[inline]
		public function GetInt16ByBegin(beginIndex:int, offset:int):int
		{
			var index:int=beginIndex + (Math.floor((offset + 1)) / 2);
			var $offset:int=offset % 2;
			return GetInt16(index, $offset);
		}

		[inline]
		public function GetFloat(index:int):Number
		{
			if (index < _uint32_values_len)
				return GetFloatValue(_uint32_values[index]);
			return 0;
		}

		[inline]
		public function GetByte(index:int, offset:int):uint
		{
			if (index < _uint32_values_len)
				return GetByteValue(_uint32_values[index], offset);
			return 0;
		}

		[inline]
		public function GetByteByBegin(beginIndex:int, offset:int):uint
		{
			var index:int=beginIndex + (Math.floor((offset + 1) / 4));
			var $offset:int=offset % 4;
			return GetByte(beginIndex, $offset);
		}

		[inline]
		public function GetBit(index:int, offset:int):Boolean
		{
			index=index + (offset >> 5);
			if (index < _uint32_values_len)
				return (Boolean)(_uint32_values[index] >> (offset & 31) & 1);
			return false;
		}

		[inline]
		public function GetBitByBegin(beginIndex:int, offset:int):Boolean
		{
			var index:int=beginIndex + Math.floor((offset + 1) / 32);
			var $offset:int=offset % 32;
			return GetBit(index, $offset);
		}

		[inline]
		public function GetStr(index:int):String
		{
			if (index < _str_values_len)
				return _str_values[index] || "";
			return "";
		}

		///////////////////////////////////////////////////////////////////////////////////////////
		//以下为对象传输相关
		///////////////////////////////////////////////////////////////////////////////////////////
		private function ReadValues(mask:UpdateMask, bytes:ByteArray, isAto:Boolean, obj:Object, isNew:Boolean):Boolean
		{
			var length:int=mask.GetCount();
			for (var i:int=0; i < length; i++)
			{
				if (mask.GetBit(i))
				{
					checkIntSize(i);
					//从模式需要抛出事件
					var binlog:BinLogStru=(!isNew || _events_value.hasListenInt(i)) ? BinLogStru.malloc() : null;
					if (binlog)
					{
						binlog.typ=TYPE_UINT32;
						binlog.index=i;
						binlog.old_value=_uint32_values[i];
					}
					_uint32_values[i]=bytes.readUnsignedInt();
					if (binlog)
					{
						binlog.value=_uint32_values[i];
						_events_value.DispatchInt(binlog.index, binlog);
						BinLogStru.free(binlog);
					}
				}
			}
			return true;
		}

		private function ReadStringValues(mask:UpdateMask, bytes:ByteArray, isAto:Boolean, obj:Object, isNew:Boolean):Boolean
		{
			var length:int=mask.GetCount();
			for (var i:int=0; i < length; i++)
			{
				if (mask.GetBit(i))
				{
					//这样的性能并不好，但是可以节约内存，而且字符下标的用途比较少
					checkStrSize(i);
					//从模式需要抛出事件
					var binlog:BinLogStru=(!isNew || _events_str_values.hasListenInt(i)) ? BinLogStru.malloc() : null;
					if (binlog)
					{
						binlog.index=i;
						binlog.typ=TYPE_STRING;
						binlog.old_str=_str_values[i];
					}
					_str_values[i]=bytes.readUTF();
					if (binlog)
					{
						binlog.str=_str_values[i];
						_events_str_values.DispatchInt(binlog.index, binlog);
						BinLogStru.free(binlog);
					}
				}
			}
			return true;
		}

		/**
		 * 数字下标创建包掩码
		 * @param mask
		 */
		private function GetCreateMask(mask:UpdateMask):void
		{
			mask.Clear();
			for (var i:int=0; i < _uint32_values_len; i++)
			{
				//如果该下标不等于0则需要下发								
				if (_uint32_values[i])
					mask.SetBit(i);
			}
		}

		/**
		 * 字符串创建包掩码
		 * @param mask
		 */
		private function GetCreateStringMask(mask:UpdateMask):void
		{
			mask.Clear();
			for (var i:int=0; i < _str_values_len; i++)
			{
				if (_str_values[i] && _str_values[i].length > 0)
					mask.SetBit(i);
			}
		}

		private function ApplyAtomicBinLog(binlog:BinLogStru, obj:Object):void
		{
			//如果原子操作类型等于成功或者失败则执行回调
			if (binlog.atomic_opt == ATOMIC_OPT_RESULT_FAILED || binlog.atomic_opt == ATOMIC_OPT_RESULT_OK)
			{
				_events_callback.DispatchInt(binlog.callback_idx, binlog);
				return;
			}
			//字符串分支
			if (binlog._typ == TYPE_STRING)
			{
				//如果越界了就扩张
				checkStrSize(binlog._index);
				//如果不等就操作失败
				if (binlog._old_value_str != _str_values[binlog._index])
				{
					binlog._old_value_str=binlog._value_str;
					binlog._value_str=_str_values[binlog._index];
					binlog._atomic_opt=ATOMIC_OPT_RESULT_FAILED;
				}
				else
				{
					binlog._atomic_opt=ATOMIC_OPT_RESULT_OK;
					//应用完后记录一下准备回去了
					ApplyBinLog(binlog, obj);
				}
				return;
			}
			//其他类型,目前仅仅支持uint32/int32类型
			//校验长度越界就扩张
			checkIntSize(binlog._index);
			//读取u32进行比较			
			var cur_val:uint=_uint32_values[binlog.index];
			if (binlog._old_value_u32 != cur_val)
			{
				binlog._old_value_u32=binlog._value_u32;
				binlog._value_u32=cur_val;
				binlog._atomic_opt=ATOMIC_OPT_RESULT_FAILED;
			}
			else
			{
				binlog._atomic_opt=ATOMIC_OPT_RESULT_OK;
				//应用完后记录一下准备回去了
				ApplyBinLog(binlog, obj);
			}
		}

		/**
		 * 将binlog的操作实施到对象，并且如果就主模式，转换binlog得到
		 * 这个函数会把转
		 * @param binlog
		 */
		private function ApplyBinLog(binlog:BinLogStru, obj:Object):void
		{
			var index:int=binlog.index;
			//字符串直接处理掉了
			if (binlog._typ == TYPE_STRING)
			{
				checkStrSize(index);
				binlog.old_str=_str_values[index] ? _str_values[index] : ""; //保存旧值 
				_str_values[index]=binlog._value_str;
				return;
			}
			//记录一下旧值
			if (binlog.typ == TYPE_DOUBLE)
			{
				if (_uint32_values_len > index + 1)
				{
					binlog._old_value_dbe=GetDoubleValue(_uint32_values, index);
				}
				checkIntSize(index + 1);
			}
			else
			{
				if (binlog.typ != TYPE_BIT && _uint32_values_len > index /*&& binlog.opt != OPT_SET*/)
				{
					binlog.old_value=_uint32_values[index];
				}
				checkIntSize(index);
			}
			//因为uint32不需要偏移，所以单独写
			if (binlog.typ == TYPE_UINT32 || binlog.typ == TYPE_INT32 || binlog.typ == TYPE_FLOAT)
			{
				switch (binlog.opt)
				{
					case OPT_SET:
						_uint32_values[index]=binlog.uint32;
						break;
					case OPT_ADD:
						_uint32_values[index]=_uint32_values[index] + binlog.uint32;
						break;
					case OPT_SUB:
						_uint32_values[index]=_uint32_values[index] - binlog.uint32;
						break;
				}
			}
			else if (binlog.typ == TYPE_DOUBLE)
			{
				switch (binlog.opt)
				{
					case OPT_SET:
						SetDoubleValue(_uint32_values, index, binlog.double);
						break;
					case OPT_ADD:
						var d:Number=GetDoubleValue(_uint32_values, index);
						d+=binlog.double;
						SetDoubleValue(_uint32_values, index, d);
						break;
					case OPT_SUB:
						var dd:Number=GetDoubleValue(_uint32_values, index);
						dd-=binlog.double;
						SetDoubleValue(_uint32_values, index, dd);
						break;
				}
			}
			else if (binlog.typ == TYPE_BIT)
			{
				switch (binlog.opt)
				{
					case OPT_SET:
						_uint32_values[index]=SetBitValue(_uint32_values[index], 1, binlog.uint32);
						break;
					case OPT_UNSET:
						_uint32_values[index]=SetBitValue(_uint32_values[index], 0, binlog.uint32);
						break;
					default:
						throw "JLC_BinLogObject_BIT:op type is error.";
				}
			}
			else
			{
				var value:uint=0;
				switch (binlog.typ)
				{
					case TYPE_UINT16:
						switch (binlog.opt)
						{
							case OPT_SET:
								value=binlog.uint16;
								_uint32_values[index]=SetUInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							case OPT_ADD:
								value=GetUInt16(index, binlog.offset) + binlog.uint16;
								_uint32_values[index]=SetUInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							case OPT_SUB:
								value=GetUInt16(index, binlog.offset) - binlog.uint16;
								_uint32_values[index]=SetUInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							default:
								throw "JLC_BinLogObject_UINT16:unknow OP type";
						}
						break;
					case TYPE_INT16:
						switch (binlog.opt)
						{
							case OPT_SET:
								value=binlog.int16;
								_uint32_values[index]=SetInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							case OPT_ADD:
								value=GetInt16(index, binlog.offset) + binlog.int16;
								_uint32_values[index]=SetInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							case OPT_SUB:
								value=GetInt16(index, binlog.offset) - binlog.int16;
								_uint32_values[index]=SetInt16Value(_uint32_values[index], value, binlog.offset);
								break;
							default:
								throw "JLC_BinLogObject_UINT16:unknow OP type";
						}
						break;
					case TYPE_UINT8:
						value=0; //这可恶的结构体部局，要玩死人了
						var old:int=GetByteValue(_uint32_values[index], binlog.offset);
						switch (binlog.opt)
						{
							case OPT_SET:
								_uint32_values[index]=SetByteValue(_uint32_values[index], binlog.byte, binlog.offset);
								break;
							case OPT_ADD:
								value=old + value;
								_uint32_values[index]=SetByteValue(_uint32_values[index], value, binlog.offset);
								break;
							case OPT_SUB:
								value=old - value;
								_uint32_values[index]=SetByteValue(_uint32_values[index], value, binlog.offset);
								break;
							default:
								throw "JLC_BinLogObject_UINT8:op type is error.";
						}
						break;
					default:
						throw "JLC_BinLogObject:op type is error.";
				}
			}
		}
		//临时变量,每次读取需要使用的临时变量
		private static var _tmpBinlog:BinLogStru=new BinLogStru();

		public function ReadFrom(flags:int, bytes:ByteArray, obj:Object):Boolean
		{
			var isNew:Boolean=Boolean(flags & OBJ_OPT_NEW);
			//创建包需要将所有的值清空
			if (isNew)
			{
				clearValues();
			}
			//创建包或更新包
			if (isNew || flags & OBJ_OPT_UPDATE)
			{
				//用于更新时使用的掩码				
				tmpIntMask.ReadFrom(bytes);
				tmpStrMask.ReadFrom(bytes);
				//读取整数
				ReadValues(tmpIntMask, bytes, !Boolean(flags & OBJ_OPT_BINLOG), obj, isNew);
				ReadStringValues(tmpStrMask, bytes, !Boolean(flags & OBJ_OPT_BINLOG), obj, isNew);
			}
			//如果更新的话可能还带原子操作
			//binlog更新
			if (flags & OBJ_OPT_BINLOG)
			{
				tmpIntMask.Clear();
				tmpStrMask.Clear();
				var len:int=bytes.readUnsignedShort();
				for (var i:int=0; i < len; i++)
				{
					_tmpBinlog.ReadFrom(bytes);
					if (_tmpBinlog._atomic_opt)
					{
						ApplyAtomicBinLog(_tmpBinlog, obj); //原子操作
					}
					else
					{
						ApplyBinLog(_tmpBinlog, obj);
					}
					OnEventSyncBinLog(_tmpBinlog);
				}
			}
			return true;
		}
		private static var tmpIntMask:UpdateMask=new UpdateMask;
		private static var tmpStrMask:UpdateMask=new UpdateMask;

		public function GetHashCode():uint
		{
			const FNV_offset_basis:uint=2166136261;
			const FNV_prime:uint=16777619;
			var h1:uint=FNV_offset_basis;
			for each (var v:uint in _uint32_values)
			{
				h1^=v;
				h1*=FNV_prime;
			}
			var bytes:ByteArray=new ByteArray;
			bytes.endian=Endian.LITTLE_ENDIAN;
			var h2:uint=FNV_offset_basis;
			bytes.writeMultiByte(_guid, "UTF8");
			for (var i:uint=0; i < bytes.length; i++)
			{
				h2^=uint(bytes[i]);
				h2*=FNV_prime;
			}
			for each (var s:String in _str_values)
			{
				bytes.clear();
				bytes.writeMultiByte(s ? s : "", "UTF8");
				for (i=0; i < bytes.length; i++)
				{
					h2^=uint(bytes[i]);
					h2*=FNV_prime;
				}
			}
			return h1 ^ (h2 << 1);
		}

		public function Equals(o:SyncEventRecorder):Boolean
		{
			//对所有的length处理一下成最长
			if (_uint32_values_len > o._uint32_values_len)
			{
				o.checkIntSize(_uint32_values_len);
			}
			else if (_uint32_values_len < o._uint32_values_len)
			{
				checkIntSize(o._uint32_values_len);
			}
			if (_str_values_len > o._str_values_len)
			{
				o.checkStrSize(_str_values_len);
			}
			else if (_str_values_len > o._str_values_len)
			{
				checkStrSize(o._str_values_len);
			}
			return GetHashCode() == o.GetHashCode();
		}

		public function set uint32_values(value:Vector.<uint>):void
		{
			_uint32_values=value;
		}

		public function set str_values(value:Vector.<String>):void
		{
			_str_values=value;
		}

		public function get uint32_values():Vector.<uint>
		{
			return _uint32_values;
		}

		public function get str_values():Vector.<String>
		{
			return _str_values;
		}

		public function dispose():void
		{
			clearValues();
			_events_value.Clear();
			_events_str_values.Clear();
			_events_callback.Clear();
		}
	}
}
