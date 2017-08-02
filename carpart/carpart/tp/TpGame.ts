class TpGame {
    /**是否是外网 */
    public static outNet: boolean = false;
    public static GM: boolean = true
    public static ready: boolean = false;
    public uiReadyNum: number = 0;
    public uiAllNum: number = 0;
    public init(): void {

        var $baseUiList: Array<any> = new Array;
        $baseUiList.push({ xmlurl: "ui/arpgui/textlist.xml", picurl: "ui/arpgui/textlist.png", name: UIData.textlist });
        this.uiAllNum = UIData.init($baseUiList,
            () => {
                this.loadAll();
            },
            (num: number) => {
                this.uiReadyNum = num;
                FpsStage.getInstance().showLoadInfo("读取UI数据：" + this.uiReadyNum + "/" + this.uiAllNum);
            }
        );
    }
    private loadAll(): void {
        if (this.uiReadyNum == this.uiAllNum) {
            //this.loadDataComplet();
            FpsStage.getInstance().showLoadInfo("-");
            this.loadDataComplet();
        }
    }
    private loadDataComplet(): void {
        TpModuleList.startup();//启动所有模块
        GameInstance.initData();
        KeyMouseManeger.getInstance().addMouseEvent();
        ModuleEventManager.dispatchEvent(new tp.TpSceneEvent(tp.TpSceneEvent.SHOW_TP_SCENE_EVENT));
        ModuleEventManager.dispatchEvent(new command.CammandEvent(command.CammandEvent.INIT_CAMMAD_PANEL));
        ModuleEventManager.dispatchEvent(new mainui.MainUiEvent(mainui.MainUiEvent.SHOW_MAINUI_PANEL));
    }
}