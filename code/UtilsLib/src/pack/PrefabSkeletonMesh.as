package pack
{
	import materials.Material;

	public class PrefabSkeletonMesh
	{
		private var _material:Material;
		public function PrefabSkeletonMesh()
		{
			
		}

		public function get material():Material
		{
			return _material;
		}

		public function set material(value:Material):void
		{
			_material = value;
		}
		
	}
}