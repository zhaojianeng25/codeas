package _Pan3D.base
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	
	import _Pan3D.vo.texture.TextureVo;

	public class ObjData
	{
		public var uid:uint;
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		public var uvs:Vector.<Number>;
		public var lightUvs:Vector.<Number>;
		public var tangents:Vector.<Number>;
		public var bitangents:Vector.<Number>;
		public var indexs:Vector.<uint>;
		public var mtl:String;
		public var hasTBN:Boolean;
		
		public var vertexBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var lightUvsBuffer:VertexBuffer3D;
		public var normalsBuffer:VertexBuffer3D;
		public var tangentsBuffer:VertexBuffer3D;
		public var bitangentsBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var texture:Texture;
		public var textureVo:TextureVo;
		public var hitbox:ObjectHitBox;
		public var lightMapSize:uint
		public var hasDispose:Boolean;
		public var hasUnload:Boolean;
		
		public var bindPosAry:Array;
		
		public var bindPosBoneItems:Vector.<ObjectBone>;

		public var collisionItem:Vector.<CollisionVo>;
		
		public var friction:Number;
		public var restitution:Number;
		public var isField:Boolean;
		
		
		public function ObjData()
		{
			
		}
		/**
		 * 彻底释放对象 
		 * 
		 */		
		public function dispose():void{
			if(vertexBuffer){
				vertexBuffer.dispose();
			}
			if(uvBuffer){
				uvBuffer.dispose();
			}
			if(normalsBuffer){
				normalsBuffer.dispose();
			}
			if(indexBuffer){
				indexBuffer.dispose();
			}
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
			
		}
		/**
		 * 浅释放 适用于buffer共享的对象 
		 * 
		 */		
		public function tinyDispose():void{
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
		}
		/**
		 * 释放显卡相关数据，保留内存资源 
		 * 
		 */		
		public function unload():void{
			if(vertexBuffer){
				vertexBuffer.dispose();
			}
			if(uvBuffer){
				uvBuffer.dispose();
			}
			if(normalsBuffer){
				normalsBuffer.dispose();
			}
			if(indexBuffer){
				indexBuffer.dispose();
			}
			if(lightUvsBuffer){
				lightUvsBuffer.dispose();
			}
			
			hasUnload = true;
		}
		
	}
}