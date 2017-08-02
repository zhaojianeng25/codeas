package mvc.left.panelleft.vo
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vo.FileInfoType;

	public class MaskSprite  extends Sprite
	{
		private var mc:Sprite
		public function MaskSprite()
		{
			
			this.mc=new Sprite;
			this.addChild(this.mc)
		}
		
		private var _node:PanelSkillMaskNode
	
		public function setPanelRectInfoNode(value:PanelSkillMaskNode):void
		{
		
			 this._node=value
		 	this.changeSize()
		
		}
		public function changeSize():void
		{
			var tw:Number=this._node.rect.width
			var th:Number=this._node.rect.height
		
			this.mc.graphics.clear();
			switch(this._node.type)
			{
				case FileInfoType.CIRCLE:
				{
					this.mc.graphics.beginFill(0xff0000,0.8)
						
					this.mc.graphics.drawCircle(0,0,Math.min(tw,th)/2);
					
					break;
				}
				case FileInfoType.RECTANGLE:
				{
					this.mc.graphics.beginFill(0xff00ff,0.8)
					this.mc.graphics.drawRect(0+10,-th/2,tw/2-10,th);
					
					break;
				}
				case FileInfoType.SECTOR:
				{
					//this.mc.graphics.beginFill(0xffff00,0.8)
					//this.mc.graphics.drawRect(0,0,50,50);
					this.mc.graphics.beginFill(0xffff00,0.8)
					this.mc.graphics.lineStyle(1,0xffff00)
					
						
					this.drawArc(this.mc.graphics,0,0,Math.min(tw,th)/2,-this._node.openNum/2,this._node.openNum/2,1)
					break;
				}
					
				default:
				{
					break;
				}
			}
			this.mc.graphics.endFill();
			this.mc.rotation=Number(this._node.rotationNum)
			this.mc.x=this._node.rect.width/2
			this.mc.y=this._node.rect.height/2
		}
		public function drawArc(graphics:Graphics, center_x:Number, center_y:Number, radius:Number, angle_from:Number, angle_to:Number, precision:Number = 1):void   
		{   
			//angle_fromangle_from = angle_from % 360;   
			//angle_toangle_to = angle_to % 360;   
			
			const degreeToRadian:Number = 0.0174532925;   
			var angle_diff:Number = (angle_to - angle_from) % 360;   
			var steps:Number = Math.abs(Math.round(angle_diff * precision));   
			var angle:Number = angle_from;   
			var px:Number = center_x + radius * Math.cos(angle * degreeToRadian);   
			var py:Number = center_y + radius * Math.sin(angle * degreeToRadian);   
			
			graphics.moveTo(px, py);   
			for(var i:int = 1; i <= steps; i++)   
			{   
				var radian:Number = (angle_from + angle_diff / steps * i) * degreeToRadian;   
				graphics.lineTo(center_x + radius * Math.cos(radian), center_y + radius * Math.sin(radian));   
		
			}   
	
			graphics.lineTo(center_x, center_y);   
			graphics.lineTo(px, py);   
		}   
	}
}