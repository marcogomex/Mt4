
// +----------------------------------------------------------------------------------------+ //
// |    .-._______                           XARD777                          _______.-.    | //
// |---( )_)______)                 Knowledge of the ancients                (______(_( )---| //
// |  (    ()___)                              \¦/                             (___()    )  | //
// |       ()__)                              (o o)                             (__()       | //
// |--(___()_)__________________________oOOo___(_)___oOOo_________________________(_()___)--| //
// |_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|____|_____| //
// |                                                                                   2011 | //
// |----------------------------------------------------------------------------------------| //
// |                 File:     !!!XPS v6 OSCILLATOR v3.mq4                                    | //
// | Programming language:     MQL4                                                         | //
// | Development platform:     MetaTrader 4                                                 | //
// |          End product:     THIS SOFTWARE IS FOR USE ONLY BY XARD777                     | //
// |                                                                                        | //
// |                                                         [Xard777 Proprietory Software] | //
// +----------------------------------------------------------------------------------------+ //

#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  CLR_NONE
#property  indicator_color2  Lime
#property  indicator_color3  Red
#property  indicator_width2  4
#property  indicator_width3  4
#property  indicator_level1  0
#property  indicator_levelcolor  Silver

extern int period = 52;
extern bool alarm=true;

double         ExtBuffer0[];
double         ExtBuffer1[];
double         ExtBuffer2[];


#define UPPERLINE "UPPERLINE"
#define LOWERLINE "LOWERLINE"
extern color pluslevelclr = Aqua;
extern color minuslevelclr = Magenta;
extern int levellinethickness = 1;


double alertBar;
double last;

int init()
  {

   //-----------------------------
/*   
   switch ( Period() )
   {
   case     1: period = 52;break;
   case     5: period = 52;break;
   case    15: period = 52;break;
   case    30: period = 52;break;
   case    60: period = 52;break;
   case   240: period = 52;break;
   case  1440: period = 52;break;
   case 10080: period = 52;break;
   default   : period = 52;break;
   }
*/   
   //-----------------------------

      
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   //IndicatorDigits(Digits+1);

   SetIndexBuffer(0,ExtBuffer0);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexBuffer(2,ExtBuffer2);

   IndicatorShortName("v3");
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);

   return(0);
  }



int deinit()
  {
//----
  DeleteCreateline();
/*
  ObjectDelete("XPS");
  ObjectDelete("XPS2");
  ObjectDelete("XPS3");
*/
//----
   return(0);
   }



int start() {
  
             CreateLEVEL();
   }

   void Createline(string objName, double start, double end, color clr)
   {
     if (ObjectFind(objName) != 0) // Check is it exists and only create when not
     {
     ObjectCreate(objName, OBJ_TREND,WindowFind("v3"),0, start, Time[0], end);
     ObjectSet(objName, OBJPROP_COLOR, clr);
     ObjectSet(objName, OBJPROP_WIDTH, levellinethickness);
     ObjectSet(objName, OBJPROP_RAY, true); // Changed to true so it will continue to draw 
     ObjectSet(objName, OBJPROP_BACK, 0);
     }

   }
   
   void DeleteCreateline()
   {
   ObjectDelete(UPPERLINE);ObjectDelete(LOWERLINE);
   }
   void CreateLEVEL()
   {
   // Lines never change value so why delete?
   // DeleteCreateline(); 
   
   Createline(UPPERLINE, 0.5, 0.5, pluslevelclr);
   Createline(LOWERLINE, -0.5, -0.5, minuslevelclr);

   int    limit;
   int    counted_bars=IndicatorCounted();
   double prev,current,old;
   double Value=0,Value1=0,Value2=0,Fish=0,Fish1=0,Fish2=0;
   double price;
   double MinL=0;
   double MaxH=0;  
   

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

   for(int i=0; i<limit; i++)

    { MaxH = High[Highest(NULL,0,MODE_HIGH,period,i)];
      MinL = Low[Lowest(NULL,0,MODE_LOW,period,i)];
      price = (High[i]+Low[i])/2;
      
      Value = 0.33*2*((price-MinL)/(MaxH-MinL)-0.5) + 0.67*Value1;     
      Value=MathMin(MathMax(Value,-0.999),0.999); 
      
      ExtBuffer0[i]=0.5*MathLog((1+Value)/(1-Value))+0.5*Fish1;
      
      Value1=Value;
      Fish1=ExtBuffer0[i];
    }


   bool up = TRUE;
   for(i=limit-2; i>=0; i--)
     
     {
      current=ExtBuffer0[i];
      prev=ExtBuffer0[i+1];
           
      if (((current<0)&&(prev>0))||(current<0))   up= false;    
      if (((current>0)&&(prev<0))||(current>0))   up= true;
      
      if(!up) {
         ExtBuffer2[i]=current;
         ExtBuffer1[i]=0;
      
      if (alarm && i==0 && last != 2 && ExtBuffer1[i] == 0 && Bars>alertBar) 
        {
            Alert("Possible Trend going DOWN on ",Period()," ",Symbol());
            alertBar = Bars;last = 2;
        }      
        }
        
       else {
          ExtBuffer1[i]=current;
          ExtBuffer2[i]=0;
      
      if (alarm && i==0 && last != 1 && ExtBuffer2[i] == 0 && Bars>alertBar) 
        {
            Alert("Possible Trend going UP on ",Period()," ",Symbol());
            alertBar = Bars;
            last = 1;
        }   
        }
  }//End Loop
/*
   ObjectDelete("XPS");
   ObjectCreate("XPS", OBJ_LABEL, 1, 0, 0);
   ObjectSetText("XPS","!XPS v6", 28, "Arial Black", C'46,46,46');
   ObjectSet("XPS", OBJPROP_CORNER, 2);
   ObjectSet("XPS", OBJPROP_BACK, 0);
   ObjectSet("XPS", OBJPROP_XDISTANCE, 16);
   ObjectSet("XPS", OBJPROP_YDISTANCE, 6);     
      
   ObjectDelete("XPS2");
   ObjectCreate("XPS2", OBJ_LABEL, 1, 0, 0);
   ObjectSetText("XPS2","!XPS v6", 28, "Arial Black", Silver);
   ObjectSet("XPS2", OBJPROP_CORNER, 2);
   ObjectSet("XPS2", OBJPROP_BACK, 0);
   ObjectSet("XPS2", OBJPROP_XDISTANCE, 14);
   ObjectSet("XPS2", OBJPROP_YDISTANCE, 8); 
   
   ObjectDelete("XPS3");
   ObjectCreate("XPS3", OBJ_LABEL, 1, 0, 0);
   ObjectSetText("XPS3","Release Candidate 003", 9, "Arial Black", Silver);
   ObjectSet("XPS3", OBJPROP_CORNER, 2);
   ObjectSet("XPS3", OBJPROP_BACK, 0);
   ObjectSet("XPS3", OBJPROP_XDISTANCE, 17);
   ObjectSet("XPS3", OBJPROP_YDISTANCE, 1); 
*/  
   return(0);
  }
