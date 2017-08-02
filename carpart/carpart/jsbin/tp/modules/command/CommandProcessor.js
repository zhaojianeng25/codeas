var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var command;
(function (command) {
    var CammandModule = (function (_super) {
        __extends(CammandModule, _super);
        function CammandModule() {
            _super.apply(this, arguments);
        }
        CammandModule.prototype.getModuleName = function () {
            return "CammandModule";
        };
        CammandModule.prototype.listProcessors = function () {
            return [new CammandProcessor()];
        };
        return CammandModule;
    })(Module);
    command.CammandModule = CammandModule;
    var CammandEvent = (function (_super) {
        __extends(CammandEvent, _super);
        function CammandEvent() {
            _super.apply(this, arguments);
        }
        CammandEvent.INIT_CAMMAD_PANEL = "INIT_CAMMAD_PANEL";
        CammandEvent.SHOW_CAMMAD_PANEL = "SHOW_CAMMAD_PANEL";
        return CammandEvent;
    })(BaseEvent);
    command.CammandEvent = CammandEvent;
    var CammandProcessor = (function (_super) {
        __extends(CammandProcessor, _super);
        function CammandProcessor() {
            _super.apply(this, arguments);
        }
        CammandProcessor.prototype.getName = function () {
            return "CammandProcessor";
        };
        CammandProcessor.prototype.receivedModuleEvent = function ($event) {
            if ($event instanceof CammandEvent) {
                var evt = $event;
                if (evt.type == CammandEvent.INIT_CAMMAD_PANEL) {
                    this.addEvents();
                }
                if (evt.type == CammandEvent.SHOW_CAMMAD_PANEL) {
                    this.showPanel($event);
                }
            }
        };
        CammandProcessor.prototype.addEvents = function () {
            var _this = this;
            document.addEventListener(MouseType.KeyDown, function ($evt) { _this.onKeyDown($evt); });
        };
        CammandProcessor.prototype.onKeyDown = function ($evt) {
            if (!$evt.shiftKey) {
                if ($evt.keyCode == KeyboardType.R) {
                    ModuleEventManager.dispatchEvent(new CammandEvent(CammandEvent.SHOW_CAMMAD_PANEL));
                }
                if ($evt.keyCode == KeyboardType.T) {
                    var adk = new car.CarEvent(car.CarEvent.CAMMAND_INFO);
                    adk.data = "点到点";
                    ModuleEventManager.dispatchEvent(adk);
                }
                if ($evt.keyCode == KeyboardType.Y) {
                    var adk = new car.CarEvent(car.CarEvent.CAMMAND_INFO);
                    adk.data = "停车";
                    ModuleEventManager.dispatchEvent(adk);
                }
            }
        };
        CammandProcessor.prototype.showPanel = function ($event) {
            var _this = this;
            if (!this.exchangepPanel) {
                this.exchangepPanel = new command.CommandPanel();
            }
            this.exchangepPanel.load(function () {
                UIManager.getInstance().addUIContainer(_this.exchangepPanel);
            }, false);
        };
        CammandProcessor.prototype.listenModuleEvents = function () {
            return [
                new CammandEvent(CammandEvent.INIT_CAMMAD_PANEL),
                new CammandEvent(CammandEvent.SHOW_CAMMAD_PANEL),
            ];
        };
        return CammandProcessor;
    })(BaseProcessor);
    command.CammandProcessor = CammandProcessor;
})(command || (command = {}));
//# sourceMappingURL=CommandProcessor.js.map