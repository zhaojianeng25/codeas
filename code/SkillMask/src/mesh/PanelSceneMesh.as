package mesh
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import mx.controls.Alert;
	
	import interfaces.ITile;
	
	import mvc.centen.panelcenten.PanelCentenEvent;
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	import mvc.left.panelleft.vo.PanelRectInfoType;
	import mvc.top.OutTxtModel;
	
	public class PanelSceneMesh extends EventDispatcher implements ITile
	{
		private var _panelNodeVo:PanelNodeVo
		private var _expScene:Boolean;
		protected var _canverRectSize:Point
		public function PanelSceneMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get expScene():Boolean
		{
			return _expScene;
		}
		
		public function set expScene(value:Boolean):void
		{
			_expScene = value;
			
		    var allStr:String=""
			var eeef:PanelNodeVo=_panelNodeVo;
			for(var i:uint=0;i<_panelNodeVo.item.length;i++)
			{
				var $PanelRectInfoNode:PanelSkillMaskNode=PanelSkillMaskNode(_panelNodeVo.item[i]);
				
		
				if($PanelRectInfoNode.name=="newName"){
				
					continue;
				}
				
				
				var $str:String="renderLevel.getComponent("+"\""+$PanelRectInfoNode.name+"\""+")";
				
				switch($PanelRectInfoNode.type)
				{
					case 	PanelRectInfoType.RECTANGLE:
					{

						$str=":SelectButton"+"=<"+"SelectButton"+">"+$str;						

						//this.A_select_but_0 = <SelectButton>this._midRender.getComponent("A_select_but_0")
						
						break;
					}
				
					default:
					{
						$str=":UICompenent"+"=<"+"UICompenent"+">"+$str;
						
						break;
					}
				}
				
				$str="var "+$PanelRectInfoNode.name+$str;
				allStr=allStr+$str+"\n"
				$str="this.addChild("+$PanelRectInfoNode.name+")"
				allStr=allStr+$str+"\n"
				//<UICompenent>this._midRender.getComponent(A_back_0);
					
					
					
			}
			
/*
			var fs:FileStream = new FileStream();
			var saveFile:File=new File(File.desktopDirectory.url+"/"+_panelNodeVo.name+".xml")
			fs.open(saveFile, FileMode.WRITE);
			for(var k:int = 0; k < allStr.length; k++)
			{
				fs.writeMultiByte(allStr.substr(k,1),"utf-8");
			}
			fs.close();
			*/
			
		//	Alert.show("面板列表存在"+saveFile.url)
				
				
			OutTxtModel.getInstance().initSceneConfigPanel(allStr);
			
		
			
		}

		private var num10:Number=10
		private var _okBut:Boolean;
		public function get canverRectSize():Point
		{
			return new Point(_panelNodeVo.canverRect.width/num10,_panelNodeVo.canverRect.height/num10);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",min="1",max="100",Category="尺寸",Tip="坐标")]
		public function set canverRectSize(value:Point):void
		{
			var  tw:Number=int(value.x/2)*2+1
			var  th:Number=int(value.y/2)*2+1
			tw=Math.max(3,tw);
			th=Math.max(3,th);
			_panelNodeVo.canverRect.width=tw*num10
			_panelNodeVo.canverRect.height=th*num10
			change()
			
		}
		public function get okBut():Boolean
		{
			return _okBut;
		}
		[Editor(type="Btn",Label="生存技能蒙版",sort="3",Category="导出")]
		public function set okBut(value:Boolean):void
		{
			_okBut = value;
			

			var evt:PanelCentenEvent=new PanelCentenEvent(PanelCentenEvent.EXP_SKILL_MASK_INFO)
			evt.panelNodeVo=_panelNodeVo
			ModuleEventManager.dispatchEvent(evt);
		}
		public function get color():int
		{
			return _panelNodeVo.color;
		}
	//	[Editor(type="ColorPick",Label="背景",sort="9",Category="属性",Tip="范围")]
		public function set color(value:int):void
		{
			_panelNodeVo.color = value;
			change()
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}

		public function get panelNodeVo():PanelNodeVo
		{
			return _panelNodeVo;
		}

		public function set panelNodeVo(value:PanelNodeVo):void
		{
			_panelNodeVo = value;
		}

		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return _panelNodeVo.name;
		}
		
		public function acceptPath():String
		{
			return null;
		}
	}
}