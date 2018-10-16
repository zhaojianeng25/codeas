package _Pan3D.texture
{
	import flash.display3D.textures.CubeTexture;
	
	import _Pan3D.vo.texture.TextureVo;
	
	public class TextureCubeMapVo extends TextureVo
	{
		public var texturelist:Vector.<CubeTexture>;
		
		public function TextureCubeMapVo()
		{
			super();
		}
	}
}