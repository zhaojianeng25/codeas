package _Pan3D.particle.mask
{
	import _Pan3D.particle.ParticleData;
	import _Pan3D.vo.texture.TextureVo;
	
	import flash.display3D.textures.Texture;
	
	public class ParticleMaskData extends ParticleData
	{
		public var maskTexture:Texture;
		public var maskTextureVo:TextureVo;
		
//		public var callBackMaskList:Vector.<Function>;
		public function ParticleMaskData()
		{
			super();
//			callBackMaskList = new Vector.<Function>;
		}
//		public function callMaskBack(fun:Function):void{
//			callBackMaskList.push(fun);
//		}
//		public function applyCallMaskBack():void{
//			for(var i:int;i<callBackMaskList.length;i++){
//				callBackMaskList[i]();
//			}
//			callBackMaskList.length = 0;
//		}
		override public function dispose():void{
			super.dispose();
			if(maskTextureVo){
				maskTextureVo.useNum--;
			}
		}
	}
}