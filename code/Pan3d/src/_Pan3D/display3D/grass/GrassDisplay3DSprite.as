package  _Pan3D.display3D.grass
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import PanV2.TextureCreate;
	import PanV2.loadV2.BmpLoad;
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GrassDisplay3DSprite extends ModelHasDepthSprite
	{
		/**
		 *在面向镜头时要做为纠正的旋转矩阵 
		 */
		private var _rotationMatrix3D:Matrix3D=new Matrix3D();
		/**
		 *顶点 
		 */
		private var _objVertex:Vector.<Number>;
		/**
		 *贴图 
		 */
		private var _objUv:Vector.<Number>;
		/**
		 *位置 
		 */
		private var _objPostion:Vector.<Number>;
		/**
		 *灯光编号 
		 */
		private var _objLightIndex:Vector.<Number>;
		/**
		 *系号 
		 */
		private var _objIndex:Vector.<uint>;
		
		private var _grassRound:Number=0;//  摆动位移
		
		private var _grassSwing:Number=10; //摆动幅度
		private var _faceAtlook:Boolean=false;   //面向视点


		private var _material:MaterialTree
		public static var groundLightUvTexture:Texture
		public static var groundWidthX:Number=1
		public static var groundHeightY:Number=1
		
		public function GrassDisplay3DSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(GrassDisplay3DShader.GRASS_DISPLAY3D_SHADER,GrassDisplay3DShader)
			if(!groundLightUvTexture){
				groundLightUvTexture=TextureManager.getInstance().bitmapToTexture(new BitmapData(8,8,false,0xffffff))
			}
			
		}

		public function get faceAtlook():Boolean
		{
			return _faceAtlook;
		}

		public function set faceAtlook(value:Boolean):void
		{
			_faceAtlook = value;
		}

		public function get material():MaterialTree
		{
			return _material;
		}
		public function set material(value:MaterialTree):void
		{
			_material = value;
			if(_material){
				var $picUrl:String=Scene_data.fileRoot+_material.getMainTexUrl()
				loadTexturePic($picUrl)
			}
		}

		public function get timeToken():uint
		{
			return _timeToken;
		}

		override public function update():void
		{
			if(_objData&&_objData.indexBuffer){
				super.update();
				_context3D.setProgram(Program3DManager.getInstance().getProgram(GrassDisplay3DShader.GRASS_DISPLAY3D_SHADER))
				setVc()
				setVa()
				resetVa()
			}
		}
		public function getTrangleNum():Number
		{
			if(_objIndex){
				return _objIndex.length/3
			}else{
				return 0
			}
		}
		override protected function setVa() : void {
	
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setVertexBufferAt(2, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(3, _objData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context.setTextureAt(0,_grassTexture);
			_context.setTextureAt(1,groundLightUvTexture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
			
			

		}
		
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setVertexBufferAt(3, null);
			_context.setTextureAt(0,null);

		}
		private var _countNum:Number=0;
		private var _rangeSpeed:Number=3;//  摆动速度
		private function getGrassSwing():void
		{
			_countNum+=_rangeSpeed;
			_grassRound=_grassSwing*(Math.sin(_countNum*Math.PI/180))/60
			if(_countNum==360){
				_countNum=0;
			}
		}
		override protected function setVc() : void {
			this.updateMatrix();
			this.getGrassSwing()
			_rotationMatrix3D.identity()
			if(faceAtlook){
				_rotationMatrix3D.appendRotation(-Scene_data.cam3D.rotationY , Vector3D.Y_AXIS);	
			}
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,_rotationMatrix3D, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.5,0,0,0])); //专门用来存树的通道的
			
			
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 7, Vector.<Number>([2,2,2,2])); //专门用来存树的通道的
			
			
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([1/groundWidthX,1/groundHeightY,0.5,0.5])); //专门用来存树的通道的
			

		}

		override public function set url(value : String) : void {
			if(_url!=value){
				_url = value;
				ObjsLoad.getInstance().addSingleLoad(value,objsFun)
			}
		
		}
		
		private function objsFun(obj:ObjData):void
		{
			this.objData=obj
			resetData()
		}
		public function resetData():void
		{
			if(_dataItem){
				setGrassInfoItem(_dataItem);
			}
		}
		private var _dataItem:Array  //草的数据数组
		private var _timeToken:uint;
		public function setGrassInfoItem($arr:Array):void
		{
			_dataItem=$arr
			if (!_objData||!_objData.indexs )
			{
				return; //原来加载好objs后会重置，所以不必像以前那样进行检查
			}
			if(!$arr||$arr.length==0){
				if(_objData.indexBuffer){
					_objData.indexBuffer.dispose()
				}
				return;
			}
			_objVertex=new Vector.<Number>();
			_objUv=new Vector.<Number>();
			_objPostion=new Vector.<Number>(); 
			_objLightIndex=new Vector.<Number>(); 
			_objIndex=new Vector.<uint>();
			var $indexNum:int=_objData.vertices.length / 3;   //基础草模型的顶点数量
			if(_timeToken){
				clearInterval(_timeToken);
				_timeToken=0
			}
			_timeToken=setInterval(timeFun, 50) //计数器规避不至于创建草的时候，卡死
			var $lastTimer:int=0;
			var $curTime:int=0;
			var $modeID:Number=0;
			function timeFun():void
			{
				$lastTimer=getTimer();
				while (true)
				{
					var $grassObj:Object=$arr[$curTime];
					$curTime=$curTime + 1;
					if($grassObj==null){
						break;
					}
					//var $lightVec:Vector3D=new Vector3D(grassObj.lightX,grassObj.lightY,grassObj.lightZ,grassObj.lightW)//默认的位置
					_objVertex=_objVertex.concat(makeVertices($grassObj.scaleH*1,int($grassObj.rotationY)));
					_objUv=_objUv.concat(_objData.uvs);
					for (var k:int=0; k < $indexNum; k++)
					{
						_objPostion.push($grassObj.x, $grassObj.y,$grassObj.z); // 偏移
						_objLightIndex.push(1,2,3,4) //默认的位置
					}
					for (var v:int=0; v < _objData.indexs.length; v++)
					{
						_objIndex.push(_objData.indexs[v] + $indexNum * $modeID);
					}
					$modeID++;
					if ($curTime >= $arr.length||_objIndex.length>80000)  //全部算过之后
					{
						clearInterval(_timeToken);
						_timeToken=0
						pushBuffData(_objData,_objVertex, _objPostion,_objLightIndex, _objUv, _objIndex);
						break;
					}
					if ((getTimer() - $lastTimer) > 50) //当时间超出设定的范围时设定这个进程不要超过50毫秒
					{
						break;
					}
				}
			}
			
		}
		/**
		 *将组合好的数据推向GPU 
		 * @param vv
		 * @param ss
		 * @param uu
		 * @param ii
		 * 
		 */
		protected function pushBuffData($objData:ObjData,$vertex:Vector.<Number>, $postion:Vector.<Number>,$lightIndex:Vector.<Number>, $uv:Vector.<Number>, $index:Vector.<uint>):void
		{
			$objData.vertexBuffer=this._context.createVertexBuffer($vertex.length / 3, 3);
			$objData.vertexBuffer.uploadFromVector(Vector.<Number>($vertex), 0, $vertex.length / 3);
			
			$objData.normalsBuffer=this._context.createVertexBuffer($postion.length / 3, 3); //存状态;
			$objData.normalsBuffer.uploadFromVector(Vector.<Number>($postion), 0, $postion.length / 3);
			
			$objData.lightUvsBuffer=this._context.createVertexBuffer($lightIndex.length / 4, 4); //存状态;
			$objData.lightUvsBuffer.uploadFromVector(Vector.<Number>($lightIndex), 0, $lightIndex.length / 4);
			
			$objData.uvBuffer=this._context.createVertexBuffer($uv.length / 2, 2);
			$objData.uvBuffer.uploadFromVector(Vector.<Number>($uv), 0, $uv.length / 2);
			
			
			$objData.indexBuffer=this._context.createIndexBuffer($index.length);
			$objData.indexBuffer.uploadFromVector(Vector.<uint>($index), 0, $index.length);
			
			
		}
		/**
		 *创建 一棵草的顶点数据
		 * @param sizeNum  大小
		 * @param strotationY  初始角度
		 * @return 
		 * 
		 */
		protected function  makeVertices(sizeNum:Number,strotationY:Number=0):Vector.<Number>
		{
			var item:Vector.<Number>=new Vector.<Number>();
			var p:Vector3D=new Vector3D();
			var m:Matrix3D=new Matrix3D();
			m.prependRotation(strotationY,new Vector3D(0,1,0));
			for(var i:int=0;i< _objData.vertices.length/3;i++)
			{
				p.x=_objData.vertices[i*3+0]*sizeNum;
				p.y=_objData.vertices[i*3+1]*sizeNum;
				p.z=_objData.vertices[i*3+2]*sizeNum;
				if(!_faceAtlook){
					p=m.transformVector(p);
				}
				item.push(p.x,p.y,p.z);
			}
			return item;
		}

		protected var _grassTexture:Texture
	    private function  loadTexturePic(value : String) : void 
		{

			BmpLoad.getInstance().addSingleLoad(value,function ($bitmap:Bitmap,$obj:Object):void{
				var $w:uint=Math.pow(2,Math.ceil(Math.log($bitmap.bitmapData.width)/Math.log(2)))
				var $h:uint=Math.pow(2,Math.ceil(Math.log($bitmap.bitmapData.height)/Math.log(2)))
				_grassTexture=TextureCreate.getInstance().bitmapToMinTexture($bitmap.bitmapData,$w,$h)
				
			},{})
			
		}

	}
}
