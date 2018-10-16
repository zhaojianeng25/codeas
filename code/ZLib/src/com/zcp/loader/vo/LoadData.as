package com.zcp.loader.vo
{
	import flash.display.DisplayObjectContainer;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.ImageDecodingPolicy;

	/**
	 * 基本加载模型对象
	 * 所有回调的参数类型统一为(loadData:LoadData, e:Event)
	 * e类型分别为Event、ProgressEvent、IOErrorEvent或SecurityErrorEvent
	 * @author zcp
	 * 
	 */	
	public class LoadData
	{
		/**加载类型为：URLLoaderDataFormat.TEXT*/
		public static const URLLOADER_TEXT:String = URLLoaderDataFormat.TEXT;
		/**加载类型为：URLLoaderDataFormat.BINARY*/
		public static const URLLOADER_BINARY:String = URLLoaderDataFormat.BINARY;
		/**加载类型为：URLLoaderDataFormat.VARIABLES*/
		public static const URLLOADER_VARIABLES:String = URLLoaderDataFormat.VARIABLES;
		
		/**加载类型为：显示对象*/
		public static const LOADER_DISPLAYOBJECT:String = "DISPLAYOBJECT";
		/**加载类型为：导出类*/
		public static const LOADER_CLASS:String = "CLASS";
		
		
		
		private var _url:String;
		private var _name:String;
		private var _key:String;
		private var _priority:int;

		private var _onComplete:Function;
		private var _onUpdate:Function;
		private var _onError:Function;
		
		private var _decode:Function;
		private var _dataFormat:String;
		private var _container:DisplayObjectContainer;
		
		private var _tryCount:int;
		private var _timeOut:int;

		private var _imageDecodingPolicy:String;
		
		
		
		/**
		 * 加载到哪个域(null为当前域，即：null等价于ApplicationDomain.currentDomain, 默认为当前域)
		 */		
		public var applicationDomain:ApplicationDomain;
		
		
		/**
		 * 控制 HTTP 式提交方法(有效值为 URLRequestMethod.GET 或 URLRequestMethod.POST, 默认为 URLRequestMethod.GET)
		 */		
		public var requestMethod:String = URLRequestMethod.GET;
		/**
		 * 控制 HTTP 式提交数据(该属性与 requestMethod属性配合使用。当 requestMethod 值为 GET 时，将使用 HTTP 查询字符串语法将 data 值追加到 URLRequest.url 值。当 method 值为 POST（或 GET 之外的任何值）时，将在 HTTP 请求体中传输 data 值)
		 */		
		public var requestData:Object;
		/**
		 * 控制 HTTP 式提交数据(要追加到 HTTP 请求的 HTTP 请求标头的数组。该数组由 URLRequestHeader 对象组成。)
		 */		
		public var requestHeaders:Array;
		
		
		/**
		 * 是否使用相同地址加载合并策略(默认为false)(注意:1.一般用于加载参数完全相同的加载，如果不相同，则加载参数只取最先加入的一个LoadData的数据,后加入的将被忽略 2.如果是加载显示对象，那么该显示对象在内存中只有一份，需要特别注意)
		 */		
		public var mergeSameURL:Boolean;
		
		
		private var _userData:Object;//自定义数据
		/**只读属性的自定义数据！！！*/
		public function get userData():Object
		{
			if(_userData==null)
			{
				_userData = {};
			}
			return _userData;
		}
		

		
		/**
		 * 
		 * @param $url
		 * @param $onComplete
		 * @param $onUpdate
		 * @param $onError
		 * @param $name
		 * @param $key
		 * @param $priority 加载优先级（值越高越先加载）
		 * @param $dataFormat 加载数据格式
		 * @param $decode 解密函数
		 * @param $container
		 * @param $tryCount 重试次数
		 * @param $timeOut 超时时间， 0则无超时
		 * @param $imageDecodingPolicy 对于图片的解析方式(默认为同步解析)

		 */
		public function LoadData(
			$url:String,
			
			$onComplete:Function=null,
			$onUpdate:Function=null,
			$onError:Function=null,
			
			$name:String="",
			$key:String="",
			
			$priority:int=0,
			
			$dataFormat:String=null,
			$decode:Function=null,
			$container:DisplayObjectContainer=null,
			
			$tryCount:int = 1,
			$timeOut:int = 0,
			
			$imageDecodingPolicy:String=ImageDecodingPolicy.ON_DEMAND
		)
		{
			_url = $url;
			_name = $name;
			_key = $key;
			_priority = $priority;
			
			_onComplete = $onComplete;
			_onUpdate = $onUpdate;
			_onError = $onError;
			
			_dataFormat = $dataFormat;
			_decode = $decode;
			_container = $container;
				
			_tryCount = $tryCount;
			_timeOut = $timeOut;
			
			_imageDecodingPolicy = $imageDecodingPolicy;
		}
		/**
		 * 创建一个副本(浅复制) 
		 * @return 
		 * 
		 */		
		public function clone():LoadData
		{
			var ld:LoadData = new LoadData(_url,
				_onComplete,_onUpdate,_onError,
				_name,_key,_priority,_dataFormat,_decode,_container,_tryCount,_timeOut,_imageDecodingPolicy);
			
			ld.applicationDomain = applicationDomain;
			ld.requestMethod = requestMethod;
			ld.requestData = requestData;
			ld.requestHeaders = requestHeaders;
			ld.mergeSameURL = mergeSameURL;
			//ld._userData = _userData;

			return ld;
		}
		public function get url():String
		{
			return _url;
		}
		public function get name():String
		{
			return _name;
		}
		public function get key():String
		{
			return _key;
		}
		/**加载优先级*/
		public function get priority():int
		{
			return _priority;
		}
		public function get onComplete():Function
		{
			return _onComplete;
		}
		public function get onUpdate():Function
		{
			return _onUpdate;
		}
		public function get onError():Function
		{
			return _onError;
		}
		/**加载的数据类型(在UrlLoader加载时，此类型默认为URLLOADER_TEXT；在DobjLoader加载时，此类型默认为LOADER_CLASS)*/
		public function get dataFormat():String{
			return _dataFormat;
		}
		/**解密函数(当dataFormat==LOADER_DISPLAYOBJECT 或 dataFormat==LOADER_CLASS时，此参数才有意义)**/
		public function get decode():Function
		{
			return _decode;
		}
		/**加载到的容器(当dataFormat==LOADER_DISPLAYOBJECT时，此参数才有意义)*/
		public function get container():DisplayObjectContainer{
			return _container;
		}
		/**
		 * 尝试的加载次数 
		 * @return 
		 * 
		 */		
		public function get tryCount():int
		{
			return _tryCount;
		}
		public function get timeOut():int
		{
			return _timeOut;
		}
		
		public function get imageDecodingPolicy():String
		{
			return _imageDecodingPolicy;
		}
	}
}