package _Pan3D.base
{
	import _Pan3D.base.MeshData;
	
	import flash.display3D.textures.Texture;
	
	public class MeshDataSelect extends MeshData
	{
		private var _selected:Boolean;
		public var selectedTexture:Texture;
		public function MeshDataSelect()
		{
			super();
		}
		
		override public function get texture():Texture{

			if(_selected){
			
				return selectedTexture;
			}else{
				return _texture;
			}
			
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

	}
}