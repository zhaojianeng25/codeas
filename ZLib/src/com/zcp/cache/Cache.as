package com.zcp.cache
{
    import com.zcp.vo.LNode;
    
    import flash.utils.*;

	/**
	 * key-value缓存
	 * @author zcp
	 * 
	 */	
    public class Cache extends Object
    {
		private static var _nextId:int =0; 
		
        private var _name:String;
        private var _length:int;
        private var _maxSize:int;
        private var _head:LNode;
        private var _dict:Dictionary;

        public function Cache($name:String="",$mSize:int = 2147483647)
        {
            if ($mSize < 0)
            {
                throw new Error("缓存个数必须为非负数");
            }
			_name = ($name!="")?$name:"Cache"+(_nextId++);     
			
            _maxSize = $mSize;
			_head = null;
            _length = 0;
            _dict = new Dictionary();
            return;
        }
		/**
		 * 检索某项缓存数据是否存在
		 * @param $key
		 */
        public function has($key:String) : Boolean
        {
            return _dict[$key] != null;
        }
		/**
		 * 获取某项缓存数据
		 * @param $key
		 */
		public function get($key:String) : Object
		{
			var cu:CacheUnit = _dict[$key];
			promote(cu);
			return cu.data;
		}
		/**
		 * 移除某项缓存数据
		 * @param $key
		 */
		public function remove($key:String) : void
		{
			var cu:CacheUnit = _dict[$key];
			if (cu)
			{
				//new
				//===================
				if (cu == _head)
				{
					_head = _head.pre;
				}
				//===================
				
				cu.pre.next = cu.next;
				cu.next.pre = cu.pre;
				destroy(cu);
				//new
				//===================
				_length--;
				//===================
			}
			return;
		}
		/**
		 * 向缓存数中添加数据
		 * @param $data
		 * @param $key
		 */
        public function push($data:Object, $key:String) : void
        {
            var cu:LNode;
            if (has($key))
            {
                promote(_dict[$key]);
                return;
            }
            cu = new CacheUnit($data, $key);
            _dict[$key] = cu;
            if (_length == 0)
            {
                _head = cu;
                _head.pre = cu;
                _head.next = cu;
            }
            else
            {
//				//old
//				//=======================
//                cu.pre = _head;
//                cu.next = _head.next;
//                _head.next.pre = cu;
//                _head.next = cu;
//                _head = cu;
//				//=======================
				
				
				//new
				//=======================
				cu.pre = _head;
				cu.next = _head.next;
				cu.pre.next = cu;
				cu.next.pre = cu;
				_head = cu;
				//=======================
            }
            _length++;
            if (_length > _maxSize)
            {
                cu = _head.next;
				
//				//old
//				//==========================
//                _head.next = _head.next.next;
//                _head.next.pre = _head;
//				//===========================
				
				//new
				//============================
				cu.pre.next = cu.next;
				cu.next.pre = cu.pre;
				//============================
				
                destroy(cu);
                _length--;
            }
            return;
        }
		/**
		 * 重设缓存器大小
		 * @param $size
		 */
        public function resize($size:int) : void
        {
            var cu:LNode;
            if ($size < 0 || $size == _maxSize)
            {
                return;
            }
            while (_length > $size)
            {
                cu = _head.next;
				
				//old
				//============================
//                _head.next = _head.next.next;
//				//new add
//				//=======================
//				_head.next.pre = _head;
//				//=======================
				//============================
					
				//new
				//============================
				cu.pre.next = cu.next;
				cu.next.pre = cu.pre;
				//============================
				
				destroy(cu);
                _length--;
            }
            _maxSize = $size;
            return;
        }
		/**
		 * 释放该缓存器
		 * 说明：该方法与resize(0)的区别是不改变_maxSize
		 */
        public function dispose() : void
        {
			var ms:int = _maxSize;
            resize(0);
            _maxSize = ms;
            return;
        }
		/**
		 * 获取所有键的一个数组
		 */
		public function getAllKeys():Array
		{
			var arr:Array = [];
			for(var key:String in _dict)
			{
				arr.push(key);
			}
			return arr;
		}
		/**
		 * 获取所有值的一个数组
		 */
		public function getAllValues():Array
		{
			var arr:Array = [];
			for(var key:String in _dict)
			{
				arr.push(_dict[key]);
			}
			return arr;
		}
		
		
		public function get name():String
		{
			return _name;
		}
		public function get length():int
		{
			return _length;
		}

		/**
		 * @private
		 * 将某一项缓存数据前置
		 * 说明：目的是使最近使用的缓存数据具有较低的移除优先级
		 */
		private function promote($cu:CacheUnit) : void
		{
			if ($cu == null || $cu == _head)
			{
				return;
			}
			if ($cu.pre == _head)
			{
				_head = $cu;
			}
			else
			{
				$cu.next.pre = $cu.pre;
				$cu.pre.next = $cu.next;
				$cu.pre = _head;
				$cu.next = _head.next;
				_head.next.pre = $cu;
				_head.next = $cu;
				_head = $cu;
			}
			return;
		}
		/**
		 * 销毁某项缓存数据
		 */
		private function destroy($cu:LNode) : void
		{
			delete _dict[$cu.id];
			($cu as CacheUnit).dispose();
			$cu = null;
			return;
		}
    }
}
