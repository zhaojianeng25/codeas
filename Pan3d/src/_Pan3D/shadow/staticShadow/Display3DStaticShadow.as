package _Pan3D.shadow.staticShadow
{
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	
	public class Display3DStaticShadow extends Display3DSprite
	{
		public var vcAry:Vector.<Number>;
		
		public function Display3DStaticShadow(context:Context3D)
		{
			super(context);
			initData();
		}
		
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && _objData.texture) {
				
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
		}
		
		
		public function initData():void{
			
			vcAry = new Vector.<Number>;
			for(var j:int=0;j<200;j++){
				var xpos:int = 200;
				var ypos:int = 200;
				var xpos1:int = (Scene_data.tx2D+xpos*2/Scene_data.mainScale)*Scene_data.sw2D;
				var ypos1:int = (Scene_data.ty2D-ypos*(2/Scene_data.mainScale/Scene_data.sinAngle2D))*Scene_data.sw2D;
				vcAry.push(xpos1,ypos1);
			}
			
			var vertices:Vector.<Number> = new Vector.<Number>;
			var uvs:Vector.<Number> = new Vector.<Number>;
			var pos:Vector.<Number> = new Vector.<Number>;
			var indexs:Vector.<uint> = new Vector.<uint>;
			
			var wh:Number = 30;
			for(var i:int;i<200;i++){
				vertices.push(
					-wh, 0, wh,
					wh, 0, wh, 
					wh, 0, -wh, 
					-wh, 0, -wh
				);
				
				var a:Number = 0;
				var flag:int = i/2;
				uvs.push(
					0,0,flag+12,
					0,1,flag+12,
					1,1,flag+12,
					1,0,flag+12
				);
				flag = i%2;
				if(flag == 0){
					pos.push(
						1,1,0,0,
						1,1,0,0,
						1,1,0,0,
						1,1,0,0
					);
				}if(flag == 1){
					pos.push(
						0,0,1,1,
						0,0,1,1,
						0,0,1,1,
						0,0,1,1
					);
				}
				
				indexs.push(i*4,1+i*4,2+i*4,i*4,2+i*4,3+i*4);
			}
			
			_objData = new ObjData;
			
			_objData.vertices = vertices;
			_objData.uvs = uvs;
			_objData.normals = pos;
			_objData.indexs = indexs;
			try
			{
				uplodToGpu();
			} 
			catch(error:Error) 
			{
				if(!Scene_data.disposed){
					throw error;
				}
			}
		}
		
		override protected function uplodToGpu():void{
			
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = this._context.createVertexBuffer(_objData.uvs.length / 3, 3);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 3);
			
			_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 4, 4);
			_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 4);
			
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
		
		override protected function setVa():void{
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(2, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		override protected function resetVa():void{
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(0,null);
		}
		
//		override public function updataPos():void{
//			vcAry.length = 0;
//			for(var j:int=0;j<200;j++){
//				var xpos:int = 200 + j*20;
//				var ypos:int = 200 + j*20;
//				var xpos1:int = (Scene_data.tx2D+xpos*2/Scene_data.mainScale)*Scene_data.sw2D;
//				var ypos1:int = (Scene_data.ty2D-ypos*(2/Scene_data.mainScale/Scene_data.sinAngle2D))*Scene_data.sw2D;
//				vcAry.push(xpos1,ypos1);
//			}
//		}
		
		public function set texture(value:Texture):void{
			_objData.texture = value;
		}
		
		private var vc4:Vector.<Number> = new Vector.<Number>;
		override protected function setVc():void{
			//updataPos();
			vc4[0] = Scene_data.sw2D;
			vc4[1] = Scene_data.sw2D;
			vc4[2] = Scene_data.sw2D;
			vc4[3] = 1;
			
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 ,vc4);
			//_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4 , Vector.<Number>([5,5,5,1]));
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, Scene_data.cam3D.cameraMatrix, true);
			
			var index:int;
			for(var i:int;i<vcAry.length;i+=4){
				index = 12 + int(i/4);
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, index , Vector.<Number>([vcAry[i],vcAry[i+1],vcAry[i+2],vcAry[i+3]]));
			}     
			
		}
		
		public function setData(ary:Array,startIndex:int):int{
			for(var i:int;i<vcAry.length/2;i++){
				if(startIndex+i<ary.length){
					if(ary[startIndex+i].hasShadow){
						vcAry[i*2] = ary[startIndex+i].absoluteX;
						vcAry[i*2+1] = ary[startIndex+i].absoluteZ;
					}else{
						vcAry[i*2] = -200000;
						vcAry[i*2+1] = -200000;
					}
				}else{
					vcAry[i*2] = -200000;
				}
			}
			
			if(ary.length-startIndex < vcAry.length/2){
				return -1;
			}else{
				return startIndex+vcAry.length/2;
			}
			
		}
		
		override public function reload():void{
			_context = Scene_data.context3D;
			uplodToGpu();
		}
		
		
	}
}