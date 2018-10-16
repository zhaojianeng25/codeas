package _Pan3D.base {
	import flash.display.BitmapData;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.utils.Dictionary;
	
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.utils.MaterialBaseParam;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;

	/**
	 * 
	 * mesh块数据
	 */	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class MeshData
	{
		public var uid:uint;
		public var key:String;
		public var targetKey:String;
		public var hasData:Boolean;
		public var triItem: Vector.<ObjectTri>=new Vector.<ObjectTri>;
		public var weightItem: Vector.<ObjectWeight>=new Vector.<ObjectWeight>;
		public var uvItem: Vector.<ObjectUv>=new Vector.<ObjectUv>;
		public var boneItem:Vector.<ObjectBone> = new Vector.<ObjectBone>;
//		private var uvBitmapdata:BitmapData;
		public var mesh:Dictionary = new Dictionary();
		public var dataAry:Array;
		public var uvArray:Array;
		public var boneWeightAry:Array;
		private var _bonetIDAry:Array;
		public var indexAry:Array;
		public var vec:Vector.<Number>
//		public var souceBoneItem:Vector.<ObjectBone> = new Vector.<ObjectBone>;
//		public var _trianglevertexbuffer:VertexBuffer3D;
//		public var _trianglevertexbuffer2:VertexBuffer3D;
//		public var _trianglevertexbuffer3:VertexBuffer3D;
//		public var _trianglevertexbuffer4:VertexBuffer3D;
//		public var _uvbuffer:VertexBuffer3D;
//		public var _triangbonetexbuffer:VertexBuffer3D;
//		public var _triangbonetexIDbuffer:VertexBuffer3D;
//		public var _triangleindexbuffer:IndexBuffer3D;
		
		public var vertexBuffer1:VertexBuffer3D;
		public var vertexBuffer2:VertexBuffer3D;
		public var vertexBuffer3:VertexBuffer3D;
		public var vertexBuffer4:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var boneWeightBuffer:VertexBuffer3D;
		private var _boneIdBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		protected var _texture:Texture;
		
		public var material:MaterialTree;
		
		public var materialParam:MaterialBaseParam;
		
		public var lightTexture:Texture;
		
		/**
		 * 使用次数 
		 */		
		public var useNum:int;
		/**
		 * 空闲时间 
		 */		
		public var idleTime:int;
		
		
		
		/**
		 * 是否可以显示 
		 */		
		public var visible:Boolean = true;
		/**
		 * 对应的绑定粒子列表 
		 */		
		//public var particleList:Vector.<CombineParticle>;
		/**
		 * 面数 
		 */		
		public var faceNum:int;
		
		
		public var boneNewIDAry:Array;
		

		public var hasDispose:Boolean;

		public var hasBuffer:Boolean = true;
		
		public var useLight:Boolean;
		
		public function MeshData()
		{
		}

		public function get bonetIDAry():Array
		{
			return _bonetIDAry;
		}

		public function set bonetIDAry(value:Array):void
		{
			_bonetIDAry = value;
		}

		public function get boneIdBuffer():VertexBuffer3D
		{
			return _boneIdBuffer;
		}

		public function set boneIdBuffer(value:VertexBuffer3D):void
		{
			_boneIdBuffer = value;
		}

		public function get texture():Texture
		{
			return _texture;
		}

		public function set texture(value:Texture):void
		{
			_texture = value;
		}
		
		public function dispose():void{
			key = null;
			if(triItem){
				triItem.length = 0;
				triItem = null;
			}
			if(weightItem){
				weightItem.length = 0;
				weightItem = null;	
			}
			if(uvItem){
				uvItem.length = 0;
				uvItem = null;	
			}
			
			if(boneItem){
				boneItem.length = 0;
				boneItem = null;
			}
			
			for(var keyStr:String in mesh){
				delete mesh[keyStr];
			}
			mesh = null;

			if(boneNewIDAry){
				boneNewIDAry.length = 0;
				boneNewIDAry = null;
			}
			
			if(_texture){
				_texture.dispose();
				_texture = null;
			}
			
			if(dataAry){
				dataAry.length = 0;
				dataAry = null
			}
			if(uvArray){
				uvArray.length = 0;
				uvArray = null;
			}
			if(boneWeightAry){
				boneWeightAry.length = 0;
				boneWeightAry = null;
			}
			if(bonetIDAry){
				bonetIDAry.length = 0;
				bonetIDAry = null;
			}
			
			if(!indexBuffer){
				return;
			}
			vertexBuffer1.dispose();
			
			if(!Scene_data.compressBuffer){
				vertexBuffer2.dispose();
				vertexBuffer3.dispose();
				vertexBuffer4.dispose();
				uvBuffer.dispose();
				boneWeightBuffer.dispose();
				boneIdBuffer.dispose();
				indexBuffer.dispose();
			}
			
			hasDispose = true;
		}
		/**
		 * 从显卡中卸载 
		 * 
		 */		
		public function unloadBuffer():void{
			if(hasDispose){
				return;
			}
			if(!vertexBuffer1){
				return;
			}
			vertexBuffer1.dispose();
			if(!Scene_data.compressBuffer){
				vertexBuffer2.dispose();
				vertexBuffer3.dispose();
				vertexBuffer4.dispose();
				uvBuffer.dispose();
				boneWeightBuffer.dispose();
				boneIdBuffer.dispose();
			}
			
			hasBuffer = false;
			//trace("释放数据")
		}
		/**
		 * 重新装载到显卡 
		 * 
		 */		
		public function loadBuffer():void{
			if(hasBuffer){
				return;
			}
			
			if(Scene_data.compressBuffer){
				vertexBuffer1 = Scene_data.context3D.createVertexBuffer(vec.length/22,22);
				vertexBuffer1.uploadFromVector(vec,0,vec.length/22);
			}else{
			
				uvBuffer = Scene_data.context3D.createVertexBuffer(uvArray.length/2,2);
				uvBuffer.uploadFromVector(Vector.<Number>(uvArray),0,uvArray.length/2);
				
				vertexBuffer1 = Scene_data.context3D.createVertexBuffer(dataAry[0].length/3,3);
				vertexBuffer1.uploadFromVector(Vector.<Number>(dataAry[0]),0,dataAry[0].length/3);
				
				vertexBuffer2 = Scene_data.context3D.createVertexBuffer(dataAry[1].length/3,3);
				vertexBuffer2.uploadFromVector(Vector.<Number>(dataAry[1]),0,dataAry[1].length/3);
				
				vertexBuffer3 = Scene_data.context3D.createVertexBuffer(dataAry[2].length/3,3);
				vertexBuffer3.uploadFromVector(Vector.<Number>(dataAry[2]),0,dataAry[2].length/3);
				
				vertexBuffer4 = Scene_data.context3D.createVertexBuffer(dataAry[3].length/3,3);
				vertexBuffer4.uploadFromVector(Vector.<Number>(dataAry[3]),0,dataAry[3].length/3);
				
				boneWeightBuffer = Scene_data.context3D.createVertexBuffer(boneWeightAry.length/4,4);
				boneWeightBuffer.uploadFromVector(Vector.<Number>(boneWeightAry),0,boneWeightAry.length/4);
				
				boneIdBuffer = Scene_data.context3D.createVertexBuffer(bonetIDAry.length/4,4);
				boneIdBuffer.uploadFromVector(Vector.<Number>(bonetIDAry),0,bonetIDAry.length/4);
				
			}
			
			hasBuffer = true;
			trace("装载数据")
		}
		
		public function clone():MeshData{
			
			var cloneData:MeshData = new MeshData;
			
			cloneData.uid = uid;
			cloneData.key = key;
			
			
			cloneData.triItem = triItem;
			cloneData.weightItem = weightItem;
			cloneData.uvItem = uvItem;
			cloneData.boneItem = boneItem;

			return cloneData;
			
		}
		
		public function setParamData($ary:Array):void{
			if(!this.material){
				return;
			}
			if(!$ary){
				return;
			}
			this.materialParam = new MaterialBaseParam;
			this.materialParam.setData($ary);
			this.materialParam.setMaterial(this.material);
		}

	}
}