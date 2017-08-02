package modules.expres
{
	import flash.utils.Dictionary;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	

	public class ExpResModel
	{
		private static var instance:ExpResModel;
		public static var expArpg:Boolean=true;//是否连接表导出
		public static function getInstance():ExpResModel{
			if(!instance){
				instance = new ExpResModel();
			}
			return instance;
		}
		public function ExpResModel()
		{
			
		}
		private var beakFun:Function;
		public function initData(bFun:Function,$url:String=null):void
		{
			this.beakFun=bFun
			if(tb){
				this.beakFun();
			}else{
			//	var rootUrl:String="http://192.168.88.25/net/res/"
				this.loadDataByUrl("http://192.168.88.5:8818/static/data/tb.txt?x="+String(Math.random()))
			}

		}
		public function loadDataByUrl(value:String):void
		{
			var loaderinfo : LoadInfo = new LoadInfo(value, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		
		}
		protected function onObjLoad($str : String) : void {
			this.parseLineByStr($str)
		}
        private var tb:Dictionary;
		private function parseLineByStr($str:String):void
		{
			this.hasTbData=true
				
			this.tb=new Dictionary;
			var lines:Array = $str.split(String.fromCharCode(13));
			var loop:uint = lines.length/4;
			for(var i:uint = 0; i < loop; ++i)
			{
				var $name:String=lines[i*4+0];
				var $field:String=lines[i*4+1];
				var $type:String=lines[i*4+2];
				var $data:String=lines[i*4+3];
				var vo:ResTabelVo=new ResTabelVo();
				vo.parseTable($name,$field,$data);
				trace("表",$name)
				tb[$name]=vo;
				
			}
			
			this.beakFun();
		}
		public var hasTbData:Boolean=false
			
		public function getListByTabelAndfield($tbName:String,$fieldName:String):Vector.<String>
		{
			if(this.tb.hasOwnProperty($tbName)){
				var vo:ResTabelVo=this.tb[$tbName];
				return vo.getlistByField($fieldName)
			}else{
				trace("没有表")
			}
		
			return null;
		}
		public function getTableField($tbName:String):Array
		{
			if(this.tb.hasOwnProperty($tbName)){
				var vo:ResTabelVo=this.tb[$tbName];
				return vo.field
			}else{
				trace("没有表")
			}
			return null
		}
		public function getTablList():Array
		{
			var arr:Array=new Array
			for each(var vo:ResTabelVo in this.tb){
				arr.push(vo.name)
			}
			return arr
		}
			

		
	}
}
