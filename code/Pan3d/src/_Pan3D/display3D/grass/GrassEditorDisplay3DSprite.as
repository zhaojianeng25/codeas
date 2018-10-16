package _Pan3D.display3D.grass
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.grass.quad.GrassQuadTreeModel;
	
	import _me.Scene_data;
	
	import terrain.GroundData;
	
	public class GrassEditorDisplay3DSprite extends GrassDisplay3DSprite
	{
		public function GrassEditorDisplay3DSprite(context:Context3D)
		{
			super(context);
		}
		private var _data:Array=[]
		private var _addObjVertex:Vector.<Number>;
		private var _addObjUv:Vector.<Number>;
		private var _addObjPostion:Vector.<Number>;
		private var _addObjLightIndex:Vector.<Number>;
		private var _addObjIndex:Vector.<uint>;
		private var _addObjData:ObjData

		private var _lastQuadPos:Vector3D=new Vector3D
		private static  var useQuadTree:Boolean=false
		public function get lastQuadPos():Vector3D
		{
			return _lastQuadPos;
		}
		public function set lastQuadPos(value:Vector3D):void
		{
			_lastQuadPos = value;
		}
		public function addGrassArr($arr:Array):void
		{
			_data=_data.concat($arr);
			if(!Boolean(_addObjData)){
				_addObjData=new ObjData
			}
			_addObjVertex=new Vector.<Number>();
			_addObjUv=new Vector.<Number>();
			_addObjPostion=new Vector.<Number>();
			_addObjLightIndex=new Vector.<Number>(); 
			_addObjIndex=new Vector.<uint>();
			var $indexNum:int=_objData.vertices.length / 3;   //基础草模型的顶点数量
			for(var i:uint=0;i<_data.length;i++){
				var $grassObj:Object=_data[i];
				_addObjVertex=_addObjVertex.concat(makeVertices($grassObj.scaleH,int($grassObj.rotationY)));
				_addObjUv=_addObjUv.concat(_objData.uvs);
				for (var k:int=0; k < $indexNum; k++)
				{
					_addObjPostion.push($grassObj.x, $grassObj.y,$grassObj.z); // 偏移
					_addObjLightIndex.push(1,2,3,4) //默认的位置
				}
				for (var v:int=0; v < _objData.indexs.length; v++)
				{
					_addObjIndex.push(_objData.indexs[v] + $indexNum * i);
				}
				super.pushBuffData(_addObjData,_addObjVertex, _addObjPostion,_addObjLightIndex, _addObjUv, _addObjIndex);
			}
			
		}
		override public function setGrassInfoItem($arr:Array):void
		{
			super.setGrassInfoItem($arr)
			if(useQuadTree){
				_baseItem=$arr;
				_changeData=true
			}
		}
		private var _changeData:Boolean=false
		private var _baseItem:Array
		private var _grassQuadTreeModel:GrassQuadTreeModel;
		
		public function listGrassQuad(hitPos:Vector3D):void
		{
			if(!_grassQuadTreeModel){
				_grassQuadTreeModel=new GrassQuadTreeModel
			}
			var $w:Number=GroundData.cellNumX*GroundData.terrainMidu*GroundData.cellScale*4
			var $h:Number=GroundData.cellNumZ*GroundData.terrainMidu*GroundData.cellScale*4
			_grassQuadTreeModel.groundWidth=$w
			_grassQuadTreeModel.groundHeight=$h
			if(_changeData){
				_grassQuadTreeModel.makeTree(_baseItem,new Vector3D($w/2,0,$h/2))
				_changeData=false
			}
			if(!Boolean(this.timeToken)&&_baseItem){
				var lasttime:uint=getTimer()
				if(hitPos){
					var k:Point=new Point;
					k.x=hitPos.x+$w/2
					k.y=hitPos.z+$h/2
					_lastQuadPos.x=Scene_data.cam3D.x
					_lastQuadPos.z=Scene_data.cam3D.z
					
					_grassQuadTreeModel.clikPos=k
					var $rec:Rectangle=new Rectangle(0,0,$w,$h)
					var $listArr:Vector.<Object>=_grassQuadTreeModel.drawNextRec($rec,0,new Vector.<Object>)
	
					var $objIndex:Vector.<uint>=new Vector.<uint>();
					var $indexNum:int=_objData.vertices.length / 3;   //基础草模型的顶点数量
					for(var i:uint=0;i<$listArr.length;i++)
					{
						for (var v:int=0; v < _objData.indexs.length; v++)
						{
							$objIndex.push(_objData.indexs[v] + $indexNum * $listArr[i].id);
						}
					}
					if($objIndex.length){
						if(_objData.indexBuffer){
							_objData.indexBuffer.dispose()
						}
						_objData.indexBuffer=this._context.createIndexBuffer($objIndex.length);
						_objData.indexBuffer.uploadFromVector(Vector.<uint>($objIndex), 0, $objIndex.length);
					}
				}
			}
		}
		override protected function pushBuffData($objData:ObjData,$vertex:Vector.<Number>, $postion:Vector.<Number>,$lightIndex:Vector.<Number>, $uv:Vector.<Number>, $index:Vector.<uint>):void
		{
			super.pushBuffData($objData,$vertex, $postion,$lightIndex, $uv, $index)
			_data=[]
			if(_addObjData){
				_addObjData.indexBuffer=null
			}
		}
	
		override public function update():void
		{
			super.update();
			if(_addObjData&&_addObjData.indexBuffer){
				_context.setVertexBufferAt(0, _addObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1, _addObjData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context.setVertexBufferAt(2, _addObjData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(3, _addObjData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				_context.setTextureAt(0,_grassTexture);
				_context.setTextureAt(1,groundLightUvTexture);
				_context.drawTriangles(_addObjData.indexBuffer, 0, -1);
				resetVa();
			}

		}

	}
}