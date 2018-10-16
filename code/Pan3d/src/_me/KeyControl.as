﻿package _me {
	import _Pan3D.base.Focus3D;
	import _Pan3D.base.Object3D;
	import _Pan3D.core.Groundposition;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class KeyControl extends EventDispatcher {
		private var _stage : Stage;
		private var _isFrist : Boolean = true;
		private var _keyobj : Object = new Object;
		
		public function KeyControl() {
		}
		public function init(temp_stage : Stage) : void {
			_stage = temp_stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keydownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyupHandler);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		
		}
		private function stageMouseUp(event : MouseEvent) : void {
			Scene_data.mouseInfo._mouseDown = false;
		}
		protected function stageMouseMove(event : MouseEvent) : void {

			if (Scene_data.mouseInfo._mouseDown) {
				var _E : Object3D = Groundposition._getposition(Scene_data.cam3D,Scene_data.stage.mouseX - Scene_data.stage3D.x, Scene_data.stage.mouseY - Scene_data.stage3D.y);
				Scene_data.focus3D.x = Scene_data.mouseInfo._old_x - (_E.x - Scene_data.mouseInfo._last_x);
				Scene_data.focus3D.z = Scene_data.mouseInfo._old_z - (_E.z - Scene_data.mouseInfo._last_z);
			}
	
		}
		private function stageMouseDown(event : MouseEvent) : void {
			if(!(event.target as Stage)){
				return;
			}
			
			
			var _E : Object3D = Groundposition._getposition(Scene_data.cam3D,Scene_data.stage.mouseX - Scene_data.stage3D.x, Scene_data.stage.mouseY - Scene_data.stage3D.y);
	
		//	_E.toString();
			//return ;
			Scene_data.mouseInfo._last_x = _E.x;
			Scene_data.mouseInfo._last_y = _E.y;
			Scene_data.mouseInfo._last_z = _E.z;
			
			Scene_data.mouseInfo._old_x = Scene_data.focus3D.x;
			Scene_data.mouseInfo._old_y = Scene_data.focus3D.y;
			Scene_data.mouseInfo._old_z = Scene_data.focus3D.z;
			Scene_data.mouseInfo._mouseDown = true;
			
		}
		protected var seepNum : Number = 3;
		
		public function upData() : void {
			var focus3D:Focus3D=Scene_data.focus3D;
			if (isDown(37) || isDown(65)) {
				focus3D.angle_y += 1;
			}
			if (isDown(39) || isDown(68)) {
				focus3D.angle_y -= 1;
			}
			var r1 : Number = -(focus3D.angle_y + 90);
			if (isDown(38) || isDown(87)) {
				focus3D.willgo_x = focus3D.x + seepNum * Math.cos(r1 * Math.PI / 180);
				focus3D.willgo_z = focus3D.z + seepNum * Math.sin(r1 * Math.PI / 180);
				
				focus3D.angle_x += 1;
				
			}
			if (isDown(40) || isDown(83)) {
				r1=r1 + 180
				focus3D.willgo_x = focus3D.x + seepNum * Math.cos(r1 * Math.PI / 180);
				focus3D.willgo_z = focus3D.z + seepNum * Math.sin(r1 * Math.PI / 180);
				focus3D.angle_x -= 1;
				
				
			}
		
		}
		private function mouseWheel(evt : MouseEvent) : void {
			if(evt.target as Stage){
				Scene_data.cam3D.distance = Scene_data.cam3D.distance + evt.delta * 10;
			}
		}
		private function keydownHandler(evt : KeyboardEvent) : void {
			_keyobj[evt.keyCode] = true;
			_isFrist = false;
			if(evt.keyCode == 87){
				this.dispatchEvent(evt);
			}
		
		}
		
		private function keyupHandler(evt : KeyboardEvent) : void {
			delete _keyobj[evt.keyCode];
			if(evt.keyCode == 87){
				this.dispatchEvent(evt);
			}
			
		}
		
		public function isDown(key : Number) : Boolean {
			return _keyobj[key] ? true : false;
		}
	}
}