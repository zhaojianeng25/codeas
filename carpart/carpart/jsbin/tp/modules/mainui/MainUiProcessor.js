var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var mainui;
(function (mainui) {
    var MainUiModule = (function (_super) {
        __extends(MainUiModule, _super);
        function MainUiModule() {
            _super.apply(this, arguments);
        }
        MainUiModule.prototype.getModuleName = function () {
            return "MainUiModule";
        };
        MainUiModule.prototype.listProcessors = function () {
            return [new MainUiProcessor()];
        };
        return MainUiModule;
    })(Module);
    mainui.MainUiModule = MainUiModule;
    var MainUiEvent = (function (_super) {
        __extends(MainUiEvent, _super);
        function MainUiEvent() {
            _super.apply(this, arguments);
        }
        MainUiEvent.SHOW_MAINUI_PANEL = "SHOW_MAINUI_PANEL";
        MainUiEvent.HIDE_MAINUI_PANEL = "HIDE_MAINUI_PANEL";
        return MainUiEvent;
    })(BaseEvent);
    mainui.MainUiEvent = MainUiEvent;
    var MainUiProcessor = (function (_super) {
        __extends(MainUiProcessor, _super);
        function MainUiProcessor() {
            _super.apply(this, arguments);
        }
        MainUiProcessor.prototype.getName = function () {
            return "MainUiProcessor";
        };
        MainUiProcessor.prototype.receivedModuleEvent = function ($event) {
            if ($event instanceof MainUiEvent) {
                var evt = $event;
                if (evt.type == MainUiEvent.SHOW_MAINUI_PANEL) {
                    this.showPanel($event);
                }
                if (this.exchangepPanel) {
                    if (evt.type == MainUiEvent.HIDE_MAINUI_PANEL) {
                        this.hidePanel();
                    }
                }
            }
        };
        MainUiProcessor.prototype.hidePanel = function () {
        };
        MainUiProcessor.prototype.showPanel = function ($event) {
            var _this = this;
            if (!this.exchangepPanel) {
                this.exchangepPanel = new mainui.MainUiPanel();
            }
            this.exchangepPanel.load(function () {
                UIManager.getInstance().addUIContainer(_this.exchangepPanel);
            }, false);
        };
        MainUiProcessor.prototype.listenModuleEvents = function () {
            return [
                new MainUiEvent(MainUiEvent.SHOW_MAINUI_PANEL),
                new MainUiEvent(MainUiEvent.HIDE_MAINUI_PANEL),
            ];
        };
        return MainUiProcessor;
    })(BaseProcessor);
    mainui.MainUiProcessor = MainUiProcessor;
})(mainui || (mainui = {}));
//# sourceMappingURL=MainUiProcessor.js.map