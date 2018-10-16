package mvc.left.panelleft.vo
{
	import flash.geom.Rectangle;
	
	import vo.AlighNode;
	import vo.FileInfoType;
	import vo.H5UIFileNode;

	public class PanelRectInfoNode extends AlighNode
	{


		public var type:uint
		public var isui9:Boolean;
		public var selectTab:Boolean
		public var level:uint
		public var dataItem:Array;
		public var sprite:PanelRectInfoSprite
		public var select:Boolean;
		public function PanelRectInfoNode()
		{
			super();
		}
		public function clone():PanelRectInfoNode
		{
			var  temp:PanelRectInfoNode=new PanelRectInfoNode();
			temp.name=this.name;
			temp.level=this.level;
			temp.type=this.type;
			temp.isui9=this.isui9;
			temp.dataItem=new Array
			for(var i:uint=0;i<this.dataItem.length;i++){
				temp.dataItem.push(this.dataItem[i])
			}
			temp.rect=this.rect.clone()
			
			temp.sprite=new PanelRectInfoSprite()
			temp.sprite.panelRectInfoNode=temp
				
				
			return temp;
		
		}
		public function readObject():Object
		{
			var obj:Object=new Object;
			obj.name=this.name;
			obj.level=this.level;
			obj.type=this.type;
			obj.isui9=this.isui9;
			obj.selectTab=this.selectTab;
			obj.dataItem=this.dataItem;		
			obj.rect=this.rect;
			
			return obj;
		}
		public function readObjectToH5():Object
		{
			var obj:Object=new Object;
			obj.name=this.name;
			obj.level=this.level;
			this.isui9=false
			var isFrameMove:Boolean=false
			if(this.dataItem[0]){
				var $H5UIFileNode:H5UIFileNode=UiData.getUiNodeByName(this.dataItem[0])
				if($H5UIFileNode&&$H5UIFileNode.type==FileInfoType.ui9){
					this.isui9=true
				}
				if($H5UIFileNode&&$H5UIFileNode.type==FileInfoType.frame){
					isFrameMove=true
				}
			}
			if(this.type==PanelRectInfoType.PICTURE){
				if(isFrameMove){
					obj.type=4
				}else{
				
					if(this.isui9){
						obj.type=1
					}else{
						obj.type=0
					}
				}
				
			}
			if(this.type==PanelRectInfoType.BUTTON){
				if(this.isui9){
					obj.type=3
				}else{
					obj.type=2
				}
				obj.selected=this.selectTab;
			}
			
			obj.dataItem=this.dataItem;		
			obj.rect=this.rect;
			return obj;
		}
		
		public function setObject($obj:Object):void
		{
			this.name=$obj.name;
			this.level=$obj.level;
			this.type=$obj.type;
			this.isui9=$obj.isui9;
			this.selectTab=$obj.selectTab;
			this.dataItem=$obj.dataItem;	
			
			this.rect=new Rectangle;
			this.rect.x=int($obj.rect.x)
			this.rect.y=int($obj.rect.y)
			this.rect.width=int($obj.rect.width)
			this.rect.height=int($obj.rect.height)
			
		}
	}
}