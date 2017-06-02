package
{
   import Shared.AS3.BSButtonHintBar;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSScrollingList;
   import Shared.GlobalFunc;
   import Shared.IMenu;
   import Shared.PlatformChangeEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
 //  import flash.utils.getQualifiedClassName;
   
   public class SPECIALMenu extends IMenu
   {
       
		private static var _instance:SPECIALMenu; 
      public var List_mc:BSScrollingList;
	  public var List_mc1:BSScrollingList;
		private var _SampleList: Array;
      
      public var PointCounter_tf:TextField;
      
      public var Description_tf:TextField;
      
      public var NameEntry_tf:TextField;
      
      public var Caption_tf:TextField;
      
      public var ButtonHintBar_mc:BSButtonHintBar;
      
      public var Background_mc:MovieClip;
      
      public var BackgroundBrackets_mc:MovieClip;
      
      public var VBHolder_mc:MovieClip;
      
      private var _VBLoader:Loader;
      
      protected var ExitButton:BSButtonHintData;
      
      protected var ResetButton:BSButtonHintData;
      
      private const SPECIALClipNameMap:Array = ["Name_Clip","Strength","Perception","Endurance","Charisma","Intelligence","Agility","Luck"];
	  private const SkillsClipNameMap:Array = ["Barter","Crafting","Energy Weapons","Explosives","Guns","LockPick","Medicine","Melee Weapons","Science","Sneak","Speech","Survival","Unarmed"];
      
      private const SPECIALClipSoundMap:Array = ["UIPerkMenuChargenName","UIPerkMenuChargenStrengthTraining","UIPerkMenuChargenPerceptionTraining","UIPerkMenuChargenEnduranceTraining","UIPerkMenuChargenCharismaTraining","UIPerkMenuChargenIntelligenceTraining","UIPerkMenuChargenAgilityTraining","UIPerkMenuChargenLuckTraining"];
      
      public var BGSCodeObj:Object;
      
      private var InputText:TextField;
      
      private var InputTextBaseX:Number;
      
      private var InputTextSpaceWidth:Number;
      
      private var initialValues:Array;
      
      private var uiCurrPoints:uint;
      
      private var uiMaxPoints:uint;
      
      private var uiCaptionBufferX:uint = 10;
      
      public function SPECIALMenu()
      {
	  SPECIALMenu._instance = this;
         this.ExitButton = new BSButtonHintData("$ACCEPT","R","PSN_X","Xenon_X",1,this.onExitButtonClicked);
         this.ResetButton = new BSButtonHintData("$RESET","T","PSN_Y","Xenon_Y",1,this.onResetButtonClicked);
         super();
         this.BGSCodeObj = new Object();
         this.uiCurrPoints = 0;
         this.uiMaxPoints = 0;
         this._VBLoader = new Loader();
         this.Caption_tf.autoSize = TextFieldAutoSize.LEFT;
         this.PopulateButtonBar();
         var _loc1_:MovieClip = this.BackgroundBrackets_mc.TopBorderRight_mc;
         var _loc2_:Number = _loc1_.x + _loc1_.width;
         var _loc3_:Number = this.Caption_tf.x + this.Caption_tf.textWidth + this.uiCaptionBufferX;
         var _loc4_:Number = _loc3_ - this.BackgroundBrackets_mc.x;
         _loc1_.x = _loc4_ / this.BackgroundBrackets_mc.scaleX;
         _loc1_.width = _loc2_ - _loc1_.x;
         addEventListener(KeyboardEvent.KEY_DOWN,this.onMenuKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onMenuKeyUp);
         addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPress);
         addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
         addEventListener(ArrowButton.MOUSE_UP,this.onArrowClick);
         this.__setProp_List_mc_MenuObj_List_mc_0();
		 this.__setProp_List_mc1_MenuObj_List_mc_0();
      }
      
      public static function get instance() : SPECIALMenu
      {
         return _instance;
      }
	  
      public function get editingName() : Boolean
      {
         return stage.focus == this.InputText;
      }
      
      private function PopulateButtonBar() : void
      {
         var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
         _loc1_.push(this.ResetButton);
         _loc1_.push(this.ExitButton);
         this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
      }
      
      public function get pointsRemaining() : int
      {
         return this.uiMaxPoints - this.uiCurrPoints;
      }
      
      public function get isDirty() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = 0;
         while(!_loc1_ && _loc2_ < 7)
         {
            if(this.List_mc.entryList[_loc2_ + 1].value != this.initialValues[_loc2_])
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function TrimString(param1:*) : String
      {
         var _loc2_:String = param1.replace(/^\s+|\s+$/g,"");
         _loc2_ = _loc2_.replace(/[<]+/g,"");
         return _loc2_;
      }
      
      public function onTextChangeListener(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Number = 0;
         if(this.InputText.text.length)
         {
            _loc3_ = this.InputText.text.length - 1;
            while(_loc3_ >= 0)
            {
               if(this.InputText.text.charAt(_loc3_) == " ")
               {
                  _loc2_++;
                  _loc3_--;
                  continue;
               }
               break;
            }
         }
         this.InputText.x = this.InputTextBaseX - this.InputTextSpaceWidth * _loc2_;
      }
      
      public function onCodeObjCreate() : *
      {
         var _loc2_:String = null;
         this.uiMaxPoints = this.BGSCodeObj.initMenu(this.List_mc.entryList);
         this.initialValues = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < 7)
         {
            this.initialValues[_loc1_] = this.List_mc.entryList[_loc1_ + 1].value;
            _loc1_++;
         }
         this.UpdateCounterAndButtons();
         this.List_mc.InvalidateData();
         stage.focus = this.List_mc;
         this.List_mc.selectedIndex = 0;
         this.InputText = this.List_mc.GetClipByIndex(0).textField;
         this.InputTextBaseX = this.InputText.x;
         _loc2_ = this.TrimString(this.InputText.text);
         this.InputText.text = " ";
         this.InputTextSpaceWidth = this.InputText.textWidth;
         this.InputText.text = _loc2_;
         this.InputText.addEventListener(Event.CHANGE,this.onTextChangeListener,false,0,true);
			newlist();
			this.List_mc1.entryList = this._SampleList;
			this.List_mc1.InvalidateData();
      }
      
      private function onItemPress(param1:Event) : *
      {
         if(this.List_mc.selectedIndex == 0)
         {
            if(this.InputText.type != TextFieldType.INPUT)
            {
               if(this.BGSCodeObj.startEditText())
               {
                  this.StartEditText();
               }
            }
            else
            {
               this.EndEditText();
            }
         }
      }
      
      private function StartEditText() : *
      {
         var _loc1_:String = null;
         _loc1_ = this.TrimString(this.InputText.text);
         this.InputText.text = _loc1_;
         this.List_mc.disableInput = true;
         this.InputText.type = TextFieldType.INPUT;
         this.InputText.selectable = true;
         this.InputText.maxChars = 26;
         stage.focus = this.InputText;
         this.InputText.setSelection(0,this.InputText.text.length);
      }
      
      private function EndEditText(param1:Boolean = false) : *
      {
         this.InputText.type = TextFieldType.DYNAMIC;
         this.InputText.setSelection(0,0);
         this.InputText.selectable = false;
         this.InputText.maxChars = 0;
         this.List_mc.disableInput = false;
         stage.focus = this.List_mc;
         this.List_mc.entryList[0].text = this.TrimString(this.InputText.text);
         if(this.List_mc.entryList[0].text != this.InputText.text)
         {
            this.InputText.text = this.List_mc.entryList[0].text;
            this.onTextChangeListener(null);
         }
         if(!param1)
         {
            this.BGSCodeObj.endEditText(this.List_mc.entryList[0].text);
         }
         this.UpdateCounterAndButtons();
         this.BGSCodeObj.playSound("UIMenuOK");
      }
      
      public function onMenuKeyUp(param1:KeyboardEvent) : *
      {
         if(this.List_mc.selectedIndex == 0 && (uiPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || uiPlatform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD))
         {
            if((param1.keyCode == Keyboard.ENTER || param1.keyCode == Keyboard.TAB) && stage.focus == this.InputText)
            {
               this.EndEditText();
            }
         }
      }
      
      public function onMenuKeyDown(param1:KeyboardEvent) : *
      {
         if(this.List_mc.selectedIndex != 0)
         {
            if(param1.keyCode == Keyboard.LEFT)
            {
               this.ModSelectedValue(-1);
            }
            else if(param1.keyCode == Keyboard.RIGHT)
            {
               this.ModSelectedValue(1);
            }
         }
      }
      
      private function ModListEntryValue(param1:int, param2:int, param3:Boolean) : *
      {
         if(param2 < 0 && this.uiCurrPoints > 0 && this.List_mc.entryList[param1].value > 1 || param2 > 0 && this.uiCurrPoints < this.uiMaxPoints && this.List_mc.entryList[param1].value < 10)
         {
            this.BGSCodeObj.modValue(param1,param2);
            this.uiCurrPoints = this.uiCurrPoints + param2;
            this.List_mc.UpdateList();
            this.UpdateCounterAndButtons();
            if(param3)
            {
               this.BGSCodeObj.playSound("UIMenuPrevNext");
            }
         }
      }
      
      private function ModSelectedValue(param1:int) : *
      {
         this.ModListEntryValue(this.List_mc.selectedClipIndex,param1,true);
		 recalc();
      }
      
      private function onArrowClick(param1:Event) : *
      {
         if(param1.target.name == "DecrementArrow")
         {
            this.ModSelectedValue(-1);
         }
         else
         {
            this.ModSelectedValue(1);
         }
      }
      
      private function onResetButtonClicked() : void
      {
         if(this.BGSCodeObj)
         {
            this.BGSCodeObj.confirmResetPoints();
            this.BGSCodeObj.playSound("UIMenuPopupGeneric");
         }
      }
      
      private function onExitButtonClicked() : void
      {
         if(this.BGSCodeObj)
         {
            this.BGSCodeObj.tryCloseMenu();
            this.BGSCodeObj.playSound("UIMenuOK");
         }
      }
      
      public function onVirtualKeyboardResult(param1:String, param2:Boolean) : *
      {
         if(param2)
         {
            param1 = param1.replace(/[<]+/g,"");
            this.InputText.text = param1;
         }
         this.EndEditText(param2);
      }
      
      public function CancelVirtualKeyboardNameEdit(param1:String) : *
      {
         var executeDelayed:* = undefined;
         var aOldText:String = param1;
         executeDelayed = function delayedFunc(param1:Event):void
         {
            stage.focus = Description_tf;
            InputText.text = aOldText;
            EndEditText(true);
            removeEventListener(Event.ENTER_FRAME,executeDelayed);
         };
         addEventListener(Event.ENTER_FRAME,executeDelayed);
      }
      
      protected function UpdateCounterAndButtons() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.uiCurrPoints = 0;
         for(_loc1_ in this.List_mc.entryList)
         {
            if(this.List_mc.entryList[_loc1_].value != undefined)
            {
               this.uiCurrPoints = this.uiCurrPoints + this.List_mc.entryList[_loc1_].value;
            }
         }
         this.ResetButton.ButtonEnabled = this.isDirty;
         GlobalFunc.SetText(this.PointCounter_tf,(this.uiMaxPoints - this.uiCurrPoints).toString(),false);
         _loc2_ = this.TrimString(this.List_mc.entryList[0].text);
         this.ExitButton.ButtonEnabled = this.uiCurrPoints == this.uiMaxPoints && _loc2_.length > 0;
      }
      
      private function onSelectionChange(param1:Event) : *
      {
	//	if(flash.utils.getQualifiedClassName(param1.target) == SPECIAL_List)
	if (param1.target == this.List_mc){
	this.List_mc1.selectedIndex = -1;	
	stage.focus = this.List_mc;
	} else {
	this.List_mc.selectedIndex = -1;
	stage.focus = this.List_mc1;
	}
         var _loc2_:URLRequest = null;
         var _loc3_:LoaderContext = null;
         if(this.List_mc.selectedEntry && this.List_mc.selectedEntry.description)
         {
            GlobalFunc.SetText(this.Description_tf,this.List_mc.selectedEntry.description,false);
            _loc2_ = new URLRequest("Components/VaultBoys/SPECIAL/" + this.SPECIALClipNameMap[this.List_mc.selectedIndex] + ".swf");
            _loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
            this._VBLoader.load(_loc2_,_loc3_);
         }
         else if(this.List_mc1.selectedEntry && this.List_mc1.selectedEntry.description)
         {
            GlobalFunc.SetText(this.Description_tf,this.List_mc1.selectedEntry.description,false);
			trace(this.List_mc1.selectedEntry.description);
            _loc2_ = new URLRequest("Components/VaultBoys/Skills/" + this.SkillsClipNameMap[this.List_mc1.selectedIndex] + ".swf");
            _loc3_ = new LoaderContext(false,ApplicationDomain.currentDomain);
            this._VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
            this._VBLoader.load(_loc2_,_loc3_);
         } else 
         {
            GlobalFunc.SetText(this.Description_tf,"",false);
            if(this.VBHolder_mc.numChildren > 0)
            {
               this.VBHolder_mc.removeChildAt(0);
            }
         }
         this.BGSCodeObj.playSound("UIMenuFocus");
      }
      
      private function onPerkAnimUpdate(param1:Event) : *
      {
         if(this.List_mc.selectedIndex >= 0 && param1.target.currentFrame == 1)
         {
            this.BGSCodeObj.PlayPerkSound(this.SPECIALClipSoundMap[this.List_mc.selectedIndex]);
         }
      }
      
      private function onVBLoadComplete(param1:Event) : *
      {
         var _loc2_:DisplayObject = null;
         param1.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
         if(this.VBHolder_mc.numChildren > 0)
         {
            _loc2_ = this.VBHolder_mc.getChildAt(0);
            this.VBHolder_mc.removeChild(_loc2_);
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onPerkAnimUpdate);
            this.BGSCodeObj.StopPerkSound();
         }
         this.VBHolder_mc.addChild(param1.target.content);
         param1.target.content.addEventListener(Event.ENTER_FRAME,this.onPerkAnimUpdate);
         this.BGSCodeObj.PlayPerkSound(this.SPECIALClipSoundMap[this.List_mc.selectedIndex]);
      }
      
      public function ResetPoints() : *
      {

         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         this.BGSCodeObj.playSound("UIMenuOK");
         for(_loc1_ in this.List_mc.entryList)
         {
            if(_loc1_ > 0 && this.List_mc.entryList[_loc1_].value != undefined)
            {
               _loc2_ = this.initialValues[_loc1_ - 1] - this.List_mc.entryList[_loc1_].value;
               this.ModListEntryValue(_loc1_,_loc2_,_loc1_ == 1);
            }
         }
         this.List_mc.InvalidateData();
         this.UpdateCounterAndButtons();
	  recalc();
      }
      
      public function CancelReset() : *
      {
         this.BGSCodeObj.playSound("UIMenuCancel");
      }
      
      public function IncrementPoints() : *
      {
         if(this.List_mc.selectedClipIndex > 0)
         {
            this.ModSelectedValue(1);
         }
      }
      
      public function DecrementPoints() : *
      {
         if(this.List_mc.selectedClipIndex > 0)
         {
            this.ModSelectedValue(-1);
         }
      }
      
      function __setProp_List_mc_MenuObj_List_mc_0() : *
      {
         try
         {
            this.List_mc["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc.listEntryClass = "SPECIAL_ListEntry";
         this.List_mc.numListItems = 8;
         this.List_mc.restoreListIndex = false;
         this.List_mc.textOption = "None";
         this.List_mc.verticalSpacing = 0;
         try
         {
            this.List_mc["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      function __setProp_List_mc1_MenuObj_List_mc_0() : *
      {
         try
         {
            this.List_mc1["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.List_mc1.listEntryClass = "Skills_ListEntry";
         this.List_mc1.numListItems = 13;
         this.List_mc1.restoreListIndex = false;
         this.List_mc1.textOption = "None";
         this.List_mc1.verticalSpacing = 0;
         try
         {
            this.List_mc1["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
	  private function newlist():*{
	  			this._SampleList = new Array();
			this._SampleList.push({
				text: "Barter",
				description: "Proficiency at trading and haggling. Also used to negotiate better quest rewards or occasionally as a bribe-like alternative to Speech.",
				value: 5,
				clipIndex: 0
			});
			this._SampleList.push({
				text: "Crafting",
				description: "Proficiency at repairing items and crafting items and ammunition.",
				value: 5,
				clipIndex: 1
			});
			this._SampleList.push({
				text: "Energy Weapons",
				description: "Proficiency at using energy-based weapons.",
				value: 5,
				clipIndex: 2
			});
			this._SampleList.push({
				text: "Explosives",
				description: "Proficiency at using explosive weaponry, disarming mines, and crafting explosives.",
				value: 5,
				clipIndex: 3
			});
			this._SampleList.push({
				text: "Guns",
				description: "Proficiency at using weapons that fire standard ammunition.",
				value: 5,
				clipIndex: 4
			});
			this._SampleList.push({
				text: "Lockpick",
				description: "Proficiency at picking locks.",
				value: 5,
				clipIndex: 5
			});
			this._SampleList.push({
				text: "Medicine",
				description: "Proficiency at using medical tools, drugs, and for crafting Doctor's Bags.",
				value: 5,
				clipIndex: 6
			});
			this._SampleList.push({
				text: "Melee Weapons",
				description: "Proficiency at using melee weapons.",
				value: 5,
				clipIndex: 7
			});
			this._SampleList.push({
				text: "Science",
				description: "Proficiency at hacking terminals, recycling energy ammunition at workbenches, crafting chems, and many dialog checks.",
				value: 5,
				clipIndex: 8
			});
			this._SampleList.push({
				text: "Sneak",
				description: "Proficiency at remaining undetected and stealing.",
				value: 5,
				clipIndex: 9
			});
			this._SampleList.push({
				text: "Speech",
				description: "Proficiency at persuading others. Also used to negotiate for better quest rewards and to talk your way out of combat, convincing people to give up vital information and succeeding in multiple speech checks.",
				value: 5,
				clipIndex: 10
			});
			this._SampleList.push({
				text: "Survival",
				description: "Proficiency at cooking, making poisons, and crafting \"natural\" equipment and consumables. Also yields increased benefits from food.",
				value: 5,
				clipIndex: 11
			});
			this._SampleList.push({
				text: "Unarmed",
				description: "Proficiency at unarmed fighting.",
				value: 5,
				clipIndex: 12
			});
		}
	  private function recalc():*{
		//trace("charisma: "+ List_mc.entryList[4].value)
		var iS: int = List_mc.entryList[1].value;
		var iP: int = List_mc.entryList[2].value;
		var iE: int = List_mc.entryList[3].value;
		var iC: int = List_mc.entryList[4].value;
		var iI: int = List_mc.entryList[5].value;
		var iA: int = List_mc.entryList[6].value;
		var iL: int = List_mc.entryList[7].value;
		 List_mc1.entryList[0].value=2+2*iC+Math.ceil(iL/2); //barter
		 List_mc1.entryList[1].value=2+2*iI+Math.ceil(iL/2); //craft
		 List_mc1.entryList[2].value=2+2*iP+Math.ceil(iL/2); //e weap
		 List_mc1.entryList[3].value=2+2*iP+Math.ceil(iL/2); //expl
		 List_mc1.entryList[4].value=2+2*iA+Math.ceil(iL/2); //guns
		 List_mc1.entryList[5].value=2+2*iP+Math.ceil(iL/2); //lockpick
		 List_mc1.entryList[6].value=2+2*iI+Math.ceil(iL/2); //medic
		 List_mc1.entryList[7].value=2+2*iS+Math.ceil(iL/2); //m weap
		 List_mc1.entryList[8].value=2+2*iI+Math.ceil(iL/2); //science
		 List_mc1.entryList[9].value=2+2*iA+Math.ceil(iL/2); //sneak
		 List_mc1.entryList[10].value=2+2*iC+Math.ceil(iL/2); //speech
		 List_mc1.entryList[11].value=2+2*iE+Math.ceil(iL/2); //surv
		 List_mc1.entryList[12].value=2+2*iE+Math.ceil(iL/2); //unarm
		 List_mc1.UpdateList();
	  }
   }
}
