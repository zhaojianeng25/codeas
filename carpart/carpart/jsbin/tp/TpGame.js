var TpGame = (function () {
    function TpGame() {
        this.uiReadyNum = 0;
        this.uiAllNum = 0;
    }
    TpGame.prototype.init = function () {
        var _this = this;
        var $baseUiList = new Array;
        $baseUiList.push({ xmlurl: "ui/arpgui/textlist.xml", picurl: "ui/arpgui/textlist.png", name: UIData.textlist });
        this.uiAllNum = UIData.init($baseUiList, function () {
            _this.loadAll();
        }, function (num) {
            _this.uiReadyNum = num;
            FpsStage.getInstance().showLoadInfo("读取UI数据：" + _this.uiReadyNum + "/" + _this.uiAllNum);
        });
    };
    TpGame.prototype.loadAll = function () {
        if (this.uiReadyNum == this.uiAllNum) {
            //this.loadDataComplet();
            FpsStage.getInstance().showLoadInfo("-");
            this.loadDataComplet();
        }
    };
    TpGame.prototype.loadDataComplet = function () {
        TpModuleList.startup(); //启动所有模块
        GameInstance.initData();
        KeyMouseManeger.getInstance().addMouseEvent();
        ModuleEventManager.dispatchEvent(new tp.TpSceneEvent(tp.TpSceneEvent.SHOW_TP_SCENE_EVENT));
        ModuleEventManager.dispatchEvent(new command.CammandEvent(command.CammandEvent.INIT_CAMMAD_PANEL));
        ModuleEventManager.dispatchEvent(new mainui.MainUiEvent(mainui.MainUiEvent.SHOW_MAINUI_PANEL));
    };
    /**是否是外网 */
    TpGame.outNet = false;
    TpGame.GM = true;
    TpGame.ready = false;
    return TpGame;
})();
//# sourceMappingURL=TpGame.js.map