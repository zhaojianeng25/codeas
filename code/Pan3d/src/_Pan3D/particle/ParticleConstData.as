package _Pan3D.particle
{
	public class ParticleConstData extends ParticleData
	{
		public function ParticleConstData()
		{
			super();
		}
		override public function dispose():void{
//			if(vertexBuffer){
//				vertexBuffer.dispose();
//			}
			if(uvBuffer){
				uvBuffer.dispose();
			}
			if(normalsBuffer){
				normalsBuffer.dispose();
			}
//			if(indexBuffer){
//				indexBuffer.dispose();
//			}
			if(lightUvsBuffer){
				lightUvsBuffer.dispose();
			}
			
			if(textureVo){
				textureVo.useNum--;
			}
			
			if(vertices){
				vertices.length = 0;
				vertices = null;
			}
			
			if(normals){
				normals.length = 0;
				normals = null;
			}
			
			if(uvs){
				uvs.length = 0;
				uvs = null;
			}
			if(lightUvs){
				lightUvs.length = 0;
				lightUvs = null;
			}
			
			if(indexs){
				indexs.length = 0;
				indexs = null;
			}
			
			mtl = null;
			
			
			if(vaDataBuffer){
				vaDataBuffer.dispose();
			}
			if(vaData){
				vaData.length = 0;
				vaData = null;
			}
			
//			if(callBackList){
//				callBackList.length = 0;
//				callBackList = null;
//			}
		}
	}
}