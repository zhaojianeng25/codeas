package tempest.common.net.vo {
	import flash.utils.ByteArray;

	public class TByteArray extends ByteArray {
		public function TByteArray(endian:String = "littleEndian") {
			super();
			this.endian = endian;
		}

		/**
		 * 写入定长字符串
		 * 长度不够补零
		 * 长度太长截断
		 * @param val
		 * @param len
		 * @param charSet
		 */
		public function writeLenString(val:String, len:uint, charSet:String = "gb2312"):void {
			var oldLen:uint = this.length;
			this.writeMultiByte(val, charSet);
			this.length = oldLen + len;
			this.position = this.length;
		}

		/**
		 * 按指定编码写入包含长度的字符串
		 * @param val 字符串
		 * @param charSet 编码
		 */
		public function writeString(val:String, charSet:String = "gb2312"):void {
			var oldPos:uint = this.position;
			this.writeShort(0);
			this.writeMultiByte(val, charSet);
			var len:uint = this.position - oldPos - 2;
			this.position = oldPos;
			this.writeShort(len);
			this.position = this.length;
		}

		/**
		 * 读取指定编码字符串
		 * @param charSet 编码
		 */
		public function readString(charSet:String = "auto"):String {
			var l:int = this.readUnsignedShort();
			if (charSet == "auto") {
				charSet = Func.isTextUTF8(this, this.position, l) ? "utf-8" : "gb2312";
			}
			return this.readMultiByte(l, charSet);
		}

		/**
		 * 读取Int64位
		 * @return
		 */
		public function readInt64():Number {
			var long_h:uint;
			var long_l:uint;
			//C++传过来的数据包是打过pack的 所以字节流里 低位在前
			long_l = this.readUnsignedInt();
			long_h = this.readUnsignedInt();
			if (this.endian == "littleEndian")
				return long_l * 4294967296.0 + long_h; // 4294967296 = 2^32
			else
				return long_h * 4294967296.0 + long_l; // 4294967296 = 2^32
		}

		/**
		 * 写入Int64
		 * @param value 值不能大于2的53次方
		 */
		public function writeInt64(value:Number):void {
			var long_l:uint = uint(value);
			var long_h:uint = (value - long_l) / 4294967296.0;
			if (this.endian == "littleEndian") {
				this.writeUnsignedInt(long_l);
				this.writeUnsignedInt(long_h);
			} else {
				this.writeUnsignedInt(long_h);
				this.writeUnsignedInt(long_l);
			}
		}

		public override function toString():String {
			var str:String = "";
			for (var i:uint = 0; i != this.length; i++) {
				str += int(this[i]).toString(16).toUpperCase() + " ";
			}
			return "TByteArray(length:" + this.length + " position:" + this.position + " bytes:" + str + ")";
		}
	}
}
