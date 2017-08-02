package com.zcp.worker.vo
{
	import flash.utils.ByteArray;

	/**
	 * 供WorkThread异步处理完毕返回数据使用，请复写此类，为其扩展属性
	 * 为提升性能最好自己写序列化和反序列化过程
	 * @author ZCP
	 * 
	 */	
	public class WorkReturnData
	{
		public function WorkReturnData()
		{
		}
		/**
		 * 序列化
		 * 注意:
		 * 1.需要设定ByteArray的shareable属性为true
		 * 2.需要在ByteArray最开始写入类名,供反序列化的时候使用
		 * @return 
		 * 
		 */		
		public function toByteArray():ByteArray
		{
			//			var bytes:ByteArray = new ByteArray();
			//			bytes.shareable = true;//Worker之间共享
			//			bytes.writeUTF(getQualifiedClassName(this));//写入类名
			//			bytes.writeObject(this);//最简单的序列化
			//			return bytes;
			throw new Error("需要复写序列化");
			return null;
		}
		/**
		 * 返序列化
		 * @return 
		 * 
		 */		
		public function fromByteArray($bytes:ByteArray):void
		{
			//			$bytes.position = 0;
			//			$bytes.readUTF();
			//			
			//			var wd:WorkData = $bytes.readObject();
			//			this.a = wd.a
			//			this.b = wd.b;
			throw new Error("需要复写反序列化");
		}
	}
}