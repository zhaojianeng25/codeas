package modules.grass
{
	import render.grass.GrassModelVO;
	

	public class GrassEditorData
	{

		public static var grassData:Vector.<GrassModelVO>;
		public function GrassEditorData()
		{
		}
		public static function setObject(obj:Object):void{
			
			grassData=new Vector.<GrassModelVO>
			if(obj.grassData){
				for(var i:uint=0;i<obj.grassData.length;i++){
					grassData.push(GrassModelVO.objToGrassModleVo(obj.grassData[i]))
				}
			}
		}
		public static function deleGrass(url:String):void
		{
			if(grassData){
				for(var i:uint=0;i<grassData.length;i++)
				{
					if(grassData[i].url==url){
						grassData.splice(i,1)
					}
				}
			}
			
		}
		public static function getObject():Object{
			
			var obj:Object=new Object
			obj.grassData=grassData	
			return obj;
		}
	}
}