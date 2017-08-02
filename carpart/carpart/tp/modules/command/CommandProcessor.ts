module command {
    export class CammandModule extends Module {
        public getModuleName(): string {
            return "CammandModule";
        }
        protected listProcessors(): Array<Processor> {
            return [new CammandProcessor()];
        }
    }
    export class CammandEvent extends BaseEvent {
        public static INIT_CAMMAD_PANEL: string = "INIT_CAMMAD_PANEL";
        public static SHOW_CAMMAD_PANEL: string = "SHOW_CAMMAD_PANEL";
    }
    export class CammandProcessor extends BaseProcessor {

        public getName(): string {
            return "CammandProcessor";
        }
        protected receivedModuleEvent($event: BaseEvent): void {
            if ($event instanceof CammandEvent) {
                var evt: CammandEvent = <CammandEvent>$event;
                if (evt.type == CammandEvent.INIT_CAMMAD_PANEL) {
                    this.addEvents();
                }
                if (evt.type == CammandEvent.SHOW_CAMMAD_PANEL) {
                    this.showPanel($event);
                }
            }
     
        }
        private addEvents(): void
        {
            document.addEventListener(MouseType.KeyDown, ($evt: KeyboardEvent) => { this.onKeyDown($evt) })
        }
        public onKeyDown($evt: KeyboardEvent): void {
            if (!$evt.shiftKey) {
                if ($evt.keyCode == KeyboardType.R) {
                    ModuleEventManager.dispatchEvent(new CammandEvent(CammandEvent.SHOW_CAMMAD_PANEL));

                }
                if ($evt.keyCode == KeyboardType.T) {
                    var adk: car.CarEvent = new car.CarEvent(car.CarEvent.CAMMAND_INFO)
                    adk.data = "点到点"
                    ModuleEventManager.dispatchEvent(adk);
                }
                if ($evt.keyCode == KeyboardType.Y) {
                    var adk: car.CarEvent = new car.CarEvent(car.CarEvent.CAMMAND_INFO)
                    adk.data = "停车"
                    ModuleEventManager.dispatchEvent(adk);
                }
            
            }
        }
  
        private exchangepPanel: CommandPanel
        private showPanel($event : CammandEvent): void {
            if (!this.exchangepPanel) {
                this.exchangepPanel = new CommandPanel();
            }
            this.exchangepPanel.load(() => {
                UIManager.getInstance().addUIContainer(this.exchangepPanel);
            }, false);
        }
        protected listenModuleEvents(): Array<BaseEvent> {
            return [
                new CammandEvent(CammandEvent.INIT_CAMMAD_PANEL),
                new CammandEvent(CammandEvent.SHOW_CAMMAD_PANEL),
 
            ];
        }

    }


}