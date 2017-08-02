package com.zcp._special.codemix
{
	import flash.utils.ByteArray;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	/**
	 * @private
	 * ZZip 
	 * @author zcp
	 */	
	public class ZZip
	{
		public function ZZip()
		{
		}
		//从压缩文件中抽取String
		//-----------------------------------------------------------------------------------------------------------
		/**
		 * 从压缩二进制数据中抽取第一个文本文件
		 * @param $bytes
		 * @param $decode
		 * @return fileContent:String
		 * 
		 */		
		public static function extractFristTextFileContent($bytes:ByteArray, $decode:Function=null):String {
			
			var arr:Array = extractTextFiles($bytes,$decode);
			if(arr&&arr.length>0)
			{
				return arr[0][1];
			}
			return "";
		}
		/**
		 * 从压缩二进制数据中抽取文本文件
		 * @param $bytes
		 * @param $decode
		 * @return [[fileName:String, fileContent:String]...]
		 * 
		 */		
		private static function extractTextFiles($bytes:ByteArray, $decode:Function=null):Array {
			var bytes:ByteArray = $bytes;
			
			var arr:Array = [];
			//解压缩
			var zipFile:ZipFile = new ZipFile(bytes);
			var i:int;
			var entry:ZipEntry;
			var len:int = zipFile.entries.length;
			for(i=0; i < len; i++) {
				//获取压缩包中的一个文件
				entry = zipFile.entries[i];
				bytes = zipFile.getInput(entry);
				//解密
				if($decode!=null)
				{
					bytes = $decode(bytes);
				}
				//输出
				bytes.position = 0;
				arr.push([entry.name, bytes.readUTFBytes(bytes.bytesAvailable)]);
			}
			
			return arr;
		}
		//-----------------------------------------------------------------------------------------------------------
		//从压缩文件中抽取ByteArray
		//-----------------------------------------------------------------------------------------------------------
		/**
		 * 从压缩二进制数据中抽取第一个二进制文件
		 * @param $bytes
		 * @param $decode
		 * @return fileContent:String
		 * 
		 */		
		public static function extractFristBinaryFileContent($bytes:ByteArray, $decode:Function=null):ByteArray {
			
			var arr:Array = extractBinaryFiles($bytes,$decode);
			if(arr&&arr.length>0)
			{
				return arr[0][1];
			}
			return new ByteArray();
		}
		/**
		 * 从压缩二进制数据中抽取二进制文件
		 * @param $bytes
		 * @param $decode
		 * @return [[fileName:String, fileContent:ByteArray]...]
		 * 
		 */		
		private static function extractBinaryFiles($bytes:ByteArray, $decode:Function=null):Array {
			var bytes:ByteArray = $bytes;
			
			var arr:Array = [];
			//解压缩
			var zipFile:ZipFile = new ZipFile(bytes);
			var i:int;
			var entry:ZipEntry;
			var len:int = zipFile.entries.length;
			for(i=0; i < len; i++) {
				//获取压缩包中的一个文件
				entry = zipFile.entries[i];
				bytes = zipFile.getInput(entry);
				//解密
				if($decode!=null)
				{
					bytes = $decode(bytes);
				}
				//输出
				bytes.position = 0;
				arr.push([entry.name, bytes]);
			}
			
			return arr;
		}
		//-----------------------------------------------------------------------------------------------------------
	}
}