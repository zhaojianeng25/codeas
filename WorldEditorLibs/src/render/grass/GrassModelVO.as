package  render.grass
{
	import _Pan3D.base.Object3D;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GrassModelVO extends Object3D
	{
		public var toView:Boolean;
		public var url:String
		public var data:Array = [];
		public var width:Number
		public var height:Number
		public var color:uint=0xFFFFFF;

		public function GrassModelVO()
		{
			super();
		}
		public static function objToGrassModleVo(obj:Object):GrassModelVO
		{
			var $grassModelVO:GrassModelVO=new GrassModelVO;
			$grassModelVO.url=obj.url;
			$grassModelVO.x=obj.x;
			$grassModelVO.y=obj.y;
			$grassModelVO.z=obj.z;
			$grassModelVO.width=Number(obj.width);
			$grassModelVO.height=Number(obj.height);
			if(obj.data){
				$grassModelVO.data = obj.data;
			}else{
				$grassModelVO.data = new Array
			}
			return $grassModelVO;
		}
		
	}
}