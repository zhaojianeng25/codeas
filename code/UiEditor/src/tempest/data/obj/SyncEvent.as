package tempest.data.obj
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SyncEvent extends Object
	{
		//为了防止对象更新标识与下标更新标识冲突,所以让对象更新标识占用第2位

		public static const OBJ_OPT_NEW:int=0x01; //新对象
		public static const OBJ_OPT_DELETE:int=0x02; //删除对象
		public static const OBJ_OPT_UPDATE:int=0x04; //对象更新
		public static const OBJ_OPT_BINLOG:int=0x08; //BINLOG方式
		public static const OBJ_OPT_U_GUID:int=0x10; //打包方式ID为整形

		public static const OPT_SET:int=0x01;
		public static const OPT_UNSET:int=0x02;
		public static const OPT_ADD:int=0x04;
		public static const OPT_SUB:int=0x08;

		public static const TYPE_UINT32:int=0;
		public static const TYPE_UINT16:int=1;
		public static const TYPE_UINT8:int=2;
		public static const TYPE_BIT:int=3;
		public static const TYPE_UINT64:int=4;
		public static const TYPE_INT32:int=5;
		public static const TYPE_STRING:int=6;
		public static const TYPE_INT16:int=7;
//		public static const TYPE_INT8 :int = 8;
		public static const TYPE_FLOAT:int=9;
		public static const TYPE_DOUBLE:int=10;

		public static const ATOMIC_OPT_RESULT_NO:int=0; //不是原子操作
		public static const ATOMIC_OPT_RESULT_TRY:int=1; //尝试原子操作
		public static const ATOMIC_OPT_RESULT_OK:int=2; //原子操作成功
		public static const ATOMIC_OPT_RESULT_FAILED:int=-1; //原子操作失败

		public function SyncEvent()
		{
		}

		protected static function GetInt32Value(val:uint):int
		{
			return int(val - 0xFFFFFFFF) - 1;
		}

		protected static function SetInt32Value(val:int):uint
		{
			return uint(val + 1) + 0xFFFFFFFF;
		}

		protected static function GetUInt16Value(vaule:uint, offset:int):uint
		{
			return (vaule & (0x0000FFFF << (offset << 4))) >> (offset << 4) & 0xFFFF;
		}

		protected static function SetUInt16Value(old:uint, value:uint, offset:int):uint
		{
			return old & (0xFFFFFFFF ^ (0xFFFF << (offset << 4))) | (value << (offset << 4));
		}

		protected static function GetInt16Value(vaule:uint, offset:int):int
		{
			var v:int=(vaule & (0x0000FFFF << (offset << 4))) >> (offset << 4) & 0xFFFF;
			return v > 32768 ? v - 65535 : v;
		}

		protected static function SetInt16Value(old:uint, value:int, offset:int):uint
		{
			if (value < 0)
				value+=65535;
			return old & (0xFFFFFFFF ^ (0xFFFF << (offset << 4))) | (value << (offset << 4));
		}

		protected static function GetByteValue(value:uint, offset:int):uint
		{
			return (value & (0x000000FF << (offset << 3))) >> (offset << 3) & 0xFF;
		}

		protected static function SetByteValue(old:uint, value:uint, offset:int):uint
		{
			return old & (0xFFFFFFFF ^ (0xFF << (offset << 3))) | (value << (offset << 3));
		}

		protected static function SetBitValue(old:uint, value:uint, offset:int):uint
		{
			return old & (0xFFFFFFFF ^ (0x1 << offset)) | (value << offset);
		}

		private static var tmpValueBytes:ByteArray=new ByteArray;
		tmpValueBytes.endian=Endian.LITTLE_ENDIAN;

		protected static function GetDoubleValue(_uint32_values:Vector.<uint>, index:int):Number
		{
			tmpValueBytes.position=0;
			tmpValueBytes.writeUnsignedInt(_uint32_values[index]);
			tmpValueBytes.writeUnsignedInt(_uint32_values[index + 1]);
			tmpValueBytes.position=0;
			var v:Number=tmpValueBytes.readDouble();
			return v;
		}

		protected static function SetDoubleValue(_uint32_values:Vector.<uint>, index:int, value:Number):void
		{
			var v:uint;
			tmpValueBytes.position=0;
			tmpValueBytes.writeDouble(value);
			tmpValueBytes.position=0;
			//低位
			v=tmpValueBytes.readUnsignedInt()
			_uint32_values[index]=v;
			//高位
			v=tmpValueBytes.readUnsignedInt()
			_uint32_values[index + 1]=v;
		}

		protected static function SetFloatValue(v:Number):uint
		{
			tmpValueBytes.position=0;
			tmpValueBytes.writeFloat(v)
			tmpValueBytes.position=0;
			;
			return tmpValueBytes.readUnsignedInt();
		}

		protected static function GetFloatValue(v:uint):Number
		{
			tmpValueBytes.position=0;
			tmpValueBytes.writeUnsignedInt(v);
			tmpValueBytes.position=0;
			return tmpValueBytes.readFloat();
		}
	}
}