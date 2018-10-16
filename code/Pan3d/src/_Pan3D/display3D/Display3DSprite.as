package _Pan3D.display3D {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;

	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class Display3DSprite extends Display3D implements IDisplay3D {
		protected var _url : String;
		protected var _objData : ObjData;
		protected var _context : Context3D;
		private var _bitmapdata : BitmapData;
		private var _modelMatrix : Matrix3D;
		protected var _isDestroyed:Boolean;

	

		public function Display3DSprite(context : Context3D) {
			this._context = context;
		}

		public function showTriLine(value:Boolean):void
		{
			
		}
		
		public function processTBN():void{
			
		}


		public function get url():String
		{
			return _url;
		}

		public function resetStage() : void {
			
		}
		public function update() : void {
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
		public function setMatrix(modelMatrix : Matrix3D) : void {
			this._modelMatrix = modelMatrix;
		}

		public function set url(value : String) : void {
			_url = value;
			var loaderinfo : LoadInfo = new LoadInfo(value, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}

		protected function onObjLoad(str : String) : void {
			_objData = AnalysisServer.getInstance().analysisObj(str);
			uplodToGpu();
			TextureManager.getInstance().addTexture(Scene_data.fileRoot+"texture/" + _objData.mtl + ".jpg", addTexture, null,0);
		}

		private function onTextureLoad(bitmap : Bitmap) : void {
			this._bitmapdata = bitmap.bitmapData;
			uplodToGpu();
		}
 
		protected function addTexture(textureVo : TextureVo, info : Object) : void {
			_objData.texture = textureVo.texture;
			textureVo.useNum++
			uplodToGpu();
			Scene_data.loadModeOk(_url);
			this.loadComplete = true;
			this.dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";

		protected function uplodToGpu() : void {
 			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);

			_objData.uvBuffer = this._context.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			if(_objData.lightUvs){
				_objData.lightUvsBuffer = this._context.createVertexBuffer(_objData.lightUvs.length / 2, 2);
				_objData.lightUvsBuffer.uploadFromVector(Vector.<Number>(_objData.lightUvs), 0, _objData.lightUvs.length / 2);
			}

			if(_objData.normals){
				_objData.normalsBuffer = this._context.createVertexBuffer(_objData.normals.length / 3, 3);
				_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length / 3);
			}
			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(1, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}

		protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(1,null);
		}

		protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
		}
		
		protected function setScanningVa() : void {

		}
		
		protected function resetScanningVa() : void {

		}
		
		protected function setScanningVc() : void {
			
		}

		public function get objData():ObjData
		{
			return _objData;
		}
		public function set objData(value:ObjData):void
		{
			_objData = value;
		}
		public function get disposed():Boolean
		{
			return this._context.driverInfo == "Disposed";
		}
		public function removeRender():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		
		public function reload():void{
			//_context = Scene_data.context3D;
		}
		
		override public function dispose():void
		{
			_isDestroyed = true;
			super.dispose();
			if(_bitmapdata)
			{
				_bitmapdata.dispose();
				_bitmapdata = null;
			}
		}
		
	}
}