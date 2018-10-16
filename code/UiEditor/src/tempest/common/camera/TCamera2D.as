package tempest.common.camera {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	/**
	 * 游戏摄像机
	 * @author wushangkun
	 */
	public class TCamera2D {
		/**缓动速度*/
		public var ease:Number = 0.3; 
		/**移动阈值比例*/
		public var distRatio:Number = 0.1; 
		/**X移动阈值*/
		public var distX:int = 100; 
		/**Y移动阈值*/
		public var distY:int = 60; 
		/**摄像机跟随对象*/
		public var follower:DisplayObject = null; 
		/**是否锁定摄像机*/
		public var locked:Boolean = false; 
		/**摄像机监视的视图对象*/
		private var _target:DisplayObject; 
		/**可视区域矩形*/
		private var _rect:Rectangle = new Rectangle(0, 0, 1000, 600); 
		/**真实宽*/
		public var boundW:int; 
		/**真实高*/
		public var boundH:int; 
		/**缩放比*/
		public var scaling:Number = 1; 
		/**是否开启移动阈值*/
		public var useDist:Boolean = true;

		/**
		 * 游戏摄像机
		 * @param targrt 摄像机监视的对象
		 * @param viewW 可视宽
		 * @param viewH 可视高
		 */
		public function TCamera2D(targrt:DisplayObject, width:Number = 1000, height:Number = 600) {
			this._target = targrt;
			this.boundW = targrt.width;
			this.boundH = targrt.height;
			_rect = new Rectangle(0, 0, width, height);
		}

		public function get x():Number {
			return _rect.x;
		}

		public function set x(value:Number):void {
			_rect.x = value;
			this.updateTarget();
		}

		public function get y():Number {
			return _rect.y;
		}

		public function set y(value:Number):void {
			_rect.y = value;
			this.updateTarget();
		}

		public function get rect():Rectangle {
			return _rect;
		}

		/**
		 * 设置可视区域尺寸
		 * @param w
		 * @param h
		 */
		public function setView(w:Number, h:Number):void {
			this.rect.width = w;
			this.rect.height = h;
		}

		/**
		 * 设置真实尺寸
		 * @param w
		 * @param h
		 */
		public function setBound(w:Number, h:Number):void {
			this.boundW = w;
			this.boundH = h;
		}

		/**
		 * 角色是否可见
		 * @param char
		 * @return
		 */
		public function canSee(element:DisplayObject):Boolean {
			return (element.x > this.rect.x) && (element.x < rect.right) && (element.y > rect.y) && (element.y < rect.bottom);
		}

		/**
		 * 关注对象
		 * @param follow
		 * @param useTween
		 */
		public function lookAt(follow:DisplayObject, useEase:Boolean = false):void {
			this.follower = follow;
			this._isShaking = false;
			this.run(useEase);
		}

		/**
		 * 更新摄像机
		 * @param useTween 是否使用缓动
		 */
		public function run(useEase:Boolean = true):void {
			if (locked)
				return;
			if (follower == null)
				return;
			var fx:int = follower.x * scaling;
			var fy:int = follower.y * scaling;
			var cx:int = this.rect.x + this.rect.width * 0.5;
			var cy:int = this.rect.y + this.rect.height * 0.5;
			var dx:int = Math.abs(fx - cx);
			var dy:int = Math.abs(fy - cy);
			var sx:int = this.rect.x;
			var sy:int = this.rect.y;
			if (this.useDist) {
				this.distX = this.rect.width * distRatio;
				this.distY = this.rect.height * distRatio;
				if (dx > distX) {
					dx -= distX;
					if (follower.x < cx)
						dx = -dx;
					sx += (useEase) ? dx * ease : dx;
				}
				if (dy > distY) {
					dy -= distY;
					if (follower.y < cy)
						dy = -dy;
					sy += (useEase) ? dy * ease : dy;
				}
			} else {
				if (fx < cx)
					dx = -dx;
				sx += (useEase) ? dx * ease : dx;
				if (fy < cy)
					dy = -dy;
				sy += (useEase) ? dy * ease : dy;
			}
			if (boundW < this.rect.width) {
				this.rect.x = -(this.rect.width - boundW) * 0.5;
			} else {
				this.rect.x = Math.min(Math.max(sx, 0), boundW - this.rect.width) >> 0;
			}
			if (boundH < this.rect.height) {
				this.rect.y = -(this.rect.height - boundH) * 0.5;
			} else {
				this.rect.y = Math.min(Math.max(sy, 0), boundH - this.rect.height) >> 0;
			}
			//震动
			if (_isShaking) {
				_shake_count++;
				if (getTimer() > _shake_endTime) {
					_shake_count = 0;
					_isShaking = false;
				} else if (!(_shake_count & 1)) {
					this.rect.y += (Math.random() - 0.5) * _shake_intensity;
				}
			}
			this.updateTarget();
		}

		private function updateTarget():void {
			if (this._target) {
				var rect:Rectangle = this._target.scrollRect;
				if (rect && rect.equals(this.rect))
					return;
				this._target.scrollRect = this.rect;
			}
		}
		//==================================摄像机震动=============================================
		private var _isShaking:Boolean = false;
		private var _shake_endTime:Number = 0;
		private var _shake_duration:Number = 0;
		private var _shake_intensity:int = 50;
		private var _shake_count:int = 0;
		private var _canShake:Boolean = true;

		/**
		 * 是否可以振动
		 * @return
		 */
		public function get canShake():Boolean {
			return _canShake;
		}

		/**
		 * 启动振动
		 */
		public function enableShake():void {
			_canShake = true;
		}

		/**
		 * 禁用振动
		 */
		public function disableShake():void {
			_canShake = false;
		}

		/**
		 * 振动
		 * @param duration 振动持续时间 单位:秒
		 * @param intensity 振动强度  单位:像素
		 */
		public function shake(duration:Number = 0.3, intensity:int = 50):void {
			if (!_canShake || _isShaking) {
				return;
			}
			_shake_count = 0;
			_shake_duration = duration;
			_shake_intensity = intensity;
			_shake_endTime = getTimer() + duration * 1000;
			_isShaking = true;
		}
	}
}
