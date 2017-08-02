package com.zcp._special.drag
{
	import com.greensock.TweenLite;
	import com.zcp.handle.HandleThread;
	import com.zcp.utils.Fun;
	import com.zcp.utils.ZMath;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	

	/**
	 * 拖拽管理器
	 * 说明：当为“拖入”模式时，拖入目标物体需要实现IDropInTarget接口
	 * @author zcp
	 * 
	 */	
	public class DragManager
	{
		//当前的拖拽数据
		private static var _dragData:DragData;
		//stage
		private static var _stage:Stage;
		
		public function DragManager()
		{
			throw new Event("静态类");
		}
		
		//公有方法
		//=============================================================================================================== 
		/**
		 * 添加一个拖拽
		 * @param $dragData
		 */
		public static function addDrag($dragData:DragData) : void
		{
			if(!$dragData)return;
			if(!$dragData.isValid())return;
			
			//如果有起作用区域限制，则未处于起作用区域则直接返回，不添加此拖拽
			if($dragData.touchRect)
			{
				if(!$dragData.touchRect.containsPoint($dragData.guiderStartPoint))
				{
					return;
				}
			}
			
			
			//删除旧值
			removeDrag();
			
			//记录
			_dragData = $dragData;
			_stage = _dragData.stage;
//			ZLog.add("DragManager::addDrag()::"+_dragData.dobj);  
	
			
//			if(_dragData.type ==DragType.DROP)
//			{
//				_dragData.dobj.visible = false;
//			}
//			_dragData.dobj.mouseEnabled = false;

			//注册事件
			_stage.addEventListener(Event.ENTER_FRAME,update);
			if(_dragData.mode==DragMode.DOWN_UP)
			{
				_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
			}
			else
			{
				_stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseUpHandle);
			}
			return;
		}  
		/**
		 * 清除某个拖拽
		 * @param $dobj
		 */
		public static function removeDragByDobj($dobj:DisplayObject) : DragData
		{
			if(!$dobj)return null;
			if(_dragData==null || _dragData.dobj!=$dobj)return null;
			return removeDrag();
		}  
		/**
		 * 清除拖拽
		 */
		public static function removeDrag():DragData
		{
			if(_dragData==null)return null;
			
			//还原
			if(_dragData.type ==DragType.DRAG)
			{
				//删除dragData.face
				if(_dragData.face!=_dragData.dobj)
				{
					if(_dragData.showMode == DragShowMode.BITMAP)
					{
						Fun.clearChildren(_dragData.face,true);
					}
					Fun.removeChild(_dragData.face);
				}
				
				//还原父容器
				if(_dragData.dragInStage)//注意这个判断,不能用后面这个 if(dragData.dobj.parent!=dragData.dobjParent)  或  //if(_dragData.dobj.parent==_stage)
				{
					_dragData.dobjParent.addChildAt(_dragData.dobj, Math.min(_dragData.dobjIndex, _dragData.dobjParent.numChildren));
				}
				
				//还原透明度		
				_dragData.dobj.alpha =  _dragData.dobjStartAlpha;
			}
			else if(_dragData.type ==DragType.DROP)
			{
				//还原动画
				doTween(_dragData);
			}
			
			//清除引用
//			ZLog.add("DragManager::removeDrag()::"+_dragData.dobj); 
			var temp:DragData = _dragData; 
			_dragData = null;
			
			//移除事件
			_stage.removeEventListener(Event.ENTER_FRAME,update);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandle);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseUpHandle);
			return temp;
		}          
		//=============================================================================================================== 		
		
		
		//刷新
		private static function update(e:Event) : void
		{
			//更新    
			if(_dragData.dobj.stage!=null)//如果被拖拽对象在舞台上了
			{
				//如果还没有启动拖动，则检测是否可以拖动了
				if(!_dragData.canMove)
				{
					//获取guider的位置
					var point:Point = new Point(_dragData.dobj.mouseX,_dragData.dobj.mouseY);
					
					//获取是否可以开始拖拽了,只要第一次获得true,后面恒true
					if(Point.distance(point,_dragData.guiderStartPoint) >= _dragData.criticalDis)
					{
						//添加
						_stage.addChild(_dragData.face);
						//改变标识
						_dragData.canMove = true;
					}
				}
				
				//可以拖动了
				if(_dragData.canMove)
				{
					//设置透明度
					_dragData.face.alpha =  _dragData.alpha;
					//设置位置
					updatePos(_dragData);	
				}
			}
			else//如果被拖拽对象已经不在舞台上了
			{			
				removeDrag();
			}
			return;
		}  
		//设置位置
		private static function updatePos($dragData:DragData) : void
		{
			if(!$dragData)return;
			
			var target:DisplayObject = $dragData.face.stage!=null ? $dragData.face : $dragData.dobj;
			if(target.parent==null)return;
			
			var xx:Number;
			var yy:Number;
			xx = target.parent.mouseX -$dragData.guiderStartPoint.x;
			yy = target.parent.mouseY -$dragData.guiderStartPoint.y;
			if($dragData.xyRect)
			{
//				var leftTop:Point = target.parent.globalToLocal(new Point($dragData.xyRect.left, $dragData.xyRect.top));
//				var rightBottom:Point = target.parent.globalToLocal(new Point($dragData.xyRect.right, $dragData.xyRect.bottom));
//				
//				if(xx<leftTop.x)xx = leftTop.x;
//				if(xx>rightBottom.x)xx = rightBottom.x;
//				if(yy<leftTop.y)yy = leftTop.y;
//				if(yy>rightBottom.y)yy = rightBottom.y;
				
				if(xx<$dragData.xyRect.left)xx = $dragData.xyRect.left;
				if(xx>$dragData.xyRect.right)xx = $dragData.xyRect.right;
				if(yy<$dragData.xyRect.top)yy = $dragData.xyRect.top;
				if(yy>$dragData.xyRect.bottom)yy = $dragData.xyRect.bottom;
			}
			target.x = xx;
			target.y = yy;
			return;
		}  
		
		
		
		//处理函数
		//=============================================================================================================== 
		//从$target到最顶层stage的冒泡判断，逐个执行dropIn
		private static function dropIn($target:DisplayObject, $dragData:DragData):Boolean
		{
			var hasDroped:Boolean;
			
			//先取得自身及所有父级对象的集合
			var dobjList:Array = Fun.parentList($target);
			dobjList.unshift($target);
	
			
			//再逐个执行drop函数
			var dropInTarget:IDropInTarget;
//			var iObj:InteractiveObject;
			var len:int=dobjList.length;
			for(var i:int=0; i<len; i++)
			{
				var item:DisplayObject = dobjList[i];
//				if(item is InteractiveObject) //可鼠标交互的对象
//				{
//					iObj =  item as InteractiveObject;
//					if(iObj.mouseEnabled )//响应应标
//					{
						if(item is IDropInTarget)//实现了拖拽目标接口
						{
							dropInTarget = item as IDropInTarget;
							
							//向拖拽目标内传参数
							var di:DropInData = $dragData.data;
							var ok:Boolean = dropInTarget.dropIn(di);
							if(ok && !hasDroped)
							{
								//改变标识
								hasDroped = true;
							}
							
							//判断是否打断
							if(di && di.breakUp)
							{
								break;
							}
						}
//					}
//				}
			}
			
			return hasDroped;
		}
		//全局鼠标up事件
		private static function mouseUpHandle(e:MouseEvent) : void
		{
			//移除
			var dragData:DragData = removeDrag();
			if(!dragData)return;
			if(!dragData.canMove)return;//注意这个判断必须
			
			
			
			var stageXY:Point = new Point(_stage.mouseX,_stage.mouseY);
			
			//only for DragType.DRAG
			//----------------------------------------------------------
			if(dragData.type ==DragType.DRAG)
			{
				//设置dragData.dobj位置
				if(dragData.canMove)
				{
					updatePos(dragData);
				}
				
				//还原dragData.dobj
//				dragData.dobj.mouseEnabled = true;
			}
			//----------------------------------------------------------
				
			//only for DragType.DROP
			//----------------------------------------------------------
			else if(dragData.type ==DragType.DROP)
			{
				//取得拖拽到得目标
				var dropInTarget:IDropInTarget;
				var arr:Array = dragData.stage.getObjectsUnderPoint(stageXY);
				if(arr.length>0)
				{
					//去掉自身以及自身的所有子元素 以及face
					var selfList:Array = [dragData.dobj, dragData.face];
					if(dragData.dobj is DisplayObjectContainer)
					{
						selfList = selfList.concat(Fun.childList(dragData.dobj as DisplayObjectContainer));
					}
					if(dragData.face is DisplayObjectContainer)
					{
						selfList = selfList.concat(Fun.childList(dragData.face as DisplayObjectContainer));
					}
					for each(var dobj:DisplayObject in selfList)
					{
						var index:int = arr.indexOf(dobj);
						if(index!=-1)
						{
							arr.splice(index, 1);
							if(arr.length==0)
							{
								break;
							}
						}
					}

					
					//若数组内还有元素
					if(arr.length>0)
					{
						//向拖拽目标内传参数, 只取最上一个
						var ok:Boolean = dropIn(arr[arr.length-1], dragData);
						if(ok)//从目标到最顶层stage的冒泡判断
						{
							//直接清除缓动还原
							TweenLite.killTweensOf(dragData.face,true);
						}
					}
				}
			}
			//----------------------------------------------------------
			
			//完成回调
			if(dragData.onComplete!=null)
			{
				HandleThread.execute(dragData.onComplete,dragData.onCompleteParameters);
			}
			return;
		}  
		//=============================================================================================================== 
		
		//缓动还原 only for DragType.DROP
		//=============================================================================================================== 
		//缓动还原
		private static function doTween($dragData:DragData) : void
		{
			if(!$dragData)return;
			if(!$dragData.isValid())return;
			if($dragData.type != DragType.DROP)return;
			
			//缓动
			try{	
				var speed:Number = 1450;
				var p:Point = $dragData.dobjParent.localToGlobal($dragData.dobjStartPoint);
				var duration:Number = Math.sqrt(ZMath.getDisSquare($dragData.face.x, $dragData.face.y,p.x, p.y))/speed;
				TweenLite.to($dragData.face,duration,{x:p.x,y:p.y,onComplete:tweenComplete,onCompleteParams:[$dragData]});
			}
			catch(e:Error)
			{
				$dragData.face.x = p.x;
				$dragData.face.y = p.y;
				tweenComplete($dragData);
			}
			return;
		}  
		//缓动结束
		private static function tweenComplete($dragData:DragData) : void
		{
			//删除face
			if($dragData.face!=$dragData.dobj)
			{
				if($dragData.showMode == DragShowMode.BITMAP)
				{
					Fun.clearChildren($dragData.face,true);
				}
				Fun.removeChild($dragData.face);
			}
			
			//还原拖拽对象		
			$dragData.dobj.x = $dragData.dobjStartPoint.x;
			$dragData.dobj.y = $dragData.dobjStartPoint.y;	
			$dragData.dobj.alpha = $dragData.dobjStartAlpha;
			if($dragData.dragInStage)//注意这个判断,不能用后面这个 if(dragData.dobj.parent!=dragData.dobjParent)  或  //if(_dragData.dobj.parent==_stage)
			{
				$dragData.dobjParent.addChildAt($dragData.dobj, Math.min($dragData.dobjIndex, $dragData.dobjParent.numChildren));
			}
//			$dragData.dobj.mouseEnabled = true;
//			$dragData.dobj.visible = true;    
			return;
		}  
		//=============================================================================================================== 
		
	}
}