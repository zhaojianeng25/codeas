package modules.expres
{
	import mx.controls.Alert;

	public class ResTabelVo
	{
		public var name:String;
		public var field:Array;
		public var data:Vector.<Vector.<String>>;
		public function ResTabelVo()
		{
		}
		public function parseTable($name:String,$field:String,$data:String):void
		{
			this.name=$name;
			this.field=$field.split(",");
			var lines:Array = $data.split(String.fromCharCode(1));
			
			var tw:Number=this.field.length;
			var th:Number=lines.length/tw;  //行数
			var id:Number=0;
			this.data=new Vector.<Vector.<String>>;
			for(var i:Number=0;i<th;i++)
			{
				var $celarr:Vector.<String>=new Vector.<String>
				for(var j:Number=0;j<tw;j++){
					$celarr.push(lines[id])
					id++
				}
				this.data.push($celarr)
			}
		}
		//给字段，还有属性性，得到行
		public function getCellbyField($fieldName:String,value:String):void
		{

			var fieldId:int=-1
			for(var i:Number;i<this.field.length;i++)
			{
				if(this.field[i]==$fieldName){
					fieldId=i;
				}
			}
			if(fieldId==-1){
				trace("没有这个字段")
			}
			var cellArr:Vector.<String>
			for(var j:Number=0;j<this.data.length;j++)
			{
				if(this.data[j][fieldId]==value){
					cellArr=this.data[j]
				}
			}
			if(cellArr){
				trace(cellArr)
			}else{
				trace("没找到对象")
			}

		}
		public function getlistByField($fieldName:String):Vector.<String>
		{
			var fieldId:int=-1
			for(var i:Number=0;i<this.field.length;i++)
			{
				if(this.field[i]==$fieldName){
					fieldId=i;
				}
			}
			if(fieldId==-1){
				Alert.show("没有字段"+$fieldName)
			}
			var $fieldArr:Vector.<String>=new Vector.<String>
			for(var j:Number=0;j<this.data.length;j++)
			{
				
				$fieldArr.push(this.data[j][fieldId])
			}
			return $fieldArr;
		}
			
	}
}