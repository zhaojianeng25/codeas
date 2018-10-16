package mvc.left.panelleft
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import spark.primitives.Rect;
	
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	import mvc.left.panelleft.vo.PanelRectInfoSprite;
	import mvc.left.panelleft.vo.PanelRectInfoType;

	public class PanelModel
	{
		private var _item:ArrayCollection;
		private static var instance:PanelModel;
		public function PanelModel()
		{
			_item=new ArrayCollection;
		}
		
		public function get item():ArrayCollection
		{
			return _item;
		}

		public function set item(value:ArrayCollection):void
		{
			_item = value;
		}
		public function panelNodeVoAddInfoNode($PanelNodeVo:PanelNodeVo,$pos:Point,$type:uint):void
		{
			var $PanelRectInfoNode:PanelRectInfoNode=new PanelRectInfoNode;
			if($type==PanelRectInfoType.PICTURE){
				$PanelRectInfoNode.type=PanelRectInfoType.PICTURE;
				$PanelRectInfoNode.dataItem=[""];
			}
			if($type==PanelRectInfoType.BUTTON){
				$PanelRectInfoNode.type=PanelRectInfoType.BUTTON;
				$PanelRectInfoNode.dataItem=["",""];
			}
			
			$PanelRectInfoNode.name="newName"
			$PanelRectInfoNode.level=$PanelNodeVo.item.length
			$PanelRectInfoNode.rect=new Rectangle($pos.x,$pos.y,100,100)
			$PanelRectInfoNode.sprite=new PanelRectInfoSprite()
			$PanelRectInfoNode.sprite.panelRectInfoNode=$PanelRectInfoNode
			$PanelNodeVo.item.addItem($PanelRectInfoNode)
		
		}
	
		public  function addNewPanelVo():void
		{
			var $PanelNodeVo:PanelNodeVo=new PanelNodeVo
			$PanelNodeVo.name="新面板"
			$PanelNodeVo.item=new ArrayCollection
			$PanelNodeVo.canverRect=new Rectangle(0,0,960,540)
			_item.addItem($PanelNodeVo)
			
		}

		public static function getInstance():PanelModel{
			if(!instance){
				instance = new PanelModel();
			}
			return instance;
		}
		public function getPanelNodeItemToSave():Array
		{
		
			var arr:Array=new Array;
			for(var i:uint=0;i<_item.length;i++){
				var $PanelNodeVo:PanelNodeVo =_item[i] as PanelNodeVo
				arr.push($PanelNodeVo.readObject())
			}
			return arr;
		
		}
		public function setPanelNodeItemByObj($arr:Array):void
		{
			_item=new ArrayCollection;
			for(var i:uint=0;$arr&&i<$arr.length;i++){
				var $PanelNodeVo:PanelNodeVo=new PanelNodeVo();
				$PanelNodeVo.setObject($arr[i])
				_item.addItem($PanelNodeVo)
			}
		}
		public function geth5XML():Array
		{
			var arr:Array=new Array;
			for(var i:uint=0;i<_item.length;i++){
				var $PanelNodeVo:PanelNodeVo =_item[i] as PanelNodeVo
				arr.push($PanelNodeVo.readObjectToH5())
			}
			return arr;
			
		}
			
		public  function makeNewScene():void
		{
			_item=new ArrayCollection;
			
		}
	}
}