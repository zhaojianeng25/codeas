package tempest.data.obj
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class UpdateMask
	{
		private var _bytes:ByteArray;

		public function UpdateMask()
		{
			_bytes=new ByteArray();
			_bytes.endian=Endian.LITTLE_ENDIAN;
		}

		public function get baseByteArray():ByteArray
		{
			return _bytes;
		}

		public function Clear():void
		{
			_bytes.clear();
		}

		/**
		 * 获取掩码数据列表，是否发生更新
		 * @param pos 索引位置
		 * @param len 长度
		 * @return
		 */
		public function GetBits(pos:uint, len:uint=1):Boolean
		{
			for (var i:uint=0; i < len; i++)
			{
				if (GetBit(pos + i))
					return true;
			}
			return false;
		}


		public function GetBit(i:int):Boolean
		{
			if ((i >> 3) < _bytes.length)
				return (_bytes[i >> 3] & (1 << (i & 0x7))) != 0;
			return false;
		}

		public function SetBit(i:int):void
		{
			if (i >> 3 >= _bytes.length)
				_bytes.length=(i >> 3 + 1);
			_bytes[i >> 3]|=(1 << (i & 0x7));
		}

		public function UnSetBit(i:int):void
		{
			if (i < _bytes.length << 3)
				_bytes[i >> 3]&=(0xff ^ (1 << (i & 0x7)));
		}

		public function WriteTo(bytes:ByteArray):Boolean
		{
			_bytes.position=0;
			bytes.writeShort(_bytes.length);
			if (_bytes.length)
				bytes.writeBytes(_bytes);
			return true;
		}

		public function ReadFrom(bytes:ByteArray):Boolean
		{
			//要先清空
			_bytes.clear();
			//先读取uint8的字节数量
			var count:int=bytes.readUnsignedShort();
			_bytes.length=count;
			if (count)
				bytes.readBytes(_bytes, 0, count);
			return true;
		}

		public function GetCount():int
		{
			return _bytes.length << 3;
		}

		public function SetCount(val:int):void
		{
			_bytes.length=(val + 7) >> 3;
		}

		public function empty():Boolean
		{
			for (var i:int=0; i < _bytes.length; i++)
				if (_bytes[i] != 0)
					return false;
			return true;
		}

		/**
		 * updateMask的或者掩码操作
		 * @param other
		 */
		public function or(other:UpdateMask):void
		{
			//取丙个掩码字节数组的最大值
			//如果本身长度不够就拉成大的
			var len:int=other._bytes.length;
			if (_bytes.length < len)
				_bytes.length=len;
			for (var i:int=0; i < len; i++)
			{
				_bytes[i]|=other._bytes[i];
			}
		}

		/**
		 * 两个updatemask并且成功
		 * @param other
		 * @return
		 */
		public function test(other:UpdateMask):Boolean
		{
			var len:int=_bytes.length > other._bytes.length ? other._bytes.length : _bytes.length;
			for (var i:int=0; i < len; i++)
			{
				if (_bytes[i] & other._bytes[i])
					return true;
			}
			return false;
		}

		/**
		 * 收缩,把byteArray的长度调整到最合理的位置
		 */
		private function condense():void
		{
			var len:int=_bytes.length;
			while (len > 0)
			{
				len--;
				if (_bytes[len] == 0)
					_bytes.length--;
				else
					break;
			}
		}

		/**
		 * 判断两个掩码是否相等
		 * @param other
		 * @return
		 */
		public function equals(other:UpdateMask):Boolean
		{
			condense();
			other.condense();
			if (_bytes.length != other._bytes.length)
				return false;
			for (var i:int=0; i < _bytes.length; i++)
			{
				//trace(_bytes[i],":",other._bytes[i]);
				if (_bytes[i] != other._bytes[i])
					return false;
			}
			return true;
		}

		/**
		 * 掩码克隆函数
		 * @return
		 */
		public function clone():UpdateMask
		{
			var o:UpdateMask=new UpdateMask;
			for (var i:int=0; i < _bytes.length; i++)
				o._bytes[i]=_bytes[i];
			return o;
		}
	}
}
