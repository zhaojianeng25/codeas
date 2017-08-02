package com.zcp._special.cd
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.zcp.pool.IPoolClass;
	import com.zcp.utils.ZMath;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * CDFace 
	 * @author zcp
	 */	
	public class CDFace extends Sprite implements IPoolClass
	{
		private var _bindings:Array = [];//同步的CDFace数组
		private var _now:Number = 0;//目前时间
		private var _cd:Number = 0; //总CD时间
		public var parentCDFace:CDFace; //绑定到的父CDFace
		
		public var isPublic:Boolean;//是否是公共冷却
		public var coolingID:*;//冷却ID
		
		//缓动用
		private var _obj:Object = {angle:0};
		//画图用
		private var _mask:Shape;
		private var _r:Number;
		private var _w:Number;
		private var _h:Number;
		//完成回调
		private var _onComplete:Function;
		public function CDFace($width:Number, $height:Number,$onComplete:Function=null)
		{
			mouseEnabled = mouseChildren = false;
			
			reSet([$width,$height,$onComplete]);
		}
		
		/**@private*/
		public function dispose():void{
			stop(false);
			
			//解除所有子绑定
			removeAllBindingChildren(false);
			_bindings = [];
			_now = 0;
			_cd = 0;
			//解除父绑定绑定
			if(parentCDFace!=null)
			{
				parentCDFace.removeBindingChild(this,false);
				parentCDFace = null;
			}
			
			isPublic = false;
			coolingID = null;
			_obj = {angle:0};
			_onComplete = null;
			_mask.graphics.clear();
		}
		/**@private*/
		public function reSet($parameters:Array):void{
			_w = Math.ceil($parameters[0]/2);
			_h = Math.ceil($parameters[1]/2);
			_onComplete = $parameters[2];
			
			//遮罩
			if(!_mask)
			{
				_mask = new Shape();
				this.addChild(_mask);
			}
			_mask.x = _w;
			_mask.y = _h;
			
			//此CD真身
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(0,0.5);
			g.drawRect(0,0,$parameters[0],$parameters[1]);
			g.endFill();
			this.mask = _mask;
		}
		
		public function get cd():Number	
		{
			return _cd ;
		}
		public function get now():Number	
		{
			return _now ;
		}
		/**
		 * 取得剩余时间（秒）
		 * */
		public function getLosttime():Number	
		{
			return _cd - _now;
		}
		
		/**
		 * 是否含有指定的绑定对象
		 * @param $bindingChild
		 * */
		public function hasBindingChild($bindingChild:CDFace):Boolean	
		{
			return _bindings.indexOf($bindingChild)!=-1;
		}
		/**
		 * 添加绑定
		 * @param $bindingChild 要添加的对象
		 * @param $clearOldBinding 是否删除旧有的绑定
		 * @param $complete 是否执行完成动作
		 * */
		public function addBindingChild($bindingChild:CDFace,$clearOldBinding:Boolean=false,$complete:Boolean=true):void	
		{
			//检测存在性
			if($clearOldBinding)
			{
				removeAllBindingChildren($complete);
			}
			else
			{
				if(hasBindingChild($bindingChild))return;
			}
			
			//解除旧的父子关系
			if($bindingChild.parentCDFace)
			{
				$bindingChild.parentCDFace.removeBindingChild($bindingChild,false);
			}
			$bindingChild.stop(false);
			
			//绑定新的父子关系
			$bindingChild.parentCDFace = this;
//			$bindingChild.now = _now;
//			$bindingChild.cd = _cd;
//			$bindingChild.update(_cd!=0 ? _now/_cd*360 : 360);
			$bindingChild.play(_cd,_now);
			_bindings.push($bindingChild);
			return;
		}
		/**
		 * 删除绑定
		 * @param $bindingChild 要删除的对象
		 * @param $complete 是否执行完成动作
		 * */
		public function removeBindingChild($bindingChild:CDFace,$complete:Boolean=true):void	
		{
			if($bindingChild && hasBindingChild($bindingChild))
			{
				//从数组中移除
				var index:int = _bindings.indexOf($bindingChild);
				_bindings.splice(index,1);
				//解除父子关系
				$bindingChild.parentCDFace=null;
				//执行完成
				if($complete)
				{
					$bindingChild.update(360);
				}
			}
			return;
		}
		/**
		 * 删除全部绑定
		 * @param $complete 是否执行完成动作
		 * */
		public function removeAllBindingChildren($complete:Boolean=true):void	
		{
			while(_bindings.length>0)
			{
				//从数组中移除
				var cdFace:CDFace = _bindings.shift();
				//解除父子关系
				cdFace.parentCDFace=null;
				//执行完成
				if($complete)
				{
					cdFace.update(360);
				}
			}
			return;
		}
		/**
		 * 开始
		 * @param $cd CD时长（秒）
		 * @param $start 开始时间（秒）
		 * */
		public function play($cd:Number, $start:Number=0):void
		{
			stop(false);
			
			_cd = $cd;
			_now = $start;
			
			//同步绑定后代的每一项初始数据
			if(_bindings.length>0)
			{
				_bindings.forEach(function(element:*, index:int, arr:Array):void{
					var cdf:CDFace = element as CDFace;
					cdf.play(_cd, _now);
				});
			}
			//如果是被绑定的对象则返回
			if(this.parentCDFace!=null)
			{
				return;
			}
			
			
			//缓动
			_obj.angle = _cd!=0 ? _now/_cd*360 : 360;
			if(getLosttime()>0)
			{
				onUpdate();
				TweenLite.to(_obj, getLosttime(), {angle:360, onUpdate:onUpdate, onComplete:onComplete,ease:Linear.easeNone});
			}
			else
			{
				onComplete();
			}
		}
		/**@private*/
		private function onUpdate():void
		{
			update(_obj.angle, false);//注意这个参数为false
		}
		/**@private*/
		private function onComplete():void
		{
			update(360);
		}
		/**
		 * 停止
		 * @param $complete 是否执行完成动作
		 * */
		public function stop($complete:Boolean=true):void
		{
			TweenLite.killTweensOf(_obj,$complete);
		}
		

		/**
		 * 更新
		 * @param $angle 角度
		 * @param $360isComplete 当传进360度时是否执行完成回调
		 */
		private function update($angle:Number=0, $360isComplete:Boolean=true):void
		{
			_now = $angle/360*_cd;
			
			//同步绑定的每一项
			if(_bindings.length>0)
			{
				_bindings.forEach(function(element:*, index:int, arr:Array):void{
					var cdf:CDFace = element as CDFace;
					cdf.update($angle, $360isComplete);
				});
			}
			
			//画遮罩
			//=================================================================
			//过滤角度
			var g:Graphics = _mask.graphics;
			g.clear();
			if($angle==0)
			{
				g.clear();
				g.beginFill(0,1);
				g.drawCircle(0,0,Math.sqrt(_w*_w+_h*_h));
				g.endFill();
				return;
			}
			else if($angle==360)
			{
				//完成回调
				if($360isComplete)
				{
					if(_onComplete!=null)
					{
						_onComplete(this);
					}
				}
				return;
			}
			else if($angle<0 || $angle>360)
			{
				return;
			}
			
			//画遮罩
			var tanA:Number= Math.tan($angle*ZMath.toRad);//取得正切值
			var xx:Number;
			var yy:Number;
			g.beginFill(0,1);
			g.moveTo(0,0);
			if($angle>=0 && $angle<45)
			{
				xx = _w*tanA;
				yy = -_h;
				g.lineTo(xx, yy);
				g.lineTo(_w, -_h);
				g.lineTo(_w, _h);
				g.lineTo(-_w, _h);
				g.lineTo(-_w, -_h);
			}
			else if($angle>=45 && $angle<135)
			{
				xx = _w;
				yy = -_w/tanA;
				g.lineTo(xx, yy);
				g.lineTo(_w, _h);
				g.lineTo(-_w, _h);
				g.lineTo(-_w, -_h);
			}
			else if($angle>135 && $angle<225)
			{
				xx = -_h*tanA;
				yy = _h;
				g.lineTo(xx, yy);
				g.lineTo(-_w, _h);
				g.lineTo(-_w, -_h);
			}
			else if($angle>=225 && $angle<315)
			{
				xx = -_w;
				yy = _w/tanA;
				g.lineTo(xx, yy);
				g.lineTo(-_w, -_h);
			}
			else if($angle>=315 && $angle<360)
			{
				xx = _w*tanA;
				yy = -_h;
				g.lineTo(xx, yy);
			}
			g.lineTo(0,-_h);
			g.lineTo(0,0);
			g.endFill();
			//=================================================================
		}
	}
}