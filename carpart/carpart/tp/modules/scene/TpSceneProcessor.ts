module tp {
    export class TpSceneModule extends Module {
        public getModuleName(): string {
            return "TpSceneModule";
        }
        protected listProcessors(): Array<Processor> {
            return [new TpSceneProcessor()];
        }
    }
    export class TpSceneEvent extends BaseEvent {
        //展示面板
        public static SHOW_TP_SCENE_EVENT: string = "SHOW_TP_SCENE_EVENT";

    }
    export class TpSceneProcessor extends BaseProcessor {
  
        public constructor() {
            super();

            Scene_data.uiStage.addEventListener(InteractiveEvent.Down, this.onDown, this);
            Scene_data.uiStage.addEventListener(InteractiveEvent.Move, this.onMove, this);
            Scene_data.uiStage.addEventListener(InteractiveEvent.Up, this.onUp, this);
            document.addEventListener(MouseType.MouseWheel, ($evt: MouseWheelEvent) => { this.onMouseWheel($evt) });
            document.addEventListener(MouseType.KeyDown, ($evt: KeyboardEvent) => { this.onKeyDown($evt) })
            document.addEventListener(MouseType.KeyUp, ($evt: KeyboardEvent) => { this.onKeyDown($evt) })

        }
        public onKeyDown($evt: KeyboardEvent): void {

        }
        private onMouseWheel($evt: MouseWheelEvent): void {

            Scene_data.cam3D.distance += $evt.wheelDelta / 10;

        }
        private lastMousePos: Vector2D;
        private lastRotation: Vector2D;
        protected onDown(event: InteractiveEvent): void {

         
            this.lastMousePos = new Vector2D(event.x, event.y)
            this.lastRotation = new Vector2D(Scene_data.focus3D.rotationX, Scene_data.focus3D.rotationY);
        }
        protected onMove(event: InteractiveEvent): void {
            if (this.lastRotation) {
                Scene_data.focus3D.rotationY = this.lastRotation.y - (event.x - this.lastMousePos.x) / 2;
            }
        }
        protected onUp(event: InteractiveEvent): void {
            this.lastRotation = null;
        }

        public getName(): string {
            return "TpSceneProcessor";
        }
        protected receivedModuleEvent($event: BaseEvent): void {

            if ($event instanceof TpSceneEvent) {
                var $tpMenuEvent: TpSceneEvent = <TpSceneEvent>$event;
                if ($tpMenuEvent.type == TpSceneEvent.SHOW_TP_SCENE_EVENT) {
                   // this.loadSceneByUrl();
                    this.bb();
                }
            }
        }
        private loadFinishEnd(): void
        {
            Scene_data.focus3D.rotationY = -20;
            Scene_data.cam3D.distance = 400;
            console.log("解析结束")

            GameInstance.mainChar = this.addRole(new Vector3D(0, 5, 200));
            GameInstance.mainChar.rotationY = 180;
        //  GameInstance.mainChar.play(CharAction.WALK, 0);
            GameInstance.attackChar = this.addRole(new Vector3D(-100, 5, 200));
            this.addPerfab(new Vector3D(100, 0, 0));
            

          // this.aa();
            this.bb();
 
        }
        private aa(): void
        {
            var $evt: cannon.CannonEvent = new cannon.CannonEvent(cannon.CannonEvent.INIT_CANNON_SCENE);
            $evt.data = SceneManager.getInstance().sceneCollisionItem;
            ModuleEventManager.dispatchEvent($evt);
        }
        private bb(): void {
            var $evt: car.CarEvent = new car.CarEvent(car.CarEvent.INIT_CAR_SCENE);
            $evt.data = SceneManager.getInstance().sceneCollisionItem;
            ModuleEventManager.dispatchEvent($evt);
        }
       

        private addRole($pos: Vector3D): SceneChar
        {
            var $sc: SceneChar = new SceneChar();
            $sc.setRoleUrl(getRoleUrl("2002"));
            $sc.x = $pos.x;
            $sc.y = $pos.y;
            $sc.z = $pos.z;
           // $sc.addPart("weapon", "weapon_socket_0", getModelUrl("5201"));
            $sc.addPart("weapon", "w_01", getModelUrl("5201"));
            SceneManager.getInstance().addMovieDisplay($sc);
            return $sc;
        }
        private addPerfab($pos: Vector3D): ScenePerfab {
            var $sc: ScenePerfab = new ScenePerfab();
            $sc.x = $pos.x;
            $sc.y = $pos.y;
            $sc.z = $pos.z;
            SceneManager.getInstance().addMovieDisplay($sc);
            $sc.setPerfabName("6409")
            return $sc;
        }

        private loadSceneByUrl(): void
        {
            var sName: string = "1008"
            SceneManager.getInstance().loadScene(sName,
                TpSceneProcessor.sceneLoadcomplteFun,
                TpSceneProcessor.sceneProgressFun,
                () => { this.loadFinishEnd()}
            );
        }
        private static sceneLoadcomplteFun(): void {
            console.log("加载完成")
        }
        private static sceneProgressFun(num: number): void {
            console.log(num)
        }

        protected listenModuleEvents(): Array<BaseEvent> {
            return [
                new TpSceneEvent(TpSceneEvent.SHOW_TP_SCENE_EVENT),
            ];
        }
    }
}