module command {
    export class CammandRender extends ListItemRender {

        public draw(): void {
            var $ctx: CanvasRenderingContext2D = UIManager.getInstance().getContext2D(this.uvData.ow, this.uvData.oh, false);

            $ctx.fillStyle = "rgb(" + 255 / 5 + "," + 255 / 5 + "," + 255 / 5 + ")";
            $ctx.fillRect(0, 0, this.uvData.ow-5, this.uvData.oh-5);
            LabelTextFont.writeSingleLabelToCtx($ctx, this._listItemData.data.txt, 18, this.uvData.ow/2,5,TextAlign.CENTER);
            this.atlas.updateCtx($ctx, this.uvData.ox, this.uvData.oy);

        }



    }
    export class CommandPanel extends UIPanel {

        private _listRender:UIListRenderComponent
        public constructor() {
            super();
            this.width = 600;
            this.height = 400;
            this.center = 0;
            this.middle = 0;
        }

        public applyLoad(): void {
            this.loadConfigCom();
        }
        private uiAtlasComplet: boolean = false;
        private loadConfigCom(): void
        {
            this._listRender = new UIListRenderComponent;
            this.addRender(this._listRender);
            this.addList();
            this.uiAtlasComplet = true;
            this.applyLoadComplete();
        }
        private _bgList: GridList;
        private _bgMask: UIMask;
        private addList(): void {
            var $pos: Vector2D = new Vector2D(30, 20)
            this._bgList = this._listRender.createGridList();
            this._bgList.x = $pos.x;
            this._bgList.y = $pos.y;

            this.addChild(this._bgList);

            this._bgMask = new UIMask();
            this._bgMask.x = $pos.x;
            this._bgMask.y = $pos.y;
            this._bgMask.width = 512;
            this._bgMask.height = 300;
            this.addMask(this._bgMask);

            this._listRender.mask = this._bgMask;

            this.refreshData()

        }
        private refreshData(): void {
            var ary: Array<ListItemData> = new Array;
            var butItem: Array<string> = [
                "回到原点",
                "走起",
                "消除动",

            ]
            for (var i: number = 0; i < butItem.length; i++) {
                var listItemData: ListItemData = new ListItemData();
                listItemData.data = { txt: butItem[i], id: i };
                listItemData.clickFun = ($listItemData: ListItemData) => { this.itemDataClick($listItemData) }
                ary.push(listItemData);
            }
            this._bgList.contentY = 0;
            this._bgList.setGridData(ary, CammandRender, 5, 100, 50, 512, 512, 512, 300);



        }
        private itemDataClick($listItemData: ListItemData): void {

            this.cammandStr($listItemData.data.txt);
            this.hide();
        }
        private cammandStr(str: string): void
        {
            switch (str) {
                case "回到原点":
                case "走起":
                case "消除动":

                    var adk: car.CarEvent = new car.CarEvent(car.CarEvent.CAMMAND_INFO)
                    adk.data = str
                    ModuleEventManager.dispatchEvent(adk);

                    break;
                case "普通技能1":
                    this.playTempSkill(1)
                    break;
                case "普通技能2":
                    this.playTempSkill(2)
                    break;
                case "普通技能3":
                    GameInstance.mainChar.rotationY = 45
                    this.playTempSkill(2, GameInstance.attackChar)
                    break;

                default:
                    break;
            }
        }
        
        private playTempSkill(value:number,$attackTaget:SceneBaseChar=null): void
        {
            var $obj: any = GameInstance.getSkillById(value);
            var $skill: Skill = SkillManager.getInstance().getSkill(getSkillUrl($obj.effect_file), $obj.effect);
            if ($skill) {
                $skill.reset();
                $skill.isDeath = false;
                var $hitPosItem: any;
                if ($attackTaget) {
                    $hitPosItem = new Object;
                    $hitPosItem[1] = new Vector3D($attackTaget.x, $attackTaget.y, $attackTaget.z);
                    GameInstance.mainChar.watch($attackTaget);
                }
                $skill.configFixEffect(GameInstance.mainChar, null, $hitPosItem);
                SkillManager.getInstance().playSkill($skill);
            }
        }
      
  
        public hide(): void
        {
            UIManager.getInstance().removeUIContainer(this);
        }
   
    }
}