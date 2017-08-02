package mesh
{
	import flash.geom.Point;

	public class H5UIFile9Mesh extends H5UIFileMesh
	{
		private var _rect9Size:Point
		public function H5UIFile9Mesh()
		{
			super();
		}

		public function get rect9Size():Point
		{
			return new Point(_h5UIFileNode.rect9.width,_h5UIFileNode.rect9.height);
		}
		[Editor(type="Vec2",Label="尺寸",sort="5",Category="宫格",Tip="坐标")]
		public function set rect9Size(value:Point):void
		{
			_h5UIFileNode.rect9.width=value.x;
			_h5UIFileNode.rect9.height=value.y;
			change();
		}

	}
}