package _Pan3D.particle.bone
{
	import _Pan3D.base.MeshData;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.vo.anim.AnimVo;
	import _Pan3D.vo.texture.TextureVo;
	
	import flash.display3D.textures.Texture;
	
	public class ParticleBoneData extends ParticleData
	{
		public var meshData:MeshData;
		public var animVo:AnimVo;
		public var maskTexture:Texture;
		public var maskTextureVo:TextureVo;
		public function ParticleBoneData()
		{
			super();
		}
		
		override public function dispose():void{
			super.dispose();
			if(meshData){
				meshData.useNum--;
			}
			if(animVo){
				animVo.useNum--;
			}
		}
	}
}