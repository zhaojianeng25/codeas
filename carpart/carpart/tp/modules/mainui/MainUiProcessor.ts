module mainui {
    export class MainUiModule extends Module {
        public getModuleName(): string {
            return "MainUiModule";
        }
        protected listProcessors(): Array<Processor> {
            return [new MainUiProcessor()];
        }
    }
    export class MainUiEvent extends BaseEvent {
        public static SHOW_MAINUI_PANEL: string = "SHOW_MAINUI_PANEL";
        public static HIDE_MAINUI_PANEL: string = "HIDE_MAINUI_PANEL";
    }
    export class MainUiProcessor extends BaseProcessor {

        public getName(): string {
            return "MainUiProcessor";
        }
        protected receivedModuleEvent($event: BaseEvent): void {
            if ($event instanceof MainUiEvent) {
                var evt: MainUiEvent = <MainUiEvent>$event;
                if (evt.type == MainUiEvent.SHOW_MAINUI_PANEL) {
        
                    this.showPanel($event);
                }
                if (this.exchangepPanel) {
                    if (evt.type == MainUiEvent.HIDE_MAINUI_PANEL) {
                        this.hidePanel();
                    }
                }
            }
     
        }
        private hidePanel(): void {

        }
        private exchangepPanel: MainUiPanel
        private showPanel($event : MainUiEvent): void {
            if (!this.exchangepPanel) {
                this.exchangepPanel = new MainUiPanel();
            }
            this.exchangepPanel.load(() => {
                UIManager.getInstance().addUIContainer(this.exchangepPanel);
            }, false);
        }
        protected listenModuleEvents(): Array<BaseEvent> {
            return [
                new MainUiEvent(MainUiEvent.SHOW_MAINUI_PANEL),
                new MainUiEvent(MainUiEvent.HIDE_MAINUI_PANEL),
            ];
        }

    }


}