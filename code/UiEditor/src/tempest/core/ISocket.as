package tempest.core
{
	import flash.utils.ByteArray;

	/**
	 *
	 * @author wushangkun
	 */
	public interface ISocket
	{
		/**
		 * 输入缓冲区中可读取的数据的字节数。
		 * @return
		 */
		function get bytesAvailable():uint;
		/**
		 * 指示此 Socket 对象目前是否已连接。
		 * @return
		 */
		function get connected():Boolean;
		/**
		 * 指示数据的字节顺序；可能的值为来自 flash.utils.Endian 类的常量、Endian.BIG_ENDIAN 或 Endian.LITTLE_ENDIAN。
		 * @return
		 */
		function get endian():String;
		function set endian(value:String):void;
		/**
		 * 在写入或读取对象时，控制所使用的 AMF 的版本。
		 * @return
		 */
		function get objectEncoding():uint;
		function set objectEncoding(value:uint):void;
		/**
		 * 指示建立连接时需等待的毫秒数。
		 * @return
		 */
		function get timeout():uint;
		function set timeout(value:uint):void;
		/**
		 *关闭套接字。
		 */
		function close():void;
		/**
		 * 将套接字连接到指定的主机和端口。
		 * @param host
		 * @param port
		 */
		function connect(host:String, port:int):void;
		/**
		 * 对套接字输出缓冲区中积累的所有数据进行刷新。
		 */
		function flush():void;
		/**
		 * 从套接字读取一个布尔值。
		 * @return
		 */
		function readBoolean():Boolean;
		/**
		 *从套接字读取一个带符号字节。
		 * @return
		 */
		function readByte():int;
		/**
		 *从套接字读取 length 参数所指定的数据的字节数。
		 * @param bytes
		 * @param offset
		 * @param length
		 */
		function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
		/**
		 *从套接字读取一个 IEEE 754 双精度浮点数。
		 * @return
		 */
		function readDouble():Number;
		/**
		 *从套接字读取一个 IEEE 754 单精度浮点数。
		 * @return
		 */
		function readFloat():Number;
		/**
		 *从套接字读取一个带符号的 32 位整数。
		 * @return
		 */
		function readInt():int;
		/**
		 *使用指定的字符集，从该字节流读取一个多字节字符串。
		 * @param length
		 * @param charSet
		 * @return
		 */
		function readMultiByte(length:uint, charSet:String):String;
		/**
		 *从以 AMF 序列化格式编码的套接字读取一个对象。
		 * @return
		 */
		function readObject():*;
		/**
		 *从套接字读取一个带符号的 16 位整数。
		 * @return
		 */
		function readShort():int;
		/**
		 *从套接字读取一个无符号字节。
		 * @return
		 */
		function readUnsignedByte():uint;
		/**
		 *从套接字读取一个无符号的 32 位整数。
		 * @return
		 */
		function readUnsignedInt():uint;
		/**
		 *从套接字读取一个无符号的 16 位整数。
		 * @return
		 */
		function readUnsignedShort():uint;
		/**
		 *从套接字读取一个 UTF-8 字符串。
		 * @return
		 */
		function readUTF():String;
		/**
		 *从套接字读取 length 参数所指定的 UTF-8 数据的字节数，并返回一个字符串。
		 * @param length
		 * @return
		 */
		function readUTFBytes(length:uint):String;
		/**
		 *将一个布尔值写入套接字。
		 * @param value
		 */
		function writeBoolean(value:Boolean):void;
		/**
		 *将一个字节写入套接字。
		 * @param value
		 */
		function writeByte(value:int):void;
		/**
		 *从指定的字节数组写入一系列字节。
		 * @param bytes
		 * @param offset
		 * @param length
		 */
		function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
		/**
		 *将一个 IEEE 754 双精度浮点数写入套接字。
		 * @param value
		 */
		function writeDouble(value:Number):void;
		/**
		 *将一个 IEEE 754 单精度浮点数写入套接字。
		 * @param value
		 */
		function writeFloat(value:Number):void;
		/**
		 *将一个带符号的 32 位整数写入套接字。
		 * @param value
		 */
		function writeInt(value:int):void;
		/**
		 *使用指定的字符集，从该字节流写入一个多字节字符串。
		 * @param value
		 * @param charSet
		 */
		function writeMultiByte(value:String, charSet:String):void;
		/**
		 *以 AMF 序列化格式将一个对象写入套接字。
		 * @param object
		 */
		function writeObject(object:*):void;
		/**
		 *将一个 16 位整数写入套接字。
		 * @param value
		 */
		function writeShort(value:int):void;
		/**
		 *将一个无符号的 32 位整数写入套接字。
		 * @param value
		 */
		function writeUnsignedInt(value:uint):void;
		/**
		 *将以下数据写入套接字：一个无符号 16 位整数，它指示了指定 UTF-8 字符串的长度（以字节为单位），后面跟随字符串本身。
		 * @param value
		 */
		function writeUTF(value:String):void;
		/**
		 *writeUTFBytes(value:String):void将一个 UTF-8 字符串写入套接字。
		 * @param value
		 */
		function writeUTFBytes(value:String):void;
	}
}
