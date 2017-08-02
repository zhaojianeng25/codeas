var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var tp;
(function (tp) {
    var TpSceneModule = (function (_super) {
        __extends(TpSceneModule, _super);
        function TpSceneModule() {
            _super.apply(this, arguments);
        }
        TpSceneModule.prototype.getModuleName = function () {
            return "TpSceneModule";
        };
        TpSceneModule.prototype.listProcessors = function () {
            return [new TpSceneProcessor()];
        };
        return TpSceneModule;
    })(Module);
    tp.TpSceneModule = TpSceneModule;
    var TpSceneEvent = (function (_super) {
        __extends(TpSceneEvent, _super);
        function TpSceneEvent() {
            _super.apply(this, arguments);
        }
        //展示面板
        TpSceneEvent.SHOW_TP_SCENE_EVENT = "SHOW_TP_SCENE_EVENT";
        return TpSceneEvent;
    })(BaseEvent);
    tp.TpSceneEvent = TpSceneEvent;
    var TpSceneProcessor = (function (_super) {
        __extends(TpSceneProcessor, _super);
        function TpSceneProcessor() {
            var _this = this;
            _super.call(this);
            Scene_data.uiStage.addEventListener(InteractiveEvent.Down, this.onDown, this);
            Scene_data.uiStage.addEventListener(InteractiveEvent.Move, this.onMove, this);
            Scene_data.uiStage.addEventListener(InteractiveEvent.Up, this.onUp, this);
            document.addEventListener(MouseType.MouseWheel, function ($evt) { _this.onMouseWheel($evt); });
            document.addEventListener(MouseType.KeyDown, function ($evt) { _this.onKeyDown($evt); });
            document.addEventListener(MouseType.KeyUp, function ($evt) { _this.onKeyDown($evt); });
        }
        TpSceneProcessor.prototype.onKeyDown = function ($evt) {
        };
        TpSceneProcessor.prototype.onMouseWheel = function ($evt) {
            Scene_data.cam3D.distance += $evt.wheelDelta / 10;
        };
        TpSceneProcessor.prototype.onDown = function (event) {
            this.lastMousePos = new Vector2D(event.x, event.y);
            this.lastRotation = new Vector2D(Scene_data.focus3D.rotationX, Scene_data.focus3D.rotationY);
        };
        TpSceneProcessor.prototype.onMove = function (event) {
            if (this.lastRotation) {
                Scene_data.focus3D.rotationY = this.lastRotation.y - (event.x - this.lastMousePos.x) / 2;
            }
        };
        TpSceneProcessor.prototype.onUp = function (event) {
            this.lastRotation = null;
        };
        TpSceneProcessor.prototype.getName = function () {
            return "TpSceneProcessor";
        };
        TpSceneProcessor.prototype.receivedModuleEvent = function ($event) {
            if ($event instanceof TpSceneEvent) {
                var $tpMenuEvent = $event;
                if ($tpMenuEvent.type == TpSceneEvent.SHOW_TP_SCENE_EVENT) {
                    // this.loadSceneByUrl();
                    this.bb();
                }
            }
        };
        TpSceneProcessor.prototype.loadFinishEnd = function () {
            Scene_data.focus3D.rotationY = -20;
            Scene_data.cam3D.distance = 400;
            console.log("解析结束");
            GameInstance.mainChar = this.addRole(new Vector3D(0, 5, 200));
            GameInstance.mainChar.rotationY = 180;
            //  GameInstance.mainChar.play(CharAction.WALK, 0);
            GameInstance.attackChar = this.addRole(new Vector3D(-100, 5, 200));
            this.addPerfab(new Vector3D(100, 0, 0));
            // this.aa();
            this.bb();
        };
        TpSceneProcessor.prototype.aa = function () {
            var $evt = new cannon.CannonEvent(cannon.CannonEvent.INIT_CANNON_SCENE);
            $evt.data = SceneManager.getInstance().sceneCollisionItem;
            ModuleEventManager.dispatchEvent($evt);
        };
        TpSceneProcessor.prototype.bb = function () {
            var $evt = new car.CarEvent(car.CarEvent.INIT_CAR_SCENE);
            $evt.data = SceneManager.getInstance().sceneCollisionItem;
            ModuleEventManager.dispatchEvent($evt);
        };
        TpSceneProcessor.prototype.addRole = function ($pos) {
            var $sc = new SceneChar();
            $sc.setRoleUrl(getRoleUrl("2002"));
            $sc.x = $pos.x;
            $sc.y = $pos.y;
            $sc.z = $pos.z;
            // $sc.addPart("weapon", "weapon_socket_0", getModelUrl("5201"));
            $sc.addPart("weapon", "w_01", getModelUrl("5201"));
            SceneManager.getInstance().addMovieDisplay($sc);
            return $sc;
        };
        TpSceneProcessor.prototype.addPerfab = function ($pos) {
            var $sc = new ScenePerfab();
            $sc.x = $pos.x;
            $sc.y = $pos.y;
            $sc.z = $pos.z;
            SceneManager.getInstance().addMovieDisplay($sc);
            $sc.setPerfabName("6409");
            return $sc;
        };
        TpSceneProcessor.prototype.loadSceneByUrl = function () {
            var _this = this;
            var sName = "1008";
            SceneManager.getInstance().loadScene(sName, TpSceneProcessor.sceneLoadcomplteFun, TpSceneProcessor.sceneProgressFun, function () { _this.loadFinishEnd(); });
        };
        TpSceneProcessor.sceneLoadcomplteFun = function () {
            console.log("加载完成");
        };
        TpSceneProcessor.sceneProgressFun = function (num) {
            console.log(num);
        };
        TpSceneProcessor.prototype.listenModuleEvents = function () {
            return [
                new TpSceneEvent(TpSceneEvent.SHOW_TP_SCENE_EVENT),
            ];
        };
        return TpSceneProcessor;
    })(BaseProcessor);
    tp.TpSceneProcessor = TpSceneProcessor;
})(tp || (tp = {}));
//# sourceMappingURL=TpSceneProcessor.js.map