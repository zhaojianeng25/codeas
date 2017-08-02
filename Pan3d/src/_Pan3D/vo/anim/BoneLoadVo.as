package _Pan3D.vo.anim
{
	import flash.display.BitmapData;

	public dynamic class BoneLoadVo
	{
		public var name:String;
		public var url:String;
		public var isParticle:Boolean;
		//public var bmp:BitmapData;
		public function BoneLoadVo($name:String,$url:String)
		{
			name = $name;
			url = $url;
			//bmp = new BitmapData(512,512);
		}
	}
}