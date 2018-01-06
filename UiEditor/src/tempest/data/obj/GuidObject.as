package tempest.data.obj
{
	

	/**
	 * guid基础数据对象（用户服务器数据反序列化）
	 * @author zhangyong
	 *
	 */
	public class GuidObject extends SyncEventRecorder
	{
		/**场景显示对象*/
		public var displayObject:Object;
		/**所有binlog的guid位置*/
		public static const BINLOG_STRING_FIELD_GUID:uint=0;
		/**所有binlog的name位置*/
		public static const BINLOG_STRING_FIELD_NAME:uint=1;
		/**所有binlog的版本信息位置*/
		public static const BINLOG_STRING_FIELD_VERSION:uint=2;
		/**所有binlog的owner位置*/
		public static const BINLOG_STRING_FIELD_OWNER:uint=3;
		/**引用计数*/
		protected var _ref:int=0;

		/**
		 * 增加引用计数
		 * @param r 计数变量,1/-1
		 */
		public function add_ref(r:int):void
		{
			_ref=_ref + r;
		}

		/**
		 * 当引用计数小于等于0的时候就可以从对象表中被释放了
		 */
		public function get ref():int
		{
			return _ref;
		}

		public function GuidObject(g:String="")
		{
			super();
			guid=g;
		}

		/////////////////////////////////////////////////////////////////////
		//以下为下标操作相关		
		/////////////////////////////////////////////////////////////////////
		public function SetDouble(index:int, value:Number):void
		{
			//如果空间不够就自动增长
			checkIntSize(index + 1);
			SetDoubleValue(_uint32_values, index, value);
		}

		public function AddDouble(index:int, value:Number):void
		{
			//如果空间不够就自动增长
			checkIntSize(index + 1);
			var d:Number=GetDoubleValue(_uint32_values, index);
			d+=value;
			SetDoubleValue(_uint32_values, index, d);
		}

		public function SubDouble(index:int, value:Number):void
		{
			//如果空间不够就自动增长
			checkIntSize(index + 1);
			var d:Number=GetDoubleValue(_uint32_values, index);
			d-=value;
			SetDoubleValue(_uint32_values, index, d);
		}

		public function SetUInt32(index:int, value:uint):void
		{
			//如果空间不够就自动增长
			checkIntSize(index);
			_uint32_values[index]=value;
		}

		public function AddUInt32(index:int, value:uint):void
		{
			//取出数据 并执行加法运算
			_uint32_values[index]+=value;
		}

		public function SubUInt32(index:int, value:uint):void
		{
			//取出数据 并执行减法运算
			_uint32_values[index]-=value;
		}

		public function SetInt32(index:int, value:int):void
		{
			//如果空间不够就自动增长
			checkIntSize(index);
			_uint32_values[index]=SetInt32Value(value);
		}

		public function AddInt32(index:int, value:int):void
		{
			//取出数据 并执行加法运算
			var v:int=GetInt32(index);
			v+=value;
			_uint32_values[index]=SetInt32Value(v);
		}

		public function SubInt32(index:int, value:int):void
		{
			//取出数据 并执行减法运算
			var v:int=GetInt32(index);
			v-=value;
			_uint32_values[index]=SetInt32Value(v);
		}

		public function SetUInt16(index:int, offset:int, value:uint):void
		{
			//如果空间不够就自动增长
			checkIntSize(index);
			_uint32_values[index]=SetUInt16Value(_uint32_values[index], value, offset);
		}

		public function AddUInt16(index:int, offset:int, value:uint):void
		{
			//取出数据 并执行加法运算
			checkIntSize(index);
			_uint32_values[index]=SetUInt16Value(_uint32_values[index], GetUInt16(index, offset) + value, offset);
		}

		public function SubUInt16(index:int, offset:int, value:uint):void
		{
			checkIntSize(index);
			//取出数据 并执行加法运算			
			_uint32_values[index]=SetUInt16Value(_uint32_values[index], GetUInt16(index, offset) - value, offset);
		}

		public function SetInt16(index:int, offset:int, value:int):void
		{
			//如果空间不够就自动增长
			checkIntSize(index);
			_uint32_values[index]=SetInt16Value(_uint32_values[index], value, offset);
		}

		public function AddInt16(index:int, offset:int, value:int):void
		{
			//取出数据 并执行加法运算
			checkIntSize(index);
			var v:int=GetInt16Value(_uint32_values[index], offset);
			v+=value;
			_uint32_values[index]=SetInt16Value(_uint32_values[index], v, offset);
		}

		public function SubInt16(index:int, offset:int, value:int):void
		{
			//取出数据 并执行加法运算
			var v:int=GetInt16Value(_uint32_values[index], offset);
			v-=value;
			_uint32_values[index]=SetInt16Value(_uint32_values[index], v, offset);
		}

		public function SetFloat(index:uint, v:Number):void
		{
			//如果空间不够就自动增长			
			checkIntSize(index);
			_uint32_values[index]=SetFloatValue(v);
		}

		public function SetByte(index:int, offset:int, value:int):void
		{
			//如果空间不够就自动增长
			checkIntSize(index);
			_uint32_values[index]=SetByteValue(_uint32_values[index], value, offset);
		}

		public function AddByte(index:int, offset:int, value:int):void
		{
			checkIntSize(index);
			var v:int=GetByteValue(_uint32_values[index], offset);
			v+=value;
			_uint32_values[index]=SetByteValue(_uint32_values[index], v, offset);
		}

		public function SubByte(index:int, offset:int, value:int):void
		{
			checkIntSize(index);
			var v:int=GetByteValue(_uint32_values[index], offset);
			v-=value;
			_uint32_values[index]=SetByteValue(_uint32_values[index], v, offset);
		}

		public function SetStr(index:int, val:String):void
		{
			checkStrSize(index);
			_str_values[index]=val;
		}

		public function SetBit(index:int, offset:int):void
		{
			index=index + (offset >> 5);
			offset&=31;
			checkIntSize(index);
			//转换下标第几个字节
			_uint32_values[index]=SetBitValue(_uint32_values[index], 1, offset);
		}

		public function UnSetBit(index:int, offset:int):void
		{
			//转换下标第几个字节
			index=index + (offset >> 5);
			offset&=31;
			if (index < _uint32_values_len)
			{
				//转成以字节为单位
				_uint32_values[index]=SetBitValue(_uint32_values[index], 0, offset);
			}
		}

		/**
		 *
		 * @param index
		 * @param value
		 * @param type
		 *
		 */
		public function setValue(index:int, value:*, type:int=SyncEvent.TYPE_INT32):void
		{
			var oldValue:*;
			var binlog:BinLogStru=BinLogStru.malloc();
			binlog.typ=type;
			binlog.index=index;
			switch (type)
			{
				case SyncEvent.TYPE_INT32:
					oldValue=GetInt32(index);
					SetInt32(index, value);
					binlog._old_value_u32=oldValue;
					binlog.value=value;
					break;
				case SyncEvent.TYPE_UINT32:
					if (value < 0)
					{
						value=0;
					}
					oldValue=GetUInt32(index);
					SetUInt32(index, uint(value));
					binlog._old_value_u32=uint(oldValue);
					binlog.value=uint(value);
					break;
				case SyncEvent.TYPE_DOUBLE:
					oldValue=GetDouble(index);
					SetDouble(index, Number(value));
					binlog._old_value_dbe=Number(oldValue);
					binlog._value_dbe=Number(value);
					break;
				case SyncEvent.TYPE_STRING:
					oldValue=GetStr(index);
					SetStr(index, value.toString());
					binlog._old_value_str=oldValue.toString();
					break;
			}
			if (oldValue != value)
			{
				dispatchSyncEvent(binlog);
			}
			BinLogStru.free(binlog);
		}

		/**
		 * 通过字符串对对象的int32下标赋值
		 *
		 */
		public function readInt32ValueFromIntVector(uint32_values:Vector.<uint>):void
		{
			updateProps(this, uint32_values);
		}

		/**
		 * 通过字符串对对象的字符串下标赋值
		 *
		 */
		public function readStringValueFromStringVector(string_values:Vector.<String>):void
		{
			updateProps(this, string_values, true);
		}

		/**
		 * 通过字符串对对象的int32下标赋值
		 *
		 */
		public function readInt32ValueFromArray(propertys:Array):void
		{
			updateProps(this, propertys);
		}

		/**
		 * 通过字符串对对象的字符串下标赋值
		 *
		 */
		public function readStringValueFromString(propertyString:String):void
		{
			var propertys:Array=propertyString.split("|");
			updateProps(this, propertys, true);
		}

		/**
		 * 更新对象属性
		 * @param obj 对象
		 * @param props 对象属性列表
		 * @param isString 是否字符串下表
		 *
		 */
		public static function updateProps(obj:*, props:*, isString:Boolean=false):void
		{
			var guidobj:GuidObject=(obj as GuidObject);
			if (!guidobj)
			{
				return;
			}
			var iter:int;
			var len:int=props.length;
			for (; iter != len; iter++)
			{
				if (isString)
				{
					guidobj.SetStr(iter, props[iter]);
				}
				else
				{
					guidobj.SetUInt32(iter, props[iter]);
				}
			}
		}


		public static function getGUIDIndex(s:String):uint
		{
			if (!s)
			{
				return 0;
			}
			var idx:Number=s.indexOf(".");
			idx=idx > 0 ? idx - 1 : Number.MAX_VALUE;
			return uint(s.substr(1, idx));
		}

		/**
		 * 释放
		 *
		 */
		override public function dispose():void
		{
			super.dispose();
			displayObject=null;
		}


	}
}


