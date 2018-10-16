package com.zcp._special.drag
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 拖拽拖放数据模型
	 * @author zcp
	 * 
	 */	
	public class DragData
	{
		/**
		 * 拖动的时候是否在STAGE中运行（只有在DragShowMode为SELF的时候起效） 
		 */		
		public var dragInStage:Boolean;	
		
		private var _canMove:Boolean;			//是否可以开始拖拽了
		

		private var _dobj:InteractiveObject; 	//被拖拽对象
		private var _type:int; 					//拖拽类型	
		private var _mode:int; 					//拖拽操作样式
		private var _showMode:int; 				//拖拽显示样式
		private var _criticalDis:Number;		//拖拽超过此临界距离则开始拖拽(相对于_guiderStartPoint的距离)
		private var _xyRect:Rectangle;			//dobj的坐标约束矩形（相对于父容器！！！）
		private var _touchRect:Rectangle;		//dobj上可引发合法拖拽动作的区域
		private var _alpha:Number; 				//拖动过程中的透明度(0-1)
		private var _data:DropInData;			//携带数据
		

		private var _stage:Stage;				//stage
		private var _dobjParent:DisplayObjectContainer;	//被拖拽对象的父容器
		private var _dobjIndex:int;	//被拖拽对象的层级
		private var _face:DisplayObject;		//拖拽Face
		
		private var _guiderStartPoint:Point;			//触点起始点的坐标(相对于dobj)
		private var _dobjStartPoint:Point;				//_dobj的起始坐标
		private var _dobjStartAlpha:Number;				//_dobj的初始透明度


		private var _onComplete:Function;		//完成回调
		private var _onCompleteParameters:Array;//完成回调的参数
		/**
		 * DragData
		 * @param $dobj 					//被拖拽物体
		 * @param $type						//拖拽类型(详见：DragType)
		 * @param $mode						//拖拽操作样式(详见：DragMode)
		 * @param $showMode					//拖拽显示样式(详见：DragShowMode)
		 * @param $showUV					//鼠标位于显示样式上的的比例位置，null则取当前鼠标与拖拽对象的相对位置
		 * @param $criticalDis				//拖拽超过此临界距离则开始拖拽(相对于_guiderStartPoint的距离)
		 * @param $xyRect					//被拖拽物体的坐标约束矩形（相对于父容器！！！）
		 * @param $touchRect				//被拖拽物体上可引发合法拖拽动作的区域
		 * @param $alpha					//拖拽过程中的透明度
		 * @param $onComplete				//完成回调
		 * @param $onCompleteParameters		//完成回调的参数
		 * @param $data						//携带自定义数据
		 * 
		 */		
		public function DragData(
			$dobj:InteractiveObject,
			$type:int=1,
			$mode:int=0,
			$showMode:int=0,
			$showUV:Point=null,
			$criticalDis:Number=2,$xyRect:Rectangle=null,$touchRect:Rectangle=null,
			$alpha:Number=1,
			$onComplete:Function=null,$onCompleteParameters:Array=null,
			$data:DropInData=null)
		{
			if($dobj==null || $dobj.stage==null)
			{
				throw new Error("$dobj对象必须不能为空，并且存在于在显示列表中");
			}
			
//			if($type==DragType.DROP && $showMode==DragShowMode.SELF)
//			{
//				throw new Error("DragType.DROP的拖拽类型不能启用DragShowMode.SELF");
//			}
			
			_canMove = false;
			
			//设置数据
			_dobj = $dobj;
			_type = $type;
			_mode = $mode;
			_showMode = $showMode;
			_criticalDis = $criticalDis;
			_xyRect = $xyRect;
			_touchRect = $touchRect;
			_alpha = $alpha;
			_onComplete = $onComplete;
			_onCompleteParameters = $onCompleteParameters;
			_data = $data;
			

			//获取_stage
			_stage = $dobj.stage;
			_dobjParent = $dobj.parent;
			_dobjIndex = $dobj.parent.getChildIndex($dobj);
			
			//取得_guiderStartPoint
			var bounds:Rectangle = dobj.getRect(dobj);
			if($showUV==null)
			{
				_guiderStartPoint = new Point(_dobj.mouseX,_dobj.mouseY);
			}
			else
			{
				_guiderStartPoint = new Point(bounds.width*$showUV.x, bounds.height*$showUV.y);
			}
			
			
			//获取_dobjStartPoint和_dobjStartAlpha
			_dobjStartPoint = new Point(_dobj.x,_dobj.y);
			_dobjStartAlpha = _dobj.alpha;	
			
			//_dobjStartPoint相对于舞台额坐标
//			var dobjStartPoint_onStage:Point = _dobjParent.localToGlobal(_dobjStartPoint);
//			var mouseStartPoint_onStage:Point = new Point(_stage.mouseX, _stage.mouseY);
			
			//获取_face
			var face:Sprite;
			switch(_showMode)
			{
				case DragShowMode.SELF:
					_face = _dobj;
					break;
				
				case DragShowMode.FRAME:
					var inFace:Shape = new Shape();
					inFace.graphics.clear();
					inFace.graphics.lineStyle(1,0,1);
//					inFace.graphics.beginFill(0,0);
					inFace.graphics.drawRect(0,0,bounds.width,bounds.height);
//					inFace.graphics.endFill();
					face = new Sprite();	
					face.mouseEnabled = false;
					face.mouseChildren = false;
					face.addChild(inFace);
					
					
					inFace.x = bounds.x;
					inFace.y = bounds.y;
					//face.x = dobjStartPoint_onStage.x;
					//face.y = dobjStartPoint_onStage.y;

					_face = face;
					break;
				
				case DragShowMode.BITMAP:
				default:
					var ma:Matrix = new Matrix();
					ma.translate(-bounds.x, -bounds.y);
					
					var bmd:BitmapData = new BitmapData(bounds.width,bounds.height,true,0x000000);
					bmd.draw(_dobj,ma,null,null,null,true);
					var bm:Bitmap = new Bitmap(bmd,"auto",true);
					face = new Sprite();	
					face.mouseEnabled = false;
					face.mouseChildren = false;
					face.addChild(bm);
					
					bm.x = bounds.x;
					bm.y = bounds.y;
					//face.x = dobjStartPoint_onStage.x;
					//face.y = dobjStartPoint_onStage.y;	
					

					
					_face = face;	
					break;
			}
		


		}
		/**
		 * 获取拖拽数据是否合法
		 */
		public function isValid():Boolean
		{
			return (dobj!=null)
				&&(_dobjParent!=null)		//注意这个
				&&(!isNaN(_dobjIndex))		//注意这个
				&&(!isNaN(_type))
				&&(!isNaN(_mode))
				&&(!isNaN(_showMode))
				&&(_guiderStartPoint!=null)
				&&(!isNaN(_criticalDis))
				&&(_dobjStartPoint!=null)
				&&(!isNaN(_dobjStartAlpha))
				&&(!isNaN(_alpha))
				&&(_stage!=null);
		}
		
//		/**
//		 * 是否等价（只检查主要数据）
//		 */
//		public function equal($dragData:DragData):Boolean
//		{
//			return dobj==$dragData.dobj;
//			//只检查主要数据
//		}

		public function get type():int
		{
			return _type;
		}
		public function get mode():int
		{
			return _mode;
		}
		public function get showMode():int
		{
			return _showMode;
		}
		public function get dobj():InteractiveObject
		{
			return _dobj;
		}

		public function get guiderStartPoint():Point
		{
			return _guiderStartPoint;
		}
		public function get dobjStartPoint():Point
		{
			return _dobjStartPoint;
		}
		public function get dobjStartAlpha():Number
		{
			return _dobjStartAlpha;
		}
		public function get criticalDis():Number
		{
			return _criticalDis;
		}
		public function get xyRect():Rectangle
		{
			return _xyRect;
		}
		public function get touchRect():Rectangle
		{
			return _touchRect;
		}
		public function get alpha():Number
		{
			return _alpha;
		}

		public function get onComplete():Function
		{
			return _onComplete;
		}
		public function get onCompleteParameters():Array
		{
			return _onCompleteParameters;
		}
		
		
		public function get data():DropInData
		{
			return _data;
		}

		public function get face():DisplayObject
		{
			return _face;
		}
		public function get canMove():Boolean
		{
			return _canMove;
		}
		
		
		public function get stage():Stage
		{
			return _stage;
		}
		public function get dobjParent():DisplayObjectContainer
		{
			return _dobjParent;
		}
		public function get dobjIndex():int
		{
			return _dobjIndex;
		}
		
		/**
		 * 设置是否可以拖拽了（管理器内部控制） 
		 * @param $value
		 * 
		 */		
		public function set canMove($value:Boolean):void
		{
			_canMove = $value;
		}
	}
}