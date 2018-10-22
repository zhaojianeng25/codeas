package db
{
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.MySqlToken;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.Statement;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.rpc.AsyncResponder;
	
	import spark.skins.spark.ErrorSkin;
	
	public class DatabaseUtils  extends EventDispatcher
	{
		private var _conn:Connection;
		private var _isSelect:Boolean;
		
		private var _executeHandler:Function;
		private var _errorHandler:Function;
		
		public function DatabaseUtils(conn:Connection)
		{
			this._conn = conn;
		}
		
		/**
		 * 
		 * @param sqlstr	SQL语句
		 * @param isSelect	是否是查询
		 * @param executeHandler	执行成功回调函数
		 * @param errorHandler 执行失败回调函数
		 */
		internal function execute(sqlstr:String, isSelect:Boolean = false , executeHandler:Function = null , errorHandler:Function = null):void
		{
			//替换null字符串
			var myPattern:RegExp = /'null'/g;
			sqlstr = sqlstr.replace(myPattern, "''");
			myPattern = /%null%/g;
			sqlstr = sqlstr.replace(myPattern, "%%");

			//执行各种sql语句,异步处理返回结果
			_executeHandler = executeHandler;
			_errorHandler = errorHandler;
			_isSelect = isSelect;
			
			var st:Statement=_conn.createStatement();
			
			try{
				//捕获异常 例如断开socket连接等
				var token:MySqlToken=st.executeQuery(sqlstr);
				token.addResponder(new AsyncResponder(result, fault, token));
				//token.addResponder(new AsyncResponder(result, errorHandler, executeHandler));
			}catch(e:Error){
				if(errorHandler != null)
					errorHandler(e);
//				trace("错误ID："+e.errorID+"，错误名称:"+e.name+" , 错误消息："+e.message);
			}
			
		}
		
		
		
		private function result(data:Object, token:Object):void
		{ 
			
			if(_isSelect)
			{
				var rs:ResultSet = ResultSet(data);
				_executeHandler(rs);
			}
			else
			{
				_executeHandler(data);
			}
		}
		
		private function fault(info:Object, token:Object):void
		{
			//正则匹配出错误消息号
			var reg:RegExp = new RegExp(/[0-9]\d*/g);
			var errId:int = reg.exec(info.toString());
			
			_errorHandler(new Error(info,errId));
		}
		
	}
}