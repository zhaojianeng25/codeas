package mesh
{
	import flash.geom.Point;

	public class H5UIFrameMesh extends H5UIFileMesh
	{

		public function H5UIFrameMesh()
		{
			super();
		}

		public function get rowColumn():Point
		{
			
			return _h5UIFileNode.rowColumn
	
		}
		[Editor(type="Vec2",Label="行列",sort="5",Category="行列",Tip="行列")]
		public function set rowColumn(value:Point):void
		{
	
			
			_h5UIFileNode.rowColumn.x=value.x
			_h5UIFileNode.rowColumn.y=value.y
				
			if(_h5UIFileNode.rowColumn.x<1){
				_h5UIFileNode.rowColumn.x=1
			}	
			if(_h5UIFileNode.rowColumn.y<1){
				_h5UIFileNode.rowColumn.y=1
			}	
			change();
				
		}

	}
}