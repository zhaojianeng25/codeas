package xyz.draw
{
	import flash.display.Bitmap;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooObjData;

	
	public class TooUtilDisplay extends EventDispatcher  {
		protected var _url : String;
		protected var _objData : TooObjData;
		//protected var _context : Context3D;
		private var _modelMatrix : Matrix3D;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _z:Number = 0;
		
		protected var _id:int=0;
		protected var _name:String;
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
		
		protected var _scale:Number = 1;
		protected var _scale_x:Number = 1;
		protected var _scale_y:Number = 1;
		protected var _scale_z:Number = 1;
		
		public var modelMatrix:Matrix3D;
		public var posMatrix:Matrix3D;
		
		
		
		protected var _absoluteX:Number = 0;
		protected var _absoluteY:Number = 0;
		protected var _absoluteZ:Number = 0;
		
		protected var _visible:Boolean = true;
		
		public var loadComplete:Boolean;
		protected var _program:Program3D;
		protected var _context3D:Context3D;
		public function TooUtilDisplay(context : Context3D) {

			
			
			_context3D=context
			posMatrix=new Matrix3D
			initProgram()

		}
		
		protected function initProgram():void
		{
			// TODO Auto Generated method stub
			
		}
	
		
		public function get absoluteZ():Number
		{
			return _absoluteZ;
		}
		
		public function set absoluteZ(value:Number):void
		{
			_absoluteZ = value;
		}
		
		public function get absoluteY():Number
		{
			return _absoluteY;
		}
		
		public function set absoluteY(value:Number):void
		{
			_absoluteY = value;
		}
		
		public function get absoluteX():Number
		{
			return _absoluteX;
		}
		
		public function set absoluteX(value:Number):void
		{
			_absoluteX = value;
		}
		
		public function get z():Number
		{
			return _z;
		}
		
		public function set z(value:Number):void
		{
			_z = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get rotationX():Number
		{
			return _rotationX;
		}
		
		public function set rotationX(value:Number):void
		{
			_rotationX = value;
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		
		public function set rotationY(value:Number):void
		{
			_rotationY = value;
		}
		
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		
		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
		}
		
		public function get scale_z():Number
		{
			return _scale_z;
		}
		
		public function set scale_z(value:Number):void
		{
			_scale_z = value;
		}
		
		public function get scale_y():Number
		{
			return _scale_y;
		}
		
		public function set scale_y(value:Number):void
		{
			_scale_y = value;
		}
		
		public function get scale_x():Number
		{
			return _scale_x;
		}
		
		public function set scale_x(value:Number):void
		{
			_scale_x = value;
		}
		
		public function get program():Program3D
		{
			return _program;
		}
		
		public function set program(value:Program3D):void
		{
			_program = value;
		}
		
		public function get objData():TooObjData
		{
			return _objData;
		}
		
		public function set objData(value:TooObjData):void
		{
			_objData = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function resetStage() : void {
			
		}
		public function update() : void {
			
		}
		public function setMatrix(modelMatrix : Matrix3D) : void {
			
		}
		
		public function set url(value : String) : void {
			
		}
		
		protected function onObjLoad(str : String) : void {
			
		}
		
		private function onTextureLoad(bitmap : Bitmap) : void {
			
		}
		

		
		public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
		
		protected function uplodToGpu() : void {
			_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = _context3D.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			
			if(_objData.normals){
				_objData.normalsBuffer = _context3D.createVertexBuffer(_objData.normals.length / 3, 3);
				_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 3);
			}
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		protected function setVa() : void {
			
		}
		
		protected function resetVa() : void {
			
		}
		
		protected function setVc() : void {
			
		}
		
		
		
		public function get disposed():Boolean
		{
			return _context3D.driverInfo == "Disposed";
		}
		
		public function updatePosMatrix():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			posMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			
			
		}
		public function updateMatrix():void
		{
			
		}
		public function reload():void{
			//_context = Scene_data.context3D;
		}
		
		public function dispose():void
		{
			
		}
		
	}
}



