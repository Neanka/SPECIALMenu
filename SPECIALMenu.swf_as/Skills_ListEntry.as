package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class Skills_ListEntry extends BSScrollingListEntry
   {
       
      
      public var Value_tf:TextField;
      
      public var NameLabel_tf:TextField;
      
      public var IsNameEntry:Boolean = true;
      
      public function Skills_ListEntry()
      {
         super();
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         super.SetEntryText(param1,param2);
         GlobalFunc.SetText(this.Value_tf,param1.value,false);
         this.Value_tf.textColor = this.selected?uint(0):uint(16777215);
      }
   }
}
