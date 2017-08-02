package   _Pan3D.display3D.ground
{
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.modelLine.ModelLineSprite;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class ModelHasDepthSprite extends Display3DSprite 
	{
		public var fileRoot:String;
		public var lightRoot:String;
		protected var _modelLineSprite:ModelLineSprite
		protected var _context3D:Context3D;
		protected var _showTri:Boolean=false;
		protected var _select:Boolean=false;

		
		public static var editSee:Boolean=true
	
		public function ModelHasDepthSprite(context:Context3D)
		{
			super(context);
			_context3D=context
			init()
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			_select = value;
		}

		protected function init():void
		{
			
		}
		override public function showTriLine(value:Boolean):void
		{
			if(value&&!_modelLineSprite){
				_modelLineSprite=new ModelLineSprite(_context3D)
				if(_objData){
				_modelLineSprite.setModelObjData(_objData,_showTri)
				}
			}
			if(_modelLineSprite){
				_modelLineSprite.visible=value
			}
		}
		override public function dispose():void
		{
			if(_modelLineSprite){
				_modelLineSprite.dispose()
			}
		}
		override public function update():void
		{
			if(_modelLineSprite){
				_modelLineSprite.posMatrix=this.posMatrix
				_modelLineSprite.update()
			}
		}
		override public function updatePosMatrix():void{
			posMatrix.identity();

			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			if(this._scale_x!=0&&this._scale_y!=0&&this._scale_z!=0){
				posMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			}
			
			
			
		}

	}
}