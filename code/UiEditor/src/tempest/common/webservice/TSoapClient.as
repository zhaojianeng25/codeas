package tempest.common.webservice
{
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	/**
	 * ...
	 * @author wsk
	 */
	public class TSoapClient extends MovieClip
	{
		private var _loader:URLLoader;
		private var _endpoint:String;

		public function TSoapClient(endpoint:String, wsdl:Boolean = false, timeout:int = 0, response_timeout:int = 30)
		{
			this._endpoint = endpoint;
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ErrorHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
		}

		/**
		 * 调用
		 * @param operation 方法
		 * @param params 参数 [[参数名,参数值],[参数名,参数值],[参数名,参数值]...]
		 * @param _namespace 命名空间
		 */
		public function call(operation:String, params:Array, _namespace:String = 'http://tempuri.org'):void
		{
			var soap:Namespace = new Namespace("http://schemas.xmlsoap.org/soap/envelope/");
			var request:URLRequest = new URLRequest(_endpoint);
			request.method = URLRequestMethod.POST;
			request.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml;charset=utf-8"));
			request.requestHeaders.push(new URLRequestHeader("SOAPAction", _namespace + "/" + operation));
			var xml:XML = <soap:Envelope xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd = "http://www.w3.org/2001/XMLSchema" xmlns:tns = "http://logic.backend.imageservice.inshow.com" xmlns:soap = "http://schemas.xmlsoap.org/soap/envelope/" ><soap:Body/></soap:Envelope>;
			var condition:String = "<" + operation + " xmlns=\"" + _namespace + "\">";
			for (var i:int = 0; i < params.length; i++)
			{
				condition += "<" + params[i][0] + ">" + params[i][1] + "</" + params[i][0] + ">";
			}
			condition += "</" + operation + ">";
			xml.soap::Body.appendChild(new XML(condition));
			request.data = xml;
			_loader.load(request);
		}

		//public function parseResult(xml:XML, operation:String) :Object
		//{
		//var obj:Object={};
		//var elements:XMLList = xml.child("*").child("*").child("*").elements();
		//var att:String;
		//for (var i=0; i<elements.length(); i++) {
		//att=elements[i].localName();
		//obj[att]=elements[i];
		//}
		//return obj;
		//
		//}
		private function completeHandler(e:Event):void
		{
			this.dispatchEvent(new TSoapEvent(TSoapEvent.COMPLETE, new XML(_loader.data)));
		}

		private function ErrorHandler(e:Event):void
		{
			this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
	}
}
