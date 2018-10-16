package com.zcp.loader.vo
{
	import com.zcp.loader.loader.DobjLoader;
	import com.zcp.loader.loader.UrlLoader;

	/**
	 * 具有相同加载地址的LoadData的集合
	 * @author zcp
	 * 
	 */	
	public class LoadDataGroup
	{
		//第一个加载数据
		private var _headLoadData:LoadData;
		//加载地址
		private var _url:String;
		//是否接收相同地址加载的合并
		private var _mergeSameURL:Boolean;
		//加载优先级
		private var _priority:int;
		
		//具有相同加载地址的LoadData的集合
		private var _loadDataMap:Vector.<LoadData>;
		
		//DobjLoader 不为null则正在加载
		public var dobjLoader:DobjLoader;
		//DobjLoader 不为null则正在加载
		public var urlLoader:UrlLoader;
		
		/**
		 * 
		 * @param $headLoadData 第一个加载数据（不会添加进加载列表，只是用来记录加载数据）
		 * 
		 */		
		public function LoadDataGroup($headLoadData:LoadData)
		{
			_headLoadData = $headLoadData;
			_url = _headLoadData.url;
			_mergeSameURL = _headLoadData.mergeSameURL;
			_priority = _headLoadData.priority;
			
			_loadDataMap = new Vector.<LoadData>();
		}
		/**
		 * 加载地址
		 */	
		public function get url():String
		{
			return _url;
		}
		/**
		 * 是否接收相同地址加载的合并
		 */
		public function get mergeSameURL():Boolean
		{
			return _mergeSameURL;
		}
		/**
		 * 加载优先级
		 */	
		public function get priority():int
		{
			return _priority;
		}
		
		/**
		 * 具有相同加载地址的LoadData的集合
		 */	
		public function get loadDataMap():Vector.<LoadData>
		{
			return _loadDataMap;
		}
		/**
		 * 第一个加载项
		 */	
		public function get headLoadData():LoadData
		{
			return _headLoadData;
		}
	}
}