// ------------------------------------------------------------------------------------------ //
//                                     E N D   P R O G R A M                                  //
// ------------------------------------------------------------------------------------------ //
/*                                                         
                                        ud$$$**BILLION$bc.                          
                                    u@**"        PROJECT$$Nu                       
                                  J                ""#$$$$$$r                     
                                 @                       $$$$b                    
                               .F                        ^*3$$$                   
                              :% 4                         J$$$N                  
                              $  :F                       :$$$$$                  
                             4F  9                       J$$$$$$$                 
                             4$   k             4$$$$bed$$$$$$$$$                 
                             $$r  'F            $$$$$$$$$$$$$$$$$r                
                             $$$   b.           $$$$$$$$$$$$$$$$$N                
                             $$$$$k 3eeed$$b    XARD777."$$$$$$$$$                
              .@$**N.        $$$$$" $$$$$$F'L $$$$$$$$$$$  $$$$$$$                
              :$$L  'L       $$$$$ 4$$$$$$  * $$$$$$$$$$F  $$$$$$F         edNc   
             @$$$$N  ^k      $$$$$  3$$$$*%   $F4$$$$$$$   $$$$$"        d"  z$N  
             $$$$$$   ^k     '$$$"   #$$$F   .$  $$$$$c.u@$$$          J"  @$$$$r 
             $$$$$$$b   *u    ^$L            $$  $$$$$$$$$$$$u@       $$  d$$$$$$ 
              ^$$$$$$.    "NL   "N. z@*     $$$  $$$$$$$$$$$$$P      $P  d$$$$$$$ 
                 ^"*$$$$b   '*L   9$E      4$$$  d$$$$$$$$$$$"     d*   J$$$$$r   
                      ^$$$$u  '$.  $$$L     "#" d$$$$$$".@$$    .@$"  z$$$$*"     
                        ^$$$$. ^$N.3$$$       4u$$$$$$$ 4$$$  u$*" z$$$"          
                          '*$$$$$$$$ *$b      J$$$$$$$b u$$P $"  d$$P             
                             #$$$$$$ 4$ 3*$"$*$ $"$'c@@$$$$ .u@$$$P               
                               "$$$$  ""F~$ $uNr$$$^&J$$$$F $$$$#                 
                                 "$$    "$$$bd$.$W$$$$$$$$F $$"                   
                                   ?k         ?$$$$$$$$$$$F'*                     
                                    9$$bL     z$$$$$$$$$$$F                       
                                     $$$$    $$$$$$$$$$$$$                        
                                      '#$$c  '$$$$$$$$$"                          
                                       .@"#$$$$$$$$$$$$b                          
                                     z*      $$$$$$$$$$$$N.                       
                                   e"      z$$"  #$$$k  '*$$.                     
                                .u*      u@$P"      '#$$c   "$$c                   
                        u@$*"""       d$$"            "$$$u  ^*$$b.               
                      :$F           J$P"                ^$$$c   '"$$$$$$bL        
                     d$$  ..      @$#                      #$$b         '#$       
                     9$$$$$$b   4$$                          ^$$k         '$      
                      "$$6""$b u$$                             '$    d$$$$$P      
                        '$F $$$$$"                              ^b  ^$$$$b$       
                         '$W$$$$"                                'b@$$$$"         
                                                                  ^$$$*/     