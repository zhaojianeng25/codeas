/*****************************************************  
 *    
 *  The Initial Developer of the Original Code is Jave.Lin(afeng).  
 *    
 *  Scale9Grid.as  
 *  Create By Jave.Lin(afeng)  
 *  2012-9-5 下午2:37:14  
 *    
 *****************************************************/  
package  mvc.left.panelleft.vo  
{  
	import flash.display.Bitmap;  
	import flash.display.BitmapData;  
	import flash.display.Sprite;  
	import flash.events.Event;  
	import flash.geom.Point;  
	import flash.geom.Rectangle;  
	
	/**  
	 *  9宫格类  
	 * @author Jave.Lin(afeng)  
	 **/  
	public class Scale9Grid extends Sprite  
	{  
		private var _invalidate:Boolean=false;  
		private const despoint:Point=new Point();  
		
		private var _top_left_bmp:Bitmap;  
		private var _top_bmp:Bitmap;  
		private var _top_right_bmp:Bitmap;  
		private var _right_bmp:Bitmap;  
		private var _bottom_right_bmp:Bitmap;  
		private var _bottom_bmp:Bitmap;  
		private var _botton_left_bmp:Bitmap;  
		private var _left_bmp:Bitmap;  
		private var _center_bmp:Bitmap;  
		
		private var _s9d:Rectangle;  
		
		private var _bmd:BitmapData;  
		public function get bmd():BitmapData  
		{  
			return _bmd;  
		}  
		
		private var _w:Number;  
		private var _minW:Number;  
		public override function get width():Number  
		{  
			return _w;  
		}  
		public override function set width(value:Number):void  
		{  
			if(_w!=value)  
			{  
				_w=value;  
				
				if(_w<_minW)_w=_minW;  
				invalidate();  
			}  
		}  
		
		private var _h:Number;  
		private var _minH:Number;  
		public override function get height():Number  
		{  
			return _h;  
		}  
		public override function set height(value:Number):void  
		{  
			if(_h!=value)  
			{  
				_h=value;  
				if(_h<_minH)_h=_minH;  
				invalidate();  
			}  
		}  
		
		public function Scale9Grid(bmd:BitmapData,s9d:Rectangle)  
		{  
			super();  
			
			_bmd=bmd;  
			_w=bmd.width;  
			_h=bmd.height;  
			
			checkS9d(s9d);  
			_s9d=s9d;  
			
			_minW=(_s9d.x+(_bmd.width-_s9d.right)+1);  
			_minH=(_s9d.y+(_bmd.height-_s9d.bottom)+1);  
			
			cutBmd();  
			refresh();  
		}  
		
		public function invalidate():void  
		{  
			_invalidate=true;  
			removeEventListener(Event.RENDER,onRender);  
			addEventListener(Event.RENDER,onRender);  
		}  
		
		public function refresh():void  
		{  
			_invalidate=false;  
			refreshSize();  
			layoutBmps();  
			//          graphics.clear();  
			//          drawRect(0xff0000,_top_left_bmp.getRect(this));  
			//          drawRect(0xff0000,_top_bmp.getRect(this));  
			//          drawRect(0xff0000,_top_right_bmp.getRect(this));  
			//          drawRect(0xff0000,_right_bmp.getRect(this));  
			//          drawRect(0xff0000,_bottom_right_bmp.getRect(this));  
			//          drawRect(0xff0000,_bottom_bmp.getRect(this));  
			//          drawRect(0xff0000,_botton_left_bmp.getRect(this));  
			//          drawRect(0xff0000,_left_bmp.getRect(this));  
			//          drawRect(0xff0000,_center_bmp.getRect(this));  
		}  
		
		private function onRender(event:Event):void  
		{  
			// TODO Auto-generated method stub  
			if(!_invalidate)return;  
			
			removeEventListener(Event.RENDER,onRender);  
			
			refresh();  
		}  
		
		private function layoutBmps():void  
		{  
			//0、中  
			_center_bmp.x=_s9d.x;  
			_center_bmp.y=_s9d.y;  
			var centerRect:Rectangle=_center_bmp.getRect(this);  
			
			//1、左上  
			_top_left_bmp.x=0;  
			_top_left_bmp.y=0;  
			
			//2、上  
			_top_bmp.x=_s9d.x;  
			_top_bmp.y=0;  
			
			//3、右上  
			_top_right_bmp.x=centerRect.right;  
			_top_right_bmp.y=0;  
			
			//4、右  
			
			_right_bmp.x=centerRect.right;  
			_right_bmp.y=_s9d.y;  
			
			//5、右下  
			_bottom_right_bmp.x=centerRect.right;  
			_bottom_right_bmp.y=centerRect.bottom;  
			
			//6、下  
			_bottom_bmp.x=_s9d.x;  
			_bottom_bmp.y=centerRect.bottom;  
			
			//7、左下  
			_botton_left_bmp.x=0;  
			_botton_left_bmp.y=centerRect.bottom;  
			
			//8、左  
			_left_bmp.x=0;  
			_left_bmp.y=_s9d.y;  
		}  
		
		private function refreshSize():void  
		{  
			var tw:Number=_w-(_left_bmp.width+_right_bmp.width);  
			var th:Number=_h-(_top_bmp.height+_bottom_bmp.height);  
			//上  
			_top_bmp.width=tw;  
			//下  
			_bottom_bmp.width=tw;  
			//左  
			_left_bmp.height=th;  
			//右  
			_right_bmp.height=th;  
			
			_center_bmp.width=tw;  
			_center_bmp.height=th;  
		}  
		
		//      private function drawRect(c:uint,rect:Rectangle):void  
		//      {  
		////            graphics.beginFill(c);  
		////            graphics.drawRect(rect.x,rect.y,rect.width,rect.height);  
		//          graphics.lineStyle(1,c);  
		//          graphics.moveTo(rect.x,rect.y);  
		//          graphics.lineTo(rect.width,rect.y);  
		//          graphics.lineTo(rect.width,rect.height);  
		//          graphics.lineTo(rect.x,rect.height);  
		//          graphics.lineTo(rect.x,rect.y);  
		////            graphics.endFill();  
		//      }  
		
		private function cutBmd():void  
		{  
			var rect:Rectangle;  
			
			//1、左上  
			rect=new Rectangle(0,0,_s9d.x,_s9d.y);  
			var top_left_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			top_left_bmd.copyPixels(_bmd,rect,despoint);  
			_top_left_bmp=new Bitmap(top_left_bmd);  
			addChild(_top_left_bmp);  
			//          drawRect(0xff0000,rect);  
			
			//2、上  
			rect.x=_s9d.x;  
			rect.y=0;  
			rect.width=_s9d.width;  
			rect.height=_s9d.y;  
			var top_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			top_bmd.copyPixels(_bmd,rect,despoint);  
			_top_bmp=new Bitmap(top_bmd);  
			addChild(_top_bmp);  
			//          drawRect(0xffff00,rect);  
			
			//3、右上  
			rect.x=_s9d.right;  
			rect.y=0;  
			rect.width=_bmd.width-_s9d.right;  
			rect.height=_s9d.y;  
			var top_right_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			top_right_bmd.copyPixels(_bmd,rect,despoint);  
			_top_right_bmp=new Bitmap(top_right_bmd);  
			addChild(_top_right_bmp);  
			//          drawRect(0xffffff,rect);  
			
			//4、右  
			rect.x=_s9d.right;  
			rect.y=_s9d.y;  
			rect.width=_bmd.width-_s9d.right;  
			rect.height=_s9d.height;  
			var right_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			right_bmd.copyPixels(_bmd,rect,despoint);  
			_right_bmp=new Bitmap(right_bmd);  
			addChild(_right_bmp);  
			//          drawRect(0x00ff00,rect);  
			
			//5、右下  
			rect.x=_s9d.right;  
			rect.y=_s9d.bottom;  
			rect.width=_bmd.width-_s9d.right;  
			rect.height=_bmd.height-_s9d.bottom;  
			var bottom_right_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			bottom_right_bmd.copyPixels(_bmd,rect,despoint);  
			_bottom_right_bmp=new Bitmap(bottom_right_bmd);  
			addChild(_bottom_right_bmp);  
			//          drawRect(0x0000ff,rect);  
			
			//6、下  
			rect.x=_s9d.x;  
			rect.y=_s9d.bottom;  
			rect.width=_s9d.width;  
			rect.height=_bmd.height-_s9d.bottom;  
			var botton_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			botton_bmd.copyPixels(_bmd,rect,despoint);  
			_bottom_bmp=new Bitmap(botton_bmd);  
			addChild(_bottom_bmp);  
			//          drawRect(0x00ffff,rect);  
			
			//7、左下  
			rect.x=0;  
			rect.y=_s9d.bottom;  
			rect.width=_s9d.x;  
			rect.height=_bmd.height-_s9d.bottom;  
			var botton_left_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			botton_left_bmd.copyPixels(_bmd,rect,despoint);  
			_botton_left_bmp=new Bitmap(botton_left_bmd);  
			addChild(_botton_left_bmp);  
			//          drawRect(0xeeeeee,rect);  
			
			//8、左  
			rect.x=0;  
			rect.y=_s9d.y;  
			rect.width=_s9d.x;  
			rect.height=_s9d.height;  
			var left_bmd:BitmapData=new BitmapData(rect.width,rect.height,true,0);  
			left_bmd.copyPixels(_bmd,rect,despoint);  
			_left_bmp=new Bitmap(left_bmd);  
			addChild(_left_bmp);  
			//          drawRect(0x222222,rect);  
			
			//9、中  
			var center_bmd:BitmapData=new BitmapData(_s9d.width,_s9d.height,true,0);  
			center_bmd.copyPixels(_bmd,_s9d,despoint);  
			_center_bmp=new Bitmap(center_bmd);  
			addChild(_center_bmp);  
			//          drawRect(0x99ff55,_s9d);  
		}  
		
		private function checkS9d(s9d:Rectangle):void  
		{  
			s9d.x=Math.floor(s9d.x);  
			s9d.y=Math.floor(s9d.y);  
			s9d.width=Math.ceil(s9d.width);  
			s9d.height=Math.ceil(s9d.height);  
			
			var error:Boolean=false;  
			var errorMsg:String='';  
			if(s9d.x<1)  
			{  
				error=true;  
				errorMsg+='s9d.x<1';  
			}  
			if(s9d.y<1)  
			{  
				error=true;  
				errorMsg+='s9d.y<1';  
			}  
			if((s9d.x+s9d.width)>(bmd.width-1))  
			{  
				error=true;  
				errorMsg+='(s9d.x+s9d.width)>(bmd.width-1)';  
			}  
			if((s9d.y+s9d.height)>(bmd.height-1))  
			{  
				error=true;  
				errorMsg+='(s9d.y+s9d.height)>(bmd.height-1)';  
			}  
			if(error)  
				throw new Error("s9d error!!!:\n"+errorMsg);  
		}  
	}  
}  