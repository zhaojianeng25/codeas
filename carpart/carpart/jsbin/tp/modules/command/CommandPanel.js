var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var command;
(function (command) {
    var CammandRender = (function (_super) {
        __extends(CammandRender, _super);
        function CammandRender() {
            _super.apply(this, arguments);
        }
        CammandRender.prototype.draw = function () {
            var $ctx = UIManager.getInstance().getContext2D(this.uvData.ow, this.uvData.oh, false);
            $ctx.fillStyle = "rgb(" + 255 / 5 + "," + 255 / 5 + "," + 255 / 5 + ")";
            $ctx.fillRect(0, 0, this.uvData.ow - 5, this.uvData.oh - 5);
            LabelTextFont.writeSingleLabelToCtx($ctx, this._listItemData.data.txt, 18, this.uvData.ow / 2, 5, TextAlign.CENTER);
            this.atlas.updateCtx($ctx, this.uvData.ox, this.uvData.oy);
        };
        return CammandRender;
    })(ListItemRender);
    command.CammandRender = CammandRender;
    var CommandPanel = (function (_super) {
        __extends(CommandPanel, _super);
        function CommandPanel() {
            _super.call(this);
            this.uiAtlasComplet = false;
            this.width = 600;
            this.height = 400;
            this.center = 0;
            this.middle = 0;
        }
        CommandPanel.prototype.applyLoad = function () {
            this.loadConfigCom();
        };
        CommandPanel.prototype.loadConfigCom = function () {
            this._listRender = new UIListRenderComponent;
            this.addRender(this._listRender);
            this.addList();
            this.uiAtlasComplet = true;
            this.applyLoadComplete();
        };
        CommandPanel.prototype.addList = function () {
            var $pos = new Vector2D(30, 20);
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
            this.refreshData();
        };
        CommandPanel.prototype.refreshData = function () {
            var _this = this;
            var ary = new Array;
            var butItem = [
                "回到原点",
                "走起",
                "消除动",
            ];
            for (var i = 0; i < butItem.length; i++) {
                var listItemData = new ListItemData();
                listItemData.data = { txt: butItem[i], id: i };
                listItemData.clickFun = function ($listItemData) { _this.itemDataClick($listItemData); };
                ary.push(listItemData);
            }
            this._bgList.contentY = 0;
            this._bgList.setGridData(ary, CammandRender, 5, 100, 50, 512, 512, 512, 300);
        };
        CommandPanel.prototype.itemDataClick = function ($listItemData) {
            this.cammandStr($listItemData.data.txt);
            this.hide();
        };
        CommandPanel.prototype.cammandStr = function (str) {
            switch (str) {
                case "回到原点":
                case "走起":
                case "消除动":
                    var adk = new car.CarEvent(car.CarEvent.CAMMAND_INFO);
                    adk.data = str;
                    ModuleEventManager.dispatchEvent(adk);
                    break;
                case "普通技能1":
                    this.playTempSkill(1);
                    break;
                case "普通技能2":
                    this.playTempSkill(2);
                    break;
                case "普通技能3":
                    GameInstance.mainChar.rotationY = 45;
                    this.playTempSkill(2, GameInstance.attackChar);
                    break;
                default:
                    break;
            }
        };
        CommandPanel.prototype.playTempSkill = function (value, $attackTaget) {
            if ($attackTaget === void 0) { $attackTaget = null; }
            var $obj = GameInstance.getSkillById(value);
            var $skill = SkillManager.getInstance().getSkill(getSkillUrl($obj.effect_file), $obj.effect);
            if ($skill) {
                $skill.reset();
                $skill.isDeath = false;
                var $hitPosItem;
                if ($attackTaget) {
                    $hitPosItem = new Object;
                    $hitPosItem[1] = new Vector3D($attackTaget.x, $attackTaget.y, $attackTaget.z);
                    GameInstance.mainChar.watch($attackTaget);
                }
                $skill.configFixEffect(GameInstance.mainChar, null, $hitPosItem);
                SkillManager.getInstance().playSkill($skill);
            }
        };
        CommandPanel.prototype.hide = function () {
            UIManager.getInstance().removeUIContainer(this);
        };
        return CommandPanel;
    })(UIPanel);
    command.CommandPanel = CommandPanel;
})(command || (command = {}));
//# sourceMappingURL=CommandPanel.js.map