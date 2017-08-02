package _Pan3D.role
{
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import flash.display3D.textures.Texture;

	public class FlowLightUtils
	{
		private var _lightUrl:String;
		private var _lightTexture:Texture;
		
		private var _maskUrl:String;
		private var _maskTexture:Texture;
		
		private var _fun:Function;
		
		public function FlowLightUtils()
		{
		}
		
		public function setUrl(lightUrl:String,maskUrl:String,fun:Function):void{
			_lightUrl = lightUrl;
			_maskUrl = maskUrl;
			_fun = fun;
			TextureManager.getInstance().addTexture(lightUrl,onLightTextureCom,new Object,0);
		}
		
		private function onLightTextureCom(textureVo:TextureVo,info:Object):void{
			_lightTexture = textureVo.texture;
			TextureManager.getInstance().addTexture(_maskUrl,onMaskTextureCom,new Object,0);
		}
		
		private function onMaskTextureCom(textureVo:TextureVo,info:Object):void{
			_maskTexture = textureVo.texture;
			_fun(_lightTexture,_maskTexture);
		}
		
	}
}