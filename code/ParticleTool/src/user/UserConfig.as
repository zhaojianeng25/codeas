package user
{
	import com.maclema.mysql.ResultSet;
	
	import db.DBManager;
	
	import flash.events.Event;
	import flash.text.ReturnKeyLabel;
	
	import mx.controls.Alert;

	public class UserConfig
	{
		[Embed(source = "assets/pjconfig.xml",mimeType = "application/octet-stream")]
		private var configFile:Class;
		
		private var _configXML:XML;
		private var _userName:String;
		private var _password:String;
		public function UserConfig($userName:String,$password:String)
		{
			_userName = $userName;
			_password = $password;
			
			_configXML = XML(new configFile());
			connect(0);//连接账号所在的数据库
		}
		
		private function connect(type:int):void{
			var obj:Object = _configXML.projectName[type];
			DBManager.getInstance().addEventListener(DBManager.ConnectEvent,onConnectSuc);
			DBManager.getInstance().connect(obj.ip,obj.port,obj.dbname,obj.user,obj.psd);
		}
		
		protected function onConnectSuc(event:Event):void{
			DBManager.getInstance().removeEventListener(DBManager.ConnectEvent,onConnectSuc);
			
			var sql:String =  "select * from t_tool_projectuser where username = '" + _userName + "' and password = '" + _password + "'";
			DBManager.getInstance().executeQuery(sql,querySuc,error);
			
		}
		
		private function error(value:*):void
		{
			trace(value);
		}
		private function querySuc(rs:ResultSet):void{
			var obj:Object;
			if(rs.next()){
				obj = new Object;
				obj.id = rs.getInt("Id");
				obj.username = rs.getString("username");
				obj.project = rs.getInt("project");
				obj.tool = rs.getString("tool");
				obj.permissions = rs.getInt("permissions");
				
				DBManager.getInstance().disConnect();//断开数据库连接
				
				if(getToolPermission(obj.tool)){
					var dbObj:Object = _configXML.projectName[obj.project];
					DBManager.getInstance().connect(dbObj.ip,dbObj.port,dbObj.dbname,dbObj.user,dbObj.psd);
					
					AppParticleData.projectName = String(_configXML.projectName[obj.project].@name);
					AppParticleData.statusString = "user:" + obj.username + "---《" + AppParticleData.projectName + "》";
					AppParticleData.isAuthorize = true;
					AppParticleData.mapUrl = dbObj.mapUrl;
					AppParticleData.projectType = obj.project;
				}else{
					AppParticleData.statusString = "当前账户没有操作此编辑器的权限!";
				}
				
			}else{
				DBManager.getInstance().disConnect();//断开数据库连接
				AppParticleData.statusString = "保存的账号不存在或者密码不正确！";
			}
		}
		
		private function getToolPermission(str:String):Boolean{
			var ary:Array = str.split("&");
			for(var i:int;i<ary.length;i++){
				if(int(ary[i]) == 2){
					break;
				}
			}
			if(i == ary.length){
				return false;
			}else{
				return true;
			}
		}
		
	}
}