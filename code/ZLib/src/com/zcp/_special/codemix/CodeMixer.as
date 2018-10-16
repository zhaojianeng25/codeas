package com.zcp._special.codemix
{
	import flash.display.Stage;
	import flash.utils.ByteArray;
	
	/**
	 * @private
	 * CodeMixer 
	 * @author zcp
	 */	
	public class CodeMixer
	{
		public static var key:uint = 123;
		public static var pieceLen:uint = 37;
		public static var skip:uint = 299;
		/**
		 * 加密二进制 
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function encodeBytes(bytes:ByteArray):ByteArray {
			bytes.position = 0;
			var bytesLen:uint = bytes.length;
			var i:uint = 0;
			while (true) {
				for (var j:uint = 0; j < pieceLen; j++) {
					bytes[i] ^= key;
					i++;
					if (i >= bytesLen) break;
				}
				i += skip;
				if (i >= bytesLen) break;
			}
			
			var doneBytes:ByteArray = new ByteArray();
			doneBytes.writeBytes(bytes);
			
			return doneBytes;
		}
		
		/**
		 * 解密二进制数据
		 * @param doneBytes
		 * @return 
		 * 
		 */		
		public static function decodeBytes(bytes:ByteArray):ByteArray {
			bytes.position = 0;
			var newSWFBytes:ByteArray = new ByteArray();
			bytes.readBytes(newSWFBytes);
			var bytesLen:uint = newSWFBytes.length;
			var i:uint = 0;
			while (true) {
				for (var j:uint = 0; j < pieceLen; j++) {
					newSWFBytes[i] ^= key;
					i++;
					
					if (i >= bytesLen)break;
				}
				i += skip;
				if (i >= bytesLen)break;
			}
			
			return newSWFBytes;
		}
	}
}