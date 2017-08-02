package db.tempUtils
{
	import com.maclema.mysql.ResultSet;
	
	import db.DBManager;

	public class EncodeUTF
	{

		private var ary:Array;
		private var flag:int;
		public var tableName:String;
		public function EncodeUTF()
		{
			tableName = "t_avatars_equ";
		}
		public function change():void{
			var sql:String =  "select * from " + tableName;
			DBManager.getInstance().executeQuery(sql,querySuc,error);
		}
		private function error(value:*):void
		{
			trace(value);
		}
		private function querySuc(rs:ResultSet):void{
			ary = new Array;
			while(rs.next()){
				var obj:Object = new Object;
				obj.id = rs.getInt("f_id");
				obj.name = rs.getString("f_name");
				ary.push(obj);
			}
			update();
		}
		
		private function update(value:Object=null):void{
			if(flag == ary.length){
				return;
			}
			var selectObj:Object = ary[flag];
			var sql:String = "update " + tableName + " set f_name='" + decodeURI(selectObj.name) + "' where f_id=" + selectObj.id;
			DBManager.getInstance().executeUpdate(sql,update,error);
			flag++;
		}
		
		
		
		
	}
}