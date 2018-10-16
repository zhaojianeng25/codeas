package renderLevel.levels
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	
	public class Display3dGrid extends Display3DSprite
	{
		public function Display3dGrid(context:Context3D)
		{
			super(context);
			initGrid();
		}
		private var lineWidth:Number = 5;
		private var wh:Number = 15;
		private var height:Number = 3;
		private function initGrid():void{
			var vertexAry:Array=new Array();
			var uvAry:Array = new Array();
			var indexAry:Array = new Array();
			
			var wNum:int = 100;
			var hNum:int = 100;
			
			/*for(var i:int=0;i<wNum;i++){
				var xpos:Number = i*50;
				var ypos:Number = 0;
				var zpos:Number = hNum*50;
				
				vertexAry.push(xpos,ypos,0);
				vertexAry.push(xpos+lineWidth,ypos,0);
				vertexAry.push(xpos,ypos,zpos);
				vertexAry.push(xpos+lineWidth,ypos,zpos);
				
				uvAry.push(0,0);
				uvAry.push(0,1);
				uvAry.push(1,1);
				uvAry.push(1,0);
				
				indexAry.push(i*4,i*4+1,i*4+2,i*4+1,i*4+3,i*4+2);
			}*/
			
			vertexAry.push(-wh,-height,-wh);
			vertexAry.push(wh,-height,-wh);
			vertexAry.push(-wh,-height,wh);
			vertexAry.push(wh,-height,wh);
			
			uvAry.push(0,0);
			uvAry.push(0,1);
			uvAry.push(1,1);
			uvAry.push(1,0);
			
			indexAry.push(0,1,2,1,3,2);
			
			
			_objData=new ObjData;
			
			_objData.vertexBuffer = this._context.createVertexBuffer(vertexAry.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(vertexAry), 0, vertexAry.length / 3);
			
			_objData.uvBuffer = this._context.createVertexBuffer(uvAry.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(uvAry), 0, uvAry.length / 2);
			
			_objData.indexBuffer = this._context.createIndexBuffer(indexAry.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(indexAry), 0, indexAry.length);
			
			var tempBmp:BitmapData = new BitmapData(512,512,false,0x666666);
			_objData.texture=_context.createTexture(tempBmp.width,tempBmp.height, Context3DTextureFormat.BGRA,true);
			_objData.texture.uploadFromBitmapData(tempBmp);
			
		}
		
		
	}
}