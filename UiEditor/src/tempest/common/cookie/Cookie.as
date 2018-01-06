package tempest.common.cookie
{
	import flash.net.*;

	public class Cookie implements ICookie
	{
		protected var locking:Boolean = false;
		protected var so:SharedObject;

		public function Cookie(name:String)
		{
			so = SharedObject.getLocal(name, "/");
		}

		/**
		 * 获取值
		 * @param name
		 * @return
		 */
		public function getValue(name:String):Object
		{
			try
			{
				return so.data[name];
			}
			catch (error:Error)
			{
				trace(error);
			}
			return null;
		}

		/**
		 * 解锁
		 */
		public function unlock():void
		{
			locking = false;
			flush();
		}

		/**
		 * 锁定
		 */
		public function lock():void
		{
			locking = true;
		}

		/**
		 * 清除
		 */
		public function clear():void
		{
			so.clear();
		}

		/**
		 * 删除值
		 * @param name
		 */
		public function deleteValue(name:String):void
		{
			try
			{
				so.data[name] = null;
				delete so.data[name];
				flush();
			}
			catch (error:Error)
			{
				trace(error);
			}
		}

		/**
		 * 设置值
		 * @param name
		 * @param value
		 */
		public function setValue(name:String, value:Object):void
		{
			so.data[name] = value;
			flush();
		}

		private function flush():void
		{
			try
			{
				if (!locking)
				{
					so.flush();
				}
			}
			catch (error:Error)
			{
				trace(error);
			}
		}
	}
}
