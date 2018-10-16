package tempest.data.obj
{
	import flash.utils.ByteArray;

	import tempest.common.obj.IBinLogStru;

	/**
	 * 用于标识下对象的一步操作(包括对下标的加减设置)
	 * @author linbc
	 *
	 */
	public class BinLogStru extends SyncEvent implements IBinLogStru
	{

		private static var _pool:Vector.<BinLogStru>=new Vector.<BinLogStru>();

		/*获得一个可以使用的对象*/
		public static function malloc():BinLogStru
		{
			if (_pool.length == 0)
			{
				return new BinLogStru();
			}
			return _pool.pop();
		}

		public static function free(ptr:BinLogStru):void
		{
			ptr.Clear();
			_pool[_pool.length]=ptr;
		}

		//操作类型
		public var _opt:int;

		//变量类型
		public var _typ:int;

		//下标
		public var _index:int;

		//标识原子操作模式 看AtomicOptResult
		public var _atomic_opt:int;

		public var _value_u32:uint;
		public var _value_dbe:Number
		public var _value_str:String;

		public var _callback_index:uint;

		public var _old_value_u32:uint;
		public var _old_value_dbe:Number
		public var _old_value_str:String;

		public function BinLogStru()
		{
			Clear();
		}

		public function get opt():int
		{
			return _opt;
		}

		public function set opt(o:int):void
		{
			_opt=o;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(i:int):void
		{
			_index=i;
		}

		public function get offset():int
		{
			return GetByteValue(_value_u32, 0);
		}

		public function set offset(val:int):void
		{
			_value_u32=SetByteValue(_value_u32, val, 0);
		}

		public function get typ():int
		{
			return _typ;
		}

		public function set typ(t:int):void
		{
			_typ=t;
		}

		public function get atomic_opt():int
		{
			return _atomic_opt;
		}

		public function set atomic_opt(val:int):void
		{
			_atomic_opt=val;
		}

		public function get callback_idx():int
		{
			return _callback_index;
		}

		public function set callback_idx(val:int):void
		{
			_callback_index=val;
		}

		public function get uint32():uint
		{
			return _value_u32;
		}

		public function set uint32(val:uint):void
		{
			_typ=TYPE_UINT32;
			_value_u32=val;
		}

		public function get int32():int
		{
			if (_typ != TYPE_INT32)
				throw new Error("get int32 but _typ != TYPE_INT32!");
			return int(_value_u32 - 0xFFFFFFFF) - 1;
		}

		public function set int32(val:int):void
		{
			_typ=TYPE_INT32;
			_value_u32=uint(0xFFFFFFFF + val) + 1;
		}

		public function set bit(val:int):void
		{
			_typ=TYPE_BIT;
			_value_u32=val;
		}

		public function get bit():int
		{
			if (_typ != TYPE_BIT)
				throw new Error("get bit but _typ != TYPE_BIT");
			return _value_u32;
		}

		public function get old_int32():int
		{
			if (_typ != TYPE_INT32)
				throw new Error("get int32 but _typ != TYPE_INT32!");
			return int(_old_value_u32 - 0xFFFFFFFF) - 1;
		}

		public function set old_int32(val:int):void
		{
			if (_typ != TYPE_INT32)
				throw new Error("get int32 but _typ != TYPE_INT32!");
			_old_value_u32=uint(0xFFFFFFFF + val) + 1;
		}

		public function get uint16():int
		{
			if (_typ != TYPE_UINT16)
				throw new Error("get uint16 but _typ != TYPE_UINT16!");
			return GetUInt16Value(_value_u32, 1);
		}

		public function set uint16(val:int):void
		{
			_typ=TYPE_UINT16;
			_value_u32=SetUInt16Value(_value_u32, val, 1);
		}

		public function get int16():int
		{
			if (_typ != TYPE_INT16)
				throw new Error("get int16 but _typ != TYPE_INT16!");
			return GetInt16Value(_value_u32, 1);
		}

		public function set int16(val:int):void
		{
			_typ=TYPE_INT16;
			_value_u32=SetInt16Value(_value_u32, val, 1);
		}

		public function get byte():int
		{
			if (_typ != TYPE_UINT8)
				throw new Error("get uint8 but _typ != TYPE_UINT8!");
			return GetByteValue(_value_u32, 2);
		}

		public function set byte(val:int):void
		{
			_typ=TYPE_UINT8;
			_value_u32=SetByteValue(_value_u32, val, 2);
		}

		public function get double():Number
		{
			return _value_dbe;
		}

		public function set double(val:Number):void
		{
			_value_dbe=val;
		}

		public function get old_double():Number
		{
			return _old_value_dbe
		}

		public function get float():Number
		{
			return GetFloatValue(_value_u32);
		}

		public function set float(val:Number):void
		{
			_value_u32=SetFloatValue(val);
		}

		public function get str():String
		{
			if (_typ != TYPE_STRING)
				throw new Error("get str but _typ != TYPE_STRING!");
			return _value_str;
		}

		public function set str(v:String):void
		{
			_typ=TYPE_STRING;
			_value_str=v;
		}

		public function get old_str():String
		{
			if (_typ != TYPE_STRING)
				throw new Error("get old_str but _typ != TYPE_STRING!");
			return _old_value_str;
		}

		public function set old_str(v:String):void
		{
			if (_typ != TYPE_STRING)
				throw new Error("set old_str but _typ != TYPE_STRING!");
			_old_value_str=v;
		}

		public function get value():uint
		{
			return _value_u32;
		}

		public function set value(v:uint):void
		{
			_value_u32=v;
		}

		public function get old_value():uint
		{
			return _old_value_u32;
		}

		public function set old_value(v:uint):void
		{
			_old_value_u32=v;
		}

		public function Clear():void
		{
			_opt=0;
			_typ=0;
			_index=0;

			_atomic_opt=SyncEvent.ATOMIC_OPT_RESULT_NO;

			_value_u32=0;
			_value_dbe=0;
			_value_str="";

			_callback_index=0;

			_old_value_u32=0;
			_old_value_dbe=0;
			_old_value_str="";
		}

		public function ReadFrom(bytes:ByteArray):Boolean
		{
			_opt=bytes.readUnsignedByte();
			_typ=bytes.readUnsignedByte();
			_index=bytes.readUnsignedShort();
			_atomic_opt=bytes.readUnsignedByte();

			//除了字符串，其他的都通过无符号整形进行转换
			if (_typ == TYPE_STRING)
			{
				_value_str=bytes.readUTF();
			}
			else if (_typ == TYPE_DOUBLE)
			{
				_value_dbe=bytes.readDouble();
			}
			else
			{
				_value_u32=bytes.readUnsignedInt();
			}

			if (_atomic_opt)
			{
				_callback_index=bytes.readUnsignedInt();
				if (_typ == TYPE_STRING)
				{
					_old_value_str=bytes.readUTF();
				}
				else if (_typ == TYPE_DOUBLE)
				{
					_old_value_dbe=bytes.readDouble();
				}
				else
				{
					_old_value_u32=bytes.readUnsignedInt();
				}
			}
			return true;
		}

		public function WriteTo(bytes:ByteArray):void
		{
			bytes.writeByte(_opt);
			bytes.writeByte(_typ);
			bytes.writeShort(_index);
			bytes.writeByte(_atomic_opt); //输出非原子操作

			//如果是字符串
			if (_typ == TYPE_STRING)
				bytes.writeUTF(_value_str ? _value_str : "");
			else if (_typ == TYPE_DOUBLE)
				bytes.writeDouble(_value_dbe);
			else
				bytes.writeUnsignedInt(_value_u32);
			//如果是原子操作需要加一些成员
			if (_atomic_opt)
			{
				bytes.writeUnsignedInt(_callback_index);
				if (_typ == TYPE_STRING)
					bytes.writeUTF(_old_value_str ? _old_value_str : "");
				else if (_typ == TYPE_DOUBLE)
					bytes.writeDouble(_old_value_dbe);
				else
					bytes.writeUnsignedInt(_old_value_u32);
			}
		}

		public function clone():BinLogStru
		{
			var binlog:BinLogStru=BinLogStru.malloc();
			binlog._opt=_opt;
			binlog._typ=_typ;
			binlog._index=_index;
			binlog._atomic_opt=_atomic_opt;
			binlog._value_u32=_value_u32;
			binlog._value_dbe=_value_dbe;
			binlog._value_str=_value_str;
			binlog._callback_index=_callback_index;
			binlog._old_value_u32=_old_value_u32;
			binlog._old_value_dbe=_old_value_dbe;
			binlog._old_value_str=_old_value_str;
			return binlog;
		}
	}
}